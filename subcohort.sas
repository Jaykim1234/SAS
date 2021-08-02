libname Song "/userdata07/room284/data_source/ANALYSIS/Song";
/*song.BR_NCS_09_10_ALL 전체데이터*/
/*SONG.TEMP는 70%데이터/ SONG.TEMP_70는 C50,D05보정 DATA*/
/*SONG.TEMP_30는 30%데이터/ SONG.TEST_30는 C50,D05보정 DATA*/

DATA SONG.TEMP_TEST; SET SONG.TEMP;
IF C50=1 THEN BC=1; 
ELSE IF C50=0 AND D05=1 THEN DELETE;
ELSE IF C50=0 AND D05=0 THEN BC=0;
RUN;
PROC FREQ DATA=SONG.TEMP_TEST; TABLE BC; RUN; /*BC=0 N=2468706. BC=1 N=30471*/
/*RISK FACTOR 결측확인*/
PROC FREQ DATA=SONG.TEMP_TEST;
TABLE CBR_PCH_AMT QC_PHX_BBR_YN QC_MNC_AGE MNS_YN_1 MNP_AGE QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR BC G1E_BMI/LIST MISSING;
RUN;


/***************************************************************************************************************************************/
/*연속변수 표준화*/
PROC STANDARD DATA=SONG.TEMP_TEST MEAN=0 STD=1 OUT=SONG.TEMP_TEST2;
VAR QC_MNC_AGE MNP_AGE EXER G1E_BMI Q_DRK_FRQ_V09N; RUN;
PROC PRINT DATA=SONG.TEMP_TEST2 (OBS=100); RUN;
PROC MEANS DATA=SONG.TEMP_TEST2;
VAR QC_MNC_AGE MNP_AGE EXER G1E_BMI Q_DRK_FRQ_V09N; RUN;

/*범주형 CATEGORY 2개/ MNS_YN_1.FAM_CBR*/
DATA SONG.TEMP_TEST2; SET SONG.TEMP_TEST2;
IF MNS_YN_1=1 THEN MNS_YN_2=0;
ELSE MNS_YN_2=1; RUN;
PROC FREQ DATA=SONG.TEMP_TEST2; TABLE MNS_YN_2; RUN;

/*범주형 CATEGORY 3개 이상 더미변수/ CBR_RCH_AMT.QC_PHX_BBR_YN,QC_DLV_FRQ,QC_BRFD_DRT,Q_SMK_YN*/
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if CBR_PCH_AMT=1 then do; CBR_PCH_AMT_1=1; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=0; end;
if CBR_PCH_AMT=2 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=1; CBR_PCH_AMT_3=0; end;
if CBR_PCH_AMT=3 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=1; end;
if CBR_PCH_AMT=4 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=0; end; run; 
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if QC_PHX_BBR_YN=1 then do; QC_PHX_BBR_YN_1=1; QC_PHX_BBR_YN_2=0; end;
if QC_PHX_BBR_YN=2 then do; QC_PHX_BBR_YN_1=0; QC_PHX_BBR_YN_2=1; end; 
if QC_PHX_BBR_YN=3 then do; QC_PHX_BBR_YN_1=0; QC_PHX_BBR_YN_2=0; end; RUN;
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if QC_DLV_FRQ=1 then do; QC_DLV_FRQ_1=1; QC_DLV_FRQ_2=0; end;
if QC_DLV_FRQ=2 then do; QC_DLV_FRQ_1=0; QC_DLV_FRQ_2=1; end;
if QC_DLV_FRQ=3 then do; QC_DLV_FRQ_1=0; QC_DLV_FRQ_2=0; end; RUN;
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if QC_BRFD_DRT=1 then do; QC_BRFD_DRT_1=1; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=0; end;
if QC_BRFD_DRT=2 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=1; QC_BRFD_DRT_3=0; end;
if QC_BRFD_DRT=3 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=1; end;
if QC_BRFD_DRT=4 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=0; end; run;  
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if Q_SMK_YN=1 then do; Q_SMK_YN_1=1; Q_SMK_YN_2=0; end; 
if Q_SMK_YN=2 then do; Q_SMK_YN_1=0; Q_SMK_YN_2=1; end; 
if Q_SMK_YN=3 then do; Q_SMK_YN_1=0; Q_SMK_YN_2=0; end; RUN;

/*범주형 CATEGORY 3개 이상/ CBR_RCH_AMT.QC_PHX_BBR_YN,QC_DLV_FRQ,QC_BRFD_DRT,Q_SMK_YN*/
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if CBR_PCH_AMT=1 then CBR_PCH_AMT_1=1; else CBR_PCH_AMT_1=0; 
if CBR_PCH_AMT=2 then CBR_PCH_AMT_2=1; else CBR_PCH_AMT_2=0; 
if CBR_PCH_AMT=3 then CBR_PCH_AMT_3=1; else CBR_PCH_AMT_3=0; 
if CBR_PCH_AMT=4 then CBR_PCH_AMT_4=1; else CBR_PCH_AMT_4=0;run;  
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if QC_PHX_BBR_YN=1 then QC_PHX_BBR_YN_1=1; else QC_PHX_BBR_YN_1=0; 
if QC_PHX_BBR_YN=2 then QC_PHX_BBR_YN_2=1; else QC_PHX_BBR_YN_2=0; 
if QC_PHX_BBR_YN=3 then QC_PHX_BBR_YN_3=1; else QC_PHX_BBR_YN_3=0; RUN;
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if QC_DLV_FRQ=1 then QC_DLV_FRQ_1=1; else QC_DLV_FRQ_1=0; 
if QC_DLV_FRQ=2 then QC_DLV_FRQ_2=1; else QC_DLV_FRQ_2=0; 
if QC_DLV_FRQ=3 then QC_DLV_FRQ_3=1; else QC_DLV_FRQ_3=0; RUN;
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if QC_BRFD_DRT=1 then QC_BRFD_DRT_1=1; else QC_BRFD_DRT_1=0; 
if QC_BRFD_DRT=2 then QC_BRFD_DRT_2=1; else QC_BRFD_DRT_2=0; 
if QC_BRFD_DRT=3 then QC_BRFD_DRT_3=1; else QC_BRFD_DRT_3=0; 
if QC_BRFD_DRT=4 then QC_BRFD_DRT_4=1; else QC_BRFD_DRT_4=0;run;  
data SONG.TEMP_TEST2; set SONG.TEMP_TEST2;
if Q_SMK_YN=1 then Q_SMK_YN_1=1; else Q_SMK_YN_1=0; 
if Q_SMK_YN=2 then Q_SMK_YN_2=1; else Q_SMK_YN_2=0; 
if Q_SMK_YN=3 then Q_SMK_YN_3=1; else Q_SMK_YN_3=0; RUN;
/***************************************************************************************************************************************/



/***************************************************************************************************************************************/
/****************************폐경전후 데이터로 따로 만들기****************************/
/*폐경유무 카테고리 바꾸기*/
DATA SONG.TEMP_TEST3; SET SONG.TEMP_TEST;
IF MNS_YN_1=1 THEN MNS_YN_2=0;
ELSE MNS_YN_2=1; RUN;
PROC FREQ DATA=SONG.TEMP_TEST3; TABLE MNS_YN_2; RUN;/*MNS_YN_2=0 1174182개, MNS_YN_2=1 1324995개*/

/*범주형 CATEGORY 3개 이상 더미변수/ CBR_RCH_AMT.QC_PHX_BBR_YN,QC_DLV_FRQ,QC_BRFD_DRT,Q_SMK_YN*/
data SONG.TEMP_TEST3; set SONG.TEMP_TEST3;
if CBR_PCH_AMT=1 then do; CBR_PCH_AMT_1=1; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=0; end;
if CBR_PCH_AMT=2 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=1; CBR_PCH_AMT_3=0; end;
if CBR_PCH_AMT=3 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=1; end;
if CBR_PCH_AMT=4 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=0; end; run; 
data SONG.TEMP_TEST3; set SONG.TEMP_TEST3;
if QC_PHX_BBR_YN=1 then do; QC_PHX_BBR_YN_1=1; QC_PHX_BBR_YN_2=0; end;
if QC_PHX_BBR_YN=2 then do; QC_PHX_BBR_YN_1=0; QC_PHX_BBR_YN_2=1; end; 
if QC_PHX_BBR_YN=3 then do; QC_PHX_BBR_YN_1=0; QC_PHX_BBR_YN_2=0; end; RUN;
data SONG.TEMP_TEST3; set SONG.TEMP_TEST3;
if QC_DLV_FRQ=1 then do; QC_DLV_FRQ_1=1; QC_DLV_FRQ_2=0; end;
if QC_DLV_FRQ=2 then do; QC_DLV_FRQ_1=0; QC_DLV_FRQ_2=1; end;
if QC_DLV_FRQ=3 then do; QC_DLV_FRQ_1=0; QC_DLV_FRQ_2=0; end; RUN;
data SONG.TEMP_TEST3; set SONG.TEMP_TEST3;
if QC_BRFD_DRT=1 then do; QC_BRFD_DRT_1=1; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=0; end;
if QC_BRFD_DRT=2 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=1; QC_BRFD_DRT_3=0; end;
if QC_BRFD_DRT=3 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=1; end;
if QC_BRFD_DRT=4 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=0; end; run;  
data SONG.TEMP_TEST3; set SONG.TEMP_TEST3;
if Q_SMK_YN=1 then do; Q_SMK_YN_1=1; Q_SMK_YN_2=0; end; 
if Q_SMK_YN=2 then do; Q_SMK_YN_1=0; Q_SMK_YN_2=1; end; 
if Q_SMK_YN=3 then do; Q_SMK_YN_1=0; Q_SMK_YN_2=0; end; RUN;
/*폐경전후데이터셋나누기*/
data MNS0 MNS1; set song.temp_test3;
if MNS_YN_2=0 then output MNS0;
else output MNS1; run; /*SONG.MNS0은(는) 1174182개, SONG.MNS1은(는) 1324995개*/

