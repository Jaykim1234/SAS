libname A  'C:\Users\USER01\Desktop\전체\5-21 과제\Data analysis';
libname B 'C:\Users\USER01\Desktop\전체\5-21 과제\Data analysis\result';

/**************************/
/*******Total Dataset*******/
/*************************/

/** Raw Thesis Dataset 에서 시작**/

/**** Variable Modification ****/
/***** Data Reveiw Table *****/

proc contents data=a.thesis_total ; run;

/*****최소 한개 이상의 암이 걸린 사람들 테이블*****/
proc freq data=a.thesis_total ; where ca+ LI_C+ CO_C +BR_C +CE_C+THY_C+ LU_C+PRO_C+BL_C+OT_C >= 1 ; table ca*LI_C*CO_C* BR_C*CE_C*THY_C*LU_C*PRO_C*BL_C*OT_C/list missing; run;


data b.thesis; set a.thesis_total;
    if ca+ LI_C+ CO_C +BR_C +CE_C+THY_C+ LU_C+PRO_C+BL_C+OT_C = 1then group1=0;
    else if ca+ LI_C+ CO_C +BR_C +CE_C+THY_C+ LU_C+PRO_C+BL_C+OT_C >= 2  then group1=1; run; /**0: 암이 하나만 걸린 사람 1: 암이 2개 이상 걸린 사람**/
proc freq data= b.thesis; tables group1/list missing; run;


/*****나이*****/
data b.thesis; set b.thesis;
    cage=DS1_AGE+0;
run;
proc freq data=b.thesis; tables DS1_AGE; run;
proc freq data=b.thesis; tables cage; run;
data b.thesis  ; set b.thesis ;
    if cage<50 then DS1_AGE1=1; else if cage<55 then DS1_AGE1=2;  else if cage<60 then DS1_AGE1=3; else if cage<65 then DS1_AGE1=4; else DS1_AGE1 =5; run;
proc freq data=b.thesis;  tables DS1_AGE1*group1/chisq; run;
/***나이(평균 및 표준편차)univariate***/
proc univariate data=b.thesis ; class group1; var cage; run;
proc univariate data=b.thesis ; var cage; run;
/***나이(평균 및 표준편차)ttest***/
proc ttest data=b.thesis; class group1;var cage; run;

/***성별***/
data b.thesis; set b.thesis;
    if DS1_SEX in ('1') then DS1_SEX1=1; else if DS1_SEX in ('2') then DS1_SEX1=2; else if DS1_SEX in ('99999') then DS1_SEX1 = 99; run;
proc freq data=b.thesis; tables DS1_SEX1; run;
proc freq data=b.thesis; where group1=0;tables DS1_SEX1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_SEX1/list missing; run;
proc freq data=b.thesis;  tables DS1_SEX1*group1/chisq; run;



/*DS1_MARRY_A_1; 미혼/별거/이혼/사별/기타 (1), 기혼/동거=결혼(2), */
data  b.thesis  ; set  b.thesis ;
    if DS1_MARRY_A in ('2') or  DS1_MARRY in ('2','6') then DS1_MARRY_A_1=2; else if DS1_MARRY_A in ('66666','99999') and DS1_MARRY in ('66666','99999') then DS1_MARRY_A_1=99; else DS1_MARRY_A_1=1;  run;
proc freq data= b.thesis; where group1=0;tables DS1_MARRY_A_1/list missing; run;
proc freq data= b.thesis; where group1=1;tables DS1_MARRY_A_1/list missing; run;
proc freq data= b.thesis; tables DS1_MARRY_A_1*group1/chisq; run;

/*DS1_EDU*/
data b.thesis; set b.thesis  ; /* 0=학교에 다니지 않았다, 1=초등학교 중퇴, 2=초등학교 졸업 또는 중학교 중퇴, 3=중학교 졸업 또는 고등학교 중퇴, 4=고등학교 졸업, 5=기술(전문)학교 졸업, 6=대학교 중퇴, 7=대학교 졸업, 8=대학원 이상 */
    if DS1_EDU in ('0','1','2','3','4') then DS1_EDU1=1; else if DS1_EDU in ('5','6','7','8') then DS1_EDU1=2; else if DS1_EDU in ('99999') then DS1_EDU1=99;
    if DS1_EDU in ('0','1','2','3') then DS1_EDU2=1;else if DS1_EDU in ('4') then DS1_EDU2=2; else if DS1_EDU in ('5','6','7','8') then DS1_EDU2=3; else if DS1_EDU in ('99999') then DS1_EDU2=99;  run;
proc freq data=b.thesis; tables DS1_EDU*group1/chisq; run;
proc freq data=b.thesis; where group1=0;tables DS1_EDU1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_EDU1/list missing; run;
proc freq data=b.thesis; tables DS1_EDU1*group1/chisq; run;
proc freq data=b.thesis; tables DS1_EDU2*group1/chisq; run;

/****수입****/
data b.thesis  ; set b.thesis  ;
    if DS1_INCOME in ('1','2','3','4') then DS1_INCOME1=1; else if DS1_INCOME in ('5','6') then DS1_INCOME1=2; else if DS1_INCOME in ('7','8') then DS1_INCOME1=3;
    if DS1_INCOME in ('1','2','3','4','5') then DS1_INCOME2=1; else if DS1_INCOME in ('6','7','8') then DS1_INCOME2=2; else if DS1_INCOME in ('66666','99999') then DS1_INCOME2=99;
    else if DS1_INCOME in ('66666','99999') then DS1_INCOME1=99; run;
proc freq data=b.thesis; where group1=0;tables DS1_INCOME/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_INCOME/list missing; run;
proc freq data=b.thesis; tables DS1_INCOME1*group1/chisq; run;    /* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 */
proc freq data=b.thesis; tables DS1_INCOME2*group1/chisq; run;    /* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 */

/*DS1_JOB_1; 주부나 무직(1), 직업있음(2)*/
data b.thesis ; set b.thesis  ;
    if DS1_JOB in ('66666','99999') and DS1_JOB_A in ('66666','99999') then DS1_JOB_1=99;
    else if DS1_JOB in ('12','13') or DS1_JOB_A in ('12') then DS1_JOB_1=1; else DS1_JOB_1=2; run;
proc freq data=b.thesis; where group1=0;tables DS1_JOB_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_JOB_1/list missing; run;
proc freq data=b.thesis; tables DS1_JOB_1*group1/chisq; run;

/*흡연*/
data b.thesis  ; set b.thesis  ;
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then csmok=99;
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then csmok=1;                           /*csmok: 현재흡연 (1), 과거흡연& 경험없음(0)*/
    else if DS1_SMOKE in ('1', '2') or  DS1_SMOKE_100 in ('1', '2') then csmok=0;

            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then psmok=99;
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then psmok=2;
    else if DS1_SMOKE in ('2') or  DS1_SMOKE_100 in ('2') then psmok=1;
    else if DS1_SMOKE in ('1') or  DS1_SMOKE_100 in ('1') then psmok=0; run;     /*psmok: 현재흡연 (2), 과거흡연 (1), 경험없음 (0)*/
proc freq data=b.thesis; where group1=0; tables psmok/list missing; run;
proc freq data=b.thesis; where group1=1; tables psmok/list missing; run;
proc freq data=b.thesis;  tables psmok*group1/chisq; run;
proc freq data=b.thesis; where psmok^=99 ; tables psmok*group1/chisq; run;

/*음주*/
data b.thesis  ; set b.thesis  ;
            if DS1_DRINK in ('66666', '99999') then cdrink=99;
    else if DS1_DRINK='3' then cdrink=1;
    else if DS1_DRINK in ('1', '2') then cdrink=0;                     /*cdrink: 현재음주(1), 현재음주안함(0)*/

            if DS1_DRINK in ('66666', '99999') then pdrink=99;
    else if DS1_DRINK='3' then pdrink=2;
    else if DS1_DRINK='2' then pdrink=1;
    else if DS1_DRINK in ('1') then pdrink=0; run;           /*pdrink: 현재음주 (2), 과거음주 (1), 경험없음 (0)*/
proc freq data=b.thesis; where group1=0  ;tables pdrink/list missing; run;
proc freq data=b.thesis; where group1=1 ;tables pdrink/list missing; run;
proc freq data=b.thesis; tables pdrink*group1/chisq; run;

/***운동**/
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
proc freq data=b.thesis; where group1=0; tables gexer_wk2/list missing; run;
proc freq data=b.thesis; where group1=1; tables gexer_wk2/list missing; run;
proc freq data=b.thesis; tables gexer_wk2*group1/chisq; run;

/***gbmi****/
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
proc freq data=b.thesis; where group1=0;tables gbmi2/list missing; run;
proc freq data=b.thesis; where group1=1;tables gbmi2/list missing; run;
proc freq data=b.thesis;  tables gbmi2*group1/chisq; run;

/*DS1_SRH_1/2; 건강함(1), 건강하지않음(2)*/
data b.thesis ; set b.thesis  ;
    if DS1_SRH in ('1','2') then DS1_SRH_1=1; else if DS1_SRH in ('3','4','5') then DS1_SRH_1=2; else if DS1_SRH in ('66666','99999') then DS1_SRH_1=99;
    if DS1_SRH in ('1','2','3') then DS1_SRH_2=1; else if DS1_SRH in ('4','5') then DS1_SRH_2=2; else if DS1_SRH in ('66666','99999') then DS1_SRH_2=99;
run;

proc freq data=b.thesis; where group1=0;tables DS1_SRH_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_SRH_1/list missing; run;
proc freq data=b.thesis;  tables DS1_SRH_1*group1/chisq; run;


/*DS1_FCA_1; 암가족력없음(1), 암가족력있음(2)*/
data b.thesis ; set b.thesis  ;
    if DS1_FCA in ('66666','99999') and DS1_FCA1 in ('66666','99999') then DS1_FCA_1=99; else if DS1_FCA in ('2') or DS1_FCA1 in ('2') then DS1_FCA_1=2; else DS1_FCA_1=1;
run;

proc freq data=b.thesis; where group1=0;tables DS1_FCA_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_FCA_1/list missing; run;
proc freq data=b.thesis;  tables DS1_FCA_1*group1/chisq; run;


/***스트레스pwi****/
/****pwi 공식으로 총점 구하기***/
data b.thesis; set b.thesis;
    pwi = ds1_pwi1 + (3-ds1_pwi2) + (3-ds1_pwi3) + (3-ds1_pwi4) + ds1_pwi5 + ds1_pwi6 + (3-ds1_pwi7) + ds1_pwi8 + ds1_pwi9 + ds1_pwi10 + ds1_pwi11 + ds1_pwi12 +
    (3-ds1_pwi13) + ds1_pwi14 + (3-ds1_pwi15) + (3-ds1_pwi16) + ds1_pwi17 + ds1_pwi18; run;
data b.thesis; set b.thesis;
    if  ds1_pwi1 in ('99999') or ds1_pwi2 in ('99999') or ds1_pwi3 in ('99999') or ds1_pwi4 in ('99999') or ds1_pwi5 in ('99999') or ds1_pwi6 in ('99999') or ds1_pwi7 in ('99999') or ds1_pwi8 in ('99999') or ds1_pwi9 in ('99999') or
       ds1_pwi10 in ('99999') or ds1_pwi11 in ('99999') or ds1_pwi12 in ('99999') or ds1_pwi13 in ('99999') or ds1_pwi14 in ('99999') or ds1_pwi15 in ('99999') or ds1_pwi16 in ('99999') or
       ds1_pwi17 in ('99999') or ds1_pwi18 in ('99999') then  pwi=99999;run;
proc freq data=b.thesis; tables pwi; run;

data b.thesis  ; set b.thesis  ;
    if -999999<pwi<0  then PWI1=99999;
    else if 99999<=pwi<=1000014  then PWI1=99999;   run;
proc freq data=b.thesis; tables PWI1; RUN;
data b.thesis  ; set b.thesis  ;  DS1_pwi_1= DS1_pwi+0; run;
proc freq data=b.thesis; where DS1_pwi_1^=pwi; tables DS1_pwi*pwi/list missing; run;/***0개***/
proc freq data=b.thesis; where DS1_pwi_1^=pwi and DS1_pwi_1=99999 and pwi not in (.) ; tables ds1_pwi1--ds1_pwi18; run;/***0개***/

data b.thesis ; set b.thesis ;
    if pwi=99999 then PWI_1 =99999; /***missing ***/
    else if 0<=pwi<=8 then PWI_1 = 1; /***정상***/
    else if 9<=pwi<=26 then PWI_1 = 2; /***약간 스트레스****/
    else if 27<=pwi<99999 then PWI_1=3; /****매우 스트레스****/
    if pwi=99999 then PWI_2 = 99999;
    else if 0<=pwi<=8 then PWI_2 = 1; /***정상***/
    else if 9<=pwi<99999 then PWI_2 = 2;/***약간 스트레스 + 매우 스트레스*/
run;

proc freq data=b.Thesis; where group1=0; tables PWI_1; run;
proc freq data=b.Thesis; where group1=1; tables PWI_1; run;
proc freq data=b.thesis;  tables PWI_1*group1/chisq; run;
proc univariate data=b.thesis ; where PWI^=99999; class group1; var PWI; run;
proc ttest data=b.thesis; where PWI^=99999;  class group1; var PWI; run;

/***OC 사용여부****/
/*DS1_ORALCON: OC사용한적 없음(1), 있음(2, 과거사용+현재사용)*/
proc freq data=b.thesis; tables ds1_oralcon/list missing; run;
data b.thesis; set b.thesis;
    if DS1_ORALCON in ('77777','99999') then DS1_ORALCON_1=99; else if DS1_ORALCON=1 then DS1_ORALCON_1=1; else DS1_ORALCON_1=2;
run;
proc freq data=b.thesis; tables ds1_oralcon * ds1_oralcon_1/list missing; run;

proc freq data=b.thesis; where group1=0;tables DS1_ORALCON_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_ORALCON_1/list missing; run;
proc freq data=b.thesis;  tables DS1_ORALCON_1*group1/chisq; run;


/***생리 여부****/
proc freq data=b.thesis; tables ds1_menyn_a/list missing; run;
data b.thesis; set b.thesis;
    if DS1_MENYN_A in  ('66666','77777','99999') and DS1_MENYN in  ('66666','77777','99999') then DS1_MENYN_1=99;
    else if  DS1_MENYN_A=1 or  DS1_MENYN=1 then DS1_MENYN_1=1;
    else  DS1_MENYN_1=2;
    /* DS1_MENYN: 폐경=생리 없음(1), 생리 있음(2)*/
run;

proc freq data=b.thesis; tables ds1_menyn * ds1_menyn_a * ds1_menyn_1/list missing; run;
proc freq data=b.thesis; where group1=0;tables DS1_MENYN_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_MENYN_1/list missing; run;
proc freq data=b.thesis;  tables DS1_MENYN_1*group1/chisq; run;



/***************************************Metabolic syndrome 변수 만들기 */
data b.thesis; set b.thesis;
    cheight = DS1_HEIGHT+0;
    cweight = DS1_WEIGHT+0;
    cwaist = DS1_WAIST+0;
    chip = DS1_HIP+0 ;
    ds1_tg1 = ds1_tg+0;
    ds1_hdl1 = ds1_hdl+0;
    ds1_dbp1 = ds1_dbp+0;
    ds1_sbp1 = ds1_sbp+0;
    ds1_glu0_1 = ds1_glu0+0;
run;
proc freq data=b.thesis; tables ds1_height * cheight/list missing; run;
proc freq data=b.thesis; tables ds1_weight * cweight/list missing; run;
proc freq data=b.thesis; tables ds1_waist * cwaist/list missing; run;
proc freq data=b.thesis; tables ds1_hip * chip/list missing; run;
proc univariate data=b.thesis; var ds1_tg1; run;
proc univariate data=b.thesis; var ds1_hdl1; run;
proc univariate data=b.thesis; var ds1_dbp1; run;
proc univariate data=b.thesis; var ds1_sbp1; run;
proc univariate data=b.thesis; var ds1_glu0_1; run;

/*MeS 만들기*/
data  b.thesis; set  b.thesis;
    if  cwaist=99999 then wc=99;
    else if (cwaist >=90 and DS1_SEX1=1) or (cwaist >=80 and DS1_SEX1=2) then wc=1;
    else wc=0;
    /*wc=1이면 metabolic syndrom, wc=0 이면 metS 해당없음 */

    if DS1_TG1 =99999 then TG=99;
    else if DS1_TG1 >=150 or DS1_LIPCUTY=1 or DS1_LIPCUTRPM=2 then TG=1;
    else TG=0;
    /*TG=1 이면 metS criteria인 highTC*/

    if DS1_HDL1 =99999 then HDL=99;
    else if (DS1_HDL1 <40 and DS1_SEX1=1) or (DS1_HDL1 <50 and DS1_SEX1=2) then HDL=1;
    else HDL=0;
    /*HDL=1 이면 metS criteria*/

    if DS1_DBP1=99999 or DS1_SBP1=99999 then BP=99;
    else if DS1_SBP1 >=130 or DS1_DBP1 >=85 or DS1_HTNCUTY=1 or DS1_HTNCUTRPM=2 or DS1_BP_MEDI=2 then BP=1;
    else BP=0;
    /*BP=1 이면 metS criteria*/

    if DS1_GLU0_1 =99999 then GLU=99;
    else IF DS1_GLU0_1>=100 or DS1_DMCUTY=1 or DS1_DMCUTY=2 or DS1_DMCUTY=4 or DS1_DMCUTY1=1 or DS1_DMCUTY1=2 or DS1_DMCUTY1=4 or   DS1_DMCUTRPM=2 or DS1_DMCUTRIN=2 then GLU=1;
    else GLU=0;
    /*GLU=1 이면 metS criteria*/
run;
data  b.thesis(drop = i); set  b.thesis;
    metS_sum = 0;
    do i = wc, tg, hdl, bp, glu;
        if i ^= 99 then metS_sum + i;
        else metS_sum + 0;
    end;

    if metS_sum > 2 then MeS = 1;
    else MeS = 0;
run;
proc freq data=b.thesis; tables metS_sum * MeS/list missing; run;
proc freq data=b.thesis; tables wc * tg * hdl * bp * glu * metS_sum * MeS/list missing; run;
proc freq data=b.thesis; tables MeS * group1/chisq; run;

proc freq data=b.thesis; where wc ^= 99; tables wc * group1/chisq; run;
proc univariate data=b.thesis; where wc ^= 99; class group1; var cwaist; run;
proc freq data=b.thesis; where tg ^= 99; tables tg * group1/chisq; run;
proc univariate data=b.thesis; where tg ^= 99; class tg; var ds1_tg1; run;
proc freq data=b.thesis; where hdl ^= 99; tables hdl * group1/chisq; run;
proc univariate data=b.thesis; where hdl ^= 99; class hdl; var ds1_hdl1; run;
proc freq data=b.thesis; where bp ^= 99; tables bp * group1/chisq; run;
proc univariate data=b.thesis; where bp ^= 99; class bp; var ds1_dbp1; run;
proc univariate data=b.thesis; where bp ^= 99; class bp; var ds1_sbp1; run;
proc freq data=b.thesis; where glu ^= 99; tables glu * group1/chisq; run;
proc univariate data=b.thesis; where glu ^= 99; class glu; var ds1_glu0_1; run;

proc ttest data=b.thesis; where cwaist^=99999; class group1; var cwaist; run;
proc ttest data=b.thesis; where DS1_TG1^=99999; class group1; var DS1_TG1; run;
proc ttest data=b.thesis; where DS1_HDL1^=99999; class group1; var DS1_HDL1; run;
proc ttest data=b.thesis; where DS1_SBP1^=99999; class group1; var DS1_SBP1; run;
proc ttest data=b.thesis; where DS1_DBP1^=99999; class group1; var DS1_DBP1; run;
proc ttest data=b.thesis; where DS1_GLU0_1^=99999; class group1; var DS1_GLU0_1; run;

/****Chart : 전체 성별에 따라 흡연, 음주, 운동, 스트레스****/
/****(1) Smoke****/
proc freq data=b.thesis; where psmok^=99 and DS1_SEX1=1; tables psmok*group1/chisq; run;
proc freq data=b.thesis; where psmok^=99 and DS1_SEX1=2; tables psmok*group1/chisq; run;
/****(2) Drink****/
proc freq data=b.thesis; where pdrink^=99 and DS1_SEX1=1; tables pdrink*group1/chisq; run;
proc freq data=b.thesis; where pdrink^=99 and DS1_SEX1=2; tables pdrink*group1/chisq; run;
/****(3) Gexer****/
proc freq data=b.thesis; where gexer_wk2^=99 and DS1_SEX1=1; tables gexer_wk2*group1/chisq; run;
proc freq data=b.thesis; where gexer_wk2^=99 and DS1_SEX1=2; tables gexer_wk2*group1/chisq; run;
/****(4) Gbmi2****/
proc freq data=b.thesis; where gbmi2^=99999 and DS1_SEX1=1; tables gbmi2*group1/chisq; run;
proc freq data=b.thesis; where gbmi2^=99999 and DS1_SEX1=2; tables gbmi2*group1/chisq; run;
/****(5) pwi_1****/
proc freq data=b.thesis; where pwi_1^=99999 and DS1_SEX1=1; tables pwi_1*group1/chisq; run;
proc freq data=b.thesis; where pwi_1^=99999 and DS1_SEX1=2; tables pwi_1*group1/chisq; run;
/****(6) Totalkcal****/
proc freq data=b.thesis; where Totalkcal^=9999 and DS1_SEX1=1; tables Totalkcal*group1/chisq; run;
proc freq data=b.thesis; where Totalkcal^=9999 and DS1_SEX1=2; tables Totalkcal*group1/chisq; run;
/****(7) MeS****/
proc freq data=b.thesis; where DS1_SEX1=1; tables MeS*group1/chisq; run;
proc freq data=b.thesis; where DS1_SEX1=2; tables MeS*group1/chisq; run;
/****(8) WC****/
proc freq data=b.thesis; where wc ^= 99 and DS1_SEX1=1; tables wc*group1/chisq; run;
proc freq data=b.thesis; where wc ^= 99 and DS1_SEX1=2; tables wc*group1/chisq; run;
/****(9) TG****/
proc freq data=b.thesis; where TG ^= 99 and DS1_SEX1=1; tables TG*group1/chisq; run;
proc freq data=b.thesis; where TG ^= 99 and DS1_SEX1=2; tables TG*group1/chisq; run;
/****(10) HDL****/
proc freq data=b.thesis; where HDL ^= 99 and DS1_SEX1=1; tables HDL*group1/chisq; run;
proc freq data=b.thesis; where HDL ^= 99 and DS1_SEX1=2; tables HDL*group1/chisq; run;
/****(11) BP****/
proc freq data=b.thesis; where BP ^= 99 and DS1_SEX1=1; tables BP*group1/chisq; run;
proc freq data=b.thesis; where BP ^= 99 and DS1_SEX1=2; tables BP*group1/chisq; run;
/****(12) GLU****/
proc freq data=b.thesis; where GLU ^= 99 and DS1_SEX1=1; tables GLU*group1/chisq; run;
proc freq data=b.thesis; where GLU ^= 99 and DS1_SEX1=2; tables GLU*group1/chisq; run;


/*******Data Reveiw for Nutrition *******/
/*****영양  (DS1_SS01 DS1_SS24)*****/
data b.thesis; set b.thesis;
    if DS1_SS01^='' then SS01=DS1_SS01+0;  else if DS1_SS01='' then SS01=99999;
    if DS1_SS02^='' then SS02=DS1_SS02+0;  else if DS1_SS02='' then SS02=99999;
    if DS1_SS03^='' then SS03=DS1_SS03+0;  else if DS1_SS03='' then SS03=99999;
    if DS1_SS04^='' then SS04=DS1_SS04+0;  else if DS1_SS04='' then SS04=99999;
    if DS1_SS05^='' then SS05=DS1_SS05+0;  else if DS1_SS05='' then SS05=99999;
    if DS1_SS06^='' then SS06=DS1_SS06+0;  else if DS1_SS06='' then SS06=99999;
    if DS1_SS07^='' then SS07=DS1_SS07+0;  else if DS1_SS07='' then SS07=99999;
    if DS1_SS08^='' then SS08=DS1_SS08+0;  else if DS1_SS08='' then SS08=99999;
    if DS1_SS09^='' then SS09=DS1_SS09+0;  else if DS1_SS09='' then SS09=99999;
    if DS1_SS10^='' then SS10=DS1_SS10+0;  else if DS1_SS10='' then SS10=99999;
    if DS1_SS11^='' then SS11=DS1_SS11+0;  else if DS1_SS11='' then SS11=99999;
    if DS1_SS12^='' then SS12=DS1_SS12+0;  else if DS1_SS12='' then SS12=99999;
    if DS1_SS13^='' then SS13=DS1_SS13+0;  else if DS1_SS13='' then SS13=99999;
    if DS1_SS14^='' then SS14=DS1_SS14+0;  else if DS1_SS14='' then SS14=99999;
    if DS1_SS15^='' then SS15=DS1_SS15+0;  else if DS1_SS15='' then SS15=99999;
    if DS1_SS16^='' then SS16=DS1_SS16+0;  else if DS1_SS16='' then SS16=99999;
    if DS1_SS17^='' then SS17=DS1_SS17+0;  else if DS1_SS17='' then SS17=99999;
    if DS1_SS18^='' then SS18=DS1_SS18+0;  else if DS1_SS18='' then SS18=99999;
    if DS1_SS19^='' then SS19=DS1_SS19+0;  else if DS1_SS19='' then SS19=99999;
    if DS1_SS20^='' then SS20=DS1_SS20+0;  else if DS1_SS20='' then SS20=99999;
    if DS1_SS21^='' then SS21=DS1_SS21+0;  else if DS1_SS21='' then SS21=99999;
    if DS1_SS23^='' then SS23=DS1_SS23+0;  else if DS1_SS23='' then SS23=99999;
    if DS1_SS24^='' then SS24=DS1_SS24+0;  else if DS1_SS24='' then SS24=99999;
run;

/*totalkcal*/
data b.thesis; set b.thesis;
    if 100<SS01<1380 then Totalkcal=1;
    else if 1380<=SS01<1700 then Totalkcal=2;
    else if 1700<=SS01<2000 then Totalkcal=3;
    else if 2000<=SS01<9999 then Totalkcal=4;
    else if 9999<=SS01 then Totalkcal=9999;
run;
proc freq data=b.thesis; where Totalkcal^=9999; tables Totalkcal*group1/chisq; run;

data b.thesis; set b.thesis;
    if SS01=99999 or SS02=99999 then SS02_Per=99999;
    else SS02_Per=(SS02*4)/SS01; /*Proportion of Protein in Total Calorie*/

    if SS01=99999 or SS03=99999 then SS03_Per=99999;
    else    SS03_Per=(SS03*9)/SS01;    /*Proportion of Fat in Total Calorie*/

    if SS01=99999 or SS04=99999 then SS04_Per=99999;
    else SS04_Per=(SS04*4)/SS01;    /*Proportion of Sugar in Total Calorie*/
run;

/****영양 권장량 이상/미만 1: 미만, 2: 이상****/
/***(1)에너지***/
data b.thesis; set b.thesis;
      if SS01^=99999 and SS02^=99999 and SS03^=99999 then SS01_1= DS1_SS02*4+DS1_SS03*9+DS1_SS04* 4; else  SS01_1=99999;
      if SS04^=99999 then sugar_percent= (SS04*4/SS01)*100; else  sugar_percent=99999;
      if SS03^=99999 then fat_percent= (SS03*9/SS01)*100;  else  fat_percent=99999;
      if SS01 in (.,99999) then energy=99999;
 else if DS1_SEX1=1 and DS1_AGE<30 and SS01<2600 then energy=1; else if DS1_SEX1=1 and 30=<DS1_AGE<49 and SS01<2400 then energy=1;
 else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS01<2200 then energy=1; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS01<2000 then energy=1; else if DS1_SEX1=1 and 75=<DS1_AGE and SS01<2000 then energy=1;
 else if DS1_SEX1=2 and DS1_AGE<30 and SS01<2100 then energy=1; else if DS1_SEX1=2 and 30=<DS1_AGE<49 and SS01<1900 then energy=1;
 else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS01<1800 then energy=1; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS01<1600 then energy=1; else if DS1_SEX1=2 and 75=<DS1_AGE and SS01<1600 then energy=1;
 else energy=2; run;

/* Error in Old code */
/*data b.thesis; set b.thesis;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (2600 2400 2200 2000 2000 2100 1900 1800 1600 1600);

     if SS01 in (.,99999) then energy=99999;
     else if SS01 < reference[group12] then energy=1;
     else energy=2;
     drop t1 - t10;
run;*/

proc freq data=b.thesis; tables energy*SS01_1/list missing; run;
proc freq data=b.thesis; tables energy; run; /*1미만 : 30420, 2이상 :15700   99999: 758*/
proc freq data=b.thesis; where energy^=99999; tables energy*group1/chisq; run;

/***(2) 단백질Protein***/
data b.thesis; set b.thesis;
    if SS02 in (.,99999) then Protein=99999;
    else if DS1_SEX1=1 and DS1_AGE<30 and SS02<65 then Protein=0; else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS02<60 then Protein=0;
    else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS02<60 then Protein=0; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS02<55 then Protein=0; else if DS1_SEX1=1 and 75=<DS1_AGE and SS02<55 then Protein=0;
    else if DS1_SEX1=2 and DS1_AGE<30 and SS02<55 then Protein=0; else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS02<50 then Protein=0;
    else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS02<50 then Protein=0; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS02<45 then Protein=0; else if DS1_SEX1=2 and 75=<DS1_AGE and SS02<45then Protein=0;
    else Protein=1;
run;
proc freq data=b.thesis; tables Protein; run;/*1 : 이상19715  0: 미만 26412   751*/
proc freq data=b.thesis; tables Protein*SS02/list missing; run;
proc freq data=b.thesis; tables Protein*group1/chisq; run;

/*(3) 지방*/
/*data b.thesis; set b.thesis;
    if SS03 in (.,99999) then fat=99999;
    if fat_percent=99999 then fat=99999;
    if DS1_SEX1=2 and fat_percent<15 then fat=0; else if DS1_SEX1=2 and 15=<fat_percent=<30 then fat=1; else if DS1_SEX1=2 and 30<fat_percent then fat=2; RUN;*/

data b.thesis; set b.thesis;
    if SS03 = 99999 then fat = 99999;
    else if SS03_Per < 0.15 then fat = 0;
    else if SS03_Per <= 0.30 then fat = 1;
    else fat = 2;
run;
proc freq data=b.thesis; tables fat; run; /*0 미만 : 34,510, 1 범위내 : 59,472, 2 초과 : 76,309,  99999: 3,066*/
proc freq data=b.thesis; tables fat*fat_percent/list missing; run;
proc univariate data=b.thesis; where SS03^=99999; class fat; var SS03;run;

/*(4) 탄수화물*/
data b.thesis; set b.thesis;
    if SS04 in (.,99999) then sugar=99999;
    if sugar_percent=99999 then sugar=99999;
    else if DS1_SEX1=1 and sugar_percent<55 then sugar=0; else if DS1_SEX1=1 and 55=<sugar_percent=<65 then sugar=1; else if DS1_SEX1=1 and 65<sugar_percent then sugar=2; /* 0: 범위 미만 1: 범위내 2: 범위 초과*/
    else if DS1_SEX1=2 and sugar_percent<55 then sugar=0; else if DS1_SEX1=2 and 55=<sugar_percent=<65 then sugar=1; else if DS1_SEX1=2 and 65<sugar_percent then sugar=2; RUN;
proc freq data=b.thesis; tables sugar*sugar_percent/list missing; run;
proc freq data=b.thesis; tables sugar; run;
proc freq data=b.thesis; where sugar^=99999; tables sugar*group1/chisq; run;

