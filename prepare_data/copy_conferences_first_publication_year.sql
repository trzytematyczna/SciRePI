


copy (
		select min(year), normalized_venue from trustcom_papers where  normalized_venue in
			('cvpr','ijcv','icra','iccv','icml','nips','jmlr','acl','taslp','emnlp','aaai','tfs','dss','prl','aamas','ijcai','cviu','neural networks','icpr','ieee transactions on neural networks','ijar','nc','bmvc','computer speech language','international journal of applied evolutionary computation','gecco','cl','coling','ieee transactions on affective computing','jair','kr','nca','icdar','ijcnn','aim','icaps','ecai','colt','ijis','jar','ijdar','ci','tap','eccv','natural language engineering','uai','npl','machine translation','icb','alt','paa','ictai','naacl','nca','accv','dss','iccbr','ijprai','wias','ida','ilp','jetai','tslp','pricai','ksem','ijcia','icann','iconip','talip','aamas','kbs','ai')
		group by normalized_venue order by normalized_venue desc)
		to '/Users/admin/Desktop/data/dblp_trust_rep/data/conferences_first_publication_year.csv'
		with DELIMITER ',' CSV HEADER QUOTE '"';