/*****폐경전*****/
/*연속변수 표준화*/
PROC STANDARD DATA=MNS0 OUT=MNS0_STD MEAN=0 STD=1;
VAR QC_MNC_AGE MNP_AGE Q_DRK_FRQ_V09N EXER G1E_BMI; RUN;
/*범주형 군집분석*/
PROC FASTCLUS DATA=MNS0_STD OUT=MNS0_CLUSTER1 MAXCLUSTERS=7 MAXITER=100;
VAR CBR_PCH_AMT_1 CBR_PCH_AMT_2 CBR_PCH_AMT_3 QC_PHX_BBR_YN_1 QC_PHX_BBR_YN_2 QC_DLV_FRQ_1 QC_DLV_FRQ_2 QC_BRFD_DRT_1 QC_BRFD_DRT_2 QC_BRFD_DRT_3 Q_SMK_YN_1 Q_SMK_YN_2 FAM_CBR; RUN;
/*연속형 군집분석*/
PROC FASTCLUS DATA=MNS0_STD OUT=MNS0_CLUSTER2 MAXCLUSTERS=9 MAXITER=100;
VAR QC_MNC_AGE Q_DRK_FRQ_V09N EXER G1E_BMI; RUN;
/*****폐경후*****/
/*연속변수 표준화*/
PROC STANDARD DATA=MNS1 OUT=MNS1_STD MEAN=0 STD=1;
VAR QC_MNC_AGE MNP_AGE Q_DRK_FRQ_V09N EXER G1E_BMI; RUN;
/*범주형 군집분석*/
PROC FASTCLUS DATA=MNS1_STD OUT=MNS1_CLUSTER1 MAXCLUSTERS=7 MAXITER=100;
VAR CBR_PCH_AMT_1 CBR_PCH_AMT_2 CBR_PCH_AMT_3 QC_PHX_BBR_YN_1 QC_PHX_BBR_YN_2 
QC_DLV_FRQ_1 QC_DLV_FRQ_2 QC_BRFD_DRT_1 QC_BRFD_DRT_2 QC_BRFD_DRT_3 Q_SMK_YN_1 Q_SMK_YN_2 FAM_CBR; RUN;
/*연속형 군집분석*/
PROC FASTCLUS DATA=MNS1_STD OUT=MNS1_CLUSTER2 MAXCLUSTERS=7 MAXITER=100;
VAR QC_MNC_AGE MNP_AGE Q_DRK_FRQ_V09N EXER G1E_BMI; RUN;
/***************************************************************************************************************************************/


/***************************************************************************************************************************************/
/*****전부 범주형으로 바꿔주기*****/
data song.test1; set song.temp; run;
DATA SONG.TEST_1; SET SONG.TEST1;
IF C50=1 THEN BC=1;
ELSE IF C50=0 AND D05=1 THEN DELETE;
ELSE IF C50=0 AND D05=0 THEN BC=0;
RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF 40<=AGE<50 THEN AGE1=1;
IF 50<=AGE<60 THEN AGE1=2;
IF 60<=AGE<70 THEN AGE1=3; RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF QC_MNC_AGE<15 THEN MNC_AGE1=1;
ELSE MNC_AGE1=2; RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF MNP_AGE<52 THEN MNP_AGE1=1;
ELSE MNP_AGE1=2; RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF G1E_BMI<23 THEN BMI=1;
ELSE BMI=2; RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF Q_DRK_FRQ_V09N<1 THEN DRK_FRQ=1;
ELSE DRK_FRQ=2; RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF EXER<7 THEN EXER1=1;
ELSE EXER1=2; RUN;
DATA SONG.TEST_1; SET SONG.TEST_1;
IF MNS_YN_1=1 THEN MNS_YN_2=0;
ELSE MNS_YN_2=1; RUN;

PROC SQL;
CREATE TABLE SONG.TEST_2 AS
SELECT AGE1, MNC_AGE1, MNP_AGE1, BMI, DRK_FRQ, EXER1, CBR_PCH_AMT, QC_PHX_BBR_YN, MNS_YN_2, QC_DLV_FRQ, QC_BRFD_DRT, Q_SMK_YN, FAM_CBR
FROM SONG.TEST_1
; RUN;
/*범주형 CATEGORY 3개 이상 더미변수/ CBR_RCH_AMT.QC_PHX_BBR_YN,QC_DLV_FRQ,QC_BRFD_DRT,Q_SMK_YN*/
data SONG.TEST_2; set SONG.TEST_2;
if AGE1=1 then do; AGE1_1=1; AGE1_2=0; AGE1_3=0; end;
if AGE1=2 then do; AGE1_1=0; AGE1_2=1; AGE1_3=0; end;
if AGE1=3 then do; AGE1_1=0; AGE1_2=0; AGE1_3=1; end; 

if CBR_PCH_AMT=1 then do; CBR_PCH_AMT_1=1; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=0; end;
if CBR_PCH_AMT=2 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=1; CBR_PCH_AMT_3=0; end;
if CBR_PCH_AMT=3 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=1; end;
if CBR_PCH_AMT=4 then do; CBR_PCH_AMT_1=0; CBR_PCH_AMT_2=0; CBR_PCH_AMT_3=0; end; 

if QC_PHX_BBR_YN=1 then do; QC_PHX_BBR_YN_1=1; QC_PHX_BBR_YN_2=0; end;
if QC_PHX_BBR_YN=2 then do; QC_PHX_BBR_YN_1=0; QC_PHX_BBR_YN_2=1; end; 
if QC_PHX_BBR_YN=3 then do; QC_PHX_BBR_YN_1=0; QC_PHX_BBR_YN_2=0; end; 

if QC_DLV_FRQ=1 then do; QC_DLV_FRQ_1=1; QC_DLV_FRQ_2=0; end;
if QC_DLV_FRQ=2 then do; QC_DLV_FRQ_1=0; QC_DLV_FRQ_2=1; end;
if QC_DLV_FRQ=3 then do; QC_DLV_FRQ_1=0; QC_DLV_FRQ_2=0; end; 

if QC_BRFD_DRT=1 then do; QC_BRFD_DRT_1=1; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=0; end;
if QC_BRFD_DRT=2 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=1; QC_BRFD_DRT_3=0; end;
if QC_BRFD_DRT=3 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=1; end;
if QC_BRFD_DRT=4 then do; QC_BRFD_DRT_1=0; QC_BRFD_DRT_2=0; QC_BRFD_DRT_3=0; end;

