## creates two tables - temp 1 having for each year from start to fin: number of base papers cited by citing (temp 1, numerator of CR), and temp 2 having: numeb of any papers cited by citing (temp2, denominator of CR)
### creates additional table trustcom_conference_periodtimes with the exact beginning and ending year of the period for which both conferences exist - hence there are actually values of citations

##temp1
## has info about how many papers of base was cited by citing in this current_year year
##temp2
## has info about how many papers IN GENERAL was cited by citing in this current_year year
CREATE OR REPLACE FUNCTION trustcom_timeSeries_fn(citing varchar(200), base varchar(200), start INT, fin INT)

RETURNS VOID AS $$

  DECLARE i INT;
  declare base_beginning INT;
  declare current_year INT;
  citing_min int;
  base_min int;
  pivot int;
  used_start int;

BEGIN


  create table if not exists temp1( 
  citing varchar(200) DEFAULT NULL, 
  base varchar(200) DEFAULT NULL, 
  current_year INT DEFAULT NULL,
  year_cited_papers INT DEFAULT NULL, 
  selected_cited_papers_in_year_no INT DEFAULT NULL);

  create table if not exists temp2( 
  citing varchar(200) DEFAULT NULL, 
  base varchar(200) DEFAULT NULL, 
  current_year INT DEFAULT NULL,
  year_cited_papers INT DEFAULT NULL, 
  all_cited_papers_in_year_no INT DEFAULT NULL);

  create table if not exists trustcom_conference_periodtimes(
  from_citing varchar(200) DEFAULT NULL,
  to_base varchar(200) DEFAULT NULL,
  start INT DEFAULT NULL,
  fin INT DEFAULT NULL
);

select min(year) into citing_min from trustcom_papers where normalized_venue=citing;
select min(year) into base_min from trustcom_papers where normalized_venue=base;

if(citing_min<base_min) then

  pivot = base_min;

else

  pivot = citing_min;

end if;

if(start<pivot) then

  current_year := pivot;

else
  current_year := start;

end if;

    used_start:=current_year;
    insert into trustcom_conference_periodtimes values(citing, base, used_start, fin);


  while current_year <= fin LOOP

    insert into temp1 select citing, base, current_year, year, count(paper_id) as count1 from trustcom_papers 
      where paper_id in (
        select paper_reference_id from trustcom_paperreferences 
          where paper_id in (select distinct paper_id from trustcom_papers where normalized_venue = citing and year = current_year)       
          and paper_reference_id in (select distinct paper_id from trustcom_papers where normalized_venue = base and year<current_year)
      ) 
      group by year order by year asc;

    insert into temp2 select citing, base, current_year, year, count(paper_id) as count2 from trustcom_papers 
      where paper_id in (
        select paper_reference_id from trustcom_paperreferences 
          where paper_id in (select distinct paper_id from trustcom_papers where normalized_venue = citing and year = current_year)       
      ) 
      group by year order by year asc;


    current_year := current_year + 1;

  end LOOP;


END;
$$ 

LANGUAGE plpgsql;