data b.thesis; set b.thesis;
    if sugar in (., 99999) then sugar_2=99999;
    else if sugar < 2 then sugar_2=0;
    else sugar_2=1;

    if fat in (., 99999) then fat_2=99999;
    else if fat < 2 then fat_2=0;
    else fat_2=1;
run;
proc freq data=b.thesis; tables sugar*sugar_2/list missing; run;
proc freq data=b.thesis; tables fat*fat_2/list missing; run;
proc univariate data=b.thesis; where SS04^=99999; class sugar_2; var SS04_Per; run;
proc univariate data=b.thesis; where SS03^=99999; class fat_2; var SS03_Per; run;

/*(5) 식이섬유Fiber*/
data  b.thesis; set b.thesis;
    if SS21 in (.,99999) then fiber=99999;
    else if DS1_SEX1=1 and DS1_AGE<30 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS21<25 then fiber=0;
    else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 75=<DS1_AGE and SS21<25 then fiber=0;
    else if DS1_SEX1=2 and DS1_AGE<30 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS21<20 then fiber=0;
    else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 75=<DS1_AGE and SS21<20 then fiber=0;
    else fiber=1; RUN;
proc freq data=b.thesis; tables Fiber; run;
proc freq data=b.thesis; tables Fiber*ss21/list missing;run;
proc freq data=b.thesis; where Fiber^=99999; tables Fiber*group1/chisq; run;

/* Declaration of group12 variable to analyze nutrition*/
data b.thesis; set b.thesis;
    if DS1_SEX1 = 1 and DS1_AGE < 30 then group12=1;
    else if DS1_SEX1 = 1 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=2;
    else if DS1_SEX1 = 1 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=3;
    else if DS1_SEX1 = 1 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=4;
    else if DS1_SEX1 = 1 and DS1_AGE >= 75 then group12=5;
    else if DS1_SEX1 = 2 and DS1_AGE < 30 then group12=6;
    else if DS1_SEX1 = 2 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=7;
    else if DS1_SEX1 = 2 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=8;
    else if DS1_SEX1 = 2 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=9;
    else group12=10;
run;
proc freq data=b.thesis; tables group12; run;

/*Error in Old code*/
/*(6) 비타민A*/
/*data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (800 750 750 700 700 650 650 600 550 550);
    if SS09 in (.,99999) then VitA=99999;
    else if SS09 < reference[group12] then VitA=0;
    else VitA = 1;
run;
data b.thesis; set b.thesis;
    drop t1-t10;
run;
proc freq data=b.thesis; tables VitA; run;/* 미만 35957    이상 10163   758*/
/*proc freq data=b.thesis; tables VitA*ss09/list missing;run;
proc freq data=b.thesis; where VitA^=99999; tables VitA*group1/chisq; run;*/

/*(6) 비타민A */
data b.thesis; set b.thesis;
    if SS09 in (.,99999) then VitA2=99999;
    else if DS1_SEX1=1 and DS1_AGE<30 and SS09<800 then VitA2=0;
    else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS09<750 then VitA2=0;
    else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS09<750 then VitA2=0;
    else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS09<700 then VitA2=0;
    else if DS1_SEX1=1 and 75=<DS1_AGE and SS09<700 then VitA2=0;
    else if DS1_SEX1=2 and DS1_AGE<30 and SS09<650 then VitA2=0;
    else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS09<650 then VitA2=0;
    else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS09<600 then VitA2=0;
    else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS09<550 then VitA2=0;
    else if DS1_SEX1=2 and 75=<DS1_AGE and SS09<550 then VitA2=0;
    else VitA2=1; RUN;
proc freq data=b.thesis; tables VitA2; run; /*미만 35957    이상 10163   758 */
proc freq data=b.thesis; tables VitA2*ss09/list missing;run;
proc freq data=b.thesis; tables VitA2*group1/chisq; run;

/*(7) 티아민(비타민B1)*/
data b.thesis; set b.thesis;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.2 1.2 1.2 1.2 1.2 1.1 1.1 1.1 1.1 1.1);

     if SS11 in (.,99999) then VitB1=99999;
     else if SS11 < reference[group12] then VitB1=0;
     else VitB1=1;
     drop t1 - t10;
run;
proc freq data=b.thesis; tables VitB1; run;
proc freq data=b.thesis; tables VitB1*ss11/list missing;run;
proc freq data=b.thesis; where VitB1^=99999; tables VitB1*group1/chisq; run;

/*(10) 리보플라빈(비타민B2)*/
data b.thesis; set b.thesis;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.5 1.5 1.5 1.5 1.5 1.2 1.2 1.2 1.2 1.2);

     if SS12 in (.,99999) then VitB2=99999;
     else if SS12 < reference[group12] then VitB2=0;
     else VitB2=1;
     drop t1 - t10;
run;
proc freq data=b.thesis; tables VitB2; run;
proc freq data=b.thesis; tables VitB2*ss12/list missing;run;
proc freq data=b.thesis; where VitB2^=99999; tables VitB2*group1/chisq; run;

/*(11) 니아신*/
 data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (16 16 16 16 16 14 14 14 14 14);

    if SS13 in (.,99999) then Niacin=99999;
    else if SS13 < reference[group12] then Niacin=0;
    else Niacin=1;
    drop t1-t10;
run;
proc freq data=b.thesis; tables Niacin; run;
proc freq data=b.thesis; tables Niacin*ss13/list missing;run;
proc freq data=b.thesis; where Niacin^=99999; tables Niacin*group1/chisq; run;

/*(12) 엽산*/
data b.thesis; set b.thesis;
    if SS17 in (.,99999) then Folate=99999;
    else if SS17 < 400 then Folate=0;
    else Folate=1;
run;
proc freq data=b.thesis; tables Folate; run;
proc freq data=b.thesis; tables Folate*ss17/list missing;run;
proc freq data=b.thesis; where Folate^=99999; tables Folate*group1/chisq; run;

/*(13) 비타민B6*/
data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.5 1.5 1.5 1.5 1.5 1.4 1.4 1.4 1.4 1.4);

    if SS16 in (.,99999) then VitB6=99999;
    else if SS16 < reference[group12] then VitB6=0;
    else VitB6=1;
    drop t1-t10;
run;
proc freq data=b.thesis; tables VitB6; run;
proc freq data=b.thesis; tables VitB6*ss16/list missing;run;
proc freq data=b.thesis; where VitB6^=99999; tables VitB6*group1/chisq; run;

/*(14) 비타민C*/
data b.thesis; set b.thesis;
    if SS14 in (.,99999) then VitC=99999;
    else if SS14 < 100 then VitC=0;
    else VitC=1;
run;
proc freq data=b.thesis; tables VitC; run;
proc freq data=b.thesis; tables VitC*ss14/list missing;run;
proc freq data=b.thesis; where VitC^=99999; tables VitC*group1/chisq; run;

/*(15) 비타민E*/
data b.thesis; set b.thesis;
    if SS23 in (.,99999) then VitE=99999;
    else if SS23 < 12 then VitE=0;
    else VitE=1;
run;
proc freq data=b.thesis; tables VitE; run;
proc freq data=b.thesis; tables VitE*ss23/list missing;run;
proc freq data=b.thesis; where VitE^=99999; tables VitE*group1/chisq; run;

/*(16) 칼슘*/
data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (800 800 750 700 700 700 700 800 800 800);

    if SS05 in (.,99999) then cals=99999;
    else if SS05 < reference[group12] then cals=0;
    else cals=1;
    drop t1-t10;
run;
proc freq data=b.thesis; tables cals; run;
proc freq data=b.thesis; tables cals*ss05/list missing;run;
proc freq data=b.thesis; where cals^=99999; tables cals*group1/chisq; run;

/*(17) 인*/
data b.thesis; set b.thesis;
    if SS06 in (.,99999) then pho=99999;
    else if SS06 < 700 then pho=0;
    else pho=1;
run;
proc freq data=b.thesis; tables pho; run;
proc freq data=b.thesis; tables pho*ss06/list missing;run;
proc freq data=b.thesis; where pho^=99999; tables pho*group1/chisq; run;

/*(18) 철*/
data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (10 10 9 9 9 14 14 8 8 7);

    if SS07 in (.,99999) then iron=99999;
    else if SS07 < reference[group12] then iron=0;
    else iron=1;
    drop t1-t10;
run;
proc freq data=b.thesis; tables iron; run;
proc freq data=b.thesis; tables iron*ss07/list missing;run;
proc freq data=b.thesis; where iron^=99999; tables iron*group1/chisq; run;

/*(19) 칼륨*/
data b.thesis; set b.thesis;
    if SS08 in (.,99999) then Cal=99999;
    else if SS08 < 3500 then Cal=0;
    else Cal=1;
run;
proc freq data=b.thesis; tables Cal; run;
proc freq data=b.thesis; tables Cal*ss08/list missing;run;
proc freq data=b.thesis; where Cal^=99999; tables Cal*group1/chisq; run;

/*(20) 아연*/
data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (10 10 9 9 9 8 8 7 7 7);

    if SS15 in (.,99999) then Zinc=99999;
    else if SS15 < reference[group12] then Zinc=0;
    else Zinc=1;
    drop t1-t10;
run;
proc freq data=b.thesis; tables Zinc; run;
proc freq data=b.thesis; tables Zinc*ss15/list missing;run;
proc freq data=b.thesis; where Zinc^=99999; tables Zinc*group1/chisq; run;

/*(21) 나트륨과 염소*/
data b.thesis; set b.thesis;
    array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1500 1500 1500 1300 1100 1500 1500 1500 1300 1100);

    if SS10 in (.,99999) then Na=99999;
    else if SS10 < reference[group12] then Na=0;
    else Na=1;
    drop t1-t10;
run;
proc freq data=b.thesis; tables Na; run;
proc freq data=b.thesis; tables Na*ss10/list missing;run;
proc freq data=b.thesis; where Na^=99999; tables Na*group1/chisq; run;


/*****영양 ttest****/
proc ttest data=b.thesis; where SS01^=99999; class group1; var SS01; run;
proc ttest data=b.thesis; where SS02^=99999; class group1; var SS02; run;
proc ttest data=b.thesis; where SS02_Per^=99999; class group1; var SS02_Per; run;
proc ttest data=b.thesis; where SS03^=99999; class group1; var SS03; run;
proc ttest data=b.thesis; where SS03_Per^=99999; class group1; var SS03_Per; run;
proc ttest data=b.thesis; where SS04^=99999; class group1; var SS04; run;
proc ttest data=b.thesis; where SS04_Per^=99999; class group1; var SS04_Per; run;
proc ttest data=b.thesis; where SS05^=99999; class group1; var SS05; run;
proc ttest data=b.thesis; where SS06^=99999; class group1; var SS06; run;
proc ttest data=b.thesis; where SS07^=99999; class group1; var SS07; run;
proc ttest data=b.thesis; where SS08^=99999; class group1; var SS08; run;
proc ttest data=b.thesis; where SS09^=99999; class group1; var SS09; run;
proc ttest data=b.thesis; where SS10^=99999; class group1; var SS10; run;
proc ttest data=b.thesis; where SS11^=99999; class group1; var SS11; run;
proc ttest data=b.thesis; where SS12^=99999; class group1; var SS12; run;
proc ttest data=b.thesis; where SS13^=99999; class group1; var SS13; run;
proc ttest data=b.thesis; where SS14^=99999; class group1; var SS14; run;
proc ttest data=b.thesis; where SS15^=99999; class group1; var SS15; run;
proc ttest data=b.thesis; where SS16^=99999; class group1; var SS16; run;
proc ttest data=b.thesis; where SS17^=99999; class group1; var SS17; run;
proc ttest data=b.thesis; where SS18^=99999; class group1; var SS18; run;
proc ttest data=b.thesis; where SS19^=99999; class group1; var SS19; run;
proc ttest data=b.thesis; where SS20^=99999; class group1; var SS20; run;
proc ttest data=b.thesis; where SS21^=99999; class group1; var SS21; run;
proc ttest data=b.thesis; where SS23^=99999; class group1; var SS23; run;
proc ttest data=b.thesis; where SS24^=99999; class group1; var SS24; run;


/*******Data Reveiw by Cancer Type *******/
/*암유병자 그룹2 만들기*/
data b.thesis; set b.thesis;
    TOTAL_C = GA_C + LI_C + CO_C + BR_C + CE_C + LU_C + THY_C + PRO_C + BL_C + OT_C;
run;
proc freq data=b.thesis; table TOTAL_C*group1; run; /*암 환자이나 암종 정보가 없는 경우 240명*/

data b.thesis; set b.thesis;
    TOTAL_CA = TOTAL_C>=2;
run;
proc freq data=b.thesis; where CA=1; tables TOTAL_CA;run; /* 암2개 이상 환자 137명*/

data b.thesis; set b.thesis;
    IF GA_C = 1 then CANCER_TYPE=1;
    IF LI_C = 1 then CANCER_TYPE=2;
    IF CO_C = 1 then CANCER_TYPE=3;
    IF BR_C = 1 then CANCER_TYPE=4;
    IF CE_C = 1 then CANCER_TYPE=5;
    IF LU_C = 1 then CANCER_TYPE=6;
    IF THY_C = 1 then CANCER_TYPE=7;
    IF PRO_C = 1 then CANCER_TYPE=8;
    IF BL_C = 1 then CANCER_TYPE=9;
    IF OT_C = 1 then CANCER_TYPE=10;
    IF TOTAL_CA= 1 then CANCER_TYPE=11;
run;
proc freq data=b.thesis; tables CANCER_TYPE; run;

proc freq data=b.thesis; where group1=0; tables CANCER_TYPE*DS1_SEX/chisq; run;
proc freq data=b.thesis; where group1=0 and psmok^=99; tables CANCER_TYPE*psmok/chisq; run;
proc freq data=b.thesis; where group1=0 and pdrink^=99; tables CANCER_TYPE*pdrink/chisq; run;
proc freq data=b.thesis; where group1=0 and gexer_wk2^=99; tables CANCER_TYPE*gexer_wk2/chisq; run;
proc freq data=b.thesis; where group1=0 and gbmi2^=99999; tables CANCER_TYPE*gbmi2/chisq; run;
proc freq data=b.thesis; where group1=0 and PWI_1^=99999; tables CANCER_TYPE*PWI_1/chisq; run;

proc freq data=b.thesis; where group1=0 and energy^=99999; tables CANCER_TYPE*energy/chisq; run;
proc freq data=b.thesis; where group1=0 and Protein^=99999; tables CANCER_TYPE*Protein/chisq; run;
proc freq data=b.thesis; where group1=0 and fat^=99999; tables CANCER_TYPE*fat/chisq; run;
proc freq data=b.thesis; where group1=0 and sugar^=99999; tables CANCER_TYPE*sugar/chisq; run;
proc freq data=b.thesis; where group1=0 and Fiber^=99999; tables CANCER_TYPE*Fiber/chisq; run;
proc freq data=b.thesis; where group1=0 and VitA^=99999; tables CANCER_TYPE*VitA/chisq; run;
proc freq data=b.thesis; where group1=0 and VitE^=99999; tables CANCER_TYPE*VitE/chisq; run;
proc freq data=b.thesis; where group1=0 and VitC^=99999; tables CANCER_TYPE*VitC/chisq; run;
proc freq data=b.thesis; where group1=0 and VitB1^=99999; tables CANCER_TYPE*VitB1/chisq; run;
proc freq data=b.thesis; where group1=0 and VitB2^=99999; tables CANCER_TYPE*VitB2/chisq; run;
proc freq data=b.thesis; where group1=0 and Niacin^=99999; tables CANCER_TYPE*Niacin/chisq; run;
proc freq data=b.thesis; where group1=0 and VitB6^=99999; tables CANCER_TYPE*VitB6/chisq; run;
proc freq data=b.thesis; where group1=0 and Folate^=99999; tables CANCER_TYPE*Folate/chisq; run;
proc freq data=b.thesis; where group1=0 and cals^=99999; tables CANCER_TYPE*cals/chisq; run;
proc freq data=b.thesis; where group1=0 and pho^=99999; tables CANCER_TYPE*pho/chisq; run;
proc freq data=b.thesis; where group1=0 and Na^=99999; tables CANCER_TYPE*Na/chisq; run;
proc freq data=b.thesis; where group1=0 and Cal^=99999; tables CANCER_TYPE*Cal/chisq; run;
proc freq data=b.thesis; where group1=0 and iron^=99999; tables CANCER_TYPE*iron/chisq; run;
proc freq data=b.thesis; where group1=0 and Zinc^=99999; tables CANCER_TYPE*Zinc/chisq; run;

proc contents data=b.thesis ; run;
/*****Logistic Regression (Total)****/