if Q_SMK_YN=1 then do; Q_SMK_YN_1=1; Q_SMK_YN_2=0; end; 
if Q_SMK_YN=2 then do; Q_SMK_YN_1=0; Q_SMK_YN_2=1; end; 
if Q_SMK_YN=3 then do; Q_SMK_YN_1=0; Q_SMK_YN_2=0; end; RUN;
/*폐경전후데이터셋나누기*/
data TEST_MNS0 TEST_MNS1; set song.TEST_2;
if MNS_YN_2=0 then output TEST_MNS0;
else output TEST_MNS1; run; /*SONG.TEST_MNS0은(는) 1174182개, SONG.TEST_MNS1은(는) 1324995개*/
/*폐경전*/
PROC FASTCLUS DATA=TEST_MNS0 OUT=MN0OUT MAXCLUSTERS=9 MAXITER=100;
VAR AGE1 MNC_AGE1 BMI DRK_FRQ EXER1 CBR_PCH_AMT QC_PHX_BBR_YN QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN FAM_CBR;
RUN;
PROC FASTCLUS DATA=TEST_MNS0 OUT=MN0OUT MAXCLUSTERS=6 MAXITER=100;
VAR AGE1_1 AGE1_2 AGE1_3 CBR_PCH_AMT_1 CBR_PCH_AMT_2 CBR_PCH_AMT_3 QC_PHX_BBR_YN_1 QC_PHX_BBR_YN_2 MNC_AGE1 QC_DLV_FRQ_1 QC_DLV_FRQ_2
QC_BRFD_DRT_1 QC_BRFD_DRT_2 QC_BRFD_DRT_3 Q_SMK_YN_1 Q_SMK_YN_2 DRK_FRQ EXER1 BMI;
RUN;
/*페경후*/
PROC FASTCLUS DATA=TEST_MNS1 OUT=MN1OUT MAXCLUSTERS=12 MAXITER=100;
VAR AGE1 MNC_AGE1 MNP_AGE1 BMI DRK_FRQ EXER1 CBR_PCH_AMT QC_PHX_BBR_YN QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN FAM_CBR;
RUN;
PROC FASTCLUS DATA=TEST_MNS1 OUT=MN1OUT MAXCLUSTERS=7 MAXITER=100;
VAR AGE1_1 AGE1_2 AGE1_3 CBR_PCH_AMT_1 CBR_PCH_AMT_2 CBR_PCH_AMT_3 QC_PHX_BBR_YN_1 QC_PHX_BBR_YN_2 MNC_AGE1 MNP_AGE1 QC_DLV_FRQ_1 QC_DLV_FRQ_2
QC_BRFD_DRT_1 QC_BRFD_DRT_2 QC_BRFD_DRT_3 Q_SMK_YN_1 Q_SMK_YN_2 DRK_FRQ EXER1 BMI;
RUN;
/***************************************************************************************************************************************/




/***************************************************************************************************************************************/
data temp1; set EX.BR_GR_09_10_1;
if CBR_PCH_AMT in (1,2) then dense=0; else if CBR_PCH_AMT in (3,4) then dense=1; else dense=. ;  

if QC_MNC_AGE=. then MNC_AGE_1=999; else if QC_MNC_AGE<15 then MNC_AGE_1=1; else MNC_AGE_1=2;  

if QC_MNS_YN=. then MNS_YN_1=999; else if QC_MNP_AGE^=. then MNS_YN_1=1; 
else if QC_MNS_YN in (1,2) then MNS_YN_1=0; else if QC_MNS_YN=3 then MNS_YN_1=1; 

if MNS_YN_1=999 then MNP_AGE_1=999; else if MNS_YN_1=0 then MNP_AGE_1=0; else if MNS_YN_1=1 and QC_MNP_AGE=. then MNP_AGE_1=999; 
else if QC_MNP_AGE<52 then MNP_AGE_1=1; else MNP_AGE_1=2; 

if QC_DLV_FRQ=. then DLV_FRQ_1=999; else if QC_DLV_FRQ=1 then DLV_FRQ_1=0; else DLV_FRQ_1=1;
if QC_BRFD_DRT=. then BRFD_DRT_1=999; else if QC_BRFD_DRT=1 then BRFD_DRT_1=0; 
else if QC_BRFD_DRT=2 then BRFD_DRT_1=1; else BRFD_DRT_1=2;  
if QC_OPLL_YN=. then OPLL_YN_1=999; else if QC_OPLL_YN=1 then OPLL_YN_1=0; else OPLL_YN_1=1;
if MNS_YN_1=0 then ERT_YN_1=8; else if QC_ERT_YN=1 then ERT_YN_1=0; else ERT_YN_1=1;  

if QC_PFHX_CST_PRT=2 or QC_PFHX_CST_BRT=2 or QC_PFHX_CST_SST=2 then FHX_GC_1=1; else FHX_GC_1=0;
if QC_PFHX_CBR_PRT=2 or QC_PFHX_CBR_BRT=2 or QC_PFHX_CBR_SST=2 then FHX_BC_1=1; else FHX_BC_1=0;
if QC_PFHX_CCR_PRT=2 or QC_PFHX_CCR_BRT=2 or QC_PFHX_CCR_SST=2 then FHX_CC_1=1; else FHX_CC_1=0;
if QC_PFHX_CLV_PRT=2 or QC_PFHX_CLV_BRT=2 or QC_PFHX_CLV_SST=2 then FHX_LC_1=1; else FHX_LC_1=0;
if QC_PFHX_CCX_PRT=2 or QC_PFHX_CCX_BRT=2 or QC_PFHX_CCX_SST=2 then FHX_CXC_1=1; else FHX_CXC_1=0;
if QC_PFHX_ETC_PRT=2 or QC_PFHX_ETC_BRT=2 or QC_PFHX_ETC_SST=2 then FHX_ETC_1=1; else FHX_ETC_1=0;

if Q_SMK_YN=. then SMK_YN_1=999; else if Q_SMK_YN in (1) then SMK_YN_1=0; else if Q_SMK_YN in (2,3) then SMK_YN_1=1; 
if Q_DRK_FRQ_V09N=. then DRK_FRQ_1=999; else if Q_DRK_FRQ_V09N=0 then DRK_FRQ_1=0;  else if Q_DRK_FRQ_V09N=1 then DRK_FRQ_1=1; else DRK_FRQ_1=2;
exer=Q_PA_VD+Q_PA_MD+Q_PA_WALK; 
if exer=. then exer_1=999; else if exer=0 then exer_1=0; else exer_1=1;
if G1E_BMI=. then BMI_1=999; else if G1E_BMI<23 then BMI_1=1; else  BMI_1=2; 
run ;
/***************************************************************************************************************************************/


/***************************************************************************************************************************************/
/*********************범주형 다시 만들기*********************/
data song.test1; set SONG.TEMP_TEST; run;
DATA SONG.TEST1; SET SONG.TEST1;
IF 40<=AGE<50 THEN AGE1=1; ELSE IF 50<=AGE<60 THEN AGE1=2; ELSE IF 60<=AGE<70 THEN AGE1=3;
IF G1E_BMI<=23 THEN G1E_BMI_1=0; ELSE G1E_BMI_1=1;
IF QC_PHX_BBR_YN=2 THEN QC_PHX_BBR_YN_1=0; ELSE IF QC_PHX_BBR_YN=3 THEN QC_PHX_BBR_YN_1=2; ELSE QC_PHX_BBR_YN_1=1;
IF QC_MNC_AGE<15 THEN QC_MNC_AGE_1=1; ELSE QC_MNC_AGE_1=2;
IF MNS_YN_1=1 THEN MNS_YN_2=0; ELSE MNS_YN_2=1;
IF MNP_AGE=0 THEN MNP_AGE_1=0; ELSE IF MNP_AGE<52 THEN MNP_AGE_1=1; ELSE MNP_AGE_1=2;
IF QC_DLV_FRQ=1 THEN QC_DLV_FRQ_1=1; ELSE IF QC_DLV_FRQ=2 THEN QC_DLV_FRQ_1=1; ELSE QC_DLV_FRQ_1=0;
IF QC_BRFD_DRT=1 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=2 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=3 THEN QC_BRFD_DRT_1=1; ELSE QC_BRFD_DRT_1=0;
IF Q_SMK_YN=1 THEN Q_SMK_YN_1=0; ELSE IF Q_SMK_YN=2 THEN Q_SMK_YN_1=0; ELSE Q_SMK_YN_1=1;
IF Q_DRK_FRQ_V09N=0 THEN Q_DRK_FRQ_V09N_1=0; ELSE Q_DRK_FRQ_V09N_1=1;
IF EXER<8 THEN EXER_1=1; ELSE EXER_1=2; RUN;

PROC FREQ DATA=SONG.TEST1;
TABLE AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNS_YN_2 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;

/*폐경전후데이터셋나누기*/
data SONG.TEST1_MNS0 SONG.TEST1_MNS1; set SONG.TEST1;
if MNS_YN_2=0 then output SONG.TEST1_MNS0;
else output SONG.TEST1_MNS1; run; /*SONG.TEST1_MNS0은(는) 1174182개, SONG.TEST1_MNS1은(는) 1324995개*/
PROC FREQ DATA=SONG.TEST1_MNS0;
TABLE MNP_AGE_1; RUN;
PROC FREQ DATA=SONG.TEST1_MNS1;
TABLE MNP_AGE_1; RUN;

