####TRUSTCOM



CREATE INDEX index_paperreferences_paper_reference_id ON paperreferences(paper_reference_id);



#wszystkie papiery selected conf
CREATE TABLE trustcom_papers_dupl as
      SELECT *
        FROM Papers
       WHERE normalized_venue in
('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai');

CREATE INDEX index_trustcom_papers_dupl_paper_id ON trustcom_papers_dupl USING btree(paper_id);


#w tej tabeli sa wszystkie papiery opublikowane na selected conf
CREATE TABLE trustcom_papers_helper as
      SELECT paper_id
        FROM Papers
       WHERE normalized_venue in
('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai');

CREATE INDEX index_trustcom_papers_helper_paper_id ON trustcom_papers_helper USING btree(paper_id);

#wszystkie cytowane przez selected 
create table trustcom_paperreferences as
    select * from PaperReferences where paper_id in 
        (select paper_id from trustcom_papers_helper);

#wszystkie ktore cytuja selected
insert into trustcom_paperreferences (select * from PaperReferences where paper_reference_id in (select paper_id from trustcom_papers_helper));


delete from trustcom_paperreferences where not exists (select null from Papers where Papers.paper_id = trustcom_paperreferences.paper_id);
delete from trustcom_paperreferences where not exists (select null from Papers where Papers.paper_id = trustcom_paperreferences.paper_reference_id);

create table temp as select distinct * from trustcom_paperreferences;
drop table trustcom_paperreferences;

ALTER TABLE temp RENAME TO trustcom_paperreferences;

CREATE INDEX index_trustcom_paperreferences_paper_id ON trustcom_paperreferences USING btree(paper_id);
CREATE INDEX index_trustcom_paperreferences_paper_reference_id ON trustcom_paperreferences USING btree(paper_reference_id);

drop table trustcom_papers_helper;


#wszystkie papeiry ktore cytowaly selected papiery
insert into trustcom_papers_dupl (select * from Papers where exists (
							select 1 from trustcom_paperreferences 
							where  trustcom_paperreferences.paper_id = Papers.paper_id)
							);

#wszystkie papeiry ktore byly cytowane przez selected papiery
insert into trustcom_papers_dupl (select * from Papers where exists (
							select 1 from trustcom_paperreferences 
							where  trustcom_paperreferences.paper_reference_id = Papers.paper_id)
							);


CREATE TABLE trustcom_papers as select DISTINCT * from trustcom_papers_dupl;

drop table trustcom_papers_dupl;

Alter table trustcom_papers Add constraint pk_trustcom_papers primary key (paper_id);
CREATE INDEX index_trustcom_papers_normalized_venue ON trustcom_papers USING btree(normalized_venue);
CREATE INDEX index_trustcom_papers_year ON trustcom_papers USING btree(year);
CREATE INDEX index_trustcom_papers_paper_id ON trustcom_papers USING btree(paper_id);



###NA H-index
#liczba cytowan danego paperu (per paper)
create table trustcom_citation_count_per_paper as
	select paper_id, count(distinct paper_reference_id) from trustcom_paperreferences group by paper_id;

copy (select p.normalized_venue as venue, cc.paper_id, cc.count as citationcount from trustcom_papers p join trustcom_citation_count_per_paper cc on
p.paper_id = cc.paper_id group by p.normalized_venue, cc.paper_id, cc.count order by venue, citationcount desc) To '/Users/admin/Desktop/trust_com/conference_citationCount_perPaper.csv' With DELIMITER ',' CSV HEADER QUOTE '"';



copy (select p.normalized_venue as venue, cc.paper_id, cc.count as citationcount from trustcom_papers p join trustcom_citation_count_per_paper cc on p.paper_id = cc.paper_id group by p.normalized_venue, cc.paper_id, cc.count having p.normalized_venue in 
	('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai')
 	order by venue, citationcount desc) To '/Users/admin/Desktop/trust_com/conference_citationCount_perPaper_selected.csv' With DELIMITER ',' CSV HEADER QUOTE '"';