/**************Smoke*************/
proc freq data=b.thesis; tables csmok/list missing; run; /*Missing of csmok : 1,625 people*/
proc logistic data=b.thesis; where csmok not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') cexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink cexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/**************Drink*************/
proc freq data=b.thesis; tables cdrink/list missing; run; /*Missing of cdrink : 1,465 people*/
proc logistic data=b.thesis; where cdrink not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model cdrink (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc freq data=b.thesis; tables gexer_wk1/list missing; run; /*Missing of gexer_wk1 : 6,671 people*/
proc logistic data=b.thesis; where gexer_wk1 not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********gbmi**********/
proc freq data=b.thesis; tables gbmi1/list missing; run; /*Missing of gbmi1 : 934 people*/
proc logistic data=b.thesis; where gbmi1 not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********PWI**********/
proc freq data=b.thesis; tables PWI_2/list missing; run; /*Missing of PWI_2 : 7,783 people*/
proc logistic data=b.thesis; where PWI_2 not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********MeS**********/
proc freq data=b.thesis; tables MeS/list missing; run;
proc logistic data=b.thesis;

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/**********wc**********/
proc freq data=b.thesis; tables wc/list missing; run; /*Missing of wc : 2,572 people*/
proc logistic data=b.thesis; where wc not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********tg**********/
proc freq data=b.thesis; tables tg/list missing; run; /*Missing of tg : 367 people*/
proc logistic data=b.thesis; where tg not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********hdl**********/
proc freq data=b.thesis; tables hdl/list missing; run; /*Missing of hdl : 50 people*/
proc logistic data=b.thesis; where hdl not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********bp**********/
proc freq data=b.thesis; tables bp/list missing; run; /*Missing of bp : 2,557 people*/
proc logistic data=b.thesis; where bp not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********glu**********/
proc freq data=b.thesis; tables glu/list missing; run; /*Missing of glu : 4,757 people*/
proc logistic data=b.thesis; where glu not in (99);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc freq data=b.thesis; tables energy/list missing; run; /*Missing of energy : 3,066 people*/
proc logistic data=b.thesis; where energy not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1;

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables protein/list missing; run; /*Missing of protein : 3,066 people*/
proc logistic data=b.thesis; where protein not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables fat_2/list missing; run; /*Missing of fat_2 : 59,294 people Only Men*/
proc logistic data=b.thesis; where fat_2 not in (99999);

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables sugar_2/list missing; run; /*Missing of sugar_2 : 3,066 people*/
proc logistic data=b.thesis; where sugar_2 not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables fiber/list missing; run; /*Missing of fiber : 3,066 people*/
proc logistic data=b.thesis; where fiber not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitA/list missing; run; /*Missing of VitA : 3,066 people*/
proc logistic data=b.thesis; where VitA not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitB1/list missing; run; /*Missing of VitB1 : 3,066 people*/
proc logistic data=b.thesis; where VitB1 not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitB2/list missing; run; /*Missing of VitB2 : 3,066 people*/
proc logistic data=b.thesis; where VitB2 not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Niacin/list missing; run; /*Missing of Niacin : 3,066 people*/
proc logistic data=b.thesis; where Niacin not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Folate/list missing; run; /*Missing of Folate : 3,066 people*/
proc logistic data=b.thesis; where Folate not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitB6/list missing; run; /*Missing of VitB6 : 3,066 people*/
proc logistic data=b.thesis; where VitB6 not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitC/list missing; run; /*Missing of VitC : 3,066 people*/
proc logistic data=b.thesis; where VitC not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitE/list missing; run; /*Missing of VitE : 3,066 people*/
proc logistic data=b.thesis; where VitE not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Cals/list missing; run; /*Missing of Cals : 3,066 people*/
proc logistic data=b.thesis; where Cals not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables pho/list missing; run; /*Missing of pho : 3,066 people*/
proc logistic data=b.thesis; where pho not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables iron/list missing; run; /*Missing of iron : 3,066 people*/
proc logistic data=b.thesis; where iron not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Cal/list missing; run; /*Missing of Cal : 3,066 people*/
proc logistic data=b.thesis; where Cal not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Zinc/list missing; run; /*Missing of Zinc : 3,066 people*/
proc logistic data=b.thesis; where Zinc not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Na/list missing; run; /*Missing of Na : 3,066 people*/
proc logistic data=b.thesis; where Na not in (99999);

    class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;


/*****Logistic Regression (Male)****/
/**************Smoke*************/
proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/**************Drink*************/
proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model cdrink (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********gbmi**********/
proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********PWI**********/
proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********MeS**********/
proc logistic data=b.thesis; where DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********wc**********/
proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********tg**********/
proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********hdl**********/
proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********bp**********/
proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********glu**********/
proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.thesis; where energy not in (99999) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1;

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where protein not in (99999) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fat_2 not in (99999) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where sugar_2 not in (99999) and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fiber not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitA not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB1 not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB2 not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Niacin not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Folate not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB6 not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitC not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitE not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cals not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where pho not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where iron not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cal not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Zinc not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Na not in (99999)  and DS1_SEX1=1;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*****Logistic Regression (Female)****/
/**************Smoke*************/
proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk2 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/**************Drink*************/
proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model cdrink (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********gbmi**********/
proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********PWI**********/
proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1;

run;

/**********MeS**********/
proc logistic data=b.thesis; where DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/**********wc**********/
proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/**********tg**********/
proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/**********hdl**********/
proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/**********bp**********/
proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/**********glu**********/
proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1;

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.thesis; where energy not in (99999) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1;

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where protein not in (99999) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fat_2 not in (99999) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where sugar_2 not in (99999) and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fiber not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitA not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB1 not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB2 not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Niacin not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Folate not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB6 not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitC not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitE not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cals not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where pho not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where iron not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cal not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Zinc not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Na not in (99999)  and DS1_SEX1=2;

    class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
              DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1')
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;


/**************************************/
/********1 by 1 Individual  Matching******/
/**************************************/

/******total_final dataset 에서 시작********/
/****group1****/
/* group1=0 : 암생존자, group1=1 : 정상인(질병x),  group1=2 : 정상인(질병o)**/
data b.total_final; set a.total_final_1by1; run;
proc contents data=b.total_final; run;

proc freq data=b.total_final; tables group1; run; /**group10 : 5269명 group11 : 5219명 group12 : 5263명**/

/****age*****/
/***나이(평균 및 표준편차)***/
proc univariate data=b.total_final; class group1; var AGE_1; run; /*group10 : 55.8 group11 : 55.6 group12 : 55.8*/
proc anova data=b.total_final; class group1; model AGE_1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc freq data=b.total_final; tables DS1_AGE*DS1_AGE1/list missing;  run;/**이상없음**/
proc freq data=b.total_final; where group1=0;tables DS1_AGE1/list missing; run;/* 1)50세 미만 : 1267 2)55세 미만 : 1109 3)60세 미만 : 1023 4)65세 미만 : 972 5)65세 이상 : 898 */
proc freq data=b.total_final; where group1=1;tables DS1_AGE1/list missing; run;/* 1)50세 미만 : 1266 2)55세 미만 : 1109 3)60세 미만 : 1019 4)65세 미만 : 966 5)65세 이상 : 859 */
proc freq data=b.total_final; where group1=2;tables DS1_AGE1/list missing; run;/* 1)50세 미만 : 1264 2)55세 미만 : 1109 3)60세 미만 : 1023 4)65세 미만 : 972 5)65세 이상 : 895 */
proc freq data=b.total_final; tables DS1_AGE1*group1/chisq; run; /*p-value : 0.9991*/

/*****sex*****/
proc freq data=b.total_final; tables DS1_SEX1*group1/chisq; run;/**남자 : 3940 여자 : 11581 **//*p-value : 0.9967*/
proc freq data=b.total_final; where group1=0;tables DS1_SEX1/list missing; run; /**남자 : 1320 여자 : 3949 **/
proc freq data=b.total_final; where group1=1;tables DS1_SEX1/list missing; run;/**남자 : 1304 여자 : 3915 **/
proc freq data=b.total_final; where group1=2;tables DS1_SEX1/list missing; run;/**남자 : 1316 여자 : 3947 **/
proc freq data=b.total_final; tables DS1_SEX1*group1/chisq; run; /*p-value : 0.9967*/

/****결혼****/
 /*DS1_MARRY_A_1; 미혼/별거/이혼/사별/기타 (1), 기혼/동거=결혼(2), */
proc freq data=b.total_final; where group1=0;tables DS1_MARRY_A_1/list missing; run; /*1) 미혼/별거/이혼/사별/기타 : 680 2) 결혼 : 4566 99: 23*/
proc freq data=b.total_final; where group1=1;tables DS1_MARRY_A_1/list missing; run; /*1) 미혼/별거/이혼/사별/기타 : 602 2) 결혼 : 4533 99: 84*/
proc freq data=b.total_final; where group1=2;tables DS1_MARRY_A_1/list missing; run; /*1) 미혼/별거/이혼/사별/기타 : 636 2) 결혼 : 4593 99: 34*/
proc freq data=b.total_final; tables DS1_MARRY_A_1*group1/chisq; run;/*p-value : <.0001*/

/****교육****/
/* 0=학교에 다니지 않았다, 1=초등학교 중퇴, 2=초등학교 졸업 또는 중학교 중퇴, 3=중학교 졸업 또는 고등학교 중퇴, 4=고등학교 졸업, 5=기술(전문)학교 졸업, 6=대학교 중퇴, 7=대학교 졸업, 8=대학원 이상 */
proc freq data=b.total_final; tables DS1_EDU*DS1_EDU1/list missing; run;
proc freq data=b.total_final; where group1=0;tables DS1_EDU1/list missing; run;/*1)고졸 미만 : 1973 2) 고졸 : 2115 3) 대졸 이상 : 1120 99: 61 */
proc freq data=b.total_final; where group1=1;tables DS1_EDU1/list missing; run;/*1)고졸 미만 : 2015 2) 고졸 : 2010 3) 대졸 이상 : 1052 99: 142 */
proc freq data=b.total_final; where group1=2;tables DS1_EDU1/list missing; run;/*1)고졸 미만 : 2110 2) 고졸 : 2022 3) 대졸 이상 : 1058 99: 73*/
proc freq data=b.total_final; tables DS1_EDU1*group1/chisq; run;    /*p-value : <.0001*/

/****수입****/
/* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 */
proc freq data=b.total_final;  tables DS1_INCOME*DS1_INCOME1/list missing; run;
proc freq data=b.total_final; where group1=0;tables DS1_INCOME1/list missing; run;/*1) 200만원 미만 : 1798 2) 200만원 이상 400만원 미만 : 1789 3) 400만원 이상 : 954 99 : 728*/
proc freq data=b.total_final; where group1=1;tables DS1_INCOME1/list missing; run;/*1) 200만원 미만 : 1623 2) 200만원 이상 400만원 미만 : 1815 3) 400만원 이상 : 921 99 : 860 */
proc freq data=b.total_final; where group1=2;tables DS1_INCOME1/list missing; run;/*1) 200만원 미만 : 1653 2) 200만원 이상 400만원 미만 : 1789 3) 400만원 이상 : 943 99 : 878 */
proc freq data=b.total_final; tables DS1_INCOME1*group1/chisq; run; /*p-value : 0.0001*/

/****직업****/
 /*DS1_JOB_1; 주부나 무직(1), 직업있음(2)*/
proc freq data=b.total_final; tables DS1_JOB*DS1_JOB_A*DS1_JOB_1; run;
proc freq data=b.total_final; where group1=0;tables DS1_JOB_1/list missing; run; /*1)주부 혹은 무직 : 3149 2)직업있음 : 2005 99 : 115*/
proc freq data=b.total_final; where group1=1;tables DS1_JOB_1/list missing; run;/*1)주부 혹은 무직 : 2698 2)직업있음 : 2340 99 : 181*/
proc freq data=b.total_final; where group1=2;tables DS1_JOB_1/list missing; run;/*1)주부 혹은 무직 : 2892 2)직업있음 : 2212 99 : 159*/
proc freq data=b.total_final; tables DS1_JOB_1*group1/chisq; run;   /*p-value : <.0001*/

/****흡연****/
/*csmok: 현재흡연 (1), 과거흡연& 경험없음(0)*/
/*psmok: 현재흡연 (2), 과거흡연 (1), 경험없음 (0)*/
proc freq data=b.total_final; where group1=0; tables csmok*group1/list missing; run; /*0) 과거흡연&경험없음 : 4962 1) 현재흡연 : 280 99 : 27 */
proc freq data=b.total_final; where group1=1; tables csmok*group1/list missing; run;/*0) 과거흡연&경험없음 : 4697 1) 현재흡연 : 444 99 : 78 */
proc freq data=b.total_final; where group1=2; tables csmok*group1/list missing; run;/*0) 과거흡연&경험없음 : 4825 1) 현재흡연 : 404 99 : 27 */
proc freq data=b.total_final; tables csmok*group1/chisq; run;/*p-value : <.0001*/

proc freq data=b.total_final; where group1=0; tables psmok*group1/list missing; run;/*0) 경험없음 : 4143 1) 과거흡연 : 819 2) 현재흡연 : 280  99 : 27 */
proc freq data=b.total_final; where group1=1; tables psmok*group1/list missing; run;/*0) 경험없음 : 4142 1) 과거흡연 : 555 2) 현재흡연 : 444  99: 78 */
proc freq data=b.total_final; where group1=2; tables psmok*group1/list missing; run;/*0) 경험없음 : 4144 1) 과거흡연 : 681 2) 현재흡연 : 404  99: 34 */
proc freq data=b.total_final; tables psmok*group1/chisq; run;/*p-value : <.0001*/
proc freq data=b.total_final; tables psmok*group1/chisq; run;/*p-value : <.0001*/

/*****음주****/
/*cdrink: 현재음주(1), 현재음주안함(0)*/
/*pdrink: 현재음주 (2), 과거음주 (1), 경험없음 (0)*/
proc freq data=b.total_final; where group1=0;tables cdrink*group1/list missing; run;/* 0) 음주안함 : 3802 1) 현재음주 : 1444 99: 23*/
proc freq data=b.total_final; where group1=1;tables cdrink*group1/list missing; run;/* 0) 음주안함 : 3151 1) 현재음주 : 1990 99: 78*/
proc freq data=b.total_final; where group1=2;tables cdrink*group1/list missing; run;/* 0) 음주안함 : 3207 1) 현재음주 : 2027 99: 78 */
proc freq data=b.total_final; tables cdrink*group1/chisq; run;/*p-value : <.0001*/

proc freq data=b.total_final; where group1=0;tables pdrink*group1/list missing; run;/* 0) 경험없음 : 3275 1) 과거음주 : 527 2) 현재음주 : 1444 99: 23*/
proc freq data=b.total_final; where group1=1;tables pdrink*group1/list missing; run;/* 0) 경험없음 : 3019 1) 과거음주 : 132 2) 현재음주 :1990 99: 78: */
proc freq data=b.total_final; where group1=2;tables pdrink*group1/list missing; run;/* 0) 경험없음 : 3003 1) 과거음주 : 204 2) 현재음주 2027: 99: 29 */
proc freq data=b.total_final; tables pdrink*group1/chisq; run;

/***운동**/
/*gexer_wk1: 주 150분 미만 (1), 주 150분 이상 (2)*/
/*gexer_wk2: 운동안함(1), 주 150분 미만(2), 주 150분 이상(3)*/
/*gexer_wk3: 운동안함(1), 운동함 (2)*/
proc freq data=b.total_final; where group1=0; tables gexer_wk2*group1/list missing; run; /**1) 운동안함 : 2203) 2) 주 150분 미만 : 594 3) 주 150분 이상 : 2332 99 : 140**/
proc freq data=b.total_final; where group1=1; tables gexer_wk2*group1/list missing; run;  /**1) 운동안함 : 2530) 2) 주 150분 미만 : 605 3) 주 150분 이상  1838 99 : 246**/
proc freq data=b.total_final; where group1=2; tables gexer_wk2*group1/list missing; run; /**1) 운동안함 : 2470) 2) 주 150분 미만 : 630 3) 주 150분 이상 : 1987 99 : 176**/
proc freq data=b.total_final; tables gexer_wk2*group1/chisq; run;/*p-value<0.001*/

/***gbmi****/
/*gbmi1: 23 미만 (1), 23 이상 (2)*/
/*gbmi2: 23 미만 (1), 25 미만 (2) 25이상 (3)*/
/*gbmi3: 25 미만 (1), 25 이상 (2)*/
/*gwhratio1: 0.90미만(1), 0.90이상(2)*/
proc freq data=b.total_final;  tables gbmi*gbmi1/list missing; run;
proc freq data=b.total_final;  tables gbmi*gbmi2/list missing; run;
proc freq data=b.total_final;  tables gbmi*gbmi3/list missing; run;
proc freq data=b.total_final; where group1=0;tables gbmi2/list missing; run;/*gbmi2: 1)23 미만 : 2308, 2)25 미만 : 1398 3)25이상 : 1544 99999 : 19 */
proc freq data=b.total_final; where group1=1;tables gbmi2/list missing; run;/*gbmi2: 1)23 미만 : 2286, 2)25 미만 : 1455 3)25이상 : 1453 99999 : 25 */
proc freq data=b.total_final; where group1=2;tables gbmi2/list missing; run;/*gbmi2: 1)23 미만 : 1914, 2)25 미만 : 1484 3)25이상 : 1848 99999 : 17 */
proc freq data=b.total_final; tables gbmi2*group1/chisq; run; /*p-value : 0.0001*/

/****pwi 공식으로 총점 구하기***/
proc freq data=b.total_final; tables ds1_pwi1--ds1_pwi18; run;
data b.total_final; set b.total_final;
    if  ds1_pwi1 in ('99999') or ds1_pwi2 in ('99999') or ds1_pwi3 in ('99999') or ds1_pwi4 in ('99999') or ds1_pwi5 in ('99999') or ds1_pwi6 in ('99999') or ds1_pwi7 in ('99999') or
       ds1_pwi8 in ('99999') or ds1_pwi9 in ('99999') or ds1_pwi10 in ('99999') or ds1_pwi11 in ('99999') or ds1_pwi12 in ('99999') or ds1_pwi13 in ('99999') or ds1_pwi14 in ('99999') or
       ds1_pwi15 in ('99999') or ds1_pwi16 in ('99999') or ds1_pwi17 in ('99999') or ds1_pwi18 in ('99999') then  pwi=99999;
    else pwi = ds1_pwi1 + (3-ds1_pwi2) + (3-ds1_pwi3) + (3-ds1_pwi4) + ds1_pwi5 + ds1_pwi6 + (3-ds1_pwi7) + ds1_pwi8 + ds1_pwi9 + ds1_pwi10 + ds1_pwi11 + ds1_pwi12 + (3-ds1_pwi13) + ds1_pwi14 + (3-ds1_pwi15) + (3-ds1_pwi16) + ds1_pwi17 + ds1_pwi18;
run;
proc univariate data=b.total_final ; where PWI^=99999; class group1; var PWI; run;
proc anova data=b.total_final; where PWI^=99999; class group1; model PWI=group1; MEANS group1 / DUNCAN ;run; quit;

data b.total_final; set b.total_final;
    if PWI_1 = 99999 then PWI_2=99999;
    else if PWI_1 < 2 then PWI_2 = 1;    /*PWI_1 = 1*/
    else PWI_2 = 2; /*PWI_1 = 2, 3*/
run;
proc freq data=b.total_final; tables PWI_2*group1/list missing; run;

proc freq data=b.total_final; tables pwi*pwi_1/list missing; run;
proc freq data=b.total_final; tables pwi*group1/chisq;run;  /*p-value : <.0001*/
proc freq data=b.total_final; tables PWI_1; run;/*1)정상 : 1657 2) 약간 스트레스 :
proc freq data=b.total_final; where group1=0; tables PWI_1; run;/*1)정상 : 532 2) 약간 스트레스 : 3892 3) 매우 심한 스트레스 : 652 99999 : 193 */
proc freq data=b.total_final; where group1=1; tables PWI_1; run;/*1)정상 : 652 2) 약간 스트레스 : 3851 3) 매우 심한 스트레스 : 437 99999 : 279 */
proc freq data=b.total_final; where group1=2; tables PWI_1; run;/*1)정상 : 473 2) 약간 스트레스 : 3892 3) 매우 심한 스트레스 : 664 99999 : 234 */
proc freq data=b.total_final; tables PWI_1*group1/chisq; run;   /*p-value : <.0001*/

/***OC 사용여부****/
/*DS1_ORALCON: OC사용한적 없음(1), 있음(2, 과거사용+현재사용)*/
proc freq data=b.total_final; tables ds1_oralcon/list missing; run;
data b.total_final; set b.total_final;
    if DS1_ORALCON in ('77777','99999') then DS1_ORALCON_1=99; else if DS1_ORALCON=1 then DS1_ORALCON_1=1; else DS1_ORALCON_1=2;
run;
proc freq data=b.total_final; tables ds1_oralcon * ds1_oralcon_1/list missing; run;

/***생리 여부****/
proc freq data=b.total_final; tables ds1_menyn * ds1_menyn_a/list missing; run;
data b.total_final; set b.total_final;
    if DS1_MENYN_A in  ('66666','77777','99999') and DS1_MENYN in  ('66666','77777','99999') then DS1_MENYN_1=99;
    else if  DS1_MENYN_A=1 or  DS1_MENYN=1 then DS1_MENYN_1=1;
    else  DS1_MENYN_1=2;
    /* DS1_MENYN: 폐경=생리 없음(1), 생리 있음(2)*/
run;
proc freq data=b.total_final; tables ds1_menyn * ds1_menyn_a * ds1_menyn_1/list missing; run;


/***************************************Metabolic syndrome 변수 만들기 */
data b.total_final; set b.total_final;
    cheight = DS1_HEIGHT+0;
    cweight = DS1_WEIGHT+0;
    cwaist = DS1_WAIST+0;
    chip = DS1_HIP+0 ;
    ds1_tg1 = ds1_tg+0;
    ds1_hdl1 = ds1_hdl+0;
    ds1_dbp1 = ds1_dbp+0;
    ds1_sbp1 = ds1_sbp+0;
    ds1_glu0_1 = ds1_glu0+0;
run;
proc freq data=b.total_final; tables ds1_height * cheight/list missing; run;
proc freq data=b.total_final; tables ds1_weight * cweight/list missing; run;
proc freq data=b.total_final; tables ds1_waist * cwaist/list missing; run;
proc freq data=b.total_final; tables ds1_hip * chip/list missing; run;
proc univariate data=b.total_final; var ds1_tg1; run;
proc univariate data=b.total_final; var ds1_hdl1; run;
proc univariate data=b.total_final; var ds1_dbp1; run;
proc univariate data=b.total_final; var ds1_sbp1; run;
proc univariate data=b.total_final; var ds1_glu0_1; run;

/*MeS 만들기*/
data  b.total_final; set  b.total_final;
    if  cwaist=99999 then wc=99;
    else if (cwaist >=90 and DS1_SEX1=1) or (cwaist >=80 and DS1_SEX1=2) then wc=1;
    else wc=0;
    /*wc=1이면 metabolic syndrom, wc=0 이면 metS 해당없음 */

    if DS1_TG1 =99999 then TG=99;
    else if DS1_TG1 >=150 or DS1_LIPCUTY=1 or DS1_LIPCUTRPM=2 then TG=1;
    else TG=0;
    /*TG=1 이면 metS criteria인 highTC*/

    if DS1_HDL1 =99999 then HDL=99;
    else if (DS1_HDL1 <40 and DS1_SEX1=1) or (DS1_HDL1 <50 and DS1_SEX1=2) then HDL=1;
    else HDL=0;
    /*HDL=1 이면 metS criteria*/

    if DS1_DBP1=99999 or DS1_SBP1=99999 then BP=99;
    else if DS1_SBP1 >=130 or DS1_DBP1 >=85 or DS1_HTNCUTY=1 or DS1_HTNCUTRPM=2 or DS1_BP_MEDI=2 then BP=1;
    else BP=0;
    /*BP=1 이면 metS criteria*/

    if DS1_GLU0_1 =99999 then GLU=99;
    else IF DS1_GLU0_1>=100 or DS1_DMCUTY=1 or DS1_DMCUTY=2 or DS1_DMCUTY=4 or DS1_DMCUTY1=1 or DS1_DMCUTY1=2 or DS1_DMCUTY1=4 or   DS1_DMCUTRPM=2 or DS1_DMCUTRIN=2 then GLU=1;
    else GLU=0;
    /*GLU=1 이면 metS criteria*/
run;
data  b.total_final(drop = i); set  b.total_final;
    metS_sum = 0;
    do i = wc, tg, hdl, bp, glu;
        if i ^= 99 then metS_sum + i;
        else metS_sum + 0;
    end;

    if metS_sum > 2 then MeS = 1;
    else MeS = 0;
run;
proc freq data=b.total_final; tables metS_sum * MeS/list missing; run;
proc freq data=b.total_final; tables wc * tg * hdl * bp * glu * metS_sum * MeS/list missing; run;
proc freq data=b.total_final; tables MeS * group1/chisq; run;

proc freq data=b.total_final; where wc ^= 99; tables wc * group1/chisq; run;

proc freq data=b.total_final; where tg ^= 99; tables tg * group1/chisq; run;
proc univariate data=b.total_final; where tg ^= 99; class group1; var ds1_tg1; run;
proc freq data=b.total_final; where hdl ^= 99; tables hdl * group1/chisq; run;
proc univariate data=b.total_final; where hdl ^= 99; class group1; var ds1_hdl1; run;
proc freq data=b.total_final; where bp ^= 99; tables bp * group1/chisq; run;
proc univariate data=b.total_final; where bp ^= 99; class group1; var ds1_dbp1; run;
proc univariate data=b.total_final; where bp ^= 99; class group1; var ds1_sbp1; run;
proc freq data=b.total_final; where glu ^= 99; tables glu * group1/chisq; run;
proc univariate data=b.total_final; where glu ^= 99; class group1; var ds1_glu0_1; run;

proc univariate data=b.total_final; where cwaist ^= 99999; class group1; var cwaist; run;
proc anova data=b.total_final; where cwaist ^= 99999; class group1; model cwaist=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_tg1^= 99999; class group1; var ds1_tg1; run;
proc anova data=b.total_final; where ds1_tg1 ^= 99999; class group1; model ds1_tg1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_hdl1^= 99999; class group1; var ds1_hdl1; run;
proc anova data=b.total_final; where ds1_hdl1 ^= 99999; class group1; model ds1_hdl1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_sbp1^= 99999; class group1; var ds1_sbp1; run;
proc anova data=b.total_final; where ds1_sbp1 ^= 99999; class group1; model ds1_sbp1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_dbp1^= 99999; class group1; var ds1_dbp1; run;
proc anova data=b.total_final; where ds1_dbp1 ^= 99999; class group1; model ds1_dbp1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_glu0_1^= 99999; class group1; var ds1_glu0_1; run;
proc anova data=b.total_final; where ds1_glu0_1 ^= 99999; class group1; model ds1_glu0_1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;

/****Chart : 전체 성별에 따라 흡연, 음주, 운동, 스트레스****/
/****(1) Smoke****/
proc freq data=b.total_final; where psmok^=99 and DS1_SEX1=1; tables psmok*group1/chisq; run;
proc freq data=b.total_final; where psmok^=99 and DS1_SEX1=2; tables psmok*group1/chisq; run;
/****(2) Drink****/
proc freq data=b.total_final; where pdrink^=99 and DS1_SEX1=1; tables pdrink*group1/chisq; run;
proc freq data=b.total_final; where pdrink^=99 and DS1_SEX1=2; tables pdrink*group1/chisq; run;
/****(3) Gexer****/
proc freq data=b.total_final; where gexer_wk2^=99 and DS1_SEX1=1; tables gexer_wk2*group1/chisq; run;
proc freq data=b.total_final; where gexer_wk2^=99 and DS1_SEX1=2; tables gexer_wk2*group1/chisq; run;
/****(4) Gbmi2****/
proc freq data=b.total_final; where gbmi2^=99999 and DS1_SEX1=1; tables gbmi2*group1/chisq; run;
proc freq data=b.total_final; where gbmi2^=99999 and DS1_SEX1=2; tables gbmi2*group1/chisq; run;
/****(5) pwi_1****/
proc freq data=b.total_final; where pwi_1^=99999 and DS1_SEX1=1; tables pwi_1*group1/chisq; run;
proc freq data=b.total_final; where pwi_1^=99999 and DS1_SEX1=2; tables pwi_1*group1/chisq; run;
/****(6) Totalkcal****/
proc freq data=b.total_final; where Totalkcal^=9999; tables Totalkcal*group1/chisq; run;
proc freq data=b.total_final; where Totalkcal^=9999 and DS1_SEX1=1; tables Totalkcal*group1/chisq; run;
proc freq data=b.total_final; where Totalkcal^=9999 and DS1_SEX1=2; tables Totalkcal*group1/chisq; run;
/****(7) MeS****/
proc freq data=b.total_final; where DS1_SEX1=1; tables MeS*group1/chisq; run;
proc freq data=b.total_final; where DS1_SEX1=2; tables MeS*group1/chisq; run;
/****(8) WC****/
proc freq data=b.total_final; where wc ^= 99 and DS1_SEX1=1; tables wc*group1/chisq; run;
proc freq data=b.total_final; where wc ^= 99 and DS1_SEX1=2; tables wc*group1/chisq; run;
/****(9) TG****/
proc freq data=b.total_final; where TG ^= 99 and DS1_SEX1=1; tables TG*group1/chisq; run;
proc freq data=b.total_final; where TG ^= 99 and DS1_SEX1=2; tables TG*group1/chisq; run;
/****(10) HDL****/
proc freq data=b.total_final; where HDL ^= 99 and DS1_SEX1=1; tables HDL*group1/chisq; run;
proc freq data=b.total_final; where HDL ^= 99 and DS1_SEX1=2; tables HDL*group1/chisq; run;
/****(11) BP****/
proc freq data=b.total_final; where BP ^= 99 and DS1_SEX1=1; tables BP*group1/chisq; run;
proc freq data=b.total_final; where BP ^= 99 and DS1_SEX1=2; tables BP*group1/chisq; run;
/****(12) GLU****/
proc freq data=b.total_final; where GLU ^= 99 and DS1_SEX1=1; tables GLU*group1/chisq; run;
proc freq data=b.total_final; where GLU ^= 99 and DS1_SEX1=2; tables GLU*group1/chisq; run;

/* Declaration of group12 variable to analyze nutrition*/
proc contents data=b.total_final; run;
data b.total_final; set b.total_final;
    if DS1_SEX1 = 1 and DS1_AGE < 30 then group12=1;
    else if DS1_SEX1 = 1 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=2;
    else if DS1_SEX1 = 1 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=3;
    else if DS1_SEX1 = 1 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=4;
    else if DS1_SEX1 = 1 and DS1_AGE >= 75 then group12=5;
    else if DS1_SEX1 = 2 and DS1_AGE < 30 then group12=6;
    else if DS1_SEX1 = 2 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=7;
    else if DS1_SEX1 = 2 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=8;
    else if DS1_SEX1 = 2 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=9;
    else group12=10;
run;
proc freq data=b.total_final; tables group12; run;

/****영양 권장량 이상/미만 1: 미만, 2: 이상****/
/***(1)에너지***/
/* Error in Old Code (Age Range)*/
/*data b.com; set b.com;
    if SS02^=99999 then protein_percent= (SS02*4/SS01)*100;  else  protein_percent=99999;
    if SS01^=99999 and SS02^=99999 and SS03^=99999 then SS01_1= DS1_SS02*4+DS1_SS03*9+DS1_SS04* 4; else  SS01_1=99999;
    if SS04^=99999 then sugar_percent= (SS04*4/SS01)*100; else  sugar_percent=99999;
    if SS03^=99999 then fat_percent= (SS03*9/SS01)*100;  else  fat_percent=99999;
    if SS02^=99999 then protein_percent= (SS02*4/SS01)*100;  else  protein_percent=99999;
    if SS01 in (.,99999) then energy=99999;
    else if DS1_SEX1=1 and DS1_AGE<30 and SS01<2600 then energy=1; else if DS1_SEX1=1 and 30=<DS1_AGE<49 and SS01<2400 then energy=1;
    else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS01<2200 then energy=1; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS01<2000 then energy=1; else if DS1_SEX1=1 and 75=<DS1_AGE and SS01<2000 then energy=1;
    else if DS1_SEX1=2 and DS1_AGE<30 and SS01<2100 then energy=1; else if DS1_SEX1=2 and 30=<DS1_AGE<49 and SS01<1900 then energy=1;
    else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS01<1800 then energy=1; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS01<1600 then energy=1; else if DS1_SEX1=2 and 75=<DS1_AGE and SS01<1600 then energy=1;
    else energy=2; run; */
data b.total_final; set total_final; /**김명관 선생님이 만들었던 기존 energy 변수 버리고 새로 정의 **/
    drop energy;
run;
data b.total_final; set b.total_final;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (2600 2400 2200 2000 2000 2100 1900 1800 1600 1600);

     if SS01 in (.,99999) then energy=99999;
     else if SS01 < reference[group12] then energy=1;
     else energy=2;
     drop t1 - t10;
run;
proc freq data=b.total_final; where energy^=99999; tables energy*group1/chisq; run;

/* energy 변수를 제외하고 김명관 선생님이 만들어 놓은 변수들을 활용함*/

/****Data Review : Nutrition****/
proc freq data=b.total_final; where energy^=99999; tables energy*group1/chisq; run;
proc freq data=b.total_final; where protein^=99999; tables protein*group1/chisq; run;
proc freq data=b.total_final; where fat^=99999; tables fat*group1/chisq; run;
proc freq data=b.total_final; where sugar^=99999; tables sugar*group1/chisq; run;
proc freq data=b.total_final; where fiber^=99999; tables fiber*group1/chisq; run;
proc freq data=b.total_final; where VitA^=99999; tables VitA*group1/chisq; run;
proc freq data=b.total_final; where VitB1^=99999; tables VitB1*group1/chisq; run;
proc freq data=b.total_final; where VitB2^=99999; tables VitB2*group1/chisq; run;
proc freq data=b.total_final; where Niacin^=99999; tables Niacin*group1/chisq; run;
proc freq data=b.total_final; where Folate^=99999; tables Folate*group1/chisq; run;
proc freq data=b.total_final; where VitB6^=99999; tables VitB6*group1/chisq; run;
proc freq data=b.total_final; where VitC^=99999; tables VitC*group1/chisq; run;
proc freq data=b.total_final; where VitE^=99999; tables VitE*group1/chisq; run;
proc freq data=b.total_final; where Cals^=99999; tables Cals*group1/chisq; run;
proc freq data=b.total_final; where pho^=99999; tables pho*group1/chisq; run;
proc freq data=b.total_final; where iron^=99999; tables iron*group1/chisq; run;
proc freq data=b.total_final; where Cal^=99999; tables Cal*group1/chisq; run;
proc freq data=b.total_final; where Zinc^=99999; tables Zinc*group1/chisq; run;
proc freq data=b.total_final; where Na^=99999; tables Na*group1/chisq; run;

/*Nutrtion Univariate*/
proc univariate data=b.total_final ; where SS01^=99999; class group1; var SS01; run;
proc univariate data=b.total_final ; where SS02^=99999; class group1; var SS02; run;
proc univariate data=b.total_final ; where protein^=99999; class group1; var protein_percent; run;
proc univariate data=b.total_final ; where SS03^=99999; class group1; var SS03; run;
proc univariate data=b.total_final ; where fat^=99999; class group1; var fat_percent; run;
proc univariate data=b.total_final ; where SS04^=99999; class group1; var SS04; run;
proc univariate data=b.total_final ; where sugar^=99999; class group1; var sugar_percent; run;
proc univariate data=b.total_final ; where SS21^=99999; class group1; var SS21; run;
proc univariate data=b.total_final ; where SS09^=99999; class group1; var SS09; run;
proc univariate data=b.total_final ; where SS11^=99999; class group1; var SS11; run;
proc univariate data=b.total_final ; where SS12^=99999; class group1; var SS12; run;
proc univariate data=b.total_final ; where SS13^=99999; class group1; var SS13; run;
proc univariate data=b.total_final ; where SS17^=99999; class group1; var SS17; run;
proc univariate data=b.total_final ; where SS16^=99999; class group1; var SS16; run;
proc univariate data=b.total_final ; where SS14^=99999; class group1; var SS14; run;
proc univariate data=b.total_final ; where SS23^=99999; class group1; var SS23; run;
proc univariate data=b.total_final ; where SS05^=99999; class group1; var SS05; run;
proc univariate data=b.total_final ; where SS06^=99999; class group1; var SS06; run;
proc univariate data=b.total_final ; where SS07^=99999; class group1; var SS07; run;
proc univariate data=b.total_final ; where SS08^=99999; class group1; var SS08; run;
proc univariate data=b.total_final ; where SS15^=99999; class group1; var SS15; run;
proc univariate data=b.total_final ; where SS10^=99999; class group1; var SS10; run;

/*****Nutrition ANOVA****/
proc anova data=b.total_final; where SS01^=99999; class group1; model SS01=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS02^=99999; class group1; model SS02=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where protein_percent^=99999; class group1; model protein_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS03^=99999; class group1; model SS03=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where fat_percent^=99999; class group1; model fat_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS04^=99999; class group1; model SS04=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where sugar_percent^=99999; class group1; model sugar_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS21^=99999; class group1; model SS21=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS09^=99999; class group1; model SS09=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS11^=99999; class group1; model SS11=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS12^=99999; class group1; model SS12=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS13^=99999; class group1; model SS13=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS17^=99999; class group1; model SS17=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS16^=99999; class group1; model SS16=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS14^=99999; class group1; model SS14=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS23^=99999; class group1; model SS23=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS05^=99999; class group1; model SS05=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS06^=99999; class group1; model SS06=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS07^=99999; class group1; model SS07=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS08^=99999; class group1; model SS08=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS15^=99999; class group1; model SS15=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS10^=99999; class group1; model SS10=group1; MEANS group1 / DUNCAN ;run;quit;

/* Variable (Fat, Sugar) Declaration for Conditional Logistic Regression*/
data b.total_final; set b.total_final;
    if fat < 2 then fat_2 = 0;
    else fat_2 = 1;
    if sugar < 2 then sugar_2 = 0;
    else sugar_2 = 1;
run;
proc freq data=b.total_final; tables fat_2*fat/list missing; run;
proc freq data=b.total_final; tables sugar_2*sugar/list missing; run;
proc univariate data=b.total_final; where SS03^=99999; class fat_2; var fat_percent; run;
proc univariate data=b.total_final; where SS04^=99999; class sugar_2; var sugar_percent; run;

/*******Data Reveiw by Cancer Type *******/
proc freq data=b.total_final; tables CANCER_TYPE*group1/list missing;run;

data b.total_final; set b.total_final;    /* cancer_type2 변수를 새로 생성, 암 생존자 집단이 아니거나(group1=1, 2) 암 생존자이나 암종 정보가 없는 경우(239명)를 모두 Missing으로 처리*/
    if CANCER_TYPE = . then cancer_type2 = 99999;
    else if CANCER_TYPE = 0 then cancer_type2 = 99999;
    else cancer_type2 = CANCER_TYPE;
run;
libname A 'C:\Users\USER01\Desktop\5-21 과제\Data analysis';
libname B 'C:\Users\USER01\Desktop\5-21 과제\Data analysis\result';

/**************************/
/*******Total Dataset*******/
/*************************/

/** Raw Thesis Dataset 에서 시작 - 모든 변수들을 김명관 선생님이 만들었던 대로 만들어 보기 (기존에 작업된 데이터셋이 읽히지 않음)**/

/**** Variable Modification ****/
/***** Data Reveiw Table *****/

proc contents data=a.thesis_total ; run;

/*****최소 한개 이상의 암이 걸린 사람들 테이블*****/
proc freq data=a.thesis_total ; where ca+ LI_C+ CO_C +BR_C +CE_C+THY_C+ LU_C+PRO_C+BL_C+OT_C >= 1 ; table ca*LI_C*CO_C* BR_C*CE_C*THY_C*LU_C*PRO_C*BL_C*OT_C/list missing; run;


data b.thesis; set a.thesis_total; 
	if ca+ LI_C+ CO_C +BR_C +CE_C+THY_C+ LU_C+PRO_C+BL_C+OT_C = 1then group1=0; 
	else if ca+ LI_C+ CO_C +BR_C +CE_C+THY_C+ LU_C+PRO_C+BL_C+OT_C >= 2  then group1=1; run; /**0: 암이 하나만 걸린 사람 1: 암이 2개 이상 걸린 사람**/
proc freq data= b.thesis; tables group1/list missing; run;


/*****나이*****/
data b.thesis; set b.thesis;
	cage=DS1_AGE+0;
run;
proc freq data=b.thesis; tables DS1_AGE; run;
proc freq data=b.thesis; tables cage; run;
data b.thesis  ; set b.thesis ;	
	if cage<50 then DS1_AGE1=1; else if cage<55 then DS1_AGE1=2;  else if cage<60 then DS1_AGE1=3; else if cage<65 then DS1_AGE1=4; else DS1_AGE1 =5; run;
proc freq data=b.thesis;  tables DS1_AGE1*group1/chisq; run;
/***나이(평균 및 표준편차)univariate***/
proc univariate data=b.thesis ; class group1; var cage; run;
proc univariate data=b.thesis ; var cage; run;
/***나이(평균 및 표준편차)ttest***/
proc ttest data=b.thesis; class group1;var cage; run;

/***성별***/
data b.thesis; set b.thesis;
	if DS1_SEX in ('1') then DS1_SEX1=1; else if DS1_SEX in ('2') then DS1_SEX1=2; else if DS1_SEX in ('99999') then DS1_SEX1 = 99; run;
proc freq data=b.thesis; tables DS1_SEX1; run;
proc freq data=b.thesis; where group1=0;tables DS1_SEX1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_SEX1/list missing; run;
proc freq data=b.thesis;  tables DS1_SEX1*group1/chisq; run;



/*DS1_MARRY_A_1; 미혼/별거/이혼/사별/기타 (1), 기혼/동거=결혼(2), */		
data  b.thesis  ; set  b.thesis ;	
	if DS1_MARRY_A in ('2') or  DS1_MARRY in ('2','6') then DS1_MARRY_A_1=2; else if DS1_MARRY_A in ('66666','99999') and DS1_MARRY in ('66666','99999') then DS1_MARRY_A_1=99; else DS1_MARRY_A_1=1;  run;     			
proc freq data= b.thesis; where group1=0;tables DS1_MARRY_A_1/list missing; run;
proc freq data= b.thesis; where group1=1;tables DS1_MARRY_A_1/list missing; run;
proc freq data= b.thesis; tables DS1_MARRY_A_1*group1/chisq; run;	

/*DS1_EDU*/
data b.thesis; set b.thesis  ; /* 0=학교에 다니지 않았다, 1=초등학교 중퇴, 2=초등학교 졸업 또는 중학교 중퇴, 3=중학교 졸업 또는 고등학교 중퇴, 4=고등학교 졸업, 5=기술(전문)학교 졸업, 6=대학교 중퇴, 7=대학교 졸업, 8=대학원 이상 */
	if DS1_EDU in ('0','1','2','3','4') then DS1_EDU1=1; else if DS1_EDU in ('5','6','7','8') then DS1_EDU1=2; else if DS1_EDU in ('99999') then DS1_EDU1=99;
	if DS1_EDU in ('0','1','2','3') then DS1_EDU2=1;else if DS1_EDU in ('4') then DS1_EDU2=2; else if DS1_EDU in ('5','6','7','8') then DS1_EDU2=3; else if DS1_EDU in ('99999') then DS1_EDU2=99;	run;		
proc freq data=b.thesis; tables DS1_EDU*group1/chisq; run;
proc freq data=b.thesis; where group1=0;tables DS1_EDU1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_EDU1/list missing; run;
proc freq data=b.thesis; tables DS1_EDU1*group1/chisq; run;
proc freq data=b.thesis; tables DS1_EDU2*group1/chisq; run;

/****수입****/
data b.thesis  ; set b.thesis  ;	
	if DS1_INCOME in ('1','2','3','4') then DS1_INCOME1=1; else if DS1_INCOME in ('5','6') then DS1_INCOME1=2; else if DS1_INCOME in ('7','8') then DS1_INCOME1=3; 
	if DS1_INCOME in ('1','2','3','4','5') then DS1_INCOME2=1; else if DS1_INCOME in ('6','7','8') then DS1_INCOME2=2; else if DS1_INCOME in ('66666','99999') then DS1_INCOME2=99;	
	else if DS1_INCOME in ('66666','99999') then DS1_INCOME1=99; run;		
proc freq data=b.thesis; where group1=0;tables DS1_INCOME/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_INCOME/list missing; run;
proc freq data=b.thesis; tables DS1_INCOME1*group1/chisq; run; 	  /* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 */		
proc freq data=b.thesis; tables DS1_INCOME2*group1/chisq; run; 	  /* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 */		

/*DS1_JOB_1; 주부나 무직(1), 직업있음(2)*/		
data b.thesis ; set b.thesis  ;	
	if DS1_JOB in ('66666','99999') and DS1_JOB_A in ('66666','99999') then DS1_JOB_1=99; 
	else if DS1_JOB in ('12','13') or DS1_JOB_A in ('12') then DS1_JOB_1=1; else DS1_JOB_1=2; run; 		
proc freq data=b.thesis; where group1=0;tables DS1_JOB_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_JOB_1/list missing; run;
proc freq data=b.thesis; tables DS1_JOB_1*group1/chisq; run;	

/*흡연*/
data b.thesis  ; set b.thesis  ;					
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then csmok=99; 					
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then csmok=1;                           /*csmok: 현재흡연 (1), 과거흡연& 경험없음(0)*/					
	else if DS1_SMOKE in ('1', '2') or  DS1_SMOKE_100 in ('1', '2') then csmok=0;				
					
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then psmok=99; 					
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then psmok=2;					
	else if DS1_SMOKE in ('2') or  DS1_SMOKE_100 in ('2') then psmok=1; 				
	else if DS1_SMOKE in ('1') or  DS1_SMOKE_100 in ('1') then psmok=0; run;     /*psmok: 현재흡연 (2), 과거흡연 (1), 경험없음 (0)*/	
proc freq data=b.thesis; where group1=0; tables psmok/list missing; run;
proc freq data=b.thesis; where group1=1; tables psmok/list missing; run;
proc freq data=b.thesis;  tables psmok*group1/chisq; run;
proc freq data=b.thesis; where psmok^=99 ; tables psmok*group1/chisq; run;

/*음주*/
data b.thesis  ; set b.thesis  ;					
            if DS1_DRINK in ('66666', '99999') then cdrink=99;            					
    else if DS1_DRINK='3' then cdrink=1;					
	else if DS1_DRINK in ('1', '2') then cdrink=0;                     /*cdrink: 현재음주(1), 현재음주안함(0)*/				
					
            if DS1_DRINK in ('66666', '99999') then pdrink=99; 					
    else if DS1_DRINK='3' then pdrink=2;					
	else if DS1_DRINK='2' then pdrink=1;				
	else if DS1_DRINK in ('1') then pdrink=0; run;      	 /*pdrink: 현재음주 (2), 과거음주 (1), 경험없음 (0)*/		
proc freq data=b.thesis; where group1=0  ;tables pdrink/list missing; run;
proc freq data=b.thesis; where group1=1 ;tables pdrink/list missing; run;
proc freq data=b.thesis; tables pdrink*group1/chisq; run;

/***운동**/	
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
proc freq data=b.thesis; where group1=0; tables gexer_wk2/list missing; run;
proc freq data=b.thesis; where group1=1; tables gexer_wk2/list missing; run;
proc freq data=b.thesis; tables gexer_wk2*group1/chisq; run;

/***gbmi****/
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
proc freq data=b.thesis; where group1=0;tables gbmi2/list missing; run;
proc freq data=b.thesis; where group1=1;tables gbmi2/list missing; run;
proc freq data=b.thesis;  tables gbmi2*group1/chisq; run;

/*DS1_SRH_1/2; 건강함(1), 건강하지않음(2)*/		
data b.thesis ; set b.thesis  ;	
	if DS1_SRH in ('1','2') then DS1_SRH_1=1; else if DS1_SRH in ('3','4','5') then DS1_SRH_1=2; else if DS1_SRH in ('66666','99999') then DS1_SRH_1=99; 		
	if DS1_SRH in ('1','2','3') then DS1_SRH_2=1; else if DS1_SRH in ('4','5') then DS1_SRH_2=2; else if DS1_SRH in ('66666','99999') then DS1_SRH_2=99; 		
run;

proc freq data=b.thesis; where group1=0;tables DS1_SRH_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_SRH_1/list missing; run;
proc freq data=b.thesis;  tables DS1_SRH_1*group1/chisq; run;


/*DS1_FCA_1; 암가족력없음(1), 암가족력있음(2)*/
data b.thesis ; set b.thesis  ;	
	if DS1_FCA in ('66666','99999') and DS1_FCA1 in ('66666','99999') then DS1_FCA_1=99; else if DS1_FCA in ('2') or DS1_FCA1 in ('2') then DS1_FCA_1=2; else DS1_FCA_1=1;   		
run;

proc freq data=b.thesis; where group1=0;tables DS1_FCA_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_FCA_1/list missing; run;
proc freq data=b.thesis;  tables DS1_FCA_1*group1/chisq; run;


/***스트레스pwi****/
/****pwi 공식으로 총점 구하기***/
data b.thesis; set b.thesis;
	pwi = ds1_pwi1 + (3-ds1_pwi2) + (3-ds1_pwi3) + (3-ds1_pwi4) + ds1_pwi5 + ds1_pwi6 + (3-ds1_pwi7) + ds1_pwi8 + ds1_pwi9 + ds1_pwi10 + ds1_pwi11 + ds1_pwi12 + 
	(3-ds1_pwi13) + ds1_pwi14 + (3-ds1_pwi15) + (3-ds1_pwi16) + ds1_pwi17 + ds1_pwi18; run;
data b.thesis; set b.thesis;
	if  ds1_pwi1 in ('99999') or ds1_pwi2 in ('99999') or ds1_pwi3 in ('99999') or ds1_pwi4 in ('99999') or ds1_pwi5 in ('99999') or ds1_pwi6 in ('99999') or ds1_pwi7 in ('99999') or ds1_pwi8 in ('99999') or ds1_pwi9 in ('99999') or 
	   ds1_pwi10 in ('99999') or ds1_pwi11 in ('99999') or ds1_pwi12 in ('99999') or ds1_pwi13 in ('99999') or ds1_pwi14 in ('99999') or ds1_pwi15 in ('99999') or ds1_pwi16 in ('99999') or  
	   ds1_pwi17 in ('99999') or ds1_pwi18 in ('99999') then  pwi=99999;run; 
proc freq data=b.thesis; tables pwi; run;

data b.thesis  ; set b.thesis  ;	
    if -999999<pwi<0  then PWI1=99999; 			
    else if 99999<=pwi<=1000014  then PWI1=99999; 	run;
proc freq data=b.thesis; tables PWI1; RUN; 
data b.thesis  ; set b.thesis  ;  DS1_pwi_1= DS1_pwi+0; run; 
proc freq data=b.thesis; where DS1_pwi_1^=pwi; tables DS1_pwi*pwi/list missing; run;/***0개***/
proc freq data=b.thesis; where DS1_pwi_1^=pwi and DS1_pwi_1=99999 and pwi not in (.) ; tables ds1_pwi1--ds1_pwi18; run;/***0개***/

data b.thesis ; set b.thesis ;	
	if pwi=99999 then PWI_1 =99999; /***missing ***/
	else if 0<=pwi<=8 then PWI_1 = 1; /***정상***/
	else if 9<=pwi<=26 then PWI_1 = 2; /***약간 스트레스****/
	else if 27<=pwi<99999 then PWI_1=3; /****매우 스트레스****/
	if pwi=99999 then PWI_2 = 99999;
	else if 0<=pwi<=8 then PWI_2 = 1; /***정상***/
	else if 9<=pwi<99999 then PWI_2 = 2;/***약간 스트레스 + 매우 스트레스*/
run;

proc freq data=b.Thesis; where group1=0; tables PWI_1; run;
proc freq data=b.Thesis; where group1=1; tables PWI_1; run;
proc freq data=b.thesis;  tables PWI_1*group1/chisq; run;	
proc univariate data=b.thesis ; where PWI^=99999; class group1; var PWI; run;
proc ttest data=b.thesis; where PWI^=99999;  class group1; var PWI; run; 	

/***OC 사용여부****/
/*DS1_ORALCON: OC사용한적 없음(1), 있음(2, 과거사용+현재사용)*/ 	
proc freq data=b.thesis; tables ds1_oralcon/list missing; run;
data b.thesis; set b.thesis;
	if DS1_ORALCON in ('77777','99999') then DS1_ORALCON_1=99; else if DS1_ORALCON=1 then DS1_ORALCON_1=1; else DS1_ORALCON_1=2;
run;	
proc freq data=b.thesis; tables ds1_oralcon * ds1_oralcon_1/list missing; run;

proc freq data=b.thesis; where group1=0;tables DS1_ORALCON_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_ORALCON_1/list missing; run;
proc freq data=b.thesis;  tables DS1_ORALCON_1*group1/chisq; run;


/***생리 여부****/
proc freq data=b.thesis; tables ds1_menyn_a/list missing; run;
data b.thesis; set b.thesis;
	if DS1_MENYN_A in  ('66666','77777','99999') and DS1_MENYN in  ('66666','77777','99999') then DS1_MENYN_1=99;				
	else if  DS1_MENYN_A=1 or  DS1_MENYN=1 then DS1_MENYN_1=1; 
	else  DS1_MENYN_1=2;				
	/* DS1_MENYN: 폐경=생리 없음(1), 생리 있음(2)*/	
run;

proc freq data=b.thesis; tables ds1_menyn * ds1_menyn_a * ds1_menyn_1/list missing; run;
proc freq data=b.thesis; where group1=0;tables DS1_MENYN_1/list missing; run;
proc freq data=b.thesis; where group1=1;tables DS1_MENYN_1/list missing; run;
proc freq data=b.thesis;  tables DS1_MENYN_1*group1/chisq; run;



/***************************************Metabolic syndrome 변수 만들기 */
data b.thesis; set b.thesis; 
	cheight = DS1_HEIGHT+0;
	cweight = DS1_WEIGHT+0; 
	cwaist = DS1_WAIST+0;
	chip = DS1_HIP+0 ;
	ds1_tg1 = ds1_tg+0;
	ds1_hdl1 = ds1_hdl+0;
	ds1_dbp1 = ds1_dbp+0;
	ds1_sbp1 = ds1_sbp+0;
	ds1_glu0_1 = ds1_glu0+0;
run;
proc freq data=b.thesis; tables ds1_height * cheight/list missing; run;
proc freq data=b.thesis; tables ds1_weight * cweight/list missing; run;
proc freq data=b.thesis; tables ds1_waist * cwaist/list missing; run;
proc freq data=b.thesis; tables ds1_hip * chip/list missing; run;
proc univariate data=b.thesis; var ds1_tg1; run;
proc univariate data=b.thesis; var ds1_hdl1; run;
proc univariate data=b.thesis; var ds1_dbp1; run;
proc univariate data=b.thesis; var ds1_sbp1; run;
proc univariate data=b.thesis; var ds1_glu0_1; run;

/*MeS 만들기*/
data  b.thesis; set  b.thesis;																		
	if  cwaist=99999 then wc=99; 
	else if (cwaist >=90 and DS1_SEX1=1) or (cwaist >=80 and DS1_SEX1=2) then wc=1; 
	else wc=0; 																		
	/*wc=1이면 metabolic syndrom, wc=0 이면 metS 해당없음 */																	

	if DS1_TG1 =99999 then TG=99; 
	else if DS1_TG1 >=150 or DS1_LIPCUTY=1 or DS1_LIPCUTRPM=2 then TG=1;
	else TG=0; 																		
	/*TG=1 이면 metS criteria인 highTC*/	
	
	if DS1_HDL1 =99999 then HDL=99; 
	else if (DS1_HDL1 <40 and DS1_SEX1=1) or (DS1_HDL1 <50 and DS1_SEX1=2) then HDL=1;
	else HDL=0;																		
	/*HDL=1 이면 metS criteria*/

	if DS1_DBP1=99999 or DS1_SBP1=99999 then BP=99; 
	else if DS1_SBP1 >=130 or DS1_DBP1 >=85 or DS1_HTNCUTY=1 or DS1_HTNCUTRPM=2 or DS1_BP_MEDI=2 then BP=1;  
	else BP=0;																		
	/*BP=1 이면 metS criteria*/

	if DS1_GLU0_1 =99999 then GLU=99; 
	else IF DS1_GLU0_1>=100 or DS1_DMCUTY=1 or DS1_DMCUTY=2 or DS1_DMCUTY=4 or DS1_DMCUTY1=1 or DS1_DMCUTY1=2 or DS1_DMCUTY1=4 or	DS1_DMCUTRPM=2 or DS1_DMCUTRIN=2 then GLU=1;																																																		
	else GLU=0; 																		
	/*GLU=1 이면 metS criteria*/		
run;
data  b.thesis(drop = i); set  b.thesis;																		
	metS_sum = 0;
	do i = wc, tg, hdl, bp, glu;
		if i ^= 99 then metS_sum + i;
		else metS_sum + 0;
	end;

	if metS_sum > 2 then MeS = 1;
	else MeS = 0;
run;
proc freq data=b.thesis; tables metS_sum * MeS/list missing; run;
proc freq data=b.thesis; tables wc * tg * hdl * bp * glu * metS_sum * MeS/list missing; run;
proc freq data=b.thesis; tables MeS * group1/chisq; run;

proc freq data=b.thesis; where wc ^= 99; tables wc * group1/chisq; run;
proc univariate data=b.thesis; where wc ^= 99; class group1; var cwaist; run;
proc freq data=b.thesis; where tg ^= 99; tables tg * group1/chisq; run;
proc univariate data=b.thesis; where tg ^= 99; class tg; var ds1_tg1; run;
proc freq data=b.thesis; where hdl ^= 99; tables hdl * group1/chisq; run;
proc univariate data=b.thesis; where hdl ^= 99; class hdl; var ds1_hdl1; run;
proc freq data=b.thesis; where bp ^= 99; tables bp * group1/chisq; run;
proc univariate data=b.thesis; where bp ^= 99; class bp; var ds1_dbp1; run;
proc univariate data=b.thesis; where bp ^= 99; class bp; var ds1_sbp1; run;
proc freq data=b.thesis; where glu ^= 99; tables glu * group1/chisq; run;
proc univariate data=b.thesis; where glu ^= 99; class glu; var ds1_glu0_1; run;

proc ttest data=b.thesis; where cwaist^=99999; class group1; var cwaist; run; 
proc ttest data=b.thesis; where DS1_TG1^=99999; class group1; var DS1_TG1; run; 
proc ttest data=b.thesis; where DS1_HDL1^=99999; class group1; var DS1_HDL1; run; 
proc ttest data=b.thesis; where DS1_SBP1^=99999; class group1; var DS1_SBP1; run; 
proc ttest data=b.thesis; where DS1_DBP1^=99999; class group1; var DS1_DBP1; run; 
proc ttest data=b.thesis; where DS1_GLU0_1^=99999; class group1; var DS1_GLU0_1; run; 

/****Chart : 전체 성별에 따라 흡연, 음주, 운동, 스트레스****/
/****(1) Smoke****/
proc freq data=b.thesis; where psmok^=99 and DS1_SEX1=1; tables psmok*group1/chisq; run;
proc freq data=b.thesis; where psmok^=99 and DS1_SEX1=2; tables psmok*group1/chisq; run;
/****(2) Drink****/
proc freq data=b.thesis; where pdrink^=99 and DS1_SEX1=1; tables pdrink*group1/chisq; run;
proc freq data=b.thesis; where pdrink^=99 and DS1_SEX1=2; tables pdrink*group1/chisq; run;
/****(3) Gexer****/
proc freq data=b.thesis; where gexer_wk2^=99 and DS1_SEX1=1; tables gexer_wk2*group1/chisq; run;
proc freq data=b.thesis; where gexer_wk2^=99 and DS1_SEX1=2; tables gexer_wk2*group1/chisq; run;
/****(4) Gbmi2****/
proc freq data=b.thesis; where gbmi2^=99999 and DS1_SEX1=1; tables gbmi2*group1/chisq; run;
proc freq data=b.thesis; where gbmi2^=99999 and DS1_SEX1=2; tables gbmi2*group1/chisq; run;
/****(5) pwi_1****/
proc freq data=b.thesis; where pwi_1^=99999 and DS1_SEX1=1; tables pwi_1*group1/chisq; run;
proc freq data=b.thesis; where pwi_1^=99999 and DS1_SEX1=2; tables pwi_1*group1/chisq; run;
/****(6) Totalkcal****/
proc freq data=b.thesis; where Totalkcal^=9999 and DS1_SEX1=1; tables Totalkcal*group1/chisq; run;
proc freq data=b.thesis; where Totalkcal^=9999 and DS1_SEX1=2; tables Totalkcal*group1/chisq; run;
/****(7) MeS****/
proc freq data=b.thesis; where DS1_SEX1=1; tables MeS*group1/chisq; run;
proc freq data=b.thesis; where DS1_SEX1=2; tables MeS*group1/chisq; run;
/****(8) WC****/
proc freq data=b.thesis; where wc ^= 99 and DS1_SEX1=1; tables wc*group1/chisq; run;
proc freq data=b.thesis; where wc ^= 99 and DS1_SEX1=2; tables wc*group1/chisq; run;
/****(9) TG****/
proc freq data=b.thesis; where TG ^= 99 and DS1_SEX1=1; tables TG*group1/chisq; run;
proc freq data=b.thesis; where TG ^= 99 and DS1_SEX1=2; tables TG*group1/chisq; run;
/****(10) HDL****/
proc freq data=b.thesis; where HDL ^= 99 and DS1_SEX1=1; tables HDL*group1/chisq; run;
proc freq data=b.thesis; where HDL ^= 99 and DS1_SEX1=2; tables HDL*group1/chisq; run;
/****(11) BP****/
proc freq data=b.thesis; where BP ^= 99 and DS1_SEX1=1; tables BP*group1/chisq; run;
proc freq data=b.thesis; where BP ^= 99 and DS1_SEX1=2; tables BP*group1/chisq; run;
/****(12) GLU****/
proc freq data=b.thesis; where GLU ^= 99 and DS1_SEX1=1; tables GLU*group1/chisq; run;
proc freq data=b.thesis; where GLU ^= 99 and DS1_SEX1=2; tables GLU*group1/chisq; run;


/*******Data Reveiw for Nutrition *******/
/*****영양  (DS1_SS01 DS1_SS24)*****/
data b.thesis; set b.thesis; 
	if DS1_SS01^='' then SS01=DS1_SS01+0;  else if DS1_SS01='' then SS01=99999; 
	if DS1_SS02^='' then SS02=DS1_SS02+0;  else if DS1_SS02='' then SS02=99999; 
	if DS1_SS03^='' then SS03=DS1_SS03+0;  else if DS1_SS03='' then SS03=99999; 
	if DS1_SS04^='' then SS04=DS1_SS04+0;  else if DS1_SS04='' then SS04=99999;
	if DS1_SS05^='' then SS05=DS1_SS05+0;  else if DS1_SS05='' then SS05=99999;
	if DS1_SS06^='' then SS06=DS1_SS06+0;  else if DS1_SS06='' then SS06=99999;
	if DS1_SS07^='' then SS07=DS1_SS07+0;  else if DS1_SS07='' then SS07=99999;
	if DS1_SS08^='' then SS08=DS1_SS08+0;  else if DS1_SS08='' then SS08=99999;
	if DS1_SS09^='' then SS09=DS1_SS09+0;  else if DS1_SS09='' then SS09=99999;
	if DS1_SS10^='' then SS10=DS1_SS10+0;  else if DS1_SS10='' then SS10=99999;
	if DS1_SS11^='' then SS11=DS1_SS11+0;  else if DS1_SS11='' then SS11=99999;
	if DS1_SS12^='' then SS12=DS1_SS12+0;  else if DS1_SS12='' then SS12=99999;
	if DS1_SS13^='' then SS13=DS1_SS13+0;  else if DS1_SS13='' then SS13=99999;
	if DS1_SS14^='' then SS14=DS1_SS14+0;  else if DS1_SS14='' then SS14=99999;
	if DS1_SS15^='' then SS15=DS1_SS15+0;  else if DS1_SS15='' then SS15=99999;
	if DS1_SS16^='' then SS16=DS1_SS16+0;  else if DS1_SS16='' then SS16=99999;
	if DS1_SS17^='' then SS17=DS1_SS17+0;  else if DS1_SS17='' then SS17=99999;
	if DS1_SS18^='' then SS18=DS1_SS18+0;  else if DS1_SS18='' then SS18=99999;
	if DS1_SS19^='' then SS19=DS1_SS19+0;  else if DS1_SS19='' then SS19=99999;
	if DS1_SS20^='' then SS20=DS1_SS20+0;  else if DS1_SS20='' then SS20=99999;
	if DS1_SS21^='' then SS21=DS1_SS21+0;  else if DS1_SS21='' then SS21=99999;
	if DS1_SS23^='' then SS23=DS1_SS23+0;  else if DS1_SS23='' then SS23=99999;
	if DS1_SS24^='' then SS24=DS1_SS24+0;  else if DS1_SS24='' then SS24=99999; 
run; 

/*totalkcal*/
data b.thesis; set b.thesis;
	if 100<SS01<1380 then Totalkcal=1; 
    else if 1380<=SS01<1700 then Totalkcal=2; 
    else if 1700<=SS01<2000 then Totalkcal=3; 
    else if 2000<=SS01<9999 then Totalkcal=4; 
    else if 9999<=SS01 then Totalkcal=9999; 
run; 
proc freq data=b.thesis; where Totalkcal^=9999; tables Totalkcal*group1/chisq; run;

data b.thesis; set b.thesis;
	if SS01=99999 or SS02=99999 then SS02_Per=99999;    
	else SS02_Per=(SS02*4)/SS01; /*Proportion of Protein in Total Calorie*/

	if SS01=99999 or SS03=99999 then SS03_Per=99999;
	else 	SS03_Per=(SS03*9)/SS01;    /*Proportion of Fat in Total Calorie*/

	if SS01=99999 or SS04=99999 then SS04_Per=99999;
	else SS04_Per=(SS04*4)/SS01;    /*Proportion of Sugar in Total Calorie*/
run;

/****영양 권장량 이상/미만 1: 미만, 2: 이상****/
/***(1)에너지***/
data b.thesis; set b.thesis;  
      if SS01^=99999 and SS02^=99999 and SS03^=99999 then SS01_1= DS1_SS02*4+DS1_SS03*9+DS1_SS04* 4; else  SS01_1=99999; 
	  if SS04^=99999 then sugar_percent= (SS04*4/SS01)*100; else  sugar_percent=99999; 
	  if SS03^=99999 then fat_percent= (SS03*9/SS01)*100;  else  fat_percent=99999; 
      if SS01 in (.,99999) then energy=99999; 
 else if DS1_SEX1=1 and DS1_AGE<30 and SS01<2600 then energy=1; else if DS1_SEX1=1 and 30=<DS1_AGE<49 and SS01<2400 then energy=1;
 else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS01<2200 then energy=1; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS01<2000 then energy=1; else if DS1_SEX1=1 and 75=<DS1_AGE and SS01<2000 then energy=1;
 else if DS1_SEX1=2 and DS1_AGE<30 and SS01<2100 then energy=1; else if DS1_SEX1=2 and 30=<DS1_AGE<49 and SS01<1900 then energy=1;
 else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS01<1800 then energy=1; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS01<1600 then energy=1; else if DS1_SEX1=2 and 75=<DS1_AGE and SS01<1600 then energy=1;
 else energy=2; run; 

/* Error in Old code */
/*data b.thesis; set b.thesis;  
	 array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (2600 2400 2200 2000 2000 2100 1900 1800 1600 1600);

     if SS01 in (.,99999) then energy=99999;
	 else if SS01 < reference[group12] then energy=1;
	 else energy=2;
	 drop t1 - t10;
run;*/

proc freq data=b.thesis; tables energy*SS01_1/list missing; run;
proc freq data=b.thesis; tables energy; run; /*1미만 : 30420, 2이상 :15700   99999: 758*/
proc freq data=b.thesis; where energy^=99999; tables energy*group1/chisq; run;

/***(2) 단백질Protein***/
data b.thesis; set b.thesis;
    if SS02 in (.,99999) then Protein=99999; 
	else if DS1_SEX1=1 and DS1_AGE<30 and SS02<65 then Protein=0; else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS02<60 then Protein=0;
	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS02<60 then Protein=0; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS02<55 then Protein=0; else if DS1_SEX1=1 and 75=<DS1_AGE and SS02<55 then Protein=0;
	else if DS1_SEX1=2 and DS1_AGE<30 and SS02<55 then Protein=0; else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS02<50 then Protein=0;
	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS02<50 then Protein=0; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS02<45 then Protein=0; else if DS1_SEX1=2 and 75=<DS1_AGE and SS02<45then Protein=0;
	else Protein=1; 
run;
proc freq data=b.thesis; tables Protein; run;/*1 : 이상19715  0: 미만 26412   751*/
proc freq data=b.thesis; tables Protein*SS02/list missing; run;
proc freq data=b.thesis; tables Protein*group1/chisq; run;

/*(3) 지방*/
/*data b.thesis; set b.thesis; 
	if SS03 in (.,99999) then fat=99999;  
	if fat_percent=99999 then fat=99999; 
	if DS1_SEX1=2 and fat_percent<15 then fat=0; else if DS1_SEX1=2 and 15=<fat_percent=<30 then fat=1; else if DS1_SEX1=2 and 30<fat_percent then fat=2; RUN;*/

data b.thesis; set b.thesis;
	if SS03 = 99999 then fat = 99999;
	else if SS03_Per < 0.15 then fat = 0;
	else if SS03_Per <= 0.30 then fat = 1;
	else fat = 2;
run;
proc freq data=b.thesis; tables fat; run; /*0 미만 : 34,510, 1 범위내 : 59,472, 2 초과 : 76,309,  99999: 3,066*/
proc freq data=b.thesis; tables fat*fat_percent/list missing; run;
proc univariate data=b.thesis; where SS03^=99999; class fat; var SS03;run; 

/*(4) 탄수화물*/
data b.thesis; set b.thesis;
	if SS04 in (.,99999) then sugar=99999;  
	if sugar_percent=99999 then sugar=99999; 
	else if DS1_SEX1=1 and sugar_percent<55 then sugar=0; else if DS1_SEX1=1 and 55=<sugar_percent=<65 then sugar=1; else if DS1_SEX1=1 and 65<sugar_percent then sugar=2; /* 0: 범위 미만 1: 범위내 2: 범위 초과*/ 
	else if DS1_SEX1=2 and sugar_percent<55 then sugar=0; else if DS1_SEX1=2 and 55=<sugar_percent=<65 then sugar=1; else if DS1_SEX1=2 and 65<sugar_percent then sugar=2; RUN;
proc freq data=b.thesis; tables sugar*sugar_percent/list missing; run;
proc freq data=b.thesis; tables sugar; run;
proc freq data=b.thesis; where sugar^=99999; tables sugar*group1/chisq; run;

data b.thesis; set b.thesis;
  	if sugar in (., 99999) then sugar_2=99999;
	else if sugar < 2 then sugar_2=0;
	else sugar_2=1;

	if fat in (., 99999) then fat_2=99999;
	else if fat < 2 then fat_2=0;
	else fat_2=1;
run;
proc freq data=b.thesis; tables sugar*sugar_2/list missing; run;
proc freq data=b.thesis; tables fat*fat_2/list missing; run;
proc univariate data=b.thesis; where SS04^=99999; class sugar_2; var SS04_Per; run;
proc univariate data=b.thesis; where SS03^=99999; class fat_2; var SS03_Per; run;

/*(5) 식이섬유Fiber*/
data  b.thesis; set b.thesis;
	if SS21 in (.,99999) then fiber=99999; 
	else if DS1_SEX1=1 and DS1_AGE<30 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS21<25 then fiber=0;
 	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 75=<DS1_AGE and SS21<25 then fiber=0;
 	else if DS1_SEX1=2 and DS1_AGE<30 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS21<20 then fiber=0;
 	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 75=<DS1_AGE and SS21<20 then fiber=0;
 	else fiber=1; RUN;
proc freq data=b.thesis; tables Fiber; run;
proc freq data=b.thesis; tables Fiber*ss21/list missing;run;
proc freq data=b.thesis; where Fiber^=99999; tables Fiber*group1/chisq; run;

/* Declaration of group12 variable to analyze nutrition*/
data b.thesis; set b.thesis;
	if DS1_SEX1 = 1 and DS1_AGE < 30 then group12=1;
	else if DS1_SEX1 = 1 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=2;
	else if DS1_SEX1 = 1 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=3;
	else if DS1_SEX1 = 1 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=4;
	else if DS1_SEX1 = 1 and DS1_AGE >= 75 then group12=5;
	else if DS1_SEX1 = 2 and DS1_AGE < 30 then group12=6;
	else if DS1_SEX1 = 2 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=7;
	else if DS1_SEX1 = 2 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=8;
	else if DS1_SEX1 = 2 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=9;
	else group12=10; 
run;
proc freq data=b.thesis; tables group12; run;

/*Error in Old code*/
/*(6) 비타민A*/
/*data b.thesis; set b.thesis;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (800 750 750 700 700 650 650 600 550 550);
	if SS09 in (.,99999) then VitA=99999; 
	else if SS09 < reference[group12] then VitA=0;
	else VitA = 1;
run;
data b.thesis; set b.thesis;
	drop t1-t10;
run;
proc freq data=b.thesis; tables VitA; run;/* 미만 35957    이상 10163   758*/
/*proc freq data=b.thesis; tables VitA*ss09/list missing;run;
proc freq data=b.thesis; where VitA^=99999; tables VitA*group1/chisq; run;*/

/*(6) 비타민A */
data b.thesis; set b.thesis;
	if SS09 in (.,99999) then VitA2=99999; 
	else if DS1_SEX1=1 and DS1_AGE<30 and SS09<800 then VitA2=0; 
    else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS09<750 then VitA2=0;
	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS09<750 then VitA2=0; 
    else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS09<700 then VitA2=0; 
    else if DS1_SEX1=1 and 75=<DS1_AGE and SS09<700 then VitA2=0;
	else if DS1_SEX1=2 and DS1_AGE<30 and SS09<650 then VitA2=0; 
    else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS09<650 then VitA2=0;
	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS09<600 then VitA2=0; 
    else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS09<550 then VitA2=0; 
    else if DS1_SEX1=2 and 75=<DS1_AGE and SS09<550 then VitA2=0;
	else VitA2=1; RUN;
proc freq data=b.thesis; tables VitA2; run; /*미만 35957    이상 10163   758 */
proc freq data=b.thesis; tables VitA2*ss09/list missing;run;
proc freq data=b.thesis; tables VitA2*group1/chisq; run;

/*(7) 티아민(비타민B1)*/
data b.thesis; set b.thesis;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.2 1.2 1.2 1.2 1.2 1.1 1.1 1.1 1.1 1.1);

     if SS11 in (.,99999) then VitB1=99999;
	 else if SS11 < reference[group12] then VitB1=0;
	 else VitB1=1;
	 drop t1 - t10;
run;
proc freq data=b.thesis; tables VitB1; run;
proc freq data=b.thesis; tables VitB1*ss11/list missing;run;
proc freq data=b.thesis; where VitB1^=99999; tables VitB1*group1/chisq; run;

/*(10) 리보플라빈(비타민B2)*/
data b.thesis; set b.thesis;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.5 1.5 1.5 1.5 1.5 1.2 1.2 1.2 1.2 1.2);

     if SS12 in (.,99999) then VitB2=99999;
	 else if SS12 < reference[group12] then VitB2=0;
	 else VitB2=1;
	 drop t1 - t10;
run;
proc freq data=b.thesis; tables VitB2; run;
proc freq data=b.thesis; tables VitB2*ss12/list missing;run;
proc freq data=b.thesis; where VitB2^=99999; tables VitB2*group1/chisq; run;

/*(11) 니아신*/
 data b.thesis; set b.thesis;
 	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (16 16 16 16 16 14 14 14 14 14);

	if SS13 in (.,99999) then Niacin=99999; 
	else if SS13 < reference[group12] then Niacin=0;
	else Niacin=1;
	drop t1-t10;
run;
proc freq data=b.thesis; tables Niacin; run;
proc freq data=b.thesis; tables Niacin*ss13/list missing;run;
proc freq data=b.thesis; where Niacin^=99999; tables Niacin*group1/chisq; run;

/*(12) 엽산*/
data b.thesis; set b.thesis;
	if SS17 in (.,99999) then Folate=99999; 
	else if SS17 < 400 then Folate=0;
	else Folate=1;
run;
proc freq data=b.thesis; tables Folate; run;
proc freq data=b.thesis; tables Folate*ss17/list missing;run;
proc freq data=b.thesis; where Folate^=99999; tables Folate*group1/chisq; run;

/*(13) 비타민B6*/
data b.thesis; set b.thesis;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.5 1.5 1.5 1.5 1.5 1.4 1.4 1.4 1.4 1.4);

	if SS16 in (.,99999) then VitB6=99999; 
	else if SS16 < reference[group12] then VitB6=0;
	else VitB6=1;
	drop t1-t10;