/*폐경전군집분석*/
PROC FASTCLUS DATA=SONG.TEST1_MNS0 OUT=MN0OUT_1 MAXCLUSTERS=3 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;
PROC FASTCLUS DATA=SONG.TEST1_MNS0 OUT=MN0OUT_2 MAXCLUSTERS=5 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;
PROC FASTCLUS DATA=SONG.TEST1_MNS0 OUT=MN0OUT_3 MAXCLUSTERS=10 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;
/*폐경후군집분석*/
PROC FASTCLUS DATA=SONG.TEST1_MNS1 OUT=MN1OUT_1 MAXCLUSTERS=3 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;
PROC FASTCLUS DATA=SONG.TEST1_MNS1 OUT=MN1OUT_2 MAXCLUSTERS=11 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;


/*CLUSTER별 빈도표*/
/*폐경전*/
PROC SORT DATA=MN0OUT_1 OUT=MN0SORT;
BY CLUSTER; RUN;
PROC FREQ DATA=MN0SORT;
TABLE (AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR CA C50 D05 BC)*CLUSTER/CHISQ;
RUN;
PROC MEANS DATA=MN0SORT;
VAR AGE1 G1E_BMI_1 QC_MNC_AGE_1 Q_DRK_FRQ_V09N_1 EXER_1;
BY CLUSTER; RUN;
/*폐경후*/
PROC SORT DATA=MN1OUT_1 OUT=MN1SORT;
BY CLUSTER; RUN;
PROC FREQ DATA=MN1SORT;
TABLE (AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR CA C50 D05 BC)*CLUSTER/CHISQ;
RUN;
PROC MEANS DATA=MN1SORT;
VAR AGE1 G1E_BMI_1 QC_MNC_AGE_1 MNP_AGE_1 Q_DRK_FRQ_V09N_1 EXER_1;
BY CLUSTER; RUN;

/*CLUSTER별 나누기*/
/*폐경전*/
PROC SQL;
CREATE TABLE MN0_CLU1 AS
SELECT * 
FROM MN0OUT_1
WHERE CLUSTER=1 ; QUIT;
PROC SQL;
CREATE TABLE MN0_CLU2 AS
SELECT * 
FROM MN0OUT_1
WHERE CLUSTER=2 ; QUIT;
PROC SQL;
CREATE TABLE MN0_CLU3 AS
SELECT * 
FROM MN0OUT_1
WHERE CLUSTER=3 ; QUIT;
/*폐경후*/
PROC SQL;
CREATE TABLE MN1_CLU1 AS
SELECT * 
FROM MN1OUT_1
WHERE CLUSTER=1 ; QUIT;
PROC SQL;
CREATE TABLE MN1_CLU2 AS
SELECT * 
FROM MN1OUT_1
WHERE CLUSTER=2 ; QUIT;
PROC SQL;
CREATE TABLE MN1_CLU3 AS
SELECT * 
FROM MN1OUT_1
WHERE CLUSTER=3 ; QUIT;
/*CLUSTER별 OR*/
PROC FREQ DATA=MN0_CLU1;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=MN0_CLU2;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=MN0_CLU3;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=MN1_CLU1;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=MN1_CLU2;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=MN1_CLU3;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;



/*요인별*C50 or*/
/*폐경전후*/
PROC FREQ DATA=MN0SORT;
TABLES C50*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=MN1SORT;
TABLES C50*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
/*요인별*BC or*/
/*폐경전후*/
DATA SONG.TEST2; SET SONG.TEMP;
IF C50=1 AND D05=1 THEN BC=1;
ELSE IF C50=0 AND D05=0 THEN BC=0;
ELSE DELETE;
RUN;
PROC FREQ DATA=SONG.TEST2; TABLE BC; RUN; /*BC=0 N=2468706. BC=1 N=4710*/
DATA SONG.TEST2; SET SONG.TEST2;
IF 40<=AGE<50 THEN AGE1=1; ELSE IF 50<=AGE<60 THEN AGE1=2; ELSE IF 60<=AGE<70 THEN AGE1=3;
IF G1E_BMI<23 THEN G1E_BMI_1=0; ELSE G1E_BMI_1=1;
IF QC_PHX_BBR_YN=2 THEN QC_PHX_BBR_YN_1=0; ELSE IF QC_PHX_BBR_YN=3 THEN QC_PHX_BBR_YN_1=2; ELSE QC_PHX_BBR_YN_1=1;
IF QC_MNC_AGE<15 THEN QC_MNC_AGE_1=1; ELSE QC_MNC_AGE_1=2;
IF MNS_YN_1=1 THEN MNS_YN_2=0; ELSE MNS_YN_2=1;
IF MNP_AGE=0 THEN MNP_AGE_1=0; ELSE IF 0<MNP_AGE<52 THEN MNP_AGE_1=1; ELSE MNP_AGE_1=2;
IF QC_DLV_FRQ=1 THEN QC_DLV_FRQ_1=1; ELSE IF QC_DLV_FRQ=2 THEN QC_DLV_FRQ_1=1; ELSE QC_DLV_FRQ_1=0;
IF QC_BRFD_DRT=1 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=2 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=3 THEN QC_BRFD_DRT_1=1; ELSE QC_BRFD_DRT_1=0;
IF Q_SMK_YN=1 THEN Q_SMK_YN_1=0; ELSE IF Q_SMK_YN=2 THEN Q_SMK_YN_1=0; ELSE Q_SMK_YN_1=1;
IF Q_DRK_FRQ_V09N=0 THEN Q_DRK_FRQ_V09N_1=0; ELSE Q_DRK_FRQ_V09N_1=1;
IF EXER<8 THEN EXER_1=1; ELSE EXER_1=2; RUN;
data SONG.TEST2_MNS0 SONG.TEST2_MNS1; set SONG.TEST2;
if MNS_YN_2=0 then output SONG.TEST2_MNS0;
else output SONG.TEST2_MNS1; run; /*SONG.TEST2_MNS0은(는) 1159442개, SONG.TEST2_MNS1은(는) 1313974개*/
PROC FREQ DATA=SONG.TEST2_MNS0;
TABLE MNP_AGE_1 BC; RUN;
PROC FREQ DATA=SONG.TEST2_MNS1;
TABLE MNP_AGE_1 BC; RUN;
PROC FREQ DATA=SONG.TEST2_MNS0;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;
PROC FREQ DATA=SONG.TEST2_MNS1;
TABLES BC*(AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR)/CHISQ RELRISK;
RUN;


/*이분형데이터 만들기*/
DATA SONG.TEST1_temp; SET SONG.TEST1;
if age1=1 then do; age1_1=1; age1_2=0; age1_3=0; end;
if age1=2 then do; age1_1=0; age1_2=1; age1_3=0; end;
if age1=3 then do; age1_1=0; age1_2=0; age1_3=1; end;

if qc_phx_bbr_yn_1=0 then do; bbr_yn_0=1; bbr_yn_1=0; bbr_yn_2=0; end;
if qc_phx_bbr_yn_1=1 then do; bbr_yn_0=0; bbr_yn_1=1; bbr_yn_2=0; end;
if qc_phx_bbr_yn_1=2 then do; bbr_yn_0=0; bbr_yn_1=0; bbr_yn_2=1; end;

if cbr_pch_amt=1 then do; amt_1=1; amt_2=0; amt_3=0; amt_4=0; end;
if cbr_pch_amt=2 then do; amt_1=0; amt_2=1; amt_3=0; amt_4=0; end;
if cbr_pch_amt=3 then do; amt_1=0; amt_2=0; amt_3=1; amt_4=0; end;
if cbr_pch_amt=4 then do; amt_1=0; amt_2=0; amt_3=0; amt_4=1; end;

if mnp_age_1=0 then do; mnp_0=1; mnp_1=0; mnp_2=0; end;
if mnp_age_1=1 then do; mnp_0=0; mnp_1=1; mnp_2=0; end;
if mnp_age_1=2 then do; mnp_0=0; mnp_1=0; mnp_2=1; end; run;
/*폐경전후데이터셋나누기*/
data TEST1_temp_MNS0 TEST1_temp_MNS1; set SONG.test1_temp;
if MNS_YN_2=0 then output TEST1_temp_MNS0;
else output TEST1_temp_MNS1; run;
/*폐경전군집분석*/
PROC FASTCLUS DATA=TEST1_temp_MNS0 OUT=SONG.MNS0 MAXCLUSTERS=3 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;
/*폐경후군집분석*/
PROC FASTCLUS DATA=TEST1_temp_MNS1 OUT=SONG.MNS1 MAXCLUSTERS=3 MAXITER=100;
VAR AGE1 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 MNP_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR;
RUN;

