### Performs timeSeries_fn (which creates two temporal tables temp1, temp2 erased at the end of this function) for each of the pair in "selected conferences" set during period start, fin and writes the results out to the csv file


CREATE OR REPLACE FUNCTION trustcom_print_timeseries(start_period INT, fin_period INT)

RETURNS VOID AS $$
declare STATEMENT TEXT;
citing record;
base record;
start_var int;
fin_var int;

BEGIN


for citing in select distinct normalized_venue from trustcom_papers where normalized_venue in ('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai') LOOP

	for base in select distinct normalized_venue from trustcom_papers where normalized_venue in ('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai') LOOP

		perform trustcom_timeSeries_fn(citing.normalized_venue, base.normalized_venue, start_period, fin_period);

	end LOOP;

end LOOP;

create table trustcom_timeseries_results as 
	select temp1.citing as from_citing, temp1.base as to_base, temp1.current_year, temp1.year_cited_papers, temp1.selected_cited_papers_in_year_no, temp2.all_cited_papers_in_year_no 
	from temp1 join temp2 on
	(temp1.citing = temp2.citing and temp1.base = temp2.base 
	and temp1.current_year = temp2.current_year and temp1.year_cited_papers = temp2.year_cited_papers );



for citing in select distinct normalized_venue from trustcom_papers where normalized_venue in ('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai') LOOP

	for base in select distinct normalized_venue from trustcom_papers where normalized_venue in ('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai') LOOP

		select distinct start into start_var from trustcom_conference_periodtimes where from_citing = citing.normalized_venue and to_base = base.normalized_venue;
		select distinct fin into fin_var from trustcom_conference_periodtimes where from_citing = citing.normalized_venue and to_base = base.normalized_venue;

		statement := 'copy (
		select * from trustcom_timeseries_results where  
		from_citing = '''||citing.normalized_venue||''' and to_base = '''||base.normalized_venue||''' 
		order by current_year, year_cited_papers asc)
		to ''/Users/admin/Desktop/data/dblp_trust_rep/timeseries/'||citing.normalized_venue||'-'||base.normalized_venue||'_'||start_var||'-'||fin_var||'.csv'' 
		with DELIMITER '','' CSV HEADER QUOTE ''"'';';

		execute statement;

	end LOOP;

end LOOP;

	drop table temp1;
	drop table temp2;
END;
$$ 

LANGUAGE plpgsql;



 select trustcom_print_timeseries(1900,2016); 
    