run;
proc freq data=b.thesis; tables VitB6; run;
proc freq data=b.thesis; tables VitB6*ss16/list missing;run;
proc freq data=b.thesis; where VitB6^=99999; tables VitB6*group1/chisq; run;

/*(14) 비타민C*/
data b.thesis; set b.thesis;
	if SS14 in (.,99999) then VitC=99999; 
	else if SS14 < 100 then VitC=0;
	else VitC=1;
run;
proc freq data=b.thesis; tables VitC; run;
proc freq data=b.thesis; tables VitC*ss14/list missing;run;
proc freq data=b.thesis; where VitC^=99999; tables VitC*group1/chisq; run;

/*(15) 비타민E*/
data b.thesis; set b.thesis;
    if SS23 in (.,99999) then VitE=99999; 
	else if SS23 < 12 then VitE=0;
	else VitE=1;
run; 
proc freq data=b.thesis; tables VitE; run;
proc freq data=b.thesis; tables VitE*ss23/list missing;run;
proc freq data=b.thesis; where VitE^=99999; tables VitE*group1/chisq; run;

/*(16) 칼슘*/
data b.thesis; set b.thesis;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (800 800 750 700 700 700 700 800 800 800);

	if SS05 in (.,99999) then cals=99999;
	else if SS05 < reference[group12] then cals=0;
	else cals=1;
	drop t1-t10;
run;
proc freq data=b.thesis; tables cals; run;
proc freq data=b.thesis; tables cals*ss05/list missing;run;
proc freq data=b.thesis; where cals^=99999; tables cals*group1/chisq; run;

/*(17) 인*/
data b.thesis; set b.thesis;
	if SS06 in (.,99999) then pho=99999;
	else if SS06 < 700 then pho=0;
	else pho=1;
run; 
proc freq data=b.thesis; tables pho; run;
proc freq data=b.thesis; tables pho*ss06/list missing;run;
proc freq data=b.thesis; where pho^=99999; tables pho*group1/chisq; run;

/*(18) 철*/
data b.thesis; set b.thesis;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (10 10 9 9 9 14 14 8 8 7);

	if SS07 in (.,99999) then iron=99999;
	else if SS07 < reference[group12] then iron=0;
	else iron=1;
	drop t1-t10;
run; 
proc freq data=b.thesis; tables iron; run;
proc freq data=b.thesis; tables iron*ss07/list missing;run;
proc freq data=b.thesis; where iron^=99999; tables iron*group1/chisq; run;

/*(19) 칼륨*/
data b.thesis; set b.thesis;
	if SS08 in (.,99999) then Cal=99999;
	else if SS08 < 3500 then Cal=0;
	else Cal=1;
run;
proc freq data=b.thesis; tables Cal; run;
proc freq data=b.thesis; tables Cal*ss08/list missing;run;
proc freq data=b.thesis; where Cal^=99999; tables Cal*group1/chisq; run;

/*(20) 아연*/
data b.thesis; set b.thesis;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (10 10 9 9 9 8 8 7 7 7);

    if SS15 in (.,99999) then Zinc=99999; 
	else if SS15 < reference[group12] then Zinc=0;
	else Zinc=1;
	drop t1-t10;
run;
proc freq data=b.thesis; tables Zinc; run;
proc freq data=b.thesis; tables Zinc*ss15/list missing;run;
proc freq data=b.thesis; where Zinc^=99999; tables Zinc*group1/chisq; run;

/*(21) 나트륨과 염소*/
data b.thesis; set b.thesis;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1500 1500 1500 1300 1100 1500 1500 1500 1300 1100);

	if SS10 in (.,99999) then Na=99999; 
	else if SS10 < reference[group12] then Na=0;
	else Na=1;
	drop t1-t10;
run;
proc freq data=b.thesis; tables Na; run;
proc freq data=b.thesis; tables Na*ss10/list missing;run;
proc freq data=b.thesis; where Na^=99999; tables Na*group1/chisq; run;


/*****영양 ttest****/
proc ttest data=b.thesis; where SS01^=99999; class group1; var SS01; run; 
proc ttest data=b.thesis; where SS02^=99999; class group1; var SS02; run;
proc ttest data=b.thesis; where SS02_Per^=99999; class group1; var SS02_Per; run;  
proc ttest data=b.thesis; where SS03^=99999; class group1; var SS03; run; 
proc ttest data=b.thesis; where SS03_Per^=99999; class group1; var SS03_Per; run; 
proc ttest data=b.thesis; where SS04^=99999; class group1; var SS04; run; 
proc ttest data=b.thesis; where SS04_Per^=99999; class group1; var SS04_Per; run; 
proc ttest data=b.thesis; where SS05^=99999; class group1; var SS05; run; 
proc ttest data=b.thesis; where SS06^=99999; class group1; var SS06; run; 
proc ttest data=b.thesis; where SS07^=99999; class group1; var SS07; run; 
proc ttest data=b.thesis; where SS08^=99999; class group1; var SS08; run; 
proc ttest data=b.thesis; where SS09^=99999; class group1; var SS09; run; 
proc ttest data=b.thesis; where SS10^=99999; class group1; var SS10; run; 
proc ttest data=b.thesis; where SS11^=99999; class group1; var SS11; run; 
proc ttest data=b.thesis; where SS12^=99999; class group1; var SS12; run; 
proc ttest data=b.thesis; where SS13^=99999; class group1; var SS13; run; 
proc ttest data=b.thesis; where SS14^=99999; class group1; var SS14; run; 
proc ttest data=b.thesis; where SS15^=99999; class group1; var SS15; run; 
proc ttest data=b.thesis; where SS16^=99999; class group1; var SS16; run; 
proc ttest data=b.thesis; where SS17^=99999; class group1; var SS17; run; 
proc ttest data=b.thesis; where SS18^=99999; class group1; var SS18; run; 
proc ttest data=b.thesis; where SS19^=99999; class group1; var SS19; run; 
proc ttest data=b.thesis; where SS20^=99999; class group1; var SS20; run; 
proc ttest data=b.thesis; where SS21^=99999; class group1; var SS21; run; 
proc ttest data=b.thesis; where SS23^=99999; class group1; var SS23; run; 
proc ttest data=b.thesis; where SS24^=99999; class group1; var SS24; run; 


/*******Data Reveiw by Cancer Type *******/
/*암유병자 그룹2 만들기*/
data b.thesis; set b.thesis;
	TOTAL_C = GA_C + LI_C + CO_C + BR_C + CE_C + LU_C + THY_C + PRO_C + BL_C + OT_C;
run;
proc freq data=b.thesis; table TOTAL_C*group1; run; /*암 환자이나 암종 정보가 없는 경우 240명*/

data b.thesis; set b.thesis;
	TOTAL_CA = TOTAL_C>=2;
run;
proc freq data=b.thesis; where CA=1; tables TOTAL_CA;run; /* 암2개 이상 환자 137명*/

data b.thesis; set b.thesis;
	IF GA_C = 1 then CANCER_TYPE=1;
	IF LI_C = 1 then CANCER_TYPE=2;
	IF CO_C = 1 then CANCER_TYPE=3;
	IF BR_C = 1 then CANCER_TYPE=4;
	IF CE_C = 1 then CANCER_TYPE=5;
	IF LU_C = 1 then CANCER_TYPE=6;
	IF THY_C = 1 then CANCER_TYPE=7;
	IF PRO_C = 1 then CANCER_TYPE=8;
	IF BL_C = 1 then CANCER_TYPE=9;
	IF OT_C = 1 then CANCER_TYPE=10;
	IF TOTAL_CA= 1 then CANCER_TYPE=11;
run;
proc freq data=b.thesis; tables CANCER_TYPE; run;

proc freq data=b.thesis; where group1=0; tables CANCER_TYPE*DS1_SEX/chisq; run;
proc freq data=b.thesis; where group1=0 and psmok^=99; tables CANCER_TYPE*psmok/chisq; run;
proc freq data=b.thesis; where group1=0 and pdrink^=99; tables CANCER_TYPE*pdrink/chisq; run;
proc freq data=b.thesis; where group1=0 and gexer_wk2^=99; tables CANCER_TYPE*gexer_wk2/chisq; run;
proc freq data=b.thesis; where group1=0 and gbmi2^=99999; tables CANCER_TYPE*gbmi2/chisq; run;
proc freq data=b.thesis; where group1=0 and PWI_1^=99999; tables CANCER_TYPE*PWI_1/chisq; run;

proc freq data=b.thesis; where group1=0 and energy^=99999; tables CANCER_TYPE*energy/chisq; run;
proc freq data=b.thesis; where group1=0 and Protein^=99999; tables CANCER_TYPE*Protein/chisq; run;
proc freq data=b.thesis; where group1=0 and fat^=99999; tables CANCER_TYPE*fat/chisq; run;
proc freq data=b.thesis; where group1=0 and sugar^=99999; tables CANCER_TYPE*sugar/chisq; run;
proc freq data=b.thesis; where group1=0 and Fiber^=99999; tables CANCER_TYPE*Fiber/chisq; run;
proc freq data=b.thesis; where group1=0 and VitA^=99999; tables CANCER_TYPE*VitA/chisq; run;
proc freq data=b.thesis; where group1=0 and VitE^=99999; tables CANCER_TYPE*VitE/chisq; run;
proc freq data=b.thesis; where group1=0 and VitC^=99999; tables CANCER_TYPE*VitC/chisq; run;
proc freq data=b.thesis; where group1=0 and VitB1^=99999; tables CANCER_TYPE*VitB1/chisq; run;
proc freq data=b.thesis; where group1=0 and VitB2^=99999; tables CANCER_TYPE*VitB2/chisq; run;
proc freq data=b.thesis; where group1=0 and Niacin^=99999; tables CANCER_TYPE*Niacin/chisq; run;
proc freq data=b.thesis; where group1=0 and VitB6^=99999; tables CANCER_TYPE*VitB6/chisq; run;
proc freq data=b.thesis; where group1=0 and Folate^=99999; tables CANCER_TYPE*Folate/chisq; run;
proc freq data=b.thesis; where group1=0 and cals^=99999; tables CANCER_TYPE*cals/chisq; run;
proc freq data=b.thesis; where group1=0 and pho^=99999; tables CANCER_TYPE*pho/chisq; run;
proc freq data=b.thesis; where group1=0 and Na^=99999; tables CANCER_TYPE*Na/chisq; run;
proc freq data=b.thesis; where group1=0 and Cal^=99999; tables CANCER_TYPE*Cal/chisq; run;
proc freq data=b.thesis; where group1=0 and iron^=99999; tables CANCER_TYPE*iron/chisq; run;
proc freq data=b.thesis; where group1=0 and Zinc^=99999; tables CANCER_TYPE*Zinc/chisq; run;

proc contents data=b.thesis ; run;
/*****Logistic Regression (Total)****/

/**************Smoke*************/
proc freq data=b.thesis; tables csmok/list missing; run; /*Missing of csmok : 1,625 people*/  
proc logistic data=b.thesis; where csmok not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') cexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink cexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc freq data=b.thesis; tables cdrink/list missing; run; /*Missing of cdrink : 1,465 people*/ 
proc logistic data=b.thesis; where cdrink not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc freq data=b.thesis; tables gexer_wk1/list missing; run; /*Missing of gexer_wk1 : 6,671 people*/ 
proc logistic data=b.thesis; where gexer_wk1 not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc freq data=b.thesis; tables gbmi1/list missing; run; /*Missing of gbmi1 : 934 people*/ 
proc logistic data=b.thesis; where gbmi1 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc freq data=b.thesis; tables PWI_2/list missing; run; /*Missing of PWI_2 : 7,783 people*/ 
proc logistic data=b.thesis; where PWI_2 not in (99999);	   

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********MeS**********/
proc freq data=b.thesis; tables MeS/list missing; run;
proc logistic data=b.thesis;     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********wc**********/
proc freq data=b.thesis; tables wc/list missing; run; /*Missing of wc : 2,572 people*/ 
proc logistic data=b.thesis; where wc not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********tg**********/
proc freq data=b.thesis; tables tg/list missing; run; /*Missing of tg : 367 people*/ 
proc logistic data=b.thesis; where tg not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********hdl**********/
proc freq data=b.thesis; tables hdl/list missing; run; /*Missing of hdl : 50 people*/ 
proc logistic data=b.thesis; where hdl not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********bp**********/
proc freq data=b.thesis; tables bp/list missing; run; /*Missing of bp : 2,557 people*/ 
proc logistic data=b.thesis; where bp not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********glu**********/
proc freq data=b.thesis; tables glu/list missing; run; /*Missing of glu : 4,757 people*/ 
proc logistic data=b.thesis; where glu not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc freq data=b.thesis; tables energy/list missing; run; /*Missing of energy : 3,066 people*/ 
proc logistic data=b.thesis; where energy not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables protein/list missing; run; /*Missing of protein : 3,066 people*/ 
proc logistic data=b.thesis; where protein not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables fat_2/list missing; run; /*Missing of fat_2 : 59,294 people Only Men*/ 
proc logistic data=b.thesis; where fat_2 not in (99999);    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables sugar_2/list missing; run; /*Missing of sugar_2 : 3,066 people*/ 
proc logistic data=b.thesis; where sugar_2 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables fiber/list missing; run; /*Missing of fiber : 3,066 people*/ 
proc logistic data=b.thesis; where fiber not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitA/list missing; run; /*Missing of VitA : 3,066 people*/ 
proc logistic data=b.thesis; where VitA not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitB1/list missing; run; /*Missing of VitB1 : 3,066 people*/ 
proc logistic data=b.thesis; where VitB1 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitB2/list missing; run; /*Missing of VitB2 : 3,066 people*/ 
proc logistic data=b.thesis; where VitB2 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Niacin/list missing; run; /*Missing of Niacin : 3,066 people*/ 
proc logistic data=b.thesis; where Niacin not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Folate/list missing; run; /*Missing of Folate : 3,066 people*/ 
proc logistic data=b.thesis; where Folate not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitB6/list missing; run; /*Missing of VitB6 : 3,066 people*/ 
proc logistic data=b.thesis; where VitB6 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitC/list missing; run; /*Missing of VitC : 3,066 people*/
proc logistic data=b.thesis; where VitC not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables VitE/list missing; run; /*Missing of VitE : 3,066 people*/
proc logistic data=b.thesis; where VitE not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Cals/list missing; run; /*Missing of Cals : 3,066 people*/
proc logistic data=b.thesis; where Cals not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables pho/list missing; run; /*Missing of pho : 3,066 people*/
proc logistic data=b.thesis; where pho not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables iron/list missing; run; /*Missing of iron : 3,066 people*/
proc logistic data=b.thesis; where iron not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Cal/list missing; run; /*Missing of Cal : 3,066 people*/
proc logistic data=b.thesis; where Cal not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Zinc/list missing; run; /*Missing of Zinc : 3,066 people*/
proc logistic data=b.thesis; where Zinc not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc freq data=b.thesis; tables Na/list missing; run; /*Missing of Na : 3,066 people*/
proc logistic data=b.thesis; where Na not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;


/*****Logistic Regression (Male)****/
/**************Smoke*************/
proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********MeS**********/
proc logistic data=b.thesis; where DS1_SEX1=1;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********wc**********/
proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=1;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0') 			
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********tg**********/
proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=1;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg(PARAM=REF REF='0') 			
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********hdl**********/
proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=1;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl(PARAM=REF REF='0') 			
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********bp**********/
proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=1;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp(PARAM=REF REF='0') 			
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********glu**********/
proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=1;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu(PARAM=REF REF='0') 			
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.thesis; where energy not in (99999) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where protein not in (99999) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fat_2 not in (99999) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where sugar_2 not in (99999) and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fiber not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitA not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB1 not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB2 not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Niacin not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Folate not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB6 not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitC not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitE not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cals not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where pho not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where iron not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cal not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Zinc not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Na not in (99999)  and DS1_SEX1=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*****Logistic Regression (Female)****/
/**************Smoke*************/
proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk2 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********MeS**********/
proc logistic data=b.thesis; where DS1_SEX1=2;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********wc**********/
proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=2;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********tg**********/
proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=2;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********hdl**********/
proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=2;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********bp**********/
proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=2;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********glu**********/
proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=2;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.thesis; where energy not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where protein not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fat_2 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where sugar_2 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where fiber not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitA not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB1 not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB2 not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Niacin not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Folate not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitB6 not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitC not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where VitE not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cals not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where pho not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where iron not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Cal not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Zinc not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.thesis; where Na not in (99999)  and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;


/**************************************/
/********1 by 1 Individual  Matching******/ 
/**************************************/

/******total_final dataset 에서 시작********/
/****group1****/
/* group1=0 : 암생존자, group1=1 : 정상인(질병x),  group1=2 : 정상인(질병o)**/
data b.total_final; set a.total_final_1by1; run;
proc contents data=b.total_final; run;

proc freq data=b.total_final; tables group1; run; /**group10 : 5269명 group11 : 5219명 group12 : 5263명**/

/****age*****/
/***나이(평균 및 표준편차)***/
proc univariate data=b.total_final; class group1; var AGE_1; run; /*group10 : 55.8 group11 : 55.6 group12 : 55.8*/
proc anova data=b.total_final; class group1; model AGE_1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc freq data=b.total_final; tables DS1_AGE*DS1_AGE1/list missing;  run;/**이상없음**/
proc freq data=b.total_final; where group1=0;tables DS1_AGE1/list missing; run;/* 1)50세 미만 : 1267 2)55세 미만 : 1109 3)60세 미만 : 1023 4)65세 미만 : 972 5)65세 이상 : 898 */
proc freq data=b.total_final; where group1=1;tables DS1_AGE1/list missing; run;/* 1)50세 미만 : 1266 2)55세 미만 : 1109 3)60세 미만 : 1019 4)65세 미만 : 966 5)65세 이상 : 859 */
proc freq data=b.total_final; where group1=2;tables DS1_AGE1/list missing; run;/* 1)50세 미만 : 1264 2)55세 미만 : 1109 3)60세 미만 : 1023 4)65세 미만 : 972 5)65세 이상 : 895 */
proc freq data=b.total_final; tables DS1_AGE1*group1/chisq; run; /*p-value : 0.9991*/

/*****sex*****/
proc freq data=b.total_final; tables DS1_SEX1*group1/chisq; run;/**남자 : 3940 여자 : 11581 **//*p-value : 0.9967*/
proc freq data=b.total_final; where group1=0;tables DS1_SEX1/list missing; run; /**남자 : 1320 여자 : 3949 **/
proc freq data=b.total_final; where group1=1;tables DS1_SEX1/list missing; run;/**남자 : 1304 여자 : 3915 **/
proc freq data=b.total_final; where group1=2;tables DS1_SEX1/list missing; run;/**남자 : 1316 여자 : 3947 **/
proc freq data=b.total_final; tables DS1_SEX1*group1/chisq; run; /*p-value : 0.9967*/

/****결혼****/
 /*DS1_MARRY_A_1; 미혼/별거/이혼/사별/기타 (1), 기혼/동거=결혼(2), */		
proc freq data=b.total_final; where group1=0;tables DS1_MARRY_A_1/list missing; run; /*1) 미혼/별거/이혼/사별/기타 : 680 2) 결혼 : 4566 99: 23*/
proc freq data=b.total_final; where group1=1;tables DS1_MARRY_A_1/list missing; run; /*1) 미혼/별거/이혼/사별/기타 : 602 2) 결혼 : 4533 99: 84*/
proc freq data=b.total_final; where group1=2;tables DS1_MARRY_A_1/list missing; run; /*1) 미혼/별거/이혼/사별/기타 : 636 2) 결혼 : 4593 99: 34*/
proc freq data=b.total_final; tables DS1_MARRY_A_1*group1/chisq; run;/*p-value : <.0001*/

/****교육****/		
/* 0=학교에 다니지 않았다, 1=초등학교 중퇴, 2=초등학교 졸업 또는 중학교 중퇴, 3=중학교 졸업 또는 고등학교 중퇴, 4=고등학교 졸업, 5=기술(전문)학교 졸업, 6=대학교 중퇴, 7=대학교 졸업, 8=대학원 이상 */
proc freq data=b.total_final; tables DS1_EDU*DS1_EDU1/list missing; run;
proc freq data=b.total_final; where group1=0;tables DS1_EDU1/list missing; run;/*1)고졸 미만 : 1973 2) 고졸 : 2115 3) 대졸 이상 : 1120 99: 61 */
proc freq data=b.total_final; where group1=1;tables DS1_EDU1/list missing; run;/*1)고졸 미만 : 2015 2) 고졸 : 2010 3) 대졸 이상 : 1052 99: 142 */
proc freq data=b.total_final; where group1=2;tables DS1_EDU1/list missing; run;/*1)고졸 미만 : 2110 2) 고졸 : 2022 3) 대졸 이상 : 1058 99: 73*/
proc freq data=b.total_final; tables DS1_EDU1*group1/chisq; run;	/*p-value : <.0001*/

/****수입****/
/* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 */	
proc freq data=b.total_final;  tables DS1_INCOME*DS1_INCOME1/list missing; run;
proc freq data=b.total_final; where group1=0;tables DS1_INCOME1/list missing; run;/*1) 200만원 미만 : 1798 2) 200만원 이상 400만원 미만 : 1789 3) 400만원 이상 : 954 99 : 728*/ 
proc freq data=b.total_final; where group1=1;tables DS1_INCOME1/list missing; run;/*1) 200만원 미만 : 1623 2) 200만원 이상 400만원 미만 : 1815 3) 400만원 이상 : 921 99 : 860 */ 
proc freq data=b.total_final; where group1=2;tables DS1_INCOME1/list missing; run;/*1) 200만원 미만 : 1653 2) 200만원 이상 400만원 미만 : 1789 3) 400만원 이상 : 943 99 : 878 */ 
proc freq data=b.total_final; tables DS1_INCOME1*group1/chisq; run; /*p-value : 0.0001*/

/****직업****/
 /*DS1_JOB_1; 주부나 무직(1), 직업있음(2)*/		
proc freq data=b.total_final; tables DS1_JOB*DS1_JOB_A*DS1_JOB_1; run;
proc freq data=b.total_final; where group1=0;tables DS1_JOB_1/list missing; run; /*1)주부 혹은 무직 : 3149 2)직업있음 : 2005 99 : 115*/
proc freq data=b.total_final; where group1=1;tables DS1_JOB_1/list missing; run;/*1)주부 혹은 무직 : 2698 2)직업있음 : 2340 99 : 181*/
proc freq data=b.total_final; where group1=2;tables DS1_JOB_1/list missing; run;/*1)주부 혹은 무직 : 2892 2)직업있음 : 2212 99 : 159*/
proc freq data=b.total_final; tables DS1_JOB_1*group1/chisq; run;	/*p-value : <.0001*/

/****흡연****/
/*csmok: 현재흡연 (1), 과거흡연& 경험없음(0)*/					
/*psmok: 현재흡연 (2), 과거흡연 (1), 경험없음 (0)*/		
proc freq data=b.total_final; where group1=0; tables csmok*group1/list missing; run; /*0) 과거흡연&경험없음 : 4962 1) 현재흡연 : 280 99 : 27 */
proc freq data=b.total_final; where group1=1; tables csmok*group1/list missing; run;/*0) 과거흡연&경험없음 : 4697 1) 현재흡연 : 444 99 : 78 */
proc freq data=b.total_final; where group1=2; tables csmok*group1/list missing; run;/*0) 과거흡연&경험없음 : 4825 1) 현재흡연 : 404 99 : 27 */
proc freq data=b.total_final; tables csmok*group1/chisq; run;/*p-value : <.0001*/

proc freq data=b.total_final; where group1=0; tables psmok*group1/list missing; run;/*0) 경험없음 : 4143 1) 과거흡연 : 819 2) 현재흡연 : 280  99 : 27 */
proc freq data=b.total_final; where group1=1; tables psmok*group1/list missing; run;/*0) 경험없음 : 4142 1) 과거흡연 : 555 2) 현재흡연 : 444  99: 78 */
proc freq data=b.total_final; where group1=2; tables psmok*group1/list missing; run;/*0) 경험없음 : 4144 1) 과거흡연 : 681 2) 현재흡연 : 404  99: 34 */
proc freq data=b.total_final; tables psmok*group1/chisq; run;/*p-value : <.0001*/
proc freq data=b.total_final; tables psmok*group1/chisq; run;/*p-value : <.0001*/

/*****음주****/
/*cdrink: 현재음주(1), 현재음주안함(0)*/
/*pdrink: 현재음주 (2), 과거음주 (1), 경험없음 (0)*/		
proc freq data=b.total_final; where group1=0;tables cdrink*group1/list missing; run;/* 0) 음주안함 : 3802 1) 현재음주 : 1444 99: 23*/
proc freq data=b.total_final; where group1=1;tables cdrink*group1/list missing; run;/* 0) 음주안함 : 3151 1) 현재음주 : 1990 99: 78*/
proc freq data=b.total_final; where group1=2;tables cdrink*group1/list missing; run;/* 0) 음주안함 : 3207 1) 현재음주 : 2027 99: 78 */
proc freq data=b.total_final; tables cdrink*group1/chisq; run;/*p-value : <.0001*/

proc freq data=b.total_final; where group1=0;tables pdrink*group1/list missing; run;/* 0) 경험없음 : 3275 1) 과거음주 : 527 2) 현재음주 : 1444 99: 23*/
proc freq data=b.total_final; where group1=1;tables pdrink*group1/list missing; run;/* 0) 경험없음 : 3019 1) 과거음주 : 132 2) 현재음주 :1990 99: 78: */
proc freq data=b.total_final; where group1=2;tables pdrink*group1/list missing; run;/* 0) 경험없음 : 3003 1) 과거음주 : 204 2) 현재음주 2027: 99: 29 */
proc freq data=b.total_final; tables pdrink*group1/chisq; run;

/***운동**/	
/*gexer_wk1: 주 150분 미만 (1), 주 150분 이상 (2)*/
/*gexer_wk2: 운동안함(1), 주 150분 미만(2), 주 150분 이상(3)*/			
/*gexer_wk3: 운동안함(1), 운동함 (2)*/			
proc freq data=b.total_final; where group1=0; tables gexer_wk2*group1/list missing; run; /**1) 운동안함 : 2203) 2) 주 150분 미만 : 594 3) 주 150분 이상 : 2332 99 : 140**/
proc freq data=b.total_final; where group1=1; tables gexer_wk2*group1/list missing; run;  /**1) 운동안함 : 2530) 2) 주 150분 미만 : 605 3) 주 150분 이상  1838 99 : 246**/
proc freq data=b.total_final; where group1=2; tables gexer_wk2*group1/list missing; run; /**1) 운동안함 : 2470) 2) 주 150분 미만 : 630 3) 주 150분 이상 : 1987 99 : 176**/
proc freq data=b.total_final; tables gexer_wk2*group1/chisq; run;/*p-value<0.001*/

/***gbmi****/
/*gbmi1: 23 미만 (1), 23 이상 (2)*/
/*gbmi2: 23 미만 (1), 25 미만 (2) 25이상 (3)*/
/*gbmi3: 25 미만 (1), 25 이상 (2)*/
/*gwhratio1: 0.90미만(1), 0.90이상(2)*/			
proc freq data=b.total_final;  tables gbmi*gbmi1/list missing; run;
proc freq data=b.total_final;  tables gbmi*gbmi2/list missing; run;
proc freq data=b.total_final;  tables gbmi*gbmi3/list missing; run;
proc freq data=b.total_final; where group1=0;tables gbmi2/list missing; run;/*gbmi2: 1)23 미만 : 2308, 2)25 미만 : 1398 3)25이상 : 1544 99999 : 19 */
proc freq data=b.total_final; where group1=1;tables gbmi2/list missing; run;/*gbmi2: 1)23 미만 : 2286, 2)25 미만 : 1455 3)25이상 : 1453 99999 : 25 */
proc freq data=b.total_final; where group1=2;tables gbmi2/list missing; run;/*gbmi2: 1)23 미만 : 1914, 2)25 미만 : 1484 3)25이상 : 1848 99999 : 17 */
proc freq data=b.total_final; tables gbmi2*group1/chisq; run; /*p-value : 0.0001*/

/****pwi 공식으로 총점 구하기***/
proc freq data=b.total_final; tables ds1_pwi1--ds1_pwi18; run;
data b.total_final; set b.total_final;
	if  ds1_pwi1 in ('99999') or ds1_pwi2 in ('99999') or ds1_pwi3 in ('99999') or ds1_pwi4 in ('99999') or ds1_pwi5 in ('99999') or ds1_pwi6 in ('99999') or ds1_pwi7 in ('99999') or 
	   ds1_pwi8 in ('99999') or ds1_pwi9 in ('99999') or ds1_pwi10 in ('99999') or ds1_pwi11 in ('99999') or ds1_pwi12 in ('99999') or ds1_pwi13 in ('99999') or ds1_pwi14 in ('99999') or 
	   ds1_pwi15 in ('99999') or ds1_pwi16 in ('99999') or ds1_pwi17 in ('99999') or ds1_pwi18 in ('99999') then  pwi=99999;
	else pwi = ds1_pwi1 + (3-ds1_pwi2) + (3-ds1_pwi3) + (3-ds1_pwi4) + ds1_pwi5 + ds1_pwi6 + (3-ds1_pwi7) + ds1_pwi8 + ds1_pwi9 + ds1_pwi10 + ds1_pwi11 + ds1_pwi12 + (3-ds1_pwi13) + ds1_pwi14 + (3-ds1_pwi15) + (3-ds1_pwi16) + ds1_pwi17 + ds1_pwi18;
run;
proc univariate data=b.total_final ; where PWI^=99999; class group1; var PWI; run;
proc anova data=b.total_final; where PWI^=99999; class group1; model PWI=group1; MEANS group1 / DUNCAN ;run; quit;

data b.total_final; set b.total_final;
	if PWI_1 = 99999 then PWI_2=99999;
	else if PWI_1 < 2 then PWI_2 = 1;    /*PWI_1 = 1*/
	else PWI_2 = 2; /*PWI_1 = 2, 3*/
run;
proc freq data=b.total_final; tables PWI_2*group1/list missing; run;

proc freq data=b.total_final; tables pwi*pwi_1/list missing; run;
proc freq data=b.total_final; tables pwi*group1/chisq;run;	/*p-value : <.0001*/
proc freq data=b.total_final; tables PWI_1; run;/*1)정상 : 1657 2) 약간 스트레스 : 
proc freq data=b.total_final; where group1=0; tables PWI_1; run;/*1)정상 : 532 2) 약간 스트레스 : 3892 3) 매우 심한 스트레스 : 652 99999 : 193 */    
proc freq data=b.total_final; where group1=1; tables PWI_1; run;/*1)정상 : 652 2) 약간 스트레스 : 3851 3) 매우 심한 스트레스 : 437 99999 : 279 */    
proc freq data=b.total_final; where group1=2; tables PWI_1; run;/*1)정상 : 473 2) 약간 스트레스 : 3892 3) 매우 심한 스트레스 : 664 99999 : 234 */    
proc freq data=b.total_final; tables PWI_1*group1/chisq; run;	/*p-value : <.0001*/

/***OC 사용여부****/
/*DS1_ORALCON: OC사용한적 없음(1), 있음(2, 과거사용+현재사용)*/ 	
proc freq data=b.total_final; tables ds1_oralcon/list missing; run;
data b.total_final; set b.total_final;
	if DS1_ORALCON in ('77777','99999') then DS1_ORALCON_1=99; else if DS1_ORALCON=1 then DS1_ORALCON_1=1; else DS1_ORALCON_1=2;
run;	
proc freq data=b.total_final; tables ds1_oralcon * ds1_oralcon_1/list missing; run;

/***생리 여부****/
proc freq data=b.total_final; tables ds1_menyn * ds1_menyn_a/list missing; run;
data b.total_final; set b.total_final;
	if DS1_MENYN_A in  ('66666','77777','99999') and DS1_MENYN in  ('66666','77777','99999') then DS1_MENYN_1=99;				
	else if  DS1_MENYN_A=1 or  DS1_MENYN=1 then DS1_MENYN_1=1; 
	else  DS1_MENYN_1=2;				
	/* DS1_MENYN: 폐경=생리 없음(1), 생리 있음(2)*/	