proc freq data=SONG.mns0;
tables bc*cluster/cmh; run;
proc logistic data=SONG.mns0 descending;
class age1_1(ref="1") age1_2(ref="1") age1_3(ref="1") G1E_BMI_1 amt_1(ref="1") amt_2(ref="1") amt_3(ref="1") amt_4(ref="1") bbr_yn_0(ref="1") bbr_yn_1(ref="1") bbr_yn_2(ref="1") 
QC_MNC_AGE_1(ref="2") QC_DLV_FRQ_1(ref="1") QC_BRFD_DRT_1(ref="1") Q_SMK_YN_1(ref="1") Q_DRK_FRQ_V09N_1(ref="1") EXER_1(ref="1") FAM_CBR(ref="1") bc(ref="1");
model cluster=age1_1 age1_2 age1_3 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR bc;
run;
proc logistic data=SONG.mns1 descending;
class age1_1(ref="1") age1_2(ref="1") age1_3(ref="1") G1E_BMI_1 amt_1(ref="1") amt_2(ref="1") amt_3(ref="1") amt_4(ref="1") bbr_yn_0(ref="1") bbr_yn_1(ref="1") bbr_yn_2(ref="1") 
QC_MNC_AGE_1(ref="2") mnp_1(ref="1") mnp_2(ref="1") QC_DLV_FRQ_1(ref="1") QC_BRFD_DRT_1(ref="1") Q_SMK_YN_1(ref="1") Q_DRK_FRQ_V09N_1(ref="1") EXER_1(ref="1") FAM_CBR(ref="1") bc(ref="1");
model cluster=age1_1 age1_2 age1_3 G1E_BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 QC_MNC_AGE_1 mnp_1 mnp_2 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 Q_DRK_FRQ_V09N_1 EXER_1 FAM_CBR bc;
run;


proc phreg data=SONG.MNS0; 
class bc(param=ref ref="1") age1_1 (param=ref ref="1") age1_2 (param=ref ref="1") age1_3 (param=ref ref="1")
      G1E_BMI_1 (param=ref)
      amt_1 (param=ref ref="1") amt_2 (param=ref  ref="1") amt_3 (param=ref  ref="1") amt_4 (param=ref  ref="1") 
      bbr_yn_0 (param=ref  ref="1") bbr_yn_1 (param=ref ref="1") bbr_yn_2 (param=ref  ref="1")
      qc_mnc_age_1 (param=ref ref="2")
      qc_dlv_frq_1 (param=ref ref="1") 
      qc_brfd_drt_1 (param=ref ref="1")
      q_smk_yn_1  (param=ref ref="1") 
      q_drk_frq_v09n_1 (param=ref ref="1") 
      exer_1 (param=ref ref="1")  
      fam_cbr (param=ref ref="1") ;    
model cluster=bc age1_1 age1_2 age1_3 G1E_BMI_1 amt_1 amt_2 amt_3 amt_4 
bbr_yn_0 bbr_yn_1 bbr_yn_2 qc_mnc_age_1 qc_dlv_frq_1 qc_brfd_drt_1 
q_smk_yn_1 q_drk_frq_v09n_1 exer_1 fam_cbr /risklimits; run;

ods chtml close;
ods listing;

proc phreg data=SONG.MNS1; 
class bc(param=ref ref="1") age1_1 (param=ref ref="1") age1_2 (param=ref ref="1") age1_3 (param=ref ref="1")
      G1E_BMI_1 (param=ref)
      amt_1 (param=ref ref="1") amt_2 (param=ref  ref="1") amt_3 (param=ref  ref="1") amt_4 (param=ref  ref="1") 
      bbr_yn_0 (param=ref  ref="1") bbr_yn_1 (param=ref ref="1") bbr_yn_2 (param=ref  ref="1")
      qc_mnc_age_1 (param=ref ref="2")
      mnp_1 (param=ref ref="1") mnp_2 (param=ref ref="1") 
      qc_dlv_frq_1 (param=ref ref="1") 
      qc_brfd_drt_1 (param=ref ref="1")
      q_smk_yn_1  (param=ref ref="1") 
      q_drk_frq_v09n_1 (param=ref ref="1") 
      exer_1 (param=ref ref="1")  
      fam_cbr (param=ref ref="1") ;    
model cluster=bc age1_1 age1_2 age1_3 G1E_BMI_1 amt_1 amt_2 amt_3 amt_4 
bbr_yn_0 bbr_yn_1 bbr_yn_2 qc_mnc_age_1 mnp_1 mnp_2 qc_dlv_frq_1 qc_brfd_drt_1 
q_smk_yn_1 q_drk_frq_v09n_1 exer_1 fam_cbr /risklimits; run;

ods chtml close;
ods listing;



/********************************************************30%data***************************************************************************/
/*SONG.TEMP는 70%데이터*/
/*SONG.BR_NCS_0910_TEST는 30%데이터*/

data test; set song.br_ncs_0910_test; run;/*n=1072460*/
DATA test; SET test;
IF C50=1 THEN BC=1;
ELSE IF C50=0 AND D05=1 THEN DELETE;
ELSE IF C50=0 AND D05=0 THEN BC=0;
RUN; /*n=1071095*/
PROC FREQ DATA=test; TABLE BC; RUN; /*BC=0 N=1057896. BC=1 N=13199*/
/*RISK FACTOR 결측확인*/
PROC FREQ DATA=TEST;
TABLE AGE G1E_BMI CBR_PCH_AMT QC_PHX_BBR_YN QC_MNC_AGE MNS_YN_1 MNP_AGE QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR BC/LIST MISSING;
RUN;
/*폐경전후데이터셋나누기*/
data TEST_MNS0 TEST_MNS1; set TEST;
if MNS_YN_1=1 then output TEST_MNS0;
else output TEST_MNS1; run; /*TEST_MNS0은(는) 503581개,TEST_MNS1은(는) 567514개*/
proc freq data=test_mns0;
table MNS_YN_1 mnp_age; run;
proc freq data=test_mns1;
table MNS_YN_1 mnp_age; run;

DATA mns0_temp; SET test_mns0;
IF 40<=AGE<50 THEN AGE1=1;
IF 50<=AGE<60 THEN AGE1=2;
IF 60<=AGE<70 THEN AGE1=3; 

IF QC_MNC_AGE<15 THEN MNC_AGE1=1;
ELSE MNC_AGE1=2; 

IF G1E_BMI<23 THEN BMI=1;
ELSE BMI=2; 

IF Q_DRK_FRQ_V09N<1 THEN DRK_FRQ=1;
ELSE DRK_FRQ=2; 

IF EXER<7 THEN EXER1=1;
ELSE EXER1=2;  RUN;
DATA mns1_temp; SET test_mns1;
IF 40<=AGE<50 THEN AGE1=1;
IF 50<=AGE<60 THEN AGE1=2;
IF 60<=AGE<70 THEN AGE1=3; 

IF QC_MNC_AGE<15 THEN MNC_AGE1=1;
ELSE MNC_AGE1=2; 

IF MNP_AGE<52 THEN MNP_AGE1=1;
ELSE MNP_AGE1=2;

IF G1E_BMI<23 THEN BMI=1;
ELSE BMI=2; 

IF Q_DRK_FRQ_V09N<1 THEN DRK_FRQ=1;
ELSE DRK_FRQ=2; 

IF EXER<7 THEN EXER1=1;
ELSE EXER1=2;  RUN;

