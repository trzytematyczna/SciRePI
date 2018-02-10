
CREATE INDEX index_paperreferences_paper_reference_id ON paperreferences(paper_reference_id);


create
select trustcom_papers
('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai')


#wszystkie papiery selected conf
CREATE TABLE WWWPapers_dupl as
      SELECT *
        FROM Papers
       WHERE normalized_venue in
('aaai','aamas','accv','acl','alt','bmvc','coling','colt','connection','cvpr','ecai','eccv','emnlp','gecco','icann','icaps','icb','iccbr','iccv','icdar','icml','iconip','icpr','icra','ictai','ijcai','ijcnn','ilp','kr','ksem','ml','naacl','nips','pricai','pris','uai');
CREATE INDEX index_WWWPapers_dupl_paper_id ON WWWPapers_dupl USING btree(paper_id);


#w tej tabeli sa wszystkie papiery opublikowane na selected conf
CREATE TABLE WWWPapers_helper as
      SELECT paper_id
        FROM Papers
       WHERE normalized_venue in
('aaai','aamas','accv','acl','alt','bmvc','coling','colt','connection','cvpr','ecai','eccv','emnlp','gecco','icann','icaps','icb','iccbr','iccv','icdar','icml','iconip','icpr','icra','ictai','ijcai','ijcnn','ilp','kr','ksem','ml','naacl','nips','pricai','pris','uai');

CREATE INDEX index_WWWPapers_helper_paper_id ON WWWPapers_helper USING btree(paper_id);

#wszystkie cytowane przez selected 
create table WWWPaperReferences as
    select * from PaperReferences where paper_id in 
        (select paper_id from WWWPapers_helper);

#wszystkie ktore cytuja selected
insert into WWWPaperReferences (select * from PaperReferences where paper_reference_id in (select paper_id from WWWPapers_helper));


delete from WWWPaperReferences where not exists (select null from Papers where Papers.paper_id = WWWPaperReferences.paper_id);
delete from WWWPaperReferences where not exists (select null from Papers where Papers.paper_id = WWWPaperReferences.paper_reference_id);

create table temp as select distinct * from WWWPaperReferences;
drop table WWWPaperReferences;

ALTER TABLE temp RENAME TO WWWPaperReferences;

CREATE INDEX index_WWWPaperReferences_paper_id ON WWWPaperReferences USING btree(paper_id);
CREATE INDEX index_WWWPaperReferences_paper_reference_id ON WWWPaperReferences USING btree(paper_reference_id);

drop table WWWPapers_helper;
