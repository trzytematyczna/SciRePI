
0. wybranie podzbioru konferencji
1. Create_tables.sql
	I. stworzenie tabeli trustcom_papers zawierajacej: 
		(i) wszystkie papiery z selected conferences 
		(ii) wszystkie papiery ktore cytuja selected conferences 
		(iii) wszystkie papiery cytowane przez selected conferences
	II. stworzenie tabeli trustcom_paperreferences zawierajacej:
		(i) reference papierow z trustcom_papers
		(ii) pomniejszone o papiery ktore sa usuniete z papers
		(iii) usuniecie powtarzajacych sie par
2. trustcom_print_timeseries.sql <- wewnetrzne wywolanie trustcom_timeseries_fn.sql