/*범주형변수만*/
proc sql;
create table test2_mns0 as
select age1, bmi, CBR_PCH_AMT, QC_PHX_BBR_YN, MNC_AGE1, QC_DLV_FRQ, QC_BRFD_DRT, Q_SMK_YN, DRK_FRQ, EXER1, FAM_CBR, BC
from mns0_temp ; quit;
proc freq data=test2_mns0;
table AGE1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE1 QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN DRK_FRQ EXER1 FAM_CBR BC; run;
DATA test2_mns0; SET test2_mns0;
IF BMI=1 THEN BMI_1=0; ELSE BMI_1=1;
IF QC_PHX_BBR_YN=2 THEN QC_PHX_BBR_YN_1=0; ELSE IF QC_PHX_BBR_YN=3 THEN QC_PHX_BBR_YN_1=2; ELSE QC_PHX_BBR_YN_1=1;
IF QC_MNC_AGE<15 THEN QC_MNC_AGE_1=1; ELSE QC_MNC_AGE_1=2;
IF QC_DLV_FRQ=1 THEN QC_DLV_FRQ_1=1; ELSE IF QC_DLV_FRQ=2 THEN QC_DLV_FRQ_1=1; ELSE QC_DLV_FRQ_1=0;
IF QC_BRFD_DRT=1 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=2 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=3 THEN QC_BRFD_DRT_1=1; ELSE QC_BRFD_DRT_1=0;
IF Q_SMK_YN=1 THEN Q_SMK_YN_1=0; ELSE IF Q_SMK_YN=2 THEN Q_SMK_YN_1=0; ELSE Q_SMK_YN_1=1;
IF DRK_FRQ=1 THEN DRK_FRQ_1=0; ELSE DRK_FRQ_1=1; RUN;
proc sql;
create table test2_mns1 as
select age1, bmi, CBR_PCH_AMT, QC_PHX_BBR_YN, MNC_AGE1, MNP_AGE1, QC_DLV_FRQ, QC_BRFD_DRT, Q_SMK_YN, DRK_FRQ, EXER1, FAM_CBR, BC
from mns1_temp ; quit;
proc freq data=test2_mns1;
table AGE1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE1 MNP_AGE1 QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN DRK_FRQ EXER1 FAM_CBR BC; run;
DATA test2_mns1; SET test2_mns1;
IF BMI=1 THEN BMI_1=0; ELSE BMI_1=1;
IF QC_PHX_BBR_YN=2 THEN QC_PHX_BBR_YN_1=0; ELSE IF QC_PHX_BBR_YN=3 THEN QC_PHX_BBR_YN_1=2; ELSE QC_PHX_BBR_YN_1=1;
IF QC_MNC_AGE<15 THEN QC_MNC_AGE_1=1; ELSE QC_MNC_AGE_1=2;
IF QC_DLV_FRQ=1 THEN QC_DLV_FRQ_1=1; ELSE IF QC_DLV_FRQ=2 THEN QC_DLV_FRQ_1=1; ELSE QC_DLV_FRQ_1=0;
IF QC_BRFD_DRT=1 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=2 THEN QC_BRFD_DRT_1=1; ELSE IF QC_BRFD_DRT=3 THEN QC_BRFD_DRT_1=1; ELSE QC_BRFD_DRT_1=0;
IF Q_SMK_YN=1 THEN Q_SMK_YN_1=0; ELSE IF Q_SMK_YN=2 THEN Q_SMK_YN_1=0; ELSE Q_SMK_YN_1=1;
IF DRK_FRQ=1 THEN DRK_FRQ_1=0; ELSE DRK_FRQ_1=1; RUN;


/*폐경전군집분석*/
PROC FASTCLUS DATA=test2_mns0 OUT=MNS0_clu MAXCLUSTERS=3 MAXITER=100;
VAR AGE1 BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 MNC_AGE1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 DRK_FRQ_1 EXER1 FAM_CBR BC;
RUN;
/*폐경후군집분석*/
PROC FASTCLUS DATA=test2_mns1 OUT=MNS1_clu MAXCLUSTERS=3 MAXITER=100;
VAR AGE1 BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 MNC_AGE1 MNP_AGE1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 DRK_FRQ_1 EXER1 FAM_CBR BC;
RUN;

/*CLUSTER별 빈도표*/
/*폐경전*/
PROC SORT DATA=MNS0_clu OUT=MN0SORT;
BY CLUSTER; RUN;
PROC FREQ DATA=MN0SORT;
TABLE (AGE1 BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 MNC_AGE1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 DRK_FRQ_1 EXER1 FAM_CBR BC)*CLUSTER/CHISQ;
RUN;
/*폐경후*/
PROC SORT DATA=MNS1_clu OUT=MN1SORT;
BY CLUSTER; RUN;
PROC FREQ DATA=MN1SORT;
TABLE (AGE1 BMI_1 CBR_PCH_AMT QC_PHX_BBR_YN_1 MNC_AGE1 MNP_AGE1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 DRK_FRQ_1 EXER1 FAM_CBR BC)*CLUSTER/CHISQ;
RUN;

/*OR&COX*/
/*이분형데이터 만들기*/
DATA MN0_OR; SET MN0SORT;
if age1=1 then do; age1_1=1; age1_2=0; age1_3=0; end;
if age1=2 then do; age1_1=0; age1_2=1; age1_3=0; end;
if age1=3 then do; age1_1=0; age1_2=0; age1_3=1; end;

if QC_PHX_BBR_YN_1=1 then do; bbr_yn_0=1; bbr_yn_1=0; bbr_yn_2=0; end;
if QC_PHX_BBR_YN_1=2 then do; bbr_yn_0=0; bbr_yn_1=1; bbr_yn_2=0; end;
if QC_PHX_BBR_YN_1=3 then do; bbr_yn_0=0; bbr_yn_1=0; bbr_yn_2=1; end;

if cbr_pch_amt=1 then do; amt_1=1; amt_2=0; amt_3=0; amt_4=0; end;
if cbr_pch_amt=2 then do; amt_1=0; amt_2=1; amt_3=0; amt_4=0; end;
if cbr_pch_amt=3 then do; amt_1=0; amt_2=0; amt_3=1; amt_4=0; end;
if cbr_pch_amt=4 then do; amt_1=0; amt_2=0; amt_3=0; amt_4=1; end; run;
DATA MN1_OR; SET MN1SORT;
if age1=1 then do; age1_1=1; age1_2=0; age1_3=0; end;
if age1=2 then do; age1_1=0; age1_2=1; age1_3=0; end;
if age1=3 then do; age1_1=0; age1_2=0; age1_3=1; end;

if qc_phx_bbr_yn_1=0 then do; bbr_yn_0=1; bbr_yn_1=0; bbr_yn_2=0; end;
if qc_phx_bbr_yn_1=1 then do; bbr_yn_0=0; bbr_yn_1=1; bbr_yn_2=0; end;
if qc_phx_bbr_yn_1=2 then do; bbr_yn_0=0; bbr_yn_1=0; bbr_yn_2=1; end;

if cbr_pch_amt=1 then do; amt_1=1; amt_2=0; amt_3=0; amt_4=0; end;
if cbr_pch_amt=2 then do; amt_1=0; amt_2=1; amt_3=0; amt_4=0; end;
if cbr_pch_amt=3 then do; amt_1=0; amt_2=0; amt_3=1; amt_4=0; end;
if cbr_pch_amt=4 then do; amt_1=0; amt_2=0; amt_3=0; amt_4=1; end; run;

proc logistic data=MN0_OR descending;
class age1_1(ref="1") age1_2(ref="1") age1_3(ref="1") 
BMI_1(ref="1") amt_1(ref="1") amt_2(ref="1") amt_3(ref="1") amt_4(ref="1") 
bbr_yn_0(ref="1") bbr_yn_1(ref="1") 
MNC_AGE1(ref="2") QC_DLV_FRQ_1(ref="1") QC_BRFD_DRT_1(ref="1") Q_SMK_YN_1(ref="1") DRK_FRQ_1(ref="1") EXER1(ref="1") FAM_CBR(ref="1") bc(ref="1");
model cluster=age1_1 age1_2 age1_3 BMI_1 amt_1 amt_2 amt_3 amt_4 bbr_yn_0 bbr_yn_1 bbr_yn_2 MNC_AGE1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 DRK_FRQ_1 EXER1 FAM_CBR bc;
run;
proc logistic data=MN1_OR descending;
class age1_1(ref="1") age1_2(ref="1") age1_3(ref="1") 
BMI_1(ref="1") amt_1(ref="1") amt_2(ref="1") amt_3(ref="1") amt_4(ref="1") 
bbr_yn_0(ref="1") bbr_yn_1(ref="1") bbr_yn_2(ref="1") 
MNC_AGE1(ref="2") MNP_AGE1(ref="1") QC_DLV_FRQ_1(ref="1") QC_BRFD_DRT_1(ref="1") Q_SMK_YN_1(ref="1") DRK_FRQ_1(ref="1") EXER1(ref="1") FAM_CBR(ref="1") bc(ref="1");
model cluster=age1_1 age1_2 age1_3 BMI_1 amt_1 amt_2 amt_3 amt_4 bbr_yn_0 bbr_yn_1 bbr_yn_2 MNC_AGE1 MNP_AGE1 QC_DLV_FRQ_1 QC_BRFD_DRT_1 Q_SMK_YN_1 DRK_FRQ_1 EXER1 FAM_CBR bc;
run;

proc phreg data=MN0_OR; 
class bc(param=ref ref="1") age1_1 (param=ref ref="1") age1_2 (param=ref ref="1") age1_3 (param=ref ref="1")
      BMI_1 (param=ref)
      amt_1 (param=ref ref="1") amt_2 (param=ref  ref="1") amt_3 (param=ref  ref="1") amt_4 (param=ref  ref="1") 
      bbr_yn_0 (param=ref  ref="1") bbr_yn_1 (param=ref ref="1") 
      MNC_AGE1 (param=ref ref="2")
      qc_dlv_frq_1 (param=ref ref="1") 
      qc_brfd_drt_1 (param=ref ref="1")
      q_smk_yn_1  (param=ref ref="1") 
      DRK_FRQ_1 (param=ref ref="1") 
      exer1 (param=ref ref="1")  
      fam_cbr (param=ref ref="1") ;    