run;
proc freq data=b.total_final; tables ds1_menyn * ds1_menyn_a * ds1_menyn_1/list missing; run;


/***************************************Metabolic syndrome 변수 만들기 */
data b.total_final; set b.total_final; 
	cheight = DS1_HEIGHT+0;
	cweight = DS1_WEIGHT+0; 
	cwaist = DS1_WAIST+0;
	chip = DS1_HIP+0 ;
	ds1_tg1 = ds1_tg+0;
	ds1_hdl1 = ds1_hdl+0;
	ds1_dbp1 = ds1_dbp+0;
	ds1_sbp1 = ds1_sbp+0;
	ds1_glu0_1 = ds1_glu0+0;
run;
proc freq data=b.total_final; tables ds1_height * cheight/list missing; run;
proc freq data=b.total_final; tables ds1_weight * cweight/list missing; run;
proc freq data=b.total_final; tables ds1_waist * cwaist/list missing; run;
proc freq data=b.total_final; tables ds1_hip * chip/list missing; run;
proc univariate data=b.total_final; var ds1_tg1; run;
proc univariate data=b.total_final; var ds1_hdl1; run;
proc univariate data=b.total_final; var ds1_dbp1; run;
proc univariate data=b.total_final; var ds1_sbp1; run;
proc univariate data=b.total_final; var ds1_glu0_1; run;

/*MeS 만들기*/
data  b.total_final; set  b.total_final;																		
	if  cwaist=99999 then wc=99; 
	else if (cwaist >=90 and DS1_SEX1=1) or (cwaist >=80 and DS1_SEX1=2) then wc=1; 
	else wc=0; 																		
	/*wc=1이면 metabolic syndrom, wc=0 이면 metS 해당없음 */																	

	if DS1_TG1 =99999 then TG=99; 
	else if DS1_TG1 >=150 or DS1_LIPCUTY=1 or DS1_LIPCUTRPM=2 then TG=1;
	else TG=0; 																		
	/*TG=1 이면 metS criteria인 highTC*/	
	
	if DS1_HDL1 =99999 then HDL=99; 
	else if (DS1_HDL1 <40 and DS1_SEX1=1) or (DS1_HDL1 <50 and DS1_SEX1=2) then HDL=1;
	else HDL=0;																		
	/*HDL=1 이면 metS criteria*/

	if DS1_DBP1=99999 or DS1_SBP1=99999 then BP=99; 
	else if DS1_SBP1 >=130 or DS1_DBP1 >=85 or DS1_HTNCUTY=1 or DS1_HTNCUTRPM=2 or DS1_BP_MEDI=2 then BP=1;  
	else BP=0;																		
	/*BP=1 이면 metS criteria*/

	if DS1_GLU0_1 =99999 then GLU=99; 
	else IF DS1_GLU0_1>=100 or DS1_DMCUTY=1 or DS1_DMCUTY=2 or DS1_DMCUTY=4 or DS1_DMCUTY1=1 or DS1_DMCUTY1=2 or DS1_DMCUTY1=4 or	DS1_DMCUTRPM=2 or DS1_DMCUTRIN=2 then GLU=1;																																																		
	else GLU=0; 																		
	/*GLU=1 이면 metS criteria*/		
run;
data  b.total_final(drop = i); set  b.total_final;																		
	metS_sum = 0;
	do i = wc, tg, hdl, bp, glu;
		if i ^= 99 then metS_sum + i;
		else metS_sum + 0;
	end;

	if metS_sum > 2 then MeS = 1;
	else MeS = 0;
run;
proc freq data=b.total_final; tables metS_sum * MeS/list missing; run;
proc freq data=b.total_final; tables wc * tg * hdl * bp * glu * metS_sum * MeS/list missing; run;
proc freq data=b.total_final; tables MeS * group1/chisq; run;

proc freq data=b.total_final; where wc ^= 99; tables wc * group1/chisq; run;

proc freq data=b.total_final; where tg ^= 99; tables tg * group1/chisq; run;
proc univariate data=b.total_final; where tg ^= 99; class group1; var ds1_tg1; run;
proc freq data=b.total_final; where hdl ^= 99; tables hdl * group1/chisq; run;
proc univariate data=b.total_final; where hdl ^= 99; class group1; var ds1_hdl1; run;
proc freq data=b.total_final; where bp ^= 99; tables bp * group1/chisq; run;
proc univariate data=b.total_final; where bp ^= 99; class group1; var ds1_dbp1; run;
proc univariate data=b.total_final; where bp ^= 99; class group1; var ds1_sbp1; run;
proc freq data=b.total_final; where glu ^= 99; tables glu * group1/chisq; run;
proc univariate data=b.total_final; where glu ^= 99; class group1; var ds1_glu0_1; run;

proc univariate data=b.total_final; where cwaist ^= 99999; class group1; var cwaist; run;
proc anova data=b.total_final; where cwaist ^= 99999; class group1; model cwaist=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_tg1^= 99999; class group1; var ds1_tg1; run;
proc anova data=b.total_final; where ds1_tg1 ^= 99999; class group1; model ds1_tg1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_hdl1^= 99999; class group1; var ds1_hdl1; run;
proc anova data=b.total_final; where ds1_hdl1 ^= 99999; class group1; model ds1_hdl1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_sbp1^= 99999; class group1; var ds1_sbp1; run;
proc anova data=b.total_final; where ds1_sbp1 ^= 99999; class group1; model ds1_sbp1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_dbp1^= 99999; class group1; var ds1_dbp1; run;
proc anova data=b.total_final; where ds1_dbp1 ^= 99999; class group1; model ds1_dbp1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.total_final; where ds1_glu0_1^= 99999; class group1; var ds1_glu0_1; run;
proc anova data=b.total_final; where ds1_glu0_1 ^= 99999; class group1; model ds1_glu0_1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;

/****Chart : 전체 성별에 따라 흡연, 음주, 운동, 스트레스****/
/****(1) Smoke****/
proc freq data=b.total_final; where psmok^=99 and DS1_SEX1=1; tables psmok*group1/chisq; run;
proc freq data=b.total_final; where psmok^=99 and DS1_SEX1=2; tables psmok*group1/chisq; run;
/****(2) Drink****/
proc freq data=b.total_final; where pdrink^=99 and DS1_SEX1=1; tables pdrink*group1/chisq; run;
proc freq data=b.total_final; where pdrink^=99 and DS1_SEX1=2; tables pdrink*group1/chisq; run;
/****(3) Gexer****/
proc freq data=b.total_final; where gexer_wk2^=99 and DS1_SEX1=1; tables gexer_wk2*group1/chisq; run;
proc freq data=b.total_final; where gexer_wk2^=99 and DS1_SEX1=2; tables gexer_wk2*group1/chisq; run;
/****(4) Gbmi2****/
proc freq data=b.total_final; where gbmi2^=99999 and DS1_SEX1=1; tables gbmi2*group1/chisq; run;
proc freq data=b.total_final; where gbmi2^=99999 and DS1_SEX1=2; tables gbmi2*group1/chisq; run;
/****(5) pwi_1****/
proc freq data=b.total_final; where pwi_1^=99999 and DS1_SEX1=1; tables pwi_1*group1/chisq; run;
proc freq data=b.total_final; where pwi_1^=99999 and DS1_SEX1=2; tables pwi_1*group1/chisq; run;
/****(6) Totalkcal****/
proc freq data=b.total_final; where Totalkcal^=9999; tables Totalkcal*group1/chisq; run;
proc freq data=b.total_final; where Totalkcal^=9999 and DS1_SEX1=1; tables Totalkcal*group1/chisq; run;
proc freq data=b.total_final; where Totalkcal^=9999 and DS1_SEX1=2; tables Totalkcal*group1/chisq; run;
/****(7) MeS****/
proc freq data=b.total_final; where DS1_SEX1=1; tables MeS*group1/chisq; run;
proc freq data=b.total_final; where DS1_SEX1=2; tables MeS*group1/chisq; run;
/****(8) WC****/
proc freq data=b.total_final; where wc ^= 99 and DS1_SEX1=1; tables wc*group1/chisq; run;
proc freq data=b.total_final; where wc ^= 99 and DS1_SEX1=2; tables wc*group1/chisq; run;
/****(9) TG****/
proc freq data=b.total_final; where TG ^= 99 and DS1_SEX1=1; tables TG*group1/chisq; run;
proc freq data=b.total_final; where TG ^= 99 and DS1_SEX1=2; tables TG*group1/chisq; run;
/****(10) HDL****/
proc freq data=b.total_final; where HDL ^= 99 and DS1_SEX1=1; tables HDL*group1/chisq; run;
proc freq data=b.total_final; where HDL ^= 99 and DS1_SEX1=2; tables HDL*group1/chisq; run;
/****(11) BP****/
proc freq data=b.total_final; where BP ^= 99 and DS1_SEX1=1; tables BP*group1/chisq; run;
proc freq data=b.total_final; where BP ^= 99 and DS1_SEX1=2; tables BP*group1/chisq; run;
/****(12) GLU****/
proc freq data=b.total_final; where GLU ^= 99 and DS1_SEX1=1; tables GLU*group1/chisq; run;
proc freq data=b.total_final; where GLU ^= 99 and DS1_SEX1=2; tables GLU*group1/chisq; run;

/* Declaration of group12 variable to analyze nutrition*/
proc contents data=b.total_final; run;
data b.total_final; set b.total_final;
	if DS1_SEX1 = 1 and DS1_AGE < 30 then group12=1;
	else if DS1_SEX1 = 1 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=2;
	else if DS1_SEX1 = 1 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=3;
	else if DS1_SEX1 = 1 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=4;
	else if DS1_SEX1 = 1 and DS1_AGE >= 75 then group12=5;
	else if DS1_SEX1 = 2 and DS1_AGE < 30 then group12=6;
	else if DS1_SEX1 = 2 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=7;
	else if DS1_SEX1 = 2 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=8;
	else if DS1_SEX1 = 2 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=9;
	else group12=10; 
run;
proc freq data=b.total_final; tables group12; run;

/****영양 권장량 이상/미만 1: 미만, 2: 이상****/
/***(1)에너지***/
/* Error in Old Code (Age Range)*/
/*data b.com; set b.com;
	if SS02^=99999 then protein_percent= (SS02*4/SS01)*100;  else  protein_percent=99999;
    if SS01^=99999 and SS02^=99999 and SS03^=99999 then SS01_1= DS1_SS02*4+DS1_SS03*9+DS1_SS04* 4; else  SS01_1=99999; 
	if SS04^=99999 then sugar_percent= (SS04*4/SS01)*100; else  sugar_percent=99999; 
	if SS03^=99999 then fat_percent= (SS03*9/SS01)*100;  else  fat_percent=99999; 
    if SS02^=99999 then protein_percent= (SS02*4/SS01)*100;  else  protein_percent=99999;
    if SS01 in (.,99999) then energy=99999; 
 	else if DS1_SEX1=1 and DS1_AGE<30 and SS01<2600 then energy=1; else if DS1_SEX1=1 and 30=<DS1_AGE<49 and SS01<2400 then energy=1;
 	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS01<2200 then energy=1; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS01<2000 then energy=1; else if DS1_SEX1=1 and 75=<DS1_AGE and SS01<2000 then energy=1;
 	else if DS1_SEX1=2 and DS1_AGE<30 and SS01<2100 then energy=1; else if DS1_SEX1=2 and 30=<DS1_AGE<49 and SS01<1900 then energy=1;
 	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS01<1800 then energy=1; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS01<1600 then energy=1; else if DS1_SEX1=2 and 75=<DS1_AGE and SS01<1600 then energy=1;
 	else energy=2; run; */
data b.total_final; set total_final; /**김명관 선생님이 만들었던 기존 energy 변수 버리고 새로 정의 **/
	drop energy;
run;
data b.total_final; set b.total_final;  
	 array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (2600 2400 2200 2000 2000 2100 1900 1800 1600 1600);

     if SS01 in (.,99999) then energy=99999;
	 else if SS01 < reference[group12] then energy=1;
	 else energy=2;
	 drop t1 - t10;
run;
proc freq data=b.total_final; where energy^=99999; tables energy*group1/chisq; run;

/* energy 변수를 제외하고 김명관 선생님이 만들어 놓은 변수들을 활용함*/

/****Data Review : Nutrition****/
proc freq data=b.total_final; where energy^=99999; tables energy*group1/chisq; run;
proc freq data=b.total_final; where protein^=99999; tables protein*group1/chisq; run;
proc freq data=b.total_final; where fat^=99999; tables fat*group1/chisq; run;
proc freq data=b.total_final; where sugar^=99999; tables sugar*group1/chisq; run;
proc freq data=b.total_final; where fiber^=99999; tables fiber*group1/chisq; run;
proc freq data=b.total_final; where VitA^=99999; tables VitA*group1/chisq; run;
proc freq data=b.total_final; where VitB1^=99999; tables VitB1*group1/chisq; run;
proc freq data=b.total_final; where VitB2^=99999; tables VitB2*group1/chisq; run;
proc freq data=b.total_final; where Niacin^=99999; tables Niacin*group1/chisq; run;
proc freq data=b.total_final; where Folate^=99999; tables Folate*group1/chisq; run;
proc freq data=b.total_final; where VitB6^=99999; tables VitB6*group1/chisq; run;
proc freq data=b.total_final; where VitC^=99999; tables VitC*group1/chisq; run;
proc freq data=b.total_final; where VitE^=99999; tables VitE*group1/chisq; run;
proc freq data=b.total_final; where Cals^=99999; tables Cals*group1/chisq; run;
proc freq data=b.total_final; where pho^=99999; tables pho*group1/chisq; run;
proc freq data=b.total_final; where iron^=99999; tables iron*group1/chisq; run;
proc freq data=b.total_final; where Cal^=99999; tables Cal*group1/chisq; run;
proc freq data=b.total_final; where Zinc^=99999; tables Zinc*group1/chisq; run;
proc freq data=b.total_final; where Na^=99999; tables Na*group1/chisq; run;

/*Nutrtion Univariate*/
proc univariate data=b.total_final ; where SS01^=99999; class group1; var SS01; run;
proc univariate data=b.total_final ; where SS02^=99999; class group1; var SS02; run;
proc univariate data=b.total_final ; where protein^=99999; class group1; var protein_percent; run;
proc univariate data=b.total_final ; where SS03^=99999; class group1; var SS03; run;
proc univariate data=b.total_final ; where fat^=99999; class group1; var fat_percent; run;
proc univariate data=b.total_final ; where SS04^=99999; class group1; var SS04; run;
proc univariate data=b.total_final ; where sugar^=99999; class group1; var sugar_percent; run;
proc univariate data=b.total_final ; where SS21^=99999; class group1; var SS21; run;
proc univariate data=b.total_final ; where SS09^=99999; class group1; var SS09; run;
proc univariate data=b.total_final ; where SS11^=99999; class group1; var SS11; run;
proc univariate data=b.total_final ; where SS12^=99999; class group1; var SS12; run;
proc univariate data=b.total_final ; where SS13^=99999; class group1; var SS13; run;
proc univariate data=b.total_final ; where SS17^=99999; class group1; var SS17; run;
proc univariate data=b.total_final ; where SS16^=99999; class group1; var SS16; run;
proc univariate data=b.total_final ; where SS14^=99999; class group1; var SS14; run;
proc univariate data=b.total_final ; where SS23^=99999; class group1; var SS23; run;
proc univariate data=b.total_final ; where SS05^=99999; class group1; var SS05; run;
proc univariate data=b.total_final ; where SS06^=99999; class group1; var SS06; run;
proc univariate data=b.total_final ; where SS07^=99999; class group1; var SS07; run;
proc univariate data=b.total_final ; where SS08^=99999; class group1; var SS08; run;
proc univariate data=b.total_final ; where SS15^=99999; class group1; var SS15; run;
proc univariate data=b.total_final ; where SS10^=99999; class group1; var SS10; run;

/*****Nutrition ANOVA****/
proc anova data=b.total_final; where SS01^=99999; class group1; model SS01=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS02^=99999; class group1; model SS02=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where protein_percent^=99999; class group1; model protein_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS03^=99999; class group1; model SS03=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where fat_percent^=99999; class group1; model fat_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS04^=99999; class group1; model SS04=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where sugar_percent^=99999; class group1; model sugar_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS21^=99999; class group1; model SS21=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS09^=99999; class group1; model SS09=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS11^=99999; class group1; model SS11=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS12^=99999; class group1; model SS12=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS13^=99999; class group1; model SS13=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS17^=99999; class group1; model SS17=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS16^=99999; class group1; model SS16=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS14^=99999; class group1; model SS14=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS23^=99999; class group1; model SS23=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS05^=99999; class group1; model SS05=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS06^=99999; class group1; model SS06=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS07^=99999; class group1; model SS07=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS08^=99999; class group1; model SS08=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS15^=99999; class group1; model SS15=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.total_final; where SS10^=99999; class group1; model SS10=group1; MEANS group1 / DUNCAN ;run;quit;

/* Variable (Fat, Sugar) Declaration for Conditional Logistic Regression*/ 
data b.total_final; set b.total_final;    
	if fat < 2 then fat_2 = 0;
	else fat_2 = 1;
	if sugar < 2 then sugar_2 = 0;
	else sugar_2 = 1;
run;
proc freq data=b.total_final; tables fat_2*fat/list missing; run;
proc freq data=b.total_final; tables sugar_2*sugar/list missing; run;
proc univariate data=b.total_final; where SS03^=99999; class fat_2; var fat_percent; run;
proc univariate data=b.total_final; where SS04^=99999; class sugar_2; var sugar_percent; run;

/*******Data Reveiw by Cancer Type *******/
proc freq data=b.total_final; tables CANCER_TYPE*group1/list missing;run;

data b.total_final; set b.total_final;    /* cancer_type2 변수를 새로 생성, 암 생존자 집단이 아니거나(group1=1, 2) 암 생존자이나 암종 정보가 없는 경우(239명)를 모두 Missing으로 처리*/
	if CANCER_TYPE = . then cancer_type2 = 99999;
	else if CANCER_TYPE = 0 then cancer_type2 = 99999;
	else cancer_type2 = CANCER_TYPE;
run;
proc freq data=b.total_final; tables cancer_type2*group1/list missing;run;
proc freq data=b.total_final; tables cancer_type2/list missing;run;

proc freq data=b.total_final; where group1=0 and cancer_type2^=99999; tables cancer_type2*DS1_SEX1/chisq;run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and psmok^=99; tables cancer_type2*psmok/chisq;run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and pdrink^=99; tables cancer_type2*pdrink/chisq;run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and gexer_wk2^=99; tables cancer_type2*gexer_wk2/chisq;run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and gbmi2^=99999; tables cancer_type2*gbmi2/chisq;run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and PWI_1^=99999; tables cancer_type2*PWI_1/chisq;run;

proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and energy^=99999; tables cancer_type2*energy/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and protein^=99999; tables cancer_type2*protein/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and fat^=99999; tables cancer_type2*fat/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and sugar^=99999; tables cancer_type2*sugar/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and fiber^=99999; tables cancer_type2*fiber/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and VitA^=99999; tables cancer_type2*VitA/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and VitE^=99999; tables cancer_type2*VitE/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and VitC^=99999; tables cancer_type2*VitC/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and VitB1^=99999; tables cancer_type2*VitB1/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and VitB2^=99999; tables cancer_type2*VitB2/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and Niacin^=99999; tables cancer_type2*Niacin/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and VitB6^=99999; tables cancer_type2*VitB6/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and Folate^=99999; tables cancer_type2*Folate/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and Cals^=99999; tables cancer_type2*Cals/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and pho^=99999; tables cancer_type2*pho/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and Na^=99999; tables cancer_type2*Na/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and Cal^=99999; tables cancer_type2*Cal/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and iron^=99999; tables cancer_type2*iron/chisq; run;
proc freq data=b.total_final; where group1=0 and cancer_type2^=99999 and Zinc^=99999; tables cancer_type2*Zinc/chisq; run;


/*****Conditional Logistic Regression (Total)****/
/**************Smoke*************/
proc freq data=b.total_final; tables csmok/list missing; run; /*Missing of csmok : 139 people*/  
proc logistic data=b.total_final; where csmok not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc freq data=b.total_final; tables cdrink/list missing; run; /*Missing of cdrink : 130 people*/ 
proc logistic data=b.total_final; where cdrink not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Excercise**********/
proc freq data=b.total_final; tables gexer_wk1/list missing; run; /*Missing of gexer_wk1 : 562 people*/ 
proc logistic data=b.total_final; where gexer_wk1 not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc freq data=b.total_final; tables gbmi1/list missing; run; /*Missing of gbmi1 : 61 people*/ 
proc logistic data=b.total_final; where gbmi1 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc freq data=b.total_final; tables PWI_2/list missing; run; /*Missing of PWI_2 : 706 people*/ 
proc logistic data=b.total_final; where PWI_2 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********MeS**********/
proc freq data=b.total_final; tables MeS/list missing; run;
proc logistic data=b.total_final;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF='1') DS1_MENYN_1(PARAM=REF REF='2') 	 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********wc**********/
proc freq data=b.total_final; tables wc/list missing; run; /*Missing of wc : 163 people*/ 
proc logistic data=b.total_final; where wc not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********tg**********/
proc freq data=b.total_final; tables tg/list missing; run; /*Missing of tg : 31 people*/ 
proc logistic data=b.total_final; where tg not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********hdl**********/
proc freq data=b.total_final; tables hdl/list missing; run; /*Missing of hdl : 3 people*/ 
proc logistic data=b.total_final; where hdl not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********bp**********/
proc freq data=b.total_final; tables bp/list missing; run; /*Missing of bp : 177 people*/ 
proc logistic data=b.total_final; where bp not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********glu**********/
proc freq data=b.total_final; tables glu/list missing; run; /*Missing of tg : 326 people*/ 
proc logistic data=b.total_final; where glu not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc freq data=b.total_final; tables energy/list missing; run; /*Missing of energy : 258 people*/ 
proc logistic data=b.total_final; where energy not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables protein/list missing; run; /*Missing of protein : 258 people*/ 
proc logistic data=b.total_final; where protein not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables fat_2/list missing; run; /*Missing of fat_2 : 258 people*/ 
proc logistic data=b.total_final; where fat_2 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables sugar_2/list missing; run; /*Missing of sugar_2 : 258 people*/ 
proc logistic data=b.total_final; where sugar_2 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables fiber/list missing; run; /*Missing of fiber : 258 people*/ 
proc logistic data=b.total_final; where fiber not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables VitA/list missing; run; /*Missing of VitA : 258 people*/ 
proc logistic data=b.total_final; where VitA not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables VitB1/list missing; run; /*Missing of VitB1 : 258 people*/ 
proc logistic data=b.total_final; where VitB1 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables VitB2/list missing; run; /*Missing of VitB2 : 258 people*/ 
proc logistic data=b.total_final; where VitB2 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables Niacin/list missing; run; /*Missing of Niacin : 258 people*/ 
proc logistic data=b.total_final; where Niacin not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables Folate/list missing; run; /*Missing of Folate : 258 people*/ 
proc logistic data=b.total_final; where Folate not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables VitB6/list missing; run; /*Missing of VitB6 : 258 people*/ 
proc logistic data=b.total_final; where VitB6 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables VitC/list missing; run; /*Missing of VitC : 258 people*/
proc logistic data=b.total_final; where VitC not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables VitE/list missing; run; /*Missing of VitE : 258 people*/
proc logistic data=b.total_final; where VitE not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables Cals/list missing; run; /*Missing of Cals : 258 people*/
proc logistic data=b.total_final; where Cals not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables pho/list missing; run; /*Missing of pho : 258 people*/
proc logistic data=b.total_final; where pho not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables iron/list missing; run; /*Missing of iron : 258 people*/
proc logistic data=b.total_final; where iron not in (99999);  
	strata setnumber; 

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables Cal/list missing; run; /*Missing of Cal : 258 people*/
proc logistic data=b.total_final; where Cal not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables Zinc/list missing; run; /*Missing of Zinc : 258 people*/
proc logistic data=b.total_final; where Zinc not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc freq data=b.total_final; tables Na/list missing; run; /*Missing of Na : 258 people*/
proc logistic data=b.total_final; where Na not in (99999);   
	strata setnumber; 

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*****Conditional Logistic Regression (Male)****/
/**************Smoke*************/
proc logistic data=b.total_final; where csmok not in (99) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.total_final; where cdrink not in (99) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.total_final; where gexer_wk1 not in (99) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.total_final; where gbmi1 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.total_final; where PWI_2 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********MeS**********/
proc logistic data=b.total_final; where DS1_SEX1=1;
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********wc**********/
proc logistic data=b.total_final; where wc not in (99) and DS1_SEX1=1;
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc(PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********tg**********/
proc logistic data=b.total_final; where tg not in (99) and DS1_SEX1=1;
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********hdl**********/
proc logistic data=b.total_final; where hdl not in (99) and DS1_SEX1=1;
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********bp**********/
proc logistic data=b.total_final; where bp not in (99) and DS1_SEX1=1;
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********glu**********/
proc logistic data=b.total_final; where glu not in (99) and DS1_SEX1=1;
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.total_final; where energy not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where protein not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where fat_2 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where sugar_2 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where fiber not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitA not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitB1 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitB2 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Niacin not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Folate not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitB6 not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitC not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitE not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Cals not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where pho not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where iron not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Cal not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Zinc not in (99999) and DS1_SEX1=1;    
	strata setnumber;	

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Na not in (99999) and DS1_SEX1=1;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*****Conditional Logistic Regression (Female)****/
/**************Smoke*************/
proc logistic data=b.total_final; where csmok not in (99) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.total_final; where cdrink not in (99) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.total_final; where gexer_wk1 not in (99) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.total_final; where gbmi1 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.total_final; where PWI_2 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********MeS**********/
proc logistic data=b.total_final; where DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF='1') DS1_MENYN_1(PARAM=REF REF='2') 	 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********wc**********/
proc logistic data=b.total_final; where wc not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********tg**********/
proc logistic data=b.total_final; where tg not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********hdl**********/
proc logistic data=b.total_final; where hdl not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********bp**********/
proc logistic data=b.total_final; where bp not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********glu**********/
proc logistic data=b.total_final; where glu not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.total_final; where energy not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where protein not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where fat_2 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where sugar_2 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where fiber not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitA not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitB1 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitB2 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Niacin not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Folate not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitB6 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitC not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where VitE not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Cals not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where pho not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where iron not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Cal not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Zinc not in (99999) and DS1_SEX1=2;    
	strata setnumber;	

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.total_final; where Na not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;



/**************************************/
/******* 1 by 4 Frequency Matching******/ 
/**************************************/

/*****com Dataset  : 김명관 선생님이 만들었던 파일에서 새로 시작*****/
/****Group1(0, 1, 2) 확인****0 : 암 생존자 1: 질환x 일반 2: 질환0 일반**/
data b.com; set a.com_frequency; run;

proc contents data=b.com; run;
proc freq data=b.com; tables group1/list missing; run;

/*****나이*****/
/* if cage<50 then cage_2=1; else if cage<55 then cage_2=2;  else if cage<60 then cage_2=3; else if cage<65 then cage_2=4; else cage_2 =5; */
proc freq data=b.com; tables cage_2*group1/chisq; run;
/***나이(평균 및 표준편차)***/
proc univariate data=b.com ; class group1; var cage; run;
proc anova data=b.com; class group1; model cage=group1; MEANS group1 / DUNCAN ;run;

/****성별****/
proc freq data=b.com;  tables DS1_SEX1*group1/chisq; run;

/*DS1_MARRY_A_1; 미혼/별거/이혼/사별/기타 (1), 기혼/동거=결혼(2), */		
proc freq data=b.com; tables DS1_MARRY_A_1*group1/chisq; run;

/* 0=학교에 다니지 않았다, 1=초등학교 중퇴, 2=초등학교 졸업 또는 중학교 중퇴, 3=중학교 졸업 또는 고등학교 중퇴, 4=고등학교 졸업, 5=기술(전문)학교 졸업, 6=대학교 중퇴, 7=대학교 졸업, 8=대학원 이상 */			
/* if DS1_EDU in ('0','1','2','3') then DS1_EDU1=1; else if DS1_EDU in ('4','5','6') then DS1_EDU1=2; else if DS1_EDU in ('7', '8') then DS1_EDU1=3; else if DS1_EDU in ('99999') then DS1_EDU1=99;*/
proc freq data=b.com; tables DS1_EDU1*group1/chisq; run;		

/****수입****/
/* 1=50만원 미만, 2=50-100만원 미만, 3=100-150만원 미만, 4=150-200만원 미만, 5=200-300만원 미만, 6=300-400만원 미만, 7=400-600만원 미만, 8=600만원 이상 		
 if DS1_INCOME in ('1','2','3','4') then DS1_INCOME1=1; else if DS1_INCOME in ('5','6') then DS1_INCOME1=2; else if DS1_INCOME in ('7','8') then DS1_INCOME1=3; 
else if DS1_INCOME in ('66666','99999') then DS1_INCOME1=99;*/
proc freq data=b.com; tables DS1_INCOME1*group1/chisq; run;

/*DS1_JOB_1; 주부나 무직(1), 직업있음(2)*/		
proc freq data=b.com; tables DS1_JOB_1*group1/chisq; run;	

/*흡연 변수 정리-gastric cancer*/					
/*csmok: 현재흡연 (1), 과거흡연& 경험없음(0)*/					
/*psmok: 현재흡연 (2), 과거흡연 (1), 경험없음 (0)*/		
proc freq data=b.com; tables psmok*group1/chisq; run;

/****그룹 별 음주변수 정리****/
/*cdrink: 현재음주(1), 현재음주안함(0)*/				
/*pdrink: 현재음주 (2), 과거음주 (1), 경험없음 (0)*/		
proc freq data=b.com;tables pdrink*group1/chisq; run;

/****그룹 별 신체활동(운동)변수 정리****/
/*운동 변수 정리-gastric cancer*/					
/* gexer; '2'=한다(1), '1'=안한다(0)*/					
/*gexer_n; 1=주1-2회(1.5), 2=주3-4회(3.5), 3=주5-6회(5.5), 4=매일(7), DS_EXER가 아니요 (0), missing(99999) */
/*gexer_wk1: 주 150분 미만 (1), 주 150분 이상 (2)*/					
/*gexer_wk2: 운동안함(1), 주 150분 미만(2), 주 150분 이상(3)*/			
/*gexer_wk3: 운동안함(1), 운동함 (2)*/			
proc freq data=b.com; tables gexer_wk2*group1/chisq; run;

/***gbmi****/
/* if 0<gbmi<23 then gbmi2=1; else if 23<=gbmi<25 then gbmi2=2; else if 25<=gbmi<99 then gbmi2=3;else if gbmi=99999 then gbmi2=99999;*/		
proc freq data=b.com;  tables gbmi2*group1/chisq; run;

/****pwi 공식으로 총점 구하기***/
proc freq data=b.com; tables ds1_pwi1--ds1_pwi18; run;
data b.com; set b.com;
pwi = ds1_pwi1 + (3-ds1_pwi2) + (3-ds1_pwi3) + (3-ds1_pwi4) + ds1_pwi5 + ds1_pwi6 + (3-ds1_pwi7) + ds1_pwi8 + ds1_pwi9 + ds1_pwi10 + ds1_pwi11 + ds1_pwi12 + 
(3-ds1_pwi13) + ds1_pwi14 + (3-ds1_pwi15) + (3-ds1_pwi16) + ds1_pwi17 + ds1_pwi18; run;
data b.com; set b.com;
if  ds1_pwi1 in ('99999') or ds1_pwi2 in ('99999') or ds1_pwi3 in ('99999') or ds1_pwi4 in ('99999') or ds1_pwi5 in ('99999') or ds1_pwi6 in ('99999') or ds1_pwi7 in ('99999') or ds1_pwi8 in ('99999') or ds1_pwi9 in ('99999') or 
   ds1_pwi10 in ('99999') or ds1_pwi11 in ('99999') or ds1_pwi12 in ('99999') or ds1_pwi13 in ('99999') or ds1_pwi14 in ('99999') or ds1_pwi15 in ('99999') or ds1_pwi16 in ('99999') or  
   ds1_pwi17 in ('99999') or ds1_pwi18 in ('99999') then  pwi=99999;run;
