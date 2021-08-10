libname A  'D:\암1vs 암 100\작업 3 (ca 빼고)\Data analysis';
libname B 'D:\암1vs 암 100\작업 3 (ca 빼고)\Data analysis\result';


/*Smoking*/

/*smoking data cleaning*/
data b.thesis  ; set b.thesis  ;					
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then csmok=99; 					
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then csmok=1;                           /*csmok: 현재흡연 (1), 과거흡연& 경험없음(0)*/					
	else if DS1_SMOKE in ('1', '2') or  DS1_SMOKE_100 in ('1', '2') then csmok=0;				
					
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then psmok=99; 					
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then psmok=2;					
	else if DS1_SMOKE in ('2') or  DS1_SMOKE_100 in ('2') then psmok=1; 				
	else if DS1_SMOKE in ('1') or  DS1_SMOKE_100 in ('1') then psmok=0; run;     /*psmok: 현재흡연 (2), 과거흡연 (1), 경험없음 (0)*/	


/*Model1*/
/*Adjusted for age, sex*/
proc logistic data=b.thesis; where csmok not in (99);    

	class group1(PARAM=REF REF='0') DS1_SEX1(PARAM=REF REF='1')    ;

    model csmok(ref='0') = group1 cage DS1_SEX1 ; 
	
run;