model cluster=bc age1_1 age1_2 age1_3 BMI_1 amt_1 amt_2 amt_3 amt_4 
bbr_yn_0 bbr_yn_1 bbr_yn_2 MNC_AGE1 qc_dlv_frq_1 qc_brfd_drt_1 
q_smk_yn_1 DRK_FRQ_1 exer1 fam_cbr /risklimits; run;

ods chtml close;
ods listing;

proc phreg data=MN1_OR; 
class bc(param=ref ref="1") age1_1 (param=ref ref="1") age1_2 (param=ref ref="1") age1_3 (param=ref ref="1")
      BMI_1 (param=ref)
      amt_1 (param=ref ref="1") amt_2 (param=ref  ref="1") amt_3 (param=ref  ref="1") amt_4 (param=ref  ref="1") 
      bbr_yn_0 (param=ref  ref="1") bbr_yn_1 (param=ref ref="1") bbr_yn_2 (param=ref  ref="1")
      MNC_AGE1 (param=ref ref="2")
      MNP_AGE1 (param=ref ref="1")
      qc_dlv_frq_1 (param=ref ref="1") 
      qc_brfd_drt_1 (param=ref ref="1")
      q_smk_yn_1  (param=ref ref="1") 
      DRK_FRQ_1 (param=ref ref="1") 
      exer1 (param=ref ref="1")  
      fam_cbr (param=ref ref="1") ;    
model cluster=bc age1_1 age1_2 age1_3 BMI_1 amt_1 amt_2 amt_3 amt_4 
bbr_yn_0 bbr_yn_1 bbr_yn_2 MNC_AGE1 MNP_AGE1 qc_dlv_frq_1 qc_brfd_drt_1 
q_smk_yn_1 DRK_FRQ_1 exer1 fam_cbr /risklimits; run;

ods chtml close;
ods listing;


/************************************************************************************************************************************************************************/
/************************************************************************************************************************************************************************/
/*70% data*/
data song.temp_70; set song.temp; run;
proc freq data=song.temp_70; table C50 D05; run;

data song.temp_70; set song.temp_70;
if C50=1 then BC=1;
else if C50=0 and D05=0 then BC=0;
else if C50=0 and D05=1 then delete; run;
proc freq data=song.temp_70; table age BC; run;

proc freq data=song.temp_70;
table CBR_PCH_AMT QC_PHX_BBR_YN QC_MNC_AGE MNS_YN_1 MNP_AGE QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR BC G1E_BMI/LIST MISSING;
run;

data song.temp_70; set song.temp_70;
if AGE<=49 then AGE_1=1; else if 50<=AGE<=59 then AGE_1=2; else if 60<=AGE<=69 then AGE_1=3;

if QC_MNC_AGE<15 then MNC_AGE=1; else if QC_MNC_AGE>=15 then MNC_AGE=2;

if 1<=MNP_AGE<52 then MNP_AGE_1=1; else if MNP_AGE=0 then MNP_AGE_1=0; else if MNP_AGE>=52 then MNP_AGE_1=2;

if QC_DLV_FRQ=1 then DLV_FRQ=1; else if QC_DLV_FRQ=2 then DLV_FRQ=1; else if QC_DLV_FRQ=3 then DLV_FRQ=0;

if QC_BRFD_DRT=1 then BRFD_DRT=1; else if QC_BRFD_DRT=2 then BRFD_DRT=1; else if QC_BRFD_DRT=3 then BRFD_DRT=1; else if QC_BRFD_DRT=4 then BRFD_DRT=0;

if Q_SMK_YN=1 then SMK_YN=0; else if Q_SMK_YN=2 then SMK_YN=0; else if Q_SMK_YN=3 then SMK_YN=1;

if Q_DRK_FRQ_V09N=0 then DRK_FRQ=0; else if Q_DRK_FRQ_V09N>0 then DRK_FRQ=1;

if EXER=0 then EXER_1=0; else if EXER>=1 then EXER_1=1;

if G1E_BMI<23 then BMI=0; else if G1E_BMI>=23 then BMI=1; run;

proc freq data=song.temp_70;
tables AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNS_YN_1 MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR; run;

data song.temp_70; set song.temp_70;
FU_YEAR=FU_DAY/365.25; run;

data temp_mns0 temp_mns1; set song.temp_70;
if MNS_YN_1=1 then output temp_mns0;
else output temp_mns1; run;
proc freq data=temp_mns0;
table MNP_AGE_1; run;
proc freq data=temp_mns1;
table MNP_AGE_1; run;

/*폐경전군집분석*/
proc fastclus data=temp_mns0 out=mns0_clu maxclusters=3 maxiter=100;
var AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ;
run;
proc sort data=mns0_clu out=song.mns0_sort;
by cluster; run;
PROC FREQ DATA=song.mns0_sort;
TABLE (AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR BC)*CLUSTER/CHISQ;
RUN;

proc logistic data=song.mns0_sort descending;
class AGE_1(ref="2") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1")  
DLV_FRQ(ref="1") BRFD_DRT(ref="1") SMK_YN(ref="0") DRK_FRQ(ref="1") EXER_1(ref="1") FAM_CBR(ref="1") ;
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR; 
run;
proc logistic data=song.mns0_sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns0_sort; 
class AGE_1(param=ref ref="2") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1")  
DLV_FRQ(param=ref ref="1") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="0") DRK_FRQ(param=ref ref="1") EXER_1(param=ref ref="1") 
FAM_CBR(param=ref ref="1");   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns0_sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;


/*폐경후군집분석*/
proc fastclus data=temp_mns1 out=mns1_clu maxclusters=3 maxiter=100;
var AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR;
run;
proc sort data=mns1_clu out=song.mns1_sort;
by cluster; run;
PROC FREQ DATA=song.mns1_sort;
TABLE (AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR BC)*CLUSTER/CHISQ;
RUN;

proc logistic data=song.mns1_sort descending;
class AGE_1(ref="2") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1") MNP_AGE_1(ref="1")  
DLV_FRQ(ref="1") BRFD_DRT(ref="1") SMK_YN(ref="0") DRK_FRQ(ref="1") EXER_1(ref="1") FAM_CBR(ref="1") ;
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ; 
run;
proc logistic data=song.mns1_sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns1_sort;
class AGE_1(param=ref ref="2") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1") MNP_AGE_1(param=ref ref="1") 
DLV_FRQ(param=ref ref="1") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="0") DRK_FRQ(param=ref ref="1") EXER_1(param=ref ref="1") 
FAM_CBR(param=ref ref="1");   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns1_sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;

/*30% data*/
libname EX "/userdata07/room284/data_source/ANALYSIS/SUBJECT";
data TEMP; set EX.BR_NCS_0910;
if CBR_JDG_CBR=. then delete; 
else if CBR_PCH_AMT=. then delete; /**/
else if CBR_FND1=. then delete; 
else if QC_PHX_BBR_YN=. then delete; /**/
else if QC_MNC_AGE=. then delete; /**/
else if MNS_YN_1=. then delete; /**/
else if MNP_AGE=. then delete; /**/
else if ERT_YN=. then delete; 
else if QC_DLV_FRQ=. then delete; /**/
else if QC_BRFD_DRT=. then delete; /**/
else if QC_OPLL_YN=. then delete; 
else if G1E_HGHT=. then delete; 
else if G1E_WGHT=. then delete;  /*키, 몸무게는 체질량지수로 대체*/
else if G1E_BP_SYS=. then delete; 
else if G1E_BP_DIA=. then delete; 
else if G1E_HGB=. then delete; 
else if G1E_FBS=. then delete; 
else if G1E_TOT_CHOL=. then delete; 
else if G1E_SGOT=. then delete; 
else if G1E_SGPT=. then delete; 
else if G1E_GGT=. then delete; 
else if G1E_WSTC=. then delete; 
else if G1E_TG=. then delete; 
else if G1E_HDL=. then delete; 
else if G1E_LDL=. then delete; 
else if Q_SMK_YN=. then delete;  /**/
else if Q_DRK_FRQ_V09N=. then delete;  /**/
else if EXER=. then delete;  /**/
else if FAM_CBR=. then delete;  /**/
run;  /*WORK.TEMP은(는) 4110781개 관측값과 129개 변수*/
data TEMP; set TEMP;
    if INDI_DSCM_NO="" then delete; else if FU_DAY<180 then delete; else if RVSN_ADDR_CD="" then delete; 
    if AGE<40 then delete; else if AGE>69 then delete; 
run; /*WORK.TEMP은(는) 3574866개 관측값과 129개 변수*/
data TEMP; set TEMP; 
SIDO_1=substr(RVSN_ADDR_CD,1,2); drop RVSN_ADDR_CD; 
HME_M=month(HME_DT); drop HME_DT; run; 
proc sort data=TEMP; by AGE EXMD_BZ_YYYY SIDO_1 HME_M QC_MNS_YN; run; 