data b.com  ; set b.com  ;	
    if -999999<pwi<0  then PWI1=99999; 			
    else if 99999<=pwi<=1000014  then PWI1=99999; 	run;
proc freq data=b.com; tables PWI1; RUN; 
data b.com; set b.com  ;  DS1_pwi_1= DS1_pwi+0; run; 
proc freq data=b.com; where DS1_pwi_1^=pwi; tables DS1_pwi*pwi/list missing; run;
proc freq data=b.com; where DS1_pwi_1^=pwi and DS1_pwi_1=99999 and pwi not in (.) ; tables ds1_pwi1--ds1_pwi18; run;

proc univariate data=b.com ; where PWI^=99999; class group1; var pwi; run;
proc anova data=b.com; where PWI^=99999; class group1; model PWI=group1; MEANS group1 / DUNCAN ;run;

/**pwi 범위지정**/
data b.com ; set b.com  ;	
if pwi=99999 then PWI_1 =99999; /***missing ***/
else if 0<=pwi<=8 then PWI_1 = 1; /***정상***/
else if 9<=pwi<=26 then PWI_1 = 2; /***약간 스트레스****/
else if 27<=pwi<99999 then PWI_1=3; /****매우 스트레스****/
run;
proc freq data=b.com; tables PWI_1; run;/***/

proc freq data=b.com; where group1=0;tables PWI_1; run;
proc freq data=b.com; where group1=1;tables PWI_1; run;
proc freq data=b.com; where group1=2;tables PWI_1; run;
proc freq data=b.com; tables PWI_1*group1/chisq; run;	

/**pwi_2 for conditional logistic regression**/
data b.com; set b.com;
	if PWI_1 = 99999 then PWI_2=99999;
	else if PWI_1 < 2 then PWI_2 = 1;    /*PWI_1 = 1*/
	else PWI_2 = 2; /*PWI_1 = 2, 3*/
run;
proc freq data=b.com; tables PWI_2*group1/list missing; run;

/***OC 사용여부****/
/*DS1_ORALCON: OC사용한적 없음(1), 있음(2, 과거사용+현재사용)*/ 	
proc freq data=b.com; tables ds1_oralcon/list missing; run;
data b.com; set b.com;
	if DS1_ORALCON in ('77777','99999') then DS1_ORALCON_1=99; else if DS1_ORALCON=1 then DS1_ORALCON_1=1; else DS1_ORALCON_1=2;
run;	
proc freq data=b.com; tables ds1_oralcon * ds1_oralcon_1/list missing; run;

/***생리 여부****/
proc freq data=b.com; tables ds1_menyn * ds1_menyn_a/list missing; run;
data b.com; set b.com;
	if DS1_MENYN_A in  ('66666','77777','99999') and DS1_MENYN in  ('66666','77777','99999') then DS1_MENYN_1=99;				
	else if  DS1_MENYN_A=1 or  DS1_MENYN=1 then DS1_MENYN_1=1; 
	else  DS1_MENYN_1=2;				
	/* DS1_MENYN: 폐경=생리 없음(1), 생리 있음(2)*/	
run;
proc freq data=b.com; tables ds1_menyn * ds1_menyn_a * ds1_menyn_1/list missing; run;

/***************************************Metabolic syndrome 변수 만들기 */
data b.com; set b.com; 
	cheight = DS1_HEIGHT+0;
	cweight = DS1_WEIGHT+0; 
	cwaist = DS1_WAIST+0;
	chip = DS1_HIP+0 ;
	ds1_tg1 = ds1_tg+0;
	ds1_hdl1 = ds1_hdl+0;
	ds1_dbp1 = ds1_dbp+0;
	ds1_sbp1 = ds1_sbp+0;
	ds1_glu0_1 = ds1_glu0+0;
run;
proc freq data=b.com; tables ds1_height * cheight/list missing; run;
proc freq data=b.com; tables ds1_weight * cweight/list missing; run;
proc freq data=b.com; tables ds1_waist * cwaist/list missing; run;
proc freq data=b.com; tables ds1_hip * chip/list missing; run;
proc univariate data=b.com; var ds1_tg1; run;
proc univariate data=b.com; var ds1_hdl1; run;
proc univariate data=b.com; var ds1_dbp1; run;
proc univariate data=b.com; var ds1_sbp1; run;
proc univariate data=b.com; var ds1_glu0_1; run;

/*MeS 만들기*/
data  b.com; set  b.com;																		
	if  cwaist=99999 then wc=99; 
	else if (cwaist >=90 and DS1_SEX1=1) or (cwaist >=80 and DS1_SEX1=2) then wc=1; 
	else wc=0; 																		
	/*wc=1이면 metabolic syndrom, wc=0 이면 metS 해당없음 */																	

	if DS1_TG1 =99999 then TG=99; 
	else if DS1_TG1 >=150 or DS1_LIPCUTY=1 or DS1_LIPCUTRPM=2 then TG=1;
	else TG=0; 																		
	/*TG=1 이면 metS criteria인 highTC*/	
	
	if DS1_HDL1 =99999 then HDL=99; 
	else if (DS1_HDL1 <40 and DS1_SEX1=1) or (DS1_HDL1 <50 and DS1_SEX1=2) then HDL=1;
	else HDL=0;																		
	/*HDL=1 이면 metS criteria*/

	if DS1_DBP1=99999 or DS1_SBP1=99999 then BP=99; 
	else if DS1_SBP1 >=130 or DS1_DBP1 >=85 or DS1_HTNCUTY=1 or DS1_HTNCUTRPM=2 or DS1_BP_MEDI=2 then BP=1;  
	else BP=0;																		
	/*BP=1 이면 metS criteria*/

	if DS1_GLU0_1 =99999 then GLU=99; 
	else IF DS1_GLU0_1>=100 or DS1_DMCUTY=1 or DS1_DMCUTY=2 or DS1_DMCUTY=4 or DS1_DMCUTY1=1 or DS1_DMCUTY1=2 or DS1_DMCUTY1=4 or	DS1_DMCUTRPM=2 or DS1_DMCUTRIN=2 then GLU=1;																																																		
	else GLU=0; 																		
	/*GLU=1 이면 metS criteria*/		
run;
data  b.com(drop = i); set  b.com;																		
	metS_sum = 0;
	do i = wc, tg, hdl, bp, glu;
		if i ^= 99 then metS_sum + i;
		else metS_sum + 0;
	end;

	if metS_sum > 2 then MeS = 1;
	else MeS = 0;
run;
proc freq data=b.com; tables metS_sum * MeS/list missing; run;
proc freq data=b.com; tables wc * tg * hdl * bp * glu * metS_sum * MeS/list missing; run;
proc freq data=b.com; tables MeS * group1/chisq; run;

proc freq data=b.com; where wc ^= 99; tables wc * group1/chisq; run;
proc univariate data=b.com; where wc ^= 99; class wc; var cwaist; run;
proc freq data=b.com; where tg ^= 99; tables tg * group1/chisq; run;
proc univariate data=b.com; where tg ^= 99; class tg; var ds1_tg1; run;
proc freq data=b.com; where hdl ^= 99; tables hdl * group1/chisq; run;
proc univariate data=b.com; where hdl ^= 99; class hdl; var ds1_hdl1; run;
proc freq data=b.com; where bp ^= 99; tables bp * group1/chisq; run;
proc univariate data=b.com; where bp ^= 99; class bp; var ds1_dbp1; run;
proc univariate data=b.com; where bp ^= 99; class bp; var ds1_sbp1; run;
proc freq data=b.com; where glu ^= 99; tables glu * group1/chisq; run;
proc univariate data=b.com; where glu ^= 99; class glu; var ds1_glu0_1; run;

proc univariate data=b.com; where cwaist ^= 99999; class group1; var cwaist; run;
proc anova data=b.com; where cwaist ^= 99999; class group1; model cwaist=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.com; where ds1_tg1^= 99999; class group1; var ds1_tg1; run;
proc anova data=b.com; where ds1_tg1 ^= 99999; class group1; model ds1_tg1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.com; where ds1_hdl1^= 99999; class group1; var ds1_hdl1; run;
proc anova data=b.com; where ds1_hdl1 ^= 99999; class group1; model ds1_hdl1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.com; where ds1_sbp1^= 99999; class group1; var ds1_sbp1; run;
proc anova data=b.com; where ds1_sbp1 ^= 99999; class group1; model ds1_sbp1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.com; where ds1_dbp1^= 99999; class group1; var ds1_dbp1; run;
proc anova data=b.com; where ds1_dbp1 ^= 99999; class group1; model ds1_dbp1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;
proc univariate data=b.com; where ds1_glu0_1^= 99999; class group1; var ds1_glu0_1; run;
proc anova data=b.com; where ds1_glu0_1 ^= 99999; class group1; model ds1_glu0_1=group1; MEANS group1 / DUNCAN ;run;/*Duncan Group1ing : 세 그룹 모두 A */ quit;

/****Chart : 전체 성별에 따라 흡연, 음주, 운동, 스트레스****/
/****(1) Smoke****/
proc freq data=b.com; where psmok^=99 and DS1_SEX1=1; tables psmok*group1/chisq; run;
proc freq data=b.com; where psmok^=99 and DS1_SEX1=2; tables psmok*group1/chisq; run;
/****(2) Drink****/
proc freq data=b.com; where pdrink^=99 and DS1_SEX1=1; tables pdrink*group1/chisq; run;
proc freq data=b.com; where pdrink^=99 and DS1_SEX1=2; tables pdrink*group1/chisq; run;
/****(3) Gexer****/
proc freq data=b.com; where gexer_wk2^=99 and DS1_SEX1=1; tables gexer_wk2*group1/chisq; run;
proc freq data=b.com; where gexer_wk2^=99 and DS1_SEX1=2; tables gexer_wk2*group1/chisq; run;
/****(4) Gbmi2****/
proc freq data=b.com; where gbmi2^=99999 and DS1_SEX1=1; tables gbmi2*group1/chisq; run;
proc freq data=b.com; where gbmi2^=99999 and DS1_SEX1=2; tables gbmi2*group1/chisq; run;
/****(5) pwi_1****/
proc freq data=b.com; where pwi_1^=99999 and DS1_SEX1=1; tables pwi_1*group1/chisq; run;
proc freq data=b.com; where pwi_1^=99999 and DS1_SEX1=2; tables pwi_1*group1/chisq; run;
/****(6) Totalkcal****/
proc freq data=b.com; tables Totalkcal*group1/chisq; run;
proc freq data=b.com; where Totalkcal^=9999 and DS1_SEX1=1; tables Totalkcal*group1/chisq; run;
proc freq data=b.com; where Totalkcal^=9999 and DS1_SEX1=2; tables Totalkcal*group1/chisq; run;
/****(7) MeS****/
proc freq data=b.com; where DS1_SEX1=1; tables MeS*group1/chisq; run;
proc freq data=b.com; where DS1_SEX1=2; tables MeS*group1/chisq; run;
/****(8) WC****/
proc freq data=b.com; where wc ^= 99 and DS1_SEX1=1; tables wc*group1/chisq; run;
proc freq data=b.com; where wc ^= 99 and DS1_SEX1=2; tables wc*group1/chisq; run;
/****(9) TG****/
proc freq data=b.com; where TG ^= 99 and DS1_SEX1=1; tables TG*group1/chisq; run;
proc freq data=b.com; where TG ^= 99 and DS1_SEX1=2; tables TG*group1/chisq; run;
/****(10) HDL****/
proc freq data=b.com; where HDL ^= 99 and DS1_SEX1=1; tables HDL*group1/chisq; run;
proc freq data=b.com; where HDL ^= 99 and DS1_SEX1=2; tables HDL*group1/chisq; run;
/****(11) BP****/
proc freq data=b.com; where BP ^= 99 and DS1_SEX1=1; tables BP*group1/chisq; run;
proc freq data=b.com; where BP ^= 99 and DS1_SEX1=2; tables BP*group1/chisq; run;
/****(12) GLU****/
proc freq data=b.com; where GLU ^= 99 and DS1_SEX1=1; tables GLU*group1/chisq; run;
proc freq data=b.com; where GLU ^= 99 and DS1_SEX1=2; tables GLU*group1/chisq; run;

/**** Protein, Fat, Sugar Percentage Variables****/
data b.com; set b.com;
	if SS01=99999 or SS02=99999 then SS02_Per=99999;    
	else SS02_Per=(SS02*4)/SS01; /*Proportion of Protein in Total Calorie*/

	if SS01=99999 or SS03=99999 then SS03_Per=99999;
	else 	SS03_Per=(SS03*9)/SS01;    /*Proportion of Fat in Total Calorie*/

	if SS01=99999 or SS04=99999 then SS04_Per=99999;
	else SS04_Per=(SS04*4)/SS01;    /*Proportion of Sugar in Total Calorie*/
run;

/* Declaration of group12 variable to analyze nutrition*/
proc contents data=b.com; run;
data b.com; set b.com;
	if DS1_SEX1 = 1 and DS1_AGE < 30 then group12=1;
	else if DS1_SEX1 = 1 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=2;
	else if DS1_SEX1 = 1 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=3;
	else if DS1_SEX1 = 1 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=4;
	else if DS1_SEX1 = 1 and DS1_AGE >= 75 then group12=5;
	else if DS1_SEX1 = 2 and DS1_AGE < 30 then group12=6;
	else if DS1_SEX1 = 2 and DS1_AGE >= 30 and DS1_AGE < 50 then group12=7;
	else if DS1_SEX1 = 2 and DS1_AGE >= 50 and DS1_AGE < 65 then group12=8;
	else if DS1_SEX1 = 2 and DS1_AGE >= 65 and DS1_AGE < 75 then group12=9;
	else group12=10; 
run;
proc freq data=b.com; tables group12; run;

/****영양 권장량 이상/미만 1: 미만, 2: 이상****/
/***(1)에너지***/
/* Error in Old Code (Age Range)*/
/*data b.com; set b.com;
	if SS02^=99999 then protein_percent= (SS02*4/SS01)*100;  else  protein_percent=99999;
    if SS01^=99999 and SS02^=99999 and SS03^=99999 then SS01_1= DS1_SS02*4+DS1_SS03*9+DS1_SS04* 4; else  SS01_1=99999; 
	if SS04^=99999 then sugar_percent= (SS04*4/SS01)*100; else  sugar_percent=99999; 
	if SS03^=99999 then fat_percent= (SS03*9/SS01)*100;  else  fat_percent=99999; 
    if SS02^=99999 then protein_percent= (SS02*4/SS01)*100;  else  protein_percent=99999;
    if SS01 in (.,99999) then energy=99999; 
 	else if DS1_SEX1=1 and DS1_AGE<30 and SS01<2600 then energy=1; else if DS1_SEX1=1 and 30=<DS1_AGE<49 and SS01<2400 then energy=1;
 	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS01<2200 then energy=1; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS01<2000 then energy=1; else if DS1_SEX1=1 and 75=<DS1_AGE and SS01<2000 then energy=1;
 	else if DS1_SEX1=2 and DS1_AGE<30 and SS01<2100 then energy=1; else if DS1_SEX1=2 and 30=<DS1_AGE<49 and SS01<1900 then energy=1;
 	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS01<1800 then energy=1; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS01<1600 then energy=1; else if DS1_SEX1=2 and 75=<DS1_AGE and SS01<1600 then energy=1;
 	else energy=2; run; */
data b.com; set b.com;  
	 array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (2600 2400 2200 2000 2000 2100 1900 1800 1600 1600);

     if SS01 in (.,99999) then energy=99999;
	 else if SS01 < reference[group12] then energy=1;
	 else energy=2;
	 drop t1 - t10;
run;
proc freq data=b.com; where energy^=99999; tables energy*group1/chisq; run;

/***(2) 단백질Protein***/
data b.com; set b.com;
    if SS02 in (.,99999) then Protein=99999; 
	else if DS1_SEX1=1 and DS1_AGE<30 and SS02<65 then Protein=0; else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS02<60 then Protein=0;
	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS02<60 then Protein=0; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS02<55 then Protein=0; else if DS1_SEX1=1 and 75=<DS1_AGE and SS02<55 then Protein=0;
	else if DS1_SEX1=2 and DS1_AGE<30 and SS02<55 then Protein=0; else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS02<50 then Protein=0;
	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS02<50 then Protein=0; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS02<45 then Protein=0; else if DS1_SEX1=2 and 75=<DS1_AGE and SS02<45then Protein=0;
	else Protein=1; 
run;
proc freq data=b.com; where Protein^=99999; tables Protein*group1/chisq; run;

/*(3) 지방*/
/*data b.thesis; set b.thesis; 
	if SS03 in (.,99999) then fat=99999;  
	if fat_percent=99999 then fat=99999; 
	if DS1_SEX1=2 and fat_percent<15 then fat=0; else if DS1_SEX1=2 and 15=<fat_percent=<30 then fat=1; else if DS1_SEX1=2 and 30<fat_percent then fat=2; RUN;*/

data b.com; set b.com;
	if SS03 = 99999 then fat = 99999;
	else if SS03_Per < 0.15 then fat = 0;
	else if SS03_Per <= 0.30 then fat= 1;
	else fat = 2;
run;
proc freq data=b.com; where fat^=99999; tables fat*group1/chisq; run;
proc univariate data=b.com; where SS03_Per^=99999; class fat; var SS03_Per; run;

/*(4) 탄수화물*/
data b.com; set b.com;
	if SS04 in (.,99999) or SS04_Per in (., 99999) then sugar=99999;  
	else if SS04_Per < 0.55 then sugar = 0;
	else if SS04_Per =< 0.65 then sugar = 1;
	else sugar = 2;
run;	
proc freq data=b.com; where sugar^=99999; tables sugar*group1/chisq; run;
data b.com; set b.com;
    if sugar in (., 99999) then sugar_2=99999;
	else if sugar < 2 then sugar_2=0;
	else sugar_2=1;

	if fat in (., 99999) then fat_2=99999;
	else if fat < 2 then fat_2=0;
	else fat_2=1;
run;
proc freq data=b.com; where sugar_2^=99999; tables sugar_2*group1/chisq;run;
proc freq data=b.com; where fat_2^=99999; tables fat_2*group1/chisq;run;
proc univariate data=b.com; where SS03_Per^=99999; class fat_2; var SS03_Per; run;
proc univariate data=b.com; where SS04_Per^=99999; class sugar_2; var SS04_Per; run;

/*(5) 식이섬유Fiber*/
data  b.com; set b.com;
	if SS21 in (.,99999) then fiber=99999; 
	else if DS1_SEX1=1 and DS1_AGE<30 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 30=<DS1_AGE<50 and SS21<25 then fiber=0;
 	else if DS1_SEX1=1 and 50=<DS1_AGE<65 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 65=<DS1_AGE<75 and SS21<25 then fiber=0; else if DS1_SEX1=1 and 75=<DS1_AGE and SS21<25 then fiber=0;
 	else if DS1_SEX1=2 and DS1_AGE<30 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 30=<DS1_AGE<50 and SS21<20 then fiber=0;
 	else if DS1_SEX1=2 and 50=<DS1_AGE<65 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 65=<DS1_AGE<75 and SS21<20 then fiber=0; else if DS1_SEX1=2 and 75=<DS1_AGE and SS21<20 then fiber=0;
 	else fiber=1; RUN;
proc freq data=b.com; where Fiber^=99999; tables Fiber*group1/chisq; run;

/*(6) 비타민A*/
data b.com; set b.com;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (800 750 750 700 700 650 650 600 550 550);

	if SS09 in (.,99999) then VitA=99999; 
	else if SS09 < reference[group12] then VitA=0;
	else VitA = 1;

	drop t1-t10;
run;
proc freq data=b.com; where VitA^=99999; tables VitA*group1/chisq; run;

/*(7) 티아민(비타민B1)*/
data b.com; set b.com;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.2 1.2 1.2 1.2 1.2 1.1 1.1 1.1 1.1 1.1);

     if SS11 in (.,99999) then VitB1=99999;
	 else if SS11 < reference[group12] then VitB1=0;
	 else VitB1=1;
	 drop t1 - t10;
run;
proc freq data=b.com; where VitB1^=99999; tables VitB1*group1/chisq; run;

/*(10) 리보플라빈(비타민B2)*/
data b.com; set b.com;
     array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.5 1.5 1.5 1.5 1.5 1.2 1.2 1.2 1.2 1.2);

     if SS12 in (.,99999) then VitB2=99999;
	 else if SS12 < reference[group12] then VitB2=0;
	 else VitB2=1;
	 drop t1 - t10;
run;
proc freq data=b.com; where VitB2^=99999; tables VitB2*group1/chisq; run;

/*(11) 니아신*/
 data b.com; set b.com;
 	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (16 16 16 16 16 14 14 14 14 14);

	if SS13 in (.,99999) then Niacin=99999; 
	else if SS13 < reference[group12] then Niacin=0;
	else Niacin=1;
	drop t1-t10;
run;
proc freq data=b.com; where Niacin^=99999; tables Niacin*group1/chisq; run;

/*(12) 엽산*/
data b.com; set b.com;
	if SS17 in (.,99999) then Folate=99999; 
	else if SS17 < 400 then Folate=0;
	else Folate=1;
run;
proc freq data=b.com; where Folate^=99999; tables Folate*group1/chisq; run;

/*(13) 비타민B6*/
data b.com; set b.com;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1.5 1.5 1.5 1.5 1.5 1.4 1.4 1.4 1.4 1.4);

	if SS16 in (.,99999) then VitB6=99999; 
	else if SS16 < reference[group12] then VitB6=0;
	else VitB6=1;
	drop t1-t10;
run;
proc freq data=b.com; where VitB6^=99999; tables VitB6*group1/chisq; run;

/*(14) 비타민C*/
data b.com; set b.com;
	if SS14 in (.,99999) then VitC=99999; 
	else if SS14 < 100 then VitC=0;
	else VitC=1;
run;
proc freq data=b.com; where VitC^=99999; tables VitC*group1/chisq; run;

/*(15) 비타민E*/
data b.com; set b.com;
    if SS23 in (.,99999) then VitE=99999; 
	else if SS23 < 12 then VitE=0;
	else VitE=1;
run; 
proc freq data=b.com; where VitE^=99999; tables VitE*group1/chisq; run;

/*(16) 칼슘*/
data b.com; set b.com;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (800 800 750 700 700 700 700 800 800 800);

	if SS05 in (.,99999) then cals=99999;
	else if SS05 < reference[group12] then cals=0;
	else cals=1;
	drop t1-t10;
run;
proc freq data=b.com; where cals^=99999; tables cals*group1/chisq; run;

/*(17) 인*/
data b.com; set b.com;
	if SS06 in (.,99999) then pho=99999;
	else if SS06 < 700 then pho=0;
	else pho=1;
run; 
proc freq data=b.com; where pho^=99999; tables pho*group1/chisq; run;

/*(18) 철*/
data b.com; set b.com;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (10 10 9 9 9 14 14 8 8 7);

	if SS07 in (.,99999) then iron=99999;
	else if SS07 < reference[group12] then iron=0;
	else iron=1;
	drop t1-t10;
run; 
proc freq data=b.com; where iron^=99999; tables iron*group1/chisq; run;

/*(19) 칼륨*/
data b.com; set b.com;
	if SS08 in (.,99999) then Cal=99999;
	else if SS08 < 3500 then Cal=0;
	else Cal=1;
run;
proc freq data=b.com; where Cal^=99999; tables Cal*group1/chisq; run;

/*(20) 아연*/
data b.com; set b.com;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (10 10 9 9 9 8 8 7 7 7);

    if SS15 in (.,99999) then Zinc=99999; 
	else if SS15 < reference[group12] then Zinc=0;
	else Zinc=1;
	drop t1-t10;
run;
proc freq data=b.com; where Zinc^=99999; tables Zinc*group1/chisq; run;

/*(21) 나트륨과 염소*/
data b.com; set b.com;
	array reference{10} t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 (1500 1500 1500 1300 1100 1500 1500 1500 1300 1100);

	if SS10 in (.,99999) then Na=99999; 
	else if SS10 < reference[group12] then Na=0;
	else Na=1;
	drop t1-t10;
run;
proc freq data=b.com; where Na^=99999; tables Na*group1/chisq; run;

/*Nutrtion Univariate*/
proc univariate data=b.com ; where SS01^=99999; class group1; var SS01; run;
proc univariate data=b.com ; where SS02^=99999; class group1; var SS02; run;
proc univariate data=b.com ; where protein^=99999; class group1; var protein_percent; run;
proc univariate data=b.com ; where SS03^=99999; class group1; var SS03; run;
proc univariate data=b.com ; where fat^=99999; class group1; var fat_percent; run;
proc univariate data=b.com ; where SS04^=99999; class group1; var SS04; run;
proc univariate data=b.com ; where sugar^=99999; class group1; var sugar_percent; run;
proc univariate data=b.com ; where SS21^=99999; class group1; var SS21; run;
proc univariate data=b.com ; where SS09^=99999; class group1; var SS09; run;
proc univariate data=b.com ; where SS11^=99999; class group1; var SS11; run;
proc univariate data=b.com ; where SS12^=99999; class group1; var SS12; run;
proc univariate data=b.com ; where SS13^=99999; class group1; var SS13; run;
proc univariate data=b.com ; where SS17^=99999; class group1; var SS17; run;
proc univariate data=b.com ; where SS16^=99999; class group1; var SS16; run;
proc univariate data=b.com ; where SS14^=99999; class group1; var SS14; run;
proc univariate data=b.com ; where SS23^=99999; class group1; var SS23; run;
proc univariate data=b.com ; where SS05^=99999; class group1; var SS05; run;
proc univariate data=b.com ; where SS06^=99999; class group1; var SS06; run;
proc univariate data=b.com ; where SS07^=99999; class group1; var SS07; run;
proc univariate data=b.com ; where SS08^=99999; class group1; var SS08; run;
proc univariate data=b.com ; where SS15^=99999; class group1; var SS15; run;
proc univariate data=b.com ; where SS10^=99999; class group1; var SS10; run;

/*****Nutrition ANOVA****/
proc anova data=b.com; where SS01^=99999; class group1; model SS01=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS02^=99999; class group1; model SS02=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where protein_percent^=99999; class group1; model protein_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS03^=99999; class group1; model SS03=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where fat_percent^=99999; class group1; model fat_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS04^=99999; class group1; model SS04=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where sugar_percent^=99999; class group1; model sugar_percent=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS21^=99999; class group1; model SS21=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS09^=99999; class group1; model SS09=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS11^=99999; class group1; model SS11=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS12^=99999; class group1; model SS12=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS13^=99999; class group1; model SS13=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS17^=99999; class group1; model SS17=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS16^=99999; class group1; model SS16=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS14^=99999; class group1; model SS14=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS23^=99999; class group1; model SS23=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS05^=99999; class group1; model SS05=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS06^=99999; class group1; model SS06=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS07^=99999; class group1; model SS07=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS08^=99999; class group1; model SS08=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS15^=99999; class group1; model SS15=group1; MEANS group1 / DUNCAN ;run;quit;
proc anova data=b.com; where SS10^=99999; class group1; model SS10=group1; MEANS group1 / DUNCAN ;run;quit;


/*******Data Reveiw by Cancer Type *******/
proc freq data=b.com; tables CANCER_TYPE*group1/list missing;run;

data b.com; set b.com;    /* cancer_type2 변수를 새로 생성, 암 생존자 집단이 아니거나(group1=1, 2) 암 생존자이나 암종 정보가 없는 경우(239명)를 모두 Missing으로 처리*/
	if CANCER_TYPE in (., 0)  then cancer_type2 = 99999;
	else cancer_type2 = CANCER_TYPE;
run;
proc freq data=b.com; tables cancer_type2/list missing;run;;
proc freq data=b.com; tables CANCER_TYPE*cancer_type2/list missing; run;
proc freq data=b.com; tables cancer_type2*group1/list missing;run;;

proc freq data=b.com; where cancer_type2^=99999; tables cancer_type2*DS1_SEX1/chisq;run;
proc freq data=b.com; where cancer_type2^=99999 and psmok^=99; tables cancer_type2*psmok/chisq;run;
proc freq data=b.com; where cancer_type2^=99999 and pdrink^=99; tables cancer_type2*pdrink/chisq;run;
proc freq data=b.com; where cancer_type2^=99999 and gexer_wk2^=99; tables cancer_type2*gexer_wk2/chisq;run;
proc freq data=b.com; where cancer_type2^=99999 and gbmi2^=99999; tables cancer_type2*gbmi2/chisq;run;
proc freq data=b.com; where cancer_type2^=99999 and PWI_1^=99999; tables cancer_type2*PWI_1/chisq;run;

proc freq data=b.com; where cancer_type2^=99999 and energy^=99999; tables cancer_type2*energy/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and protein^=99999; tables cancer_type2*protein/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and fat^=99999; tables cancer_type2*fat/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and sugar^=99999; tables cancer_type2*sugar/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and fiber^=99999; tables cancer_type2*fiber/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and VitA^=99999; tables cancer_type2*VitA/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and VitE^=99999; tables cancer_type2*VitE/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and VitC^=99999; tables cancer_type2*VitC/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and VitB1^=99999; tables cancer_type2*VitB1/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and VitB2^=99999; tables cancer_type2*VitB2/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and Niacin^=99999; tables cancer_type2*Niacin/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and VitB6^=99999; tables cancer_type2*VitB6/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and Folate^=99999; tables cancer_type2*Folate/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and Cals^=99999; tables cancer_type2*Cals/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and pho^=99999; tables cancer_type2*pho/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and Na^=99999; tables cancer_type2*Na/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and Cal^=99999; tables cancer_type2*Cal/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and iron^=99999; tables cancer_type2*iron/chisq; run;
proc freq data=b.com; where cancer_type2^=99999 and Zinc^=99999; tables cancer_type2*Zinc/chisq; run;


/*****Conditional Logistic Regression (Total)****/
/**************Smoke*************/
proc freq data=b.com; tables csmok/list missing; run; /*Missing of csmok : 479 people*/  
proc logistic data=b.com; where csmok not in (99);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc freq data=b.com; tables cdrink/list missing; run; /*Missing of cdrink : 438 people*/ 
proc logistic data=b.com; where cdrink not in (99);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc freq data=b.com; tables gexer_wk1/list missing; run; /*Missing of gexer_wk1 : 1,886 people*/ 
proc logistic data=b.com; where gexer_wk1 not in (99);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc freq data=b.com; tables gbmi1/list missing; run; /*Missing of gbmi1 : 240 people*/ 
proc logistic data=b.com; where gbmi1 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc freq data=b.com; tables PWI_2/list missing; run; /*Missing of PWI_2 : 2,259 people*/ 
proc logistic data=b.com; where PWI_2 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********MeS**********/
proc freq data=b.com; tables MeS/list missing; run;
proc logistic data=b.com;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS (PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF='1') DS1_MENYN_1(PARAM=REF REF='2')	 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********wc**********/
proc freq data=b.com; tables wc/list missing; run; /*Missing of wc : 685 people*/
proc logistic data=b.com; where wc not in (99);
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********tg**********/
proc freq data=b.com; tables tg/list missing; run; /*Missing of tg : 96 people*/
proc logistic data=b.com; where tg not in (99);
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********hdl**********/
proc freq data=b.com; tables hdl/list missing; run; /*Missing of tg : 18 people*/
proc logistic data=b.com; where hdl not in (99);
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********bp**********/
proc freq data=b.com; tables bp/list missing; run; /*Missing of bp : 634 people*/
proc logistic data=b.com; where bp not in (99);
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********glu**********/
proc freq data=b.com; tables glu/list missing; run; /*Missing of bp : 1,272 people*/
proc logistic data=b.com; where glu not in (99);
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;