/*Model2*/
/*Adjusted for all model 1 factors, as well as marital status, education, income, employment status, self-rated health*/
proc logistic data=b.thesis; where cdrink not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
              PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0')  ;

    model csmok(ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 ; run;


/*Model3*/
/*Adjusted for all model 2 factors, as well as other health behaviors (smoking, drinking, physical activity, non-obesity)*/
proc logistic data=b.thesis; where cdrink not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
             PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  psmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1(PARAM=REF REF='1') gbmi1(PARAM=REF REF='1') 
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0') cdrink(PARAM=REF REF='0')  gexer_wk5(PARAM=REF REF='1') gbmi3(PARAM=REF REF='1');

    model csmok(ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 cdrink  gexer_wk5 gbmi3; run;


/*Drinking*/

/*Drinking data cleaning*/
data b.thesis  ; set b.thesis  ;					
            if DS1_DRINK in ('66666', '99999') then cdrink=99;            					
    else if DS1_DRINK='3' then cdrink=1;					
	else if DS1_DRINK in ('1', '2') then cdrink=0;                     /*cdrink: 현재음주(1), 현재음주안함(0)*/				
					
            if DS1_DRINK in ('66666', '99999') then pdrink=99; 					
    else if DS1_DRINK='3' then pdrink=2;					
	else if DS1_DRINK='2' then pdrink=1;				
	else if DS1_DRINK in ('1') then pdrink=0; run;      	 /*pdrink: 현재음주 (2), 과거음주 (1), 경험없음 (0)*/	

proc freq data=b.thesis; where group=0  ;tables cdrink/list missing; run;
proc freq data=b.thesis; where group=1 ;tables cdrink/list missing; run;
proc freq data=b.thesis; tables cdrink*group/chisq; run;
	
proc freq data=b.thesis; where group=0  ;tables pdrink/list missing; run;
proc freq data=b.thesis; where group=1 ;tables pdrink/list missing; run;
proc freq data=b.thesis; tables pdrink*group/chisq; run;


/*Model1*/
/*Adjusted for age, sex*/
proc logistic data=b.thesis; where cdrink not in (99);    

	class group1(PARAM=REF REF='0') DS1_SEX1(PARAM=REF REF='1')    ;
    model cdrink(ref='0') = group1 cage DS1_SEX1 ; 
	
run;

/*Model2*/
/*Adjusted for all model 1 factors, as well as marital status, education, income, employment status, self-rated health*/
proc logistic data=b.thesis; where cdrink not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
              PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0')  ;

    model cdrink (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 ; run;


/*Model3*/
/*Adjusted for all model 2 factors, as well as other health behaviors (smoking, drinking, physical activity, non-obesity)*/
proc logistic data=b.thesis; where cdrink not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
             PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  psmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1(PARAM=REF REF='1') gbmi1(PARAM=REF REF='1') 
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0') csmok(PARAM=REF REF='0') gexer_wk5(PARAM=REF REF='1') gbmi3(PARAM=REF REF='1');

    model cdrink (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 csmok gexer_wk5 gbmi3; run;



/*Physical activity*/

/***physical activity data cleaning**/	
data b.thesis  ; set b.thesis ;			
	if DS1_EXER in ('66666', '99999') then gexer=99; else if DS1_EXER='2' then gexer=1; else if DS1_EXER in ('1') then gexer=0;  
	/*'2'=한다(1), '1'=안한다(0)*/					       
	if DS1_EXERFQ=1 then gexer_n=1.5; else if DS1_EXERFQ=2 then gexer_n=3.5; 					
	else if DS1_EXERFQ=3 then gexer_n=5.5; else if DS1_EXERFQ=4 then gexer_n=7; 			
	else if DS1_EXER in ('1') then gexer_n=0; else if DS1_EXERFQ in ('99999' ,'77777') then gexer_n=99999; 					
	/* 1proc freq data=b.total_final_1=주1-2회(1.5), 2=주3-4회(3.5), 3=주5-6회(5.5), 4=매일(7), DS_EXER가 아니요 (0), missing(99999) */					
				
          if gexer_n not in ('77777','99999') and DS1_EXERDU not in ('77777', '99999') then gexer_wk=gexer_n*DS1_EXERDU; 					
          else if gexer_n in (99999) or DS1_EXERDU in ('99999') then gexer_wk=99999;     /*else if gexer_n in (77777) or DS1_EXERDU in ('77777') then gexer_wk=77777;*/					
          else if DS1_EXER in ('1') then gexer_wk=0;  if 0=<gexer_wk<150 then gexer_wk1=1;					
          else if 150=<gexer_wk<99999 then gexer_wk1=2; else if gexer_wk=99999 then gexer_wk1=99;          					
          /*gexer_wk1: 주 150분 미만 (1), 주 150분 이상 (2)*/					
					
		  if gexer_wk=0 then gexer_wk2=1; else if 0<gexer_wk<150 then gexer_wk2=2; else if 150=<gexer_wk<99999 then gexer_wk2=3; 			
          else if gexer_wk=99999 then gexer_wk2=99;		
		  /*gexer_wk2: 운동안함(1), 주 150분 미만(2), 주 150분 이상(3)*/			
					
		  if gexer_wk=0 then gexer_wk3=1; else if 0<gexer_wk<99999 then gexer_wk3=2; else if gexer_wk=99999 then gexer_wk3=99;    			
		  /*gexer_wk3: 운동안함(1), 운동함 (2)*/			
run;

proc freq data=b.thesis; where group=0; tables gexer_wk1/list missing; run;
proc freq data=b.thesis; where group=1; tables gexer_wk1/list missing; run;
proc freq data=b.thesis; tables gexer_wk1*group/chisq; run;


/*Model1*/
/*Adjusted for age, sex*/
proc logistic data=b.thesis; where gexer_wk1 not in (99);    
	class group1(PARAM=REF REF='0') DS1_SEX1(PARAM=REF REF='1')    ;
    model gexer_wk1(ref='1') = group1 cage DS1_SEX1 ; 
run;


/*Model2*/
/*Adjusted for all model 1 factors, as well as marital status, education, income, employment status, self-rated health*/
proc logistic data=b.thesis; where gexer_wk1 not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
              PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0')  ;

    model gexer_wk1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 ; run;


/*Model3*/
/*Adjusted for all model 2 factors, as well as other health behaviors (smoking, drinking, physical activity, non-obesity)*/
proc logistic data=b.thesis; where gexer_wk1 not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
             PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  psmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1(PARAM=REF REF='1') gbmi1(PARAM=REF REF='1') 
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk5(PARAM=REF REF='1') gbmi3(PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 cdrink gexer_wk5 gbmi3; run;

/*Obesity*/

/***gbmi data cleaning****/
data b.thesis  ; set b.thesis  ;	
	if DS1_HEIGHT in ('66666', '99999') or DS1_WEIGHT in ('66666', '99999') then gbmi=99999; 			
	else if DS1_HEIGHT not in ('66666', '99999') and DS1_WEIGHT not in ('66666', '99999') then gbmi=DS1_WEIGHT/((DS1_HEIGHT/100)*(DS1_HEIGHT/100)); 			
	/*gbmi1: 23 미만 (1), 23 이상 (2)*/
	if 0<gbmi<23 then gbmi1=1; else if 23<=gbmi<99999 then gbmi1=2; else if gbmi=99999 then gbmi1=99999;        	
	/*gbmi2: 23미만(1), 23이상 25미만(2) , 25이상(3)*/	
	if 0<gbmi<23 then gbmi2=1; else if 23<=gbmi<25 then gbmi2=2; else if 25<=gbmi<99 then gbmi2=3;		
	else if gbmi=99999 then gbmi2=99999;
	 if 0<gbmi<25 then gbmi3=1; else if 25<=gbmi<99999 then gbmi3=2; else if gbmi=99999 then gbmi3=99999;        	
	/*gbmi3: 25 미만 (1), 25 이상 (2)*/
run;		

/*Model1*/
/*Adjusted for age, sex*/
proc logistic data=b.thesis; where gbmi1 not in (99);    
	class group1(PARAM=REF REF='0') DS1_SEX1(PARAM=REF REF='1')    ;
    model gbmi1(ref='1') = group1 cage DS1_SEX1 ; 
run;

/*Model2*/
/*Adjusted for all model 1 factors, as well as marital status, education, income, employment status, self-rated health*/
proc logistic data=b.thesis; where gbmi1 not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
              PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0')  ;

    model gbmi1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 ; run;


/*Model3*/
/*Adjusted for all model 2 factors, as well as other health behaviors (smoking, drinking, physical activity, non-obesity)*/
proc logistic data=b.thesis; where gbmi1 not in (99) ;    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1(PARAM=REF REF='1')  DS1_INCOME1(PARAM=REF REF='1')  DS1_JOB_1(PARAM=REF REF='1') 
             PWI_2 (PARAM=REF REF='1') DS1_SRH_1 (PARAM=REF REF='1')  psmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1(PARAM=REF REF='1') gbmi1(PARAM=REF REF='1') 
			  DS1_FCA_1(PARAM=REF REF='1') group1 (PARAM=REF REF='0')   cdrink(PARAM=REF REF='0') csmok(PARAM=REF REF='0') gexer_wk5(PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1  PWI_2  DS1_SRH_1 DS1_FCA_1 cdrink csmok gexer_wk5 ; run;