data song.BR_NCS_09_10_ALL; set temp; run;
data test; set song.BR_NCS_09_10_ALL; run;

proc sql;
create table test_30 as
select *
from test one left join song.temp two
on one.INDI_DSCM_NO=two.INDI_DSCM_NO
where two.INDI_DSCM_NO is null;
quit;
data song.temp_30; set test_30; run;

proc freq data=test_30; table C50 D05; run;

data song.test_30; set test_30;
if C50=1 then BC=1;
else if C50=0 and D05=0 then BC=0;
else if C50=0 and D05=1 then delete; run;
proc freq data=song.test_30; table age BC; run;

proc freq data=song.test_30;
table CBR_PCH_AMT QC_PHX_BBR_YN QC_MNC_AGE MNS_YN_1 MNP_AGE QC_DLV_FRQ QC_BRFD_DRT Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR BC G1E_BMI/LIST MISSING;
run;

data song.test_30; set song.test_30;
if AGE<=49 then AGE_1=1; else if 50<=AGE<=59 then AGE_1=2; else if 60<=AGE<=69 then AGE_1=3;

if QC_MNC_AGE<15 then MNC_AGE=1; else if QC_MNC_AGE>=15 then MNC_AGE=2;

if 1<=MNP_AGE<52 then MNP_AGE_1=1; else if MNP_AGE=0 then MNP_AGE_1=0; else if MNP_AGE>=52 then MNP_AGE_1=2;

if QC_DLV_FRQ=1 then DLV_FRQ=1; else if QC_DLV_FRQ=2 then DLV_FRQ=1; else if QC_DLV_FRQ=3 then DLV_FRQ=0;

if QC_BRFD_DRT=1 then BRFD_DRT=1; else if QC_BRFD_DRT=2 then BRFD_DRT=1; else if QC_BRFD_DRT=3 then BRFD_DRT=1; else if QC_BRFD_DRT=4 then BRFD_DRT=0;

if Q_SMK_YN=1 then SMK_YN=0; else if Q_SMK_YN=2 then SMK_YN=0; else if Q_SMK_YN=3 then SMK_YN=1;

if Q_DRK_FRQ_V09N=0 then DRK_FRQ=0; else if Q_DRK_FRQ_V09N>0 then DRK_FRQ=1;

if EXER=0 then EXER_1=0; else if EXER>=1 then EXER_1=1;

if G1E_BMI<23 then BMI=0; else if G1E_BMI>=23 then BMI=1; run;

proc freq data=song.test_30;
tables AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNS_YN_1 MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR; run;

data song.test_30; set song.test_30;
FU_YEAR=FU_DAY/365.25; run;

data temp_mns0 temp_mns1; set song.test_30;
if MNS_YN_1=1 then output temp_mns0;
else output temp_mns1; run;
proc freq data=temp_mns0;
table MNP_AGE_1; run;
proc freq data=temp_mns1;
table MNP_AGE_1; run;

/*폐경전군집분석*/
proc fastclus data=temp_mns0 out=mns0_clu maxclusters=3 maxiter=100;
var AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ;
run;
proc sort data=mns0_clu out=song.mns0_30sort;
by cluster; run;
PROC FREQ DATA=song.mns0_30sort;
TABLE (AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR BC)*CLUSTER/CHISQ;
RUN;

proc logistic data=song.mns0_30sort descending;
class AGE_1(ref="2") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1")  
DLV_FRQ(ref="1") BRFD_DRT(ref="1") SMK_YN(ref="0") DRK_FRQ(ref="1") EXER_1(ref="1") FAM_CBR(ref="1");
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ; 
run;
proc logistic data=song.mns0_30sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns0_30sort; 
class AGE_1(param=ref ref="2") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1")  
DLV_FRQ(param=ref ref="1") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="0") DRK_FRQ(param=ref ref="1") EXER_1(param=ref ref="1") 
FAM_CBR(param=ref ref="1") ;   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns0_30sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;


/*폐경후군집분석*/
proc fastclus data=temp_mns1 out=mns1_clu maxclusters=3 maxiter=100;
var AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ;
run;
proc sort data=mns1_clu out=song.mns1_30sort;
by cluster; run;
PROC FREQ DATA=song.mns1_30sort;
TABLE (AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR BC)*CLUSTER/CHISQ;
RUN;

proc logistic data=song.mns1_30sort descending;
class AGE_1(ref="2") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1") MNP_AGE_1(ref="1")  
DLV_FRQ(ref="1") BRFD_DRT(ref="1") SMK_YN(ref="0") DRK_FRQ(ref="1") EXER_1(ref="1") FAM_CBR(ref="1") ;
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ; 
run;
proc logistic data=song.mns1_30sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns1_30sort;
class AGE_1(param=ref ref="2") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1") MNP_AGE_1(param=ref ref="1") 
DLV_FRQ(param=ref ref="1") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="0") DRK_FRQ(param=ref ref="1") EXER_1(param=ref ref="1") 
FAM_CBR(param=ref ref="1") ;   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns1_30sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;





/********************************************************************************************************************************************/
/*70% ref*/
/*전*/
proc logistic data=song.mns0_sort descending;
class AGE_1(ref="3") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1")  
DLV_FRQ(ref="0") BRFD_DRT(ref="1") SMK_YN(ref="1") DRK_FRQ(ref="0") EXER_1(ref="0") FAM_CBR(ref="1") ;
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR; 
run;
proc logistic data=song.mns0_sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns0_sort; 
class AGE_1(param=ref ref="3") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1")  
DLV_FRQ(param=ref ref="0") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="1") DRK_FRQ(param=ref ref="0") EXER_1(param=ref ref="0") 
FAM_CBR(param=ref ref="1");   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns0_sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;
/*후*/
proc logistic data=song.mns1_sort descending;
class AGE_1(ref="3") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1") MNP_AGE_1(ref="1")  
DLV_FRQ(ref="0") BRFD_DRT(ref="1") SMK_YN(ref="1") DRK_FRQ(ref="0") EXER_1(ref="0") FAM_CBR(ref="1") ;
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ; 
run;
proc logistic data=song.mns1_sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns1_sort;
class AGE_1(param=ref ref="3") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1") MNP_AGE_1(param=ref ref="1") 
DLV_FRQ(param=ref ref="0") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="1") DRK_FRQ(param=ref ref="0") EXER_1(param=ref ref="0") 
FAM_CBR(param=ref ref="1");   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns1_sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;
/*30% ref*/
/*전*/
proc logistic data=song.mns0_30sort descending;
class AGE_1(ref="3") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1")  
DLV_FRQ(ref="0") BRFD_DRT(ref="1") SMK_YN(ref="1") DRK_FRQ(ref="0") EXER_1(ref="0") FAM_CBR(ref="1");
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ; 
run;
proc logistic data=song.mns0_30sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns0_30sort; 
class AGE_1(param=ref ref="3") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1")  
DLV_FRQ(param=ref ref="0") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="1") DRK_FRQ(param=ref ref="0") EXER_1(param=ref ref="0") 
FAM_CBR(param=ref ref="1") ;   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns0_30sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;
/*후*/
proc logistic data=song.mns1_30sort descending;
class AGE_1(ref="2") BMI(ref="0") CBR_PCH_AMT(ref="1") QC_PHX_BBR_YN(ref="1") MNC_AGE(ref="1") MNP_AGE_1(ref="1")  
DLV_FRQ(ref="1") BRFD_DRT(ref="1") SMK_YN(ref="0") DRK_FRQ(ref="1") EXER_1(ref="1") FAM_CBR(ref="1") ;
model bc = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR ; 
run;
proc logistic data=song.mns1_30sort descending;
class cluster(ref="1");
model bc=cluster; run;
proc phreg data=song.mns1_30sort;
class AGE_1(param=ref ref="2") BMI(param=ref ref="0") CBR_PCH_AMT(param=ref ref="1") QC_PHX_BBR_YN(param=ref ref="1") MNC_AGE(param=ref ref="1") MNP_AGE_1(param=ref ref="1") 
DLV_FRQ(param=ref ref="1") BRFD_DRT(param=ref ref="1") SMK_YN(param=ref ref="0") DRK_FRQ(param=ref ref="1") EXER_1(param=ref ref="1") 
FAM_CBR(param=ref ref="1") ;   
model FU_YEAR*bc(0) = AGE_1 BMI CBR_PCH_AMT QC_PHX_BBR_YN MNC_AGE MNP_AGE_1 DLV_FRQ BRFD_DRT SMK_YN DRK_FRQ EXER_1 FAM_CBR /risklimits; run;
proc phreg data=song.mns1_30sort;
class CLUSTER(param=ref ref="1");
model FU_YEAR*bc(0) =cluster/risklimits; run;
