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