/*(1)*Energy 1: 미만 2: 초과****/
proc freq data=b.com; tables energy/list missing; run; /*Missing of energy : 864 people*/ 
proc logistic data=b.com; where energy not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc freq data=b.com; tables protein/list missing; run; /*Missing of protein : 864 people*/ 
proc logistic data=b.com; where protein not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc freq data=b.com; tables fat_2/list missing; run; /*Missing of fat_2 : 864 people*/ 
proc logistic data=b.com; where fat_2 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc freq data=b.com; tables sugar_2/list missing; run; /*Missing of sugar_2 : 864 people*/ 
proc logistic data=b.com; where sugar_2 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc freq data=b.com; tables fiber/list missing; run; /*Missing of fiber : 864 people*/ 
proc logistic data=b.com; where fiber not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc freq data=b.com; tables VitA/list missing; run; /*Missing of VitA : 864 people*/ 
proc logistic data=b.com; where VitA not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc freq data=b.com; tables VitB1/list missing; run; /*Missing of VitB1 : 864 people*/ 
proc logistic data=b.com; where VitB1 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc freq data=b.com; tables VitB2/list missing; run; /*Missing of VitB2 : 864 people*/ 
proc logistic data=b.com; where VitB2 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc freq data=b.com; tables Niacin/list missing; run; /*Missing of Niacin : 864 people*/ 
proc logistic data=b.com; where Niacin not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc freq data=b.com; tables Folate/list missing; run; /*Missing of Folate : 864 people*/ 
proc logistic data=b.com; where Folate not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc freq data=b.com; tables VitB6/list missing; run; /*Missing of VitB6 : 864 people*/ 
proc logistic data=b.com; where VitB6 not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc freq data=b.com; tables VitC/list missing; run; /*Missing of VitC : 864 people*/
proc logistic data=b.com; where VitC not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc freq data=b.com; tables VitE/list missing; run; /*Missing of VitE : 864 people*/
proc logistic data=b.com; where VitE not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc freq data=b.com; tables Cals/list missing; run; /*Missing of Cals : 864 people*/
proc logistic data=b.com; where Cals not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc freq data=b.com; tables pho/list missing; run; /*Missing of pho : 864 people*/
proc logistic data=b.com; where pho not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc freq data=b.com; tables iron/list missing; run; /*Missing of iron : 864 people*/
proc logistic data=b.com; where iron not in (99999);  
	strata matching; 

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc freq data=b.com; tables Cal/list missing; run; /*Missing of Cal : 864 people*/
proc logistic data=b.com; where Cal not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc freq data=b.com; tables Zinc/list missing; run; /*Missing of Zinc : 864 people*/
proc logistic data=b.com; where Zinc not in (99999);    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc freq data=b.com; tables Na/list missing; run; /*Missing of Na : 864 people*/
proc logistic data=b.com; where Na not in (99999);   
	strata matching; 

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*****Conditional Logistic Regression (Male)****/
/**************Smoke*************/
proc logistic data=b.com; where csmok not in (99) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.com; where cdrink not in (99) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Excercise**********/
proc logistic data=b.com; where gexer_wk1 not in (99) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.com; where gbmi1 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.com; where PWI_2 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********MeS**********/
proc logistic data=b.com; where DS1_SEX1=1;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********wc**********/
proc logistic data=b.com; where wc not in (99) and DS1_SEX1=1;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********tg**********/
proc logistic data=b.com; where tg not in (99) and DS1_SEX1=1;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********hdl**********/
proc logistic data=b.com; where hdl not in (99) and DS1_SEX1=1;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********bp**********/
proc logistic data=b.com; where bp not in (99) and DS1_SEX1=1;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********glu**********/
proc logistic data=b.com; where glu not in (99) and DS1_SEX1=1;   
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.com; where energy not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.com; where protein not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.com; where fat_2 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.com; where sugar_2 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.com; where fiber not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitA not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitB1 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitB2 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Niacin not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Folate not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitB6 not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitC not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitE not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Cals not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.com; where pho not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.com; where iron not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Cal not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Zinc not in (99999) and DS1_SEX1=1;    
	strata matching;	

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Na not in (99999) and DS1_SEX1=1;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*****Conditional Logistic Regression (Female)****/
/**************Smoke*************/
proc logistic data=b.com; where csmok not in (99) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model csmok (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.com; where cdrink not in (99) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

	model cdrink (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Excercise**********/
proc logistic data=b.com; where gexer_wk1 not in (99) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gexer_wk1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.com; where gbmi1 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model gbmi1 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.com; where PWI_2 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model PWI_2 (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********MeS**********/
proc logistic data=b.com; where DS1_SEX1=2;
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS (PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF='1') DS1_MENYN_1(PARAM=REF REF='2')	 			
              group1 (PARAM=REF REF='1');

    model MeS (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********wc**********/
proc logistic data=b.com; where wc not in (99) and DS1_SEX1=2;
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')	 			
              group1 (PARAM=REF REF='1');

    model wc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********tg**********/
proc logistic data=b.com; where tg not in (99) and DS1_SEX1=2;
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')	 			
              group1 (PARAM=REF REF='1');

    model tg (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********hdl**********/
proc logistic data=b.com; where hdl not in (99) and DS1_SEX1=2;
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')	 			
              group1 (PARAM=REF REF='1');

    model hdl (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********bp**********/
proc logistic data=b.com; where bp not in (99) and DS1_SEX1=2;
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')	 			
              group1 (PARAM=REF REF='1');

    model bp (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/***********glu**********/
proc logistic data=b.com; where glu not in (99) and DS1_SEX1=2;
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')	 			
              group1 (PARAM=REF REF='1');

    model glu (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/*(1)*Energy 1: 미만 2: 초과****/
proc logistic data=b.com; where energy not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model energy (ref='1') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 DS1_SRH_1 DS1_FCA_1; 

run;

/*(2)*Protein 0: 미만 1: 초과 ****/
proc logistic data=b.com; where protein not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model protein (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(3)*Fat_2 0: 미만 1: 초과 ****/
proc logistic data=b.com; where fat_2 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fat_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(4)*Sugar_2 0: 미만 1: 초과 ****/
proc logistic data=b.com; where sugar_2 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model sugar_2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(5)*Fiber 0: 미만 1: 초과 ****/
proc logistic data=b.com; where fiber not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model fiber (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(6)*VitA 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitA not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitA (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(7)*VitB1 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitB1 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB1 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(8)*VitB2 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitB2 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB2 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(9)*Niacin 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Niacin not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Niacin (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(10)*Folate 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Folate not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Folate (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(11)*VitB6 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitB6 not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitB6 (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(12)*VitC 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitC not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitC (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(13)*VitE 0: 미만 1: 초과 ****/
proc logistic data=b.com; where VitE not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model VitE (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(14)*Cals 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Cals not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cals (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(15)*pho 0: 미만 1: 초과 ****/
proc logistic data=b.com; where pho not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model pho (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(16)*iron 0: 미만 1: 초과 ****/
proc logistic data=b.com; where iron not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model iron (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(17)*Cal 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Cal not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Cal (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(18)*Zinc 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Zinc not in (99999) and DS1_SEX1=2;    
	strata matching;	

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Zinc (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/*(19)*Na 0: 미만 1: 초과 ****/
proc logistic data=b.com; where Na not in (99999) and DS1_SEX1=2;    
	strata matching;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              group1 (PARAM=REF REF='1');

    model Na (ref='0') = group1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;


/********Analysis by Cancer Type*********/

/*****************************/
/********Total Dataset*********/
/*****************************/
data b.thesis; set b.thesis;
	if ga_c = 1 and total_ca = 0 then ga_c_new = 1;
	else ga_c_new = 0;

	if co_c = 1 and total_ca = 0 then co_c_new = 1;
	else co_c_new = 0;

	if br_c = 1 and total_ca = 0 then br_c_new = 1;
	else br_c_new = 0;

	if ce_c = 1 and total_ca = 0 then ce_c_new = 1;
	else ce_c_new = 0;

	if thy_c = 1 and total_ca = 0 then thy_c_new = 1;
	else thy_c_new = 0;
run;
proc freq data=b.thesis; tables ga_c_new/list missing; run; /*0: 172,625, 1: 732*/
proc freq data=b.thesis; tables co_c_new/list missing; run; /*0: 172,978, 1: 379*/
proc freq data=b.thesis; tables ga_c_new * DS1_SEX1/list missing; run; 
proc freq data=b.thesis; tables co_c_new * DS1_SEX1/list missing; run; 
proc freq data=b.thesis; where DS1_SEX1 = 2; tables br_c_new/list missing; run; /*0: 113,190, 1: 873*/
proc freq data=b.thesis; where DS1_SEX1 = 2; tables ce_c_new/list missing; run; /*0: 113,454, 1: 609*/
proc freq data=b.thesis; where DS1_SEX1 = 2; tables thy_c_new/list missing; run; /*0: 113,244, 1: 819*/

/********Chart*********/
/********GA_C*********/
proc freq data=b.thesis; where psmok ^= 99; tables psmok * ga_c_new/chisq; run;
proc freq data=b.thesis; where pdrink ^= 99; tables pdrink * ga_c_new/chisq; run;
proc freq data=b.thesis; where gexer_wk2 ^= 99; tables gexer_wk2 * ga_c_new/chisq; run;
proc freq data=b.thesis; where gbmi2 ^= 99999; tables gbmi2 * ga_c_new/chisq; run;
proc freq data=b.thesis; where PWI_1 ^= 99999; tables PWI_1 * ga_c_new/chisq; run;
proc freq data=b.thesis; where MeS ^= 99999; tables MeS * ga_c_new/chisq; run;

/********CO_C*********/
proc freq data=b.thesis; where psmok ^= 99; tables psmok * co_c_new/chisq; run;
proc freq data=b.thesis; where pdrink ^= 99; tables pdrink * co_c_new/chisq; run;
proc freq data=b.thesis; where gexer_wk2 ^= 99; tables gexer_wk2 * co_c_new/chisq; run;
proc freq data=b.thesis; where gbmi2 ^= 99999; tables gbmi2 * co_c_new/chisq; run;
proc freq data=b.thesis; where PWI_1 ^= 99999; tables PWI_1 * co_c_new/chisq; run;
proc freq data=b.thesis; where MeS ^= 99999; tables MeS * co_c_new/chisq; run;

/********BR_C*********/
proc freq data=b.thesis; where psmok ^= 99 and DS1_SEX1 = 2; tables psmok * br_c_new/chisq; run;
proc freq data=b.thesis; where pdrink ^= 99 and DS1_SEX1 = 2;; tables pdrink * br_c_new/chisq; run;
proc freq data=b.thesis; where gexer_wk2 ^= 99 and DS1_SEX1 = 2; tables gexer_wk2 * br_c_new/chisq; run;
proc freq data=b.thesis; where gbmi2 ^= 99999 and DS1_SEX1 = 2; tables gbmi2 * br_c_new/chisq; run;
proc freq data=b.thesis; where PWI_1 ^= 99999 and DS1_SEX1 = 2; tables PWI_1 * br_c_new/chisq; run;
proc freq data=b.thesis; where MeS ^= 99999 and DS1_SEX1 = 2; tables MeS * br_c_new/chisq; run;

/********CE_C*********/
proc freq data=b.thesis; where psmok ^= 99 and DS1_SEX1 = 2; tables psmok * ce_c_new/chisq; run;
proc freq data=b.thesis; where pdrink ^= 99 and DS1_SEX1 = 2;; tables pdrink * ce_c_new/chisq; run;
proc freq data=b.thesis; where gexer_wk2 ^= 99 and DS1_SEX1 = 2; tables gexer_wk2 * ce_c_new/chisq; run;
proc freq data=b.thesis; where gbmi2 ^= 99999 and DS1_SEX1 = 2; tables gbmi2 * ce_c_new/chisq; run;
proc freq data=b.thesis; where PWI_1 ^= 99999 and DS1_SEX1 = 2; tables PWI_1 * ce_c_new/chisq; run;
proc freq data=b.thesis; where MeS ^= 99999 and DS1_SEX1 = 2; tables MeS * ce_c_new/chisq; run;

/********THY_C*********/
proc freq data=b.thesis; where psmok ^= 99 and DS1_SEX1 = 2; tables psmok * thy_c_new/chisq; run;
proc freq data=b.thesis; where pdrink ^= 99 and DS1_SEX1 = 2;; tables pdrink * thy_c_new/chisq; run;
proc freq data=b.thesis; where gexer_wk2 ^= 99 and DS1_SEX1 = 2; tables gexer_wk2 * thy_c_new/chisq; run;
proc freq data=b.thesis; where gbmi2 ^= 99999 and DS1_SEX1 = 2; tables gbmi2 * thy_c_new/chisq; run;
proc freq data=b.thesis; where PWI_1 ^= 99999 and DS1_SEX1 = 2; tables PWI_1 * thy_c_new/chisq; run;
proc freq data=b.thesis; where MeS ^= 99999 and DS1_SEX1 = 2; tables MeS * thy_c_new/chisq; run;


/********Logistic Regression (Cancer Type)*********/
/********************Smoke**********************/
proc logistic data=b.thesis; where csmok not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where csmok not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1 = 2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1 = 2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where csmok not in (99) and DS1_SEX1 = 2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.thesis; where cdrink not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.thesis; where cdrink not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1 = 2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1 = 2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.thesis; where cdrink not in (99) and DS1_SEX1 = 2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.thesis; where gexer_wk1 not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gexer_wk1 not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gexer_wk1 not in (99) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.thesis; where gbmi1 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gbmi1 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where gbmi1 not in (99999) and DS1_SEX1=2;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.thesis; where PWI_2 not in (99999);	   

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where PWI_2 not in (99999);	   

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=2;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=2;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where PWI_2 not in (99999) and DS1_SEX1=2;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********MeS**********/
proc logistic data=b.thesis;     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              ga_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.thesis;     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              co_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.thesis; where DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              br_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.thesis; where DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              ce_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.thesis; where DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              thy_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********wc**********/
proc logistic data=b.thesis; where wc not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model wc (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where wc not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model wc (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model wc (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model wc (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where wc not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model wc (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********tg**********/
proc logistic data=b.thesis; where tg not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model tg (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where tg not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model tg (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model tg (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model tg (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where tg not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model tg (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********hdl**********/
proc logistic data=b.thesis; where hdl not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where hdl not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where hdl not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********bp**********/
proc logistic data=b.thesis; where bp not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model bp (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where bp not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model bp (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model bp (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model bp (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where bp not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model bp (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********glu**********/
proc logistic data=b.thesis; where glu not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model glu (ref='0') = ga_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where glu not in (99);     

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model glu (ref='0') = co_c_new cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model glu (ref='0') = br_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model glu (ref='0') = ce_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.thesis; where glu not in (99) and DS1_SEX1=2;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model glu (ref='0') = thy_c_new cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;


/*****************************/
/********1by1 Dataset*********/
/*****************************/
data b.total_final; set b.total_final;
	if ga_c = 1 and total_ca = 0 then ga_c_new = 1;
	else ga_c_new = 0;

	if co_c = 1 and total_ca = 0 then co_c_new = 1;
	else co_c_new = 0;

	if br_c = 1 and total_ca = 0 then br_c_new = 1;
	else br_c_new = 0;

	if ce_c = 1 and total_ca = 0 then ce_c_new = 1;
	else ce_c_new = 0;

	if thy_c = 1 and total_ca = 0 then thy_c_new = 1;
	else thy_c_new = 0;
run;
proc freq data=b.total_final; tables ga_c_new/list missing; run; /*0: 172,625, 1: 731*/
proc freq data=b.total_final; tables co_c_new/list missing; run; /*0: 172,978, 1: 378*/
proc freq data=b.total_final; tables ga_c_new * DS1_SEX1/list missing; run; 
proc freq data=b.total_final; tables co_c_new * DS1_SEX1/list missing; run; 
proc freq data=b.total_final; where DS1_SEX1 = 2; tables br_c_new/list missing; run; /*0: 113,190, 1: 873*/
proc freq data=b.total_final; where DS1_SEX1 = 2; tables ce_c_new/list missing; run; /*0: 113,454, 1: 609*/
proc freq data=b.total_final; where DS1_SEX1 = 2; tables thy_c_new/list missing; run; /*0: 113,244, 1: 819*/

/********Chart*********/
/********GA_C*********/
proc freq data=b.total_final; where psmok ^= 99; tables psmok * ga_c_new/chisq; run;
proc freq data=b.total_final; where pdrink ^= 99; tables pdrink * ga_c_new/chisq; run;
proc freq data=b.total_final; where gexer_wk2 ^= 99; tables gexer_wk2 * ga_c_new/chisq; run;
proc freq data=b.total_final; where gbmi2 ^= 99999; tables gbmi2 * ga_c_new/chisq; run;
proc freq data=b.total_final; where PWI_1 ^= 99999; tables PWI_1 * ga_c_new/chisq; run;
proc freq data=b.total_final; where MeS ^= 99999; tables MeS * ga_c_new/chisq; run;

/********CO_C*********/
proc freq data=b.total_final; where psmok ^= 99; tables psmok * co_c_new/chisq; run;
proc freq data=b.total_final; where pdrink ^= 99; tables pdrink * co_c_new/chisq; run;
proc freq data=b.total_final; where gexer_wk2 ^= 99; tables gexer_wk2 * co_c_new/chisq; run;
proc freq data=b.total_final; where gbmi2 ^= 99999; tables gbmi2 * co_c_new/chisq; run;
proc freq data=b.total_final; where PWI_1 ^= 99999; tables PWI_1 * co_c_new/chisq; run;
proc freq data=b.total_final; where MeS ^= 99999; tables MeS * co_c_new/chisq; run;

/********BR_C*********/
proc freq data=b.total_final; where psmok ^= 99 and DS1_SEX1 = 2; tables psmok * br_c_new/chisq; run;
proc freq data=b.total_final; where pdrink ^= 99 and DS1_SEX1 = 2;; tables pdrink * br_c_new/chisq; run;
proc freq data=b.total_final; where gexer_wk2 ^= 99 and DS1_SEX1 = 2; tables gexer_wk2 * br_c_new/chisq; run;
proc freq data=b.total_final; where gbmi2 ^= 99999 and DS1_SEX1 = 2; tables gbmi2 * br_c_new/chisq; run;
proc freq data=b.total_final; where PWI_1 ^= 99999 and DS1_SEX1 = 2; tables PWI_1 * br_c_new/chisq; run;
proc freq data=b.total_final; where MeS ^= 99999 and DS1_SEX1 = 2; tables MeS * br_c_new/chisq; run;

/********CE_C*********/
proc freq data=b.total_final; where psmok ^= 99 and DS1_SEX1 = 2; tables psmok * ce_c_new/chisq; run;
proc freq data=b.total_final; where pdrink ^= 99 and DS1_SEX1 = 2;; tables pdrink * ce_c_new/chisq; run;
proc freq data=b.total_final; where gexer_wk2 ^= 99 and DS1_SEX1 = 2; tables gexer_wk2 * ce_c_new/chisq; run;
proc freq data=b.total_final; where gbmi2 ^= 99999 and DS1_SEX1 = 2; tables gbmi2 * ce_c_new/chisq; run;
proc freq data=b.total_final; where PWI_1 ^= 99999 and DS1_SEX1 = 2; tables PWI_1 * ce_c_new/chisq; run;
proc freq data=b.total_final; where MeS ^= 99999 and DS1_SEX1 = 2; tables MeS * ce_c_new/chisq; run;

/********THY_C*********/
proc freq data=b.total_final; where psmok ^= 99 and DS1_SEX1 = 2; tables psmok * thy_c_new/chisq; run;
proc freq data=b.total_final; where pdrink ^= 99 and DS1_SEX1 = 2;; tables pdrink * thy_c_new/chisq; run;
proc freq data=b.total_final; where gexer_wk2 ^= 99 and DS1_SEX1 = 2; tables gexer_wk2 * thy_c_new/chisq; run;
proc freq data=b.total_final; where gbmi2 ^= 99999 and DS1_SEX1 = 2; tables gbmi2 * thy_c_new/chisq; run;
proc freq data=b.total_final; where PWI_1 ^= 99999 and DS1_SEX1 = 2; tables PWI_1 * thy_c_new/chisq; run;
proc freq data=b.total_final; where MeS ^= 99999 and DS1_SEX1 = 2; tables MeS * thy_c_new/chisq; run;


/********Conditional Logistic Regression (Cancer Type)*********/
/***********************1by1 Matching***********************/
/*************************Smoke***************************/
proc logistic data=b.total_final; where csmok not in (99);
	strata setnumber; 

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where csmok not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where csmok not in (99) and DS1_SEX1 = 2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where csmok not in (99) and DS1_SEX1 = 2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where csmok not in (99) and DS1_SEX1 = 2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model csmok (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 cdrink gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.total_final; where cdrink not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.total_final; where cdrink not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.total_final; where cdrink not in (99) and DS1_SEX1 = 2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') =  br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.total_final; where cdrink not in (99) and DS1_SEX1 = 2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

proc logistic data=b.total_final; where cdrink not in (99) and DS1_SEX1 = 2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

	model cdrink (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok gexer_wk1 gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.total_final; where gexer_wk1 not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gexer_wk1 not in (99);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1')      
			  csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gexer_wk1 not in (99) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gexer_wk1 not in (99) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gexer_wk1 not in (99) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model gexer_wk1 (ref='1') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gbmi1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.total_final; where gbmi1 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gbmi1 not in (99999);    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gbmi1 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gbmi1 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where gbmi1 not in (99999) and DS1_SEX1=2;    
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2 (PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model gbmi1 (ref='1') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 PWI_2 energy DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.total_final; where PWI_2 not in (99999);	   
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ga_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where PWI_2 not in (99999);	   
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              co_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where PWI_2 not in (99999) and DS1_SEX1=2;	   
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              br_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where PWI_2 not in (99999) and DS1_SEX1=2;	   
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              ce_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where PWI_2 not in (99999) and DS1_SEX1=2;	   
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') 	 			
              thy_c_new (PARAM=REF REF='0');

    model PWI_2 (ref='1') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********MeS**********/
proc logistic data=b.total_final;     
	strata setnumber;

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              ga_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.total_final;
	strata setnumber; 

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              co_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.total_final; where DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              br_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.total_final; where DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              ce_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

proc logistic data=b.total_final; where DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') MeS(PARAM=REF REF='0') DS1_ORALCON_1(PARAM=REF REF = '1') DS1_MENYN_1 (PARAM=REF REF='2')	 			
              thy_c_new (PARAM=REF REF='0');

    model MeS (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1 DS1_ORALCON_1 DS1_MENYN_1; 

run;

/**********wc**********/
proc logistic data=b.total_final; where wc not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model wc (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where wc not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model wc (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where wc not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model wc (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where wc not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model wc (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where wc not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') wc (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model wc (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********tg**********/
proc logistic data=b.total_final; where tg not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model tg (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where tg not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model tg (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where tg not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model tg (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where tg not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model tg (ref='0') = ce_c_new  DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where tg not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') tg (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model tg (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********hdl**********/
proc logistic data=b.total_final; where hdl not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where hdl not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where hdl not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where hdl not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where hdl not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') hdl (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model hdl (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********bp**********/
proc logistic data=b.total_final; where bp not in (99);
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model bp (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where bp not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model bp (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where bp not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model bp (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where bp not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model bp (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where bp not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') bp (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model bp (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

/**********glu**********/
proc logistic data=b.total_final; where glu not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              ga_c_new (PARAM=REF REF='0');

    model glu (ref='0') = ga_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where glu not in (99);     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              co_c_new (PARAM=REF REF='0');

    model glu (ref='0') = co_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where glu not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              br_c_new (PARAM=REF REF='0');

    model glu (ref='0') = br_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where glu not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              ce_c_new (PARAM=REF REF='0');

    model glu (ref='0') = ce_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;

proc logistic data=b.total_final; where glu not in (99) and DS1_SEX1=2;     
	strata setnumber;

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              csmok(PARAM=REF REF='0') cdrink(PARAM=REF REF='0') gexer_wk1 (PARAM=REF REF='1') gbmi1 (PARAM=REF REF='1') PWI_2(PARAM=REF REF='1') energy (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1') glu (PARAM=REF REF='0')
              thy_c_new (PARAM=REF REF='0');

    model glu (ref='0') = thy_c_new DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 csmok cdrink gexer_wk1 gbmi1 energy DS1_SRH_1 DS1_FCA_1; 

run;


/********Analysis only with Cancer Survivors**********/
/**************Total Cancer Survivors***************/
data b.cancer_only; set b.thesis;
	if group1 = 0 then output b.cancer_only;
run;

/**************Smoke*************/
proc freq data=b.cancer_only; tables psmok/list missing; run; /*Missing of psmok : 27 people*/  
proc logistic data=b.cancer_only; where psmok not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc freq data=b.cancer_only; tables pdrink/list missing; run; /*Missing of pdrink : 23 people*/ 
proc logistic data=b.cancer_only; where pdrink not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc freq data=b.cancer_only; tables gexer_wk2/list missing; run; /*Missing of gexer_wk2 : 141 people*/ 
proc logistic data=b.cancer_only; where gexer_wk2 not in (99);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal(PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='1') = cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc freq data=b.cancer_only; tables gbmi2/list missing; run; /*Missing of gbmi2 : 21 people*/ 
proc logistic data=b.cancer_only; where gbmi2 not in (99999);    

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc freq data=b.cancer_only; tables PWI_1/list missing; run; /*Missing of PWI_1 : 195 people*/ 
proc logistic data=b.cancer_only; where PWI_1 not in (99999);	   

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc freq data=b.cancer_only; tables Totalkcal/list missing; run; /*Missing of Totalkcal : 48 people*/ 
proc logistic data=b.cancer_only; where Totalkcal not in (9999);	   

	class DS1_SEX1(PARAM=REF REF='1') DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_SEX1 DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;


/**************Gastric Cancer Survivors (Male)***************/
/**************Smoke*************/
proc freq data=b.cancer_only; tables psmok * ga_c_new/list missing; run; /*Missing of psmok : 27 people*/  
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=1 and ga_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc freq data=b.cancer_only; tables pdrink * ga_c_new/list missing; run; /*Missing of pdrink : 23 people*/ 
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=1 and ga_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc freq data=b.cancer_only; tables gexer_wk2 * ga_c_new/list missing; run; /*Missing of gexer_wk2 : 141 people*/ 
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=1 and ga_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc freq data=b.cancer_only; tables gbmi2 * ga_c_new/list missing; run; /*Missing of gbmi2 : 21 people*/ 
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=1 and ga_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc freq data=b.cancer_only; tables PWI_1 * ga_c_new/list missing; run; /*Missing of PWI_1 : 195 people*/ 
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=1 and ga_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc freq data=b.cancer_only; tables Totalkcal * ga_c_new/list missing; run; /*Missing of PWI_1 : 48 people*/ 
proc logistic data=b.cancer_only; where Totalkcal not in (9999) and DS1_SEX1=1 and ga_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;


/**************Gastric Cancer Survivors (Female)***************/
/**************Smoke*************/
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=2 and ga_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=2 and ga_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=2 and ga_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=2 and ga_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=2 and ga_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc logistic data=b.cancer_only; where Totalkcal not in (9999) and DS1_SEX1=2 and ga_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;

/**************Colorectal Cancer Survivors (Male)***************/
/**************Smoke*************/
proc freq data=b.cancer_only; tables psmok * co_c_new/list missing; run; /*Missing of psmok : 27 people*/  
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=1 and co_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc freq data=b.cancer_only; tables pdrink * co_c_new/list missing; run; /*Missing of pdrink : 23 people*/ 
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=1 and co_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc freq data=b.cancer_only; tables gexer_wk2 * co_c_new/list missing; run; /*Missing of gexer_wk2 : 141 people*/ 
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=1 and co_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc freq data=b.cancer_only; tables gbmi2 * co_c_new/list missing; run; /*Missing of gbmi2 : 21 people*/ 
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=1 and co_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc freq data=b.cancer_only; tables PWI_1 * co_c_new/list missing; run; /*Missing of PWI_1 : 195 people*/ 
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=1 and co_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc freq data=b.cancer_only; tables Totalkcal * co_c_new/list missing; run; /*Missing of PWI_1 : 48 people*/ 
proc logistic data=b.cancer_only; where Totalkcal not in (9999) and DS1_SEX1=1 and co_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;


/**************Colorectal Cancer Survivors (Female)***************/
/**************Smoke*************/
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=2 and co_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=2 and co_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=2 and co_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='2') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=2 and co_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=2 and co_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc logistic data=b.cancer_only; where Totalkcal not in (99999) and DS1_SEX1=2 and co_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;

/**************Breast Cancer Survivors (Female)***************/
/**************Smoke*************/
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=2 and br_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=2 and br_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=2 and br_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='2') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=2 and br_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=2 and br_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc logistic data=b.cancer_only; where Totalkcal not in (99999) and DS1_SEX1=2 and co_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;

/**************Cervical Cancer Survivors (Female)***************/
/**************Smoke*************/
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=2 and ce_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=2 and ce_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=2 and ce_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=2 and ce_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=2 and ce_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc logistic data=b.cancer_only; where Totalkcal not in (9999) and DS1_SEX1=2 and ce_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;


/**************Thyroid Cancer Survivors (Female)***************/
/**************Smoke*************/
proc logistic data=b.cancer_only; where psmok not in (99) and DS1_SEX1=2 and thy_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model psmok (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 pdrink gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/**************Drink*************/
proc logistic data=b.cancer_only; where pdrink not in (99) and DS1_SEX1=2 and thy_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');              

	model pdrink (ref='0') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok gexer_wk2 gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1;

run;

/***********Exercise**********/
proc logistic data=b.cancer_only; where gexer_wk2 not in (99) and DS1_SEX1=2 and thy_c_new=1;    

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model gexer_wk2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gbmi2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********gbmi**********/
proc logistic data=b.cancer_only; where gbmi2 not in (99999) and DS1_SEX1=2 and thy_c_new=1;     

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1 (PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1'); 	 			              

    model gbmi2 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 PWI_1 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********PWI**********/
proc logistic data=b.cancer_only; where PWI_1 not in (99999) and DS1_SEX1=2 and thy_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model PWI_1 (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 Totalkcal DS1_SRH_1 DS1_FCA_1; 

run;

/***********Totalkcal**********/
proc logistic data=b.cancer_only; where Totalkcal not in (9999) and DS1_SEX1=2 and thy_c_new=1;	   

	class DS1_MARRY_A_1(PARAM=REF REF='1') DS1_EDU1 (PARAM=REF REF='1')  DS1_INCOME1 (PARAM=REF REF='1') DS1_JOB_1 (PARAM=REF REF='1') 
              psmok(PARAM=REF REF='0') pdrink(PARAM=REF REF='0') gexer_wk2 (PARAM=REF REF='1') gbmi2 (PARAM=REF REF='1') PWI_1(PARAM=REF REF='1') Totalkcal (PARAM=REF REF='1')
			  DS1_SRH_1 (PARAM=REF REF='1')  DS1_FCA_1 (PARAM=REF REF='1');
              
    model Totalkcal (ref='1') = cage DS1_MARRY_A_1 DS1_EDU1 DS1_INCOME1 DS1_JOB_1 psmok pdrink gexer_wk2 gbmi2 PWI_1 DS1_SRH_1 DS1_FCA_1; 

run;



