libname EX "/userdata07/room284/data_source/ANALYSIS/SUBJECT";
libname CL "/userdata07/room284/data_source/ANALYSIS/Cluster";


/**********************       EX.BR_NCS_0910_TEST 이용
               만드는 과정은 /userdata07/room284/data_source/ANALYSIS/SUBJECT/Subcohort_Extraction_09_10_210318.sas    ***************/

data CL.BR_NCS_0910_TEST; set EX.BR_NCS_0910_TEST; run; /*CL.BR_NCS_0910_TEST은(는) 2502407개 관측값과 135개 변수*/
proc contents data=CL.BR_NCS_0910_TEST;run; 

/*연속변수의 분포 확인*/
proc univariate data=CL.BR_NCS_0910_TEST; var QC_MNC_AGE G1E_BMI
G1E_BP_SYS G1E_BP_DIA G1E_URN_PROT G1E_HGB G1E_FBS G1E_TOT_CHOL G1E_SGOT G1E_SGPT G1E_GGT
G1E_WSTC G1E_TG G1E_HDL G1E_LDL G1E_CRTN G1E_GFR  ; run; 
proc univariate data=CL.BR_NCS_0910_TEST; where MNS_YN_1=1; var MNP_AGE; run; 
proc univariate data=CL.BR_NCS_0910_TEST; where MNS_YN_1=2; var MNP_AGE; run; 
proc freq data= CL.BR_NCS_0910_TEST; 
tables QC_PHX_BBR_YN QC_DLV_FRQ QC_BRFD_DRT QC_OPLL_YN Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR; run; 


data CL.BR_NCS_0910_TEST; set CL.BR_NCS_0910_TEST; 
if 40<=AGE<45 then AGEGP_1=1; else if 45<=AGE<50 then AGEGP_1=2; else if 50<=AGE<55 then AGEGP_1=3; else if 55<=AGE<60 then AGEGP_1=4; 
    else if 60<=AGE<65 then AGEGP_1=5;  else if 65<=AGE<70 then AGEGP_1=6;
	label AGEGP_1="검진받은 연령: 5세 단위"; 
if QC_MNC_AGE<=14 then MENAAGE_1=1; else if QC_MNC_AGE<=16 then MENAAGE_1=2;  else if QC_MNC_AGE<=17 then MENAAGE_1=3; 
    else if QC_MNC_AGE<30 then MENAAGE_1=4; else MENAAGE_1=999;
	label MENAAGE_1="초경연령 4분위"; 
if QC_MNC_AGE<=16 then MENAAGE_2=1; else if QC_MNC_AGE<30 then MENAAGE_2=4; else MENAAGE_2=999;
	label MENAAGE_2="초경연령 중위수"; 
if MNP_AGE=0 then MENOAGE_1=8; else if MNP_AGE<=20 then MENOAGE_1=999; else if MNP_AGE<=45 then MENOAGE_1=1; else if MNP_AGE<=50 then MENOAGE_1=2; 
    else if MNP_AGE<=55 then MENOAGE_1=3; else MENOAGE_1=4;
	label MENOAGE_1="폐경연령 5세 단위"; 
if QC_BRFD_DRT=4 then BRFD_1=0; else if QC_BRFD_DRT in (1,2) then BRFD_1=1; else if QC_BRFD_DRT in (3) then BRFD_1=2;
	label BRFD_1="모유수유"; 
if Q_DRK_FRQ_V09N=0 then DRK_1=0; else if Q_DRK_FRQ_V09N in (1,2) then DRK_1=1; else DRK_1=2; 
	label DRK_1="음주일수 0 1-2 3이상"; 
if EXER=0 then EXER_1=0; else if EXER in (1,2,3) then EXER_1=1; else EXER_1=2; 
	label EXER_1="운동일수";
if G1E_BMI=. then BMI_1=999; else if G1E_BMI<9 then BMI_1=999; else if G1E_BMI>100 then BMI_1=999; 
    else if G1E_BMI<23 then BMI_1=1; else if G1E_BMI<25 then BMI_1=2; else BMI_1=3; 
    label BMI_1="BMI 23, 25 기준";
if G1E_WSTC=. then WSTC_1=999; else if G1E_WSTC<20 then WSTC_1=999; else if G1E_WSTC>300 then WSTC_1=999; 
    else if G1E_WSTC<80 then WSTC_1=0; else WSTC_1=1; 
	label WSTC_1="허리둘레 80 기준";
if G1E_FBS=. then FBS_1=999; else if G1E_FBS<10 then FBS_1=999; else if G1E_FBS>2000 then FBS_1=999; 
    else if G1E_FBS<126 then FBS_1=0; else FBS_1=1;
	label FBS_1="공복혈당 126 기준";
if G1E_TG=. then TG_1=999; else if G1E_TG<5 then TG_1=999; else if G1E_TG>10000 then TG_1=999;  
   else if G1E_TG<150 then TG_1=0; else TG_1=1;
   label TG_1="TG 150 기준";
if G1E_HDL=. then HDL_1=999.; else if G1E_HDL<1 then HDL_1=999; else if G1E_HDL>5000 then HDL_1=999; 
   else if G1E_HDL<50 then HDL_1=1; else HDL_1=0;
   label HDL_1="HDL 50 기준";
if G1E_BP_SYS=. or G1E_BP_DIA =. then BP_1=999; 
   else if G1E_BP_SYS<130 and G1E_BP_DIA<85 then BP_1=0; else BP_1=1; 
   label BP_1="고혈압 기준";
run; 
/*변수가 범주형임을 인식*/
proc format; 
value QC_PHX_BBR_YN 1='양성종양유' 2='양성종양무' 3='모름';
value AGEGP 1='40<=AGE<45' 2='45<=AGE<50' 3='50<=AGE<55' 4='55<=AGE<60' 5='60<=AGE<65' 6='65<=AGE<70'; 
value MENAAGE 1='AGE<=14' 2='AGE<=16' 3='AGE<=17' 4='AGE>17' 999='모름';
value MENOAGE 0='PREMENO' 1='AGE<=45' 2='AGE<=50' 3='AGE<=55' 4='AGE>55' 999='모름';
value ERT_YN 0='PREMENO' 1='NEVER' 2='<5YR' 3='>=5YR' 999='모름';
value QC_OPLL_YN 1='NEVER' 2='<1YR' 3='>=1YR' 4='모름' 999='모름';
value QC_DLV_FRQ 1='자녀1' 2='자녀2+' 3='자녀무' 999='모름'; 
value BRFD 0='NO' 1='<1yr' 2='>=1yr' 999='모름'; 
value Q_SMK_YN 1='NO' 2='PAST' 3='CURRENT' 999='모름';
value DRK 0='NO' 1='1-2 DAY' 2='>=3 DAY' 999='모름'; 
value EXER 0='NO' 1='1-3 DAY' 2='>=4 DAY' 999='모름';
value BMI 1='<23' 2='<25' 3='>=25' 999='모름';
value FAM_CBR 0='NO' 1='YES' 999='모름';
run; 
data CL.BR_NCS_0910_TEST; set CL.BR_NCS_0910_TEST; 
format QC_PHX_BBR_YN QC_PHX_BBR_YN.;
format AGEGP_1 AGEGP.;
format MENAAGE_1 MENAAGE.;
format MENOAGE_1 MENOAGE.;
format ERT_YN ERT_YN.;
format QC_OPLL_YN QC_OPLL_YN.;
format QC_DLV_FRQ QC_DLV_FRQ.;
format BRFD_1 BRFD.;
format Q_SMK_YN Q_SMK_YN.;
format DRK_1 DRK.;
format EXER_1 EXER.;
format BMI_1 BMI.;
format FAM_CBR FAM_CBR.;
run;  
 
data CL.BR_NCS_0910_TEST; set CL.BR_NCS_0910_TEST; 
format CBR_PCH_AMT_2 $16.;
format PHX_BBR_YN_2 $16.; 
format AGEGP_2 $16.; 
format MENAAGE_2 $16.; 
format MENOAGE_2 $16.; 
format ERT_YN_2 $16.; 
format OPLL_YN_2 $16.; 
format DLV_FRQ_2 $16.;
format BRFD_2 $16.; 
format SMK_YN_2 $16. ;
format DRK_2 $16.; 
format EXER_2 $16. ;
format BMI_2 $16. ;
format FAM_CBR_2 $16.; 
if CBR_PCH_AMT=4 then CBR_PCH_AMT_2='100%'; else if CBR_PCH_AMT=1 then CBR_PCH_AMT_2='25%'; else if CBR_PCH_AMT=2 then CBR_PCH_AMT_2='50%';
    else if CBR_PCH_AMT=3 then CBR_PCH_AMT_2='75%';
if QC_PHX_BBR_YN=1 then PHX_BBR_YN_2='양성종양유'; else if QC_PHX_BBR_YN=2 then PHX_BBR_YN_2='양성종양무'; else if QC_PHX_BBR_YN=3 then PHX_BBR_YN_2='양성종양모름';
if AGEGP_1=1 then AGEGP_2='AGE<45'; else if AGEGP_1=2 then AGEGP_2='AGE<50';else if AGEGP_1=3 then AGEGP_2='AGE<55'; else if AGEGP_1=4 then AGEGP_2='AGE<60'; 
    else if AGEGP_1=5 then AGEGP_2='AGE<65'; else if AGEGP_1=6 then AGEGP_2='AGE<70'; 
if MENAAGE_1=1 then MENAAGE_2='AGE<=14'; else if MENAAGE_1=2 then MENAAGE_2='AGE<=16'; else if MENAAGE_1=3 then MENAAGE_2='AGE>=17'; 
    else if MENAAGE_1=4 then MENAAGE_2='AGE>=17'; else if MENAAGE_1=999 then MENAAGE_2='초경연령모름';
if MENOAGE_1=8 then MENOAGE_2='PREMENO'; else if MENOAGE_1=1 then MENOAGE_2='AGE<=45'; else if MENOAGE_1=2 then MENOAGE_2='AGE<=50'; 
    else if MENOAGE_1=3 then MENOAGE_2='AGE>50'; else if MENOAGE_1=4 then MENOAGE_2='AGE>50'; else if MENOAGE_1=999 then MENOAGE_2='폐경연령모름';
if ERT_YN=0 then ERT_YN_2='PREMENO'; else if  ERT_YN=1then ERT_YN_2='NEVER'; else if ERT_YN=2 then ERT_YN_2='<5YR'; else if ERT_YN=3 then ERT_YN_2='>=5YR'; else if ERT_YN=999 then ERT_YN_2='HRT모름';
if QC_OPLL_YN=1 then OPLL_YN_2='NEVER'; else if QC_OPLL_YN=2 then OPLL_YN_2='<1YR'; else if QC_OPLL_YN=3 then OPLL_YN_2='>=1YR'; else if QC_OPLL_YN=4 then OPLL_YN_2='피임약모름'; 
   else if QC_OPLL_YN=999 then OPLL_YN_2='피임약모름';
if QC_DLV_FRQ=3 then DLV_FRQ_2='자녀0';  else if QC_DLV_FRQ=1 then DLV_FRQ_2='자녀1'; else if QC_DLV_FRQ=2 then DLV_FRQ_2='자녀2+'; else if QC_DLV_FRQ=999 then DLV_FRQ_2='자녀모름'; 
if BRFD_1=2 then BRFD_2='>=1yr';else if BRFD_1=0 then BRFD_2='NOBR'; else if BRFD_1=1 then BRFD_2='<1yr';  else if BRFD_1=999 then BRFD_2='모유모름'; 
if Q_SMK_YN=1 then SMK_YN_2='NOSMK'; else if Q_SMK_YN=2 then SMK_YN_2='NOSMK'; else if Q_SMK_YN=3 then SMK_YN_2='CURSMOK'; else if Q_SMK_YN=999 then SMK_YN_2='흡연모름';
if DRK_1=0 then DRK_2='NODRK'; else if DRK_1=1 then DRK_2='DRK1-2DAY'; else if DRK_1=2 then DRK_2='DRK3 DAY';  else if DRK_1=999 then DRK_2='음주모름'; 
if EXER_1=0 then EXER_2='NOEXER'; else if EXER_1=1 then EXER_2='EX1-3DAY';else if EXER_1=2 then EXER_2='EX>=4DAY'; else if EXER_1=999 then EXER_2='운동모름';
if BMI_1=1 then BMI_2='<23'; else if BMI_1=2 then BMI_2='<25'; else if BMI_1=3 then BMI_2='>=25';else if BMI_1=999 then BMI_2='비만모름';
if FAM_CBR=1 then FAM_CBR_2='FAMYES'; else if FAM_CBR=0 then FAM_CBR_2='FAMNO'; else if FAM_CBR=999 then FAM_CBR_2='FAM모름';
run; 
proc freq data= CL.BR_NCS_0910_TEST; 
tables QC_PHX_BBR_YN*PHX_BBR_YN_2 AGEGP_1*AGEGP_2 MENAAGE_1*MENAAGE_2 MENOAGE_1*MENOAGE_2 ERT_YN*ERT_YN_2 QC_OPLL_YN*OPLL_YN_2 
 QC_DLV_FRQ*DLV_FRQ_2 BRFD_1*BRFD_2 Q_SMK_YN*SMK_YN_2 DRK_1*DRK_2 EXER_1*EXER_2 BMI_1*BMI_2 FAM_CBR*FAM_CBR_2/list missing; run; 
proc contents data=CL.BR_NCS_0910_TEST; run; 
proc freq data= CL.BR_NCS_0910_TEST; where QC_DLV_FRQ=3; tables QC_DLV_FRQ /list missing; run; 

data TEMP;  set CL.BR_NCS_0910_TEST;
if MENAAGE_1=999 or MENOAGE_1=999 or BMI_1=999 or WSTC_1=999 or FBS_1=999 or TG_1=999 or HDL_1=999 or BP_1=999 then delete; 
FU_YEAR=FU_DAY/365.25; 
run;  /*2500349개 관측값과 146개 변수. 데이터셋 만들때 부터 추적기간 180미만은 제외*/
proc freq data= TEMP; tables QC_PHX_BBR_YN CBR_PCH_AMT; run; 
proc univariate data=TEMP; var FU_YEAR; run; 

/*****다변량 적합성 검정*****/
/*전체*/
proc factor data=TEMP method=PRINCIPAL corr msa rotate= VARIMAX;
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc factor data=TEMP method=ML corr msa rotate= VARIMAX;
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
/*폐경전*/
proc factor data=TEMP method=PRINCIPAL corr msa rotate= VARIMAX;where MENOAGE_1=8;
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc factor data=TEMP method=ML corr msa rotate= VARIMAX;where MENOAGE_1=8;
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
/*폐경후*/
proc factor data=TEMP method=PRINCIPAL corr msa rotate= VARIMAX;where MENOAGE_1 in (1,2,3,4);
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc factor data=TEMP method=ML corr msa rotate= VARIMAX;where MENOAGE_1 in (1,2,3,4);
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 

/******SCREE PLOT*****/
/*전체*/
ods graphics on; 
proc princomp data=TEMP  cov out=TEMP1; ods select ScreePlot; 
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run;  
/*폐경전*/
ods graphics on; 
proc princomp data=TEMP cov out=TEMP1; ods select ScreePlot; where MENOAGE_1=8;
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run;  
/*폐경후*/
ods graphics on; 
proc princomp data=TEMP cov out=TEMP1; ods select ScreePlot; where MENOAGE_1 in (1,2,3,4);
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run;  

proc contents data=TEMP; run; 

/*******MCA 분석: 전체 변수 가지고*******/
/* 전체*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=6 plots=all; 
tables CBR_PCH_AMT_2 PHX_BBR_YN_2 AGEGP_2 MENAAGE_2 MENOAGE_2 ERT_YN_2 OPLL_YN_2 DLV_FRQ_2 BRFD_2 SMK_YN_2 DRK_2 EXER_2 BMI_2 FAM_CBR_2; 
run; 
ods graphics off; 

proc prinqual data=TEMP out= TEMP1 n=3 replace mdpref;
title2 'Multidemensional Preference (MDPREF) Analysis';
title3 'Optimal Monotonoc Transformation of Preference Data';
id INDI_DSCM_NO; 
transform monotone (CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN
DRK_1 EXER_1 BMI_1 FAM_CBR); 
run; 
ods graphics on; 
proc princomp data=TEMP1; ods select ScreePlot; 
var CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
where _TYPE_='SCORE'; 
run; 
ods graphics on; 
proc prinqual data= TEMP out=RESULTS n=2 replace mdpref; 
title2 'Multidemensional Preference (MDPREF) Analysis';
title3 'Optimal Monotonoc Transformation of Preference Data';
id INDI_DSCM_NO; 
transform monotone (CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN
DRK_1 EXER_1 BMI_1 FAM_CBR); 
run; 
/*For pictures*/
proc template; 
define statgraph Stat.Prinqual.Graphics.MDPref; 
notes "Multidimensional Preference Analysis Plot"; 
dynamic xVar yVar xVec yVec ylab xlab yshortlab xshortla xOri yOri stretch; 
begingraph; 
entrytitle "Multidementisonal Preference Analysis"; 
layout overlayequated/* / equatetype=fit xaxisopts=(label=XLAB shortlabel=XSHORTLAB offsetmin=0.1 offsetmax=0.1)
yaxisopts=(label=YLAB shortlabel=YSHORTLAB offsetmin=0.1 offsetmax=0.1)*/; 
scatterplot y=YVAR x=XVAR / datalabel=IDLAB1 rolename=(_tip1=OBSNUMVAR _id2=IDLAB2 _id3=IDLAB3 _id4=IDLAB4 _id5=IDLAB5 _id6=IDLAB6 _id7=IDLAB7 _id8=IDLAB8 
 _id9=IDLAB9 _id10=IDLAB10 _id11=IDLAB11 _id12=IDLAB12 _id13=IDLAB13 _id14=IDLAB14 _id15=IDLAB15 _id16=IDLAB16 _id17=IDLAB17 _id18=IDLAB18 _id19=IDLAB19 _id20=IDLAB20)
 tip=(x y datalabel _tip1 _id2 _id3 _id4 _id5 _id6 _id7 _id8 _id9 _id10 _id11 _id12 _id13 _id14 _id15 _id16 _id17 _id18 _id19 _id20)
 group=idlab2 name='s'; 
 vectorplot y=YVEC x=XVEC xorigin=0 yorigin=0 / datalabel=LABEM2VAR shaftprotected=false rolename=(_tip1=VNAME _tip2=VLABEL _tip3=YROI _tip4=XORI _tip5=LENGTH _tip6=LENGTH2)
 tip=(y x datalabel _tip1 _tip2 _tip3 _tip4 _tip5 _tip6) datalabelattrs=GRAPHVALUETEXT (color=GraphData2:ContrastColor) lineattrs=GRAPHDATA2 (pattern=solid) primary=true; 
discretelegend 's';
if(0) 
entry "Vector Stretch=" STRETCH / autoalign=(topright topleft bottomright bottomleft right left top bottom); 
endif; 
endlayout; 
endgraph;
end; 
run;    /*For picture delete */   /*proc template; delete Stat.Prinqual.Graphics.MDPref ;run; */
ods graphics on; 
proc prinqual data=TEMP out= TEMP1 (where=(_type_='score'))
plots=MDPREF COV method=MTV n=2 replace mdpref;
title2 'Multidemensional Preference (MDPREF) Analysis';
title3 'Optimal Monotonoc Transformation of Preference Data';
id INDI_DSCM_NO; 
transform monotone (CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN
DRK_1 EXER_1 BMI_1 FAM_CBR); 
run; 



/*  폐경후*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=8; where MENOAGE_1 in (1,2,3,4);
tables CBR_PCH_AMT_2 PHX_BBR_YN_2 AGEGP_2 MENAAGE_2 MENOAGE_2 ERT_YN_2 OPLL_YN_2 DLV_FRQ_2 BRFD_2 SMK_YN_2 DRK_2 EXER_2 BMI_2 FAM_CBR_2; 
run; 
ods graphics off; 
proc contents data=TEMP1; run; 
data CL.RESULT_210506; set TEMP1; run; 
proc export data=WORK.TEMP1 outfile='Z:\BP\PROCESS\분석결과\MCA_RESULT_210506.csv' dbms=csv replace; sheet='Sheet1'; run; 


/******************MCA 분석: 유의한 변수 가지고****************/

/********** Total **********/
proc logistic data=TEMP descending; 
class CBR_PCH_AMT (param=ref ref="1") QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")  MENOAGE_1(param=ref ref="1")  ERT_YN(param=ref ref="1") 
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc logistic data=TEMP descending; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")  MENOAGE_1(param=ref ref="1")  ERT_YN(param=ref ref="1") 
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR
/selection=forward slentry=0.1 slstay=0.1;   /*forward만 가지고 함: 설명력 큰 변수부터 포함해서 이 순으로 MCA 수행*/
run; 
proc phreg data=TEMP; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")  MENOAGE_1(param=ref ref="1")  ERT_YN(param=ref ref="1") 
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model FU_YEAR*C50(0)= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc phreg data=TEMP; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")  MENOAGE_1(param=ref ref="1")  ERT_YN(param=ref ref="1") 
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model FU_YEAR*C50(0)= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR
/selection=forward slentry=0.1 slstay=0.1; 
run; 
/*로짓회귀분석과 콕스회귀분석의 결과가 거의 유사: 
선택된 변수: CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR BRFD_1 MENOAGE_1 BMI_1 MENAAGE_1 ERT_YN QC_DLV_FRQ AGEGP_1*/

/*다변량 적합성 검정*/
proc factor data=TEMP method=PRINCIPAL corr msa rotate= VARIMAX;
var CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR BRFD_1 MENOAGE_1 BMI_1 MENAAGE_1 ERT_YN QC_DLV_FRQ AGEGP_1 ; 
run; 
proc factor data=TEMP method=ML corr msa rotate= VARIMAX;
var CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR BRFD_1 MENOAGE_1 BMI_1 MENAAGE_1 ERT_YN QC_DLV_FRQ AGEGP_1 ; 
run;

/*SCREE PLOT*/
ods graphics on; 
proc princomp data=TEMP cov out=TEMP1; ods select ScreePlot; 
var CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR BRFD_1 MENOAGE_1 BMI_1 MENAAGE_1 ERT_YN QC_DLV_FRQ AGEGP_1 ; 
run;  

/*MCA 분석*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=18; 
tables CBR_PCH_AMT_2 PHX_BBR_YN_2 FAM_CBR_2 BRFD_2 MENOAGE_2 BMI_2 MENAAGE_2  ERT_YN_2 DLV_FRQ_2 AGEGP_2 ; 
run; 
ods graphics off; 
/*변수 1개씩 증가시키기*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=2 plots=all; 
tables CBR_PCH_AMT_2 PHX_BBR_YN_2 ; 
run; 
ods graphics off; 




/********** 폐경전 변수선정 과정 **********/
/*로짓회귀*/
proc logistic data=TEMP descending; where MENOAGE_1=8; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")   
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc logistic data=TEMP descending; where MENOAGE_1=8; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")   
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR
/selection=forward slentry=0.1 slstay=0.1; 
run; 
/*콕스모형*/
proc phreg data=TEMP; where MENOAGE_1=8; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")   
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model FU_YEAR*C50(0)= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc phreg data=TEMP; where MENOAGE_1=8; 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")   
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model FU_YEAR*C50(0)= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR
/selection=forward slentry=0.1 slstay=0.1; 
run; 

/*다변량 적합성 검정*/
proc factor data=TEMP method=PRINCIPAL corr msa rotate= VARIMAX; where MENOAGE_1=8; 
var CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR MENAAGE_1 BRFD_1  QC_DLV_FRQ BMI_1 AGEGP_1; run;  
proc factor data=TEMP method=ML corr msa rotate= VARIMAX;where MENOAGE_1=8; 
var CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR MENAAGE_1 BRFD_1  QC_DLV_FRQ BMI_1 AGEGP_1; run;

/*SCREE PLOT*/
ods graphics on; 
proc princomp data=TEMP cov out=TEMP1; ods select ScreePlot; where MENOAGE_1=8; 
var CBR_PCH_AMT QC_PHX_BBR_YN FAM_CBR MENAAGE_1 BRFD_1  QC_DLV_FRQ BMI_1 AGEGP_1; run;

/*MCA 분석*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=15; where MENOAGE_1=8; 
tables CBR_PCH_AMT_2 PHX_BBR_YN_2 FAM_CBR_2 MENAAGE_2 BRFD_2  DLV_FRQ_2 BMI_2 AGEGP_2; run;
ods graphics off; 
proc contents data=TEMP1; run; 
data CL.RESULT_210506; set TEMP1; run; 
proc export data=WORK.TEMP1 outfile='Z:\BP\PROCESS\분석결과\MCA_RESULT_210506.csv' dbms=csv replace; sheet='Sheet1'; run; 

proc freq data=TEMP; tables MENOAGE_1; run; 


/********** 폐경후 변수선정 과정 **********/
proc logistic data=TEMP descending; where MENOAGE_1 in (1,2,3,4); 
class CBR_PCH_AMT (param=ref ref="1") QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")  MENOAGE_1(param=ref ref="1")  ERT_YN(param=ref ref="1") 
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc logistic data=TEMP descending; where MENOAGE_1 in (1,2,3,4); 
class CBR_PCH_AMT (param=ref ref="1")  QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")  MENOAGE_1(param=ref ref="1")  ERT_YN(param=ref ref="1") 
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= CBR_PCH_AMT QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 ERT_YN QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR
/selection=forward slentry=0.1; 
run; 
/*콕스모형*/
proc phreg data=TEMP; where MENOAGE_1 in (1,2,3,4); 
class QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")   
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model C50= QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR; 
run; 
proc phreg data=TEMP; where MENOAGE_1 in (1,2,3,4); 
class QC_PHX_BBR_YN (param=ref ref="1") AGEGP_1(param=ref ref="1")  MENAAGE_1(param=ref ref="1")   MENOAGE_1(param=ref ref="1")
QC_OPLL_YN(param=ref ref="1")  QC_DLV_FRQ(param=ref ref="1")  BRFD_1(param=ref ref="1")  Q_SMK_YN(param=ref ref="1")  DRK_1(param=ref ref="1") 
EXER_1(param=ref ref="1")  BMI_1(param=ref ref="1")  FAM_CBR(param=ref ref="1") ; 
model FU_YEAR*C50(0)= QC_PHX_BBR_YN AGEGP_1 MENAAGE_1 MENOAGE_1 QC_OPLL_YN QC_DLV_FRQ BRFD_1 Q_SMK_YN DRK_1 EXER_1 BMI_1 FAM_CBR
/selection=forward slentry=0.1 slstay=0.1; 
run; 

/*다변량 적합성 검정*/
proc factor data=TEMP method=PRINCIPAL corr msa rotate= VARIMAX;where MENOAGE_1 in (1,2,3,4); 
var CBR_PCH_AMT QC_PHX_BBR_YN  BMI_1 BRFD_1 ERT_YN MENOAGE_1 FAM_CBR  MENAAGE_1 QC_DLV_FRQ  AGEGP_1; run;  
proc factor data=TEMP method=ML corr msa rotate= VARIMAX;where MENOAGE_1 in (1,2,3,4); 
var CBR_PCH_AMT QC_PHX_BBR_YN  BMI_1 BRFD_1 ERT_YN MENOAGE_1 FAM_CBR  MENAAGE_1 QC_DLV_FRQ  AGEGP_1; run;  

/*SCREE PLOT*/
ods graphics on; 
proc princomp data=TEMP cov out=TEMP1; ods select ScreePlot; where MENOAGE_1 in (1,2,3,4); 
var CBR_PCH_AMT QC_PHX_BBR_YN  BMI_1 BRFD_1 ERT_YN MENOAGE_1 FAM_CBR  MENAAGE_1 QC_DLV_FRQ  AGEGP_1; run;  
ods graphics off; 

/*MCA 분석*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=18; where MENOAGE_1 in (1,2,3,4); 
tables CBR_PCH_AMT_2 PHX_BBR_YN_2  BMI_2 BRFD_2 ERT_YN_2 MENOAGE_2 FAM_CBR_2  MENAAGE_2 DLV_FRQ_2  AGEGP_2; run;  
ods graphics off; 
proc contents data=TEMP1; run; 
data CL.RESULT_210506; set TEMP1; run; 
proc export data=WORK.TEMP1 outfile='Z:\BP\PROCESS\분석결과\MCA_RESULT_210506.csv' dbms=csv replace; sheet='Sheet1'; run; 



/************************CA 분석: 변수들의 조합**********************/
/*Total*/
%macro CA(a,b); 
ods graphics on; 
proc corresp data=TEMP CP RP MCA dim=3;  
tables &a &b; run;  
%mend; 
%macro CA(a,b); 
ods graphics on; 
proc corresp data=TEMP CP RP MCA dim=3; where MENOAGE_1 in (8); 
tables &a &b; run;  
%mend; 
%macro CA(a,b); 
ods graphics on; 
proc corresp data=TEMP CP RP MCA dim=3;  where MENOAGE_1 in (1,2,3,4); 
tables &a &b; run;  
%mend; 
%CA(CBR_PCH_AMT_2, C50);   /*DIM1에서 유방암 여부가 반대방향. DIM1 에서 유방밀도 <50%와 >=50%가 반대방향. DIM2에서는 25%와 50%가 반대뱡향*/
%CA(PHX_BBR_YN_2, C50);    /*DIM1에서 유방암 여부가 반대방향. DIM1 에서 양성종양 무&모름,있음 반대방향. DIM2 에서 양성종양 모름, 무 반대방향*/
%CA(AGEGP_2, C50);       /*DIM1에서 유방암 여부가 반대방향. DIM2에서 연령 55-59가 다른 연령과 반대뱡향*/
%CA(MENAAGE_2, C50);   /*DIM1에서 유방암 여부가 반대방향. DIM1에서 초경<14와 >=17이 반대방향. DIM2에서 초경<14&>=17과 15-16이 반대방향 */
%CA(MENOAGE_2, C50);   /*DIM1에서 유방암 여부가 반대방향. DIM2에서 폐경 <=45가 구분됨,  DIM3에서 폐경연령<50과 >=50이 구분됨*/
%CA(ERT_YN_2, C50);
%CA(OPLL_YN_2, C50);   
%CA(DLV_FRQ_2, C50);  /*DIM2 에서 nobirth&1birth와 2birth가 차이남*/
%CA(BRFD_2, C50);       /*DIM1,2 명확히 못 묶겠음*/
%CA(SMK_YN_2, C50);   /*DIM1,2 에서 nosmok와 smok가 차이남*/
%CA(DRK_2, C50);       /*DIM1,3 에서 nodrink&1-2day와 >=3day가 차이남*/
%CA(EXER_2, C50);     /*DIM1,3 에서 no exer과 exer이 차이남*/
%CA(BMI_2, C50);       /*DIM1,3 에서 BMI<23과 >=23이 차이남*/
%CA(FAM_CBR_2, C50);  /*FAMNO와 유방암없음이 매우 근접하고, DIM2에서 유방암있음과 FAMYES가 완전히 반대방향*/

%CA(CBR_PCH_AMT_2, PHX_BBR_YN_2);   
%CA(CBR_PCH_AMT_2, AGEGP_2);      
%CA(CBR_PCH_AMT_2, MENAAGE_2);   
%CA(CBR_PCH_AMT_2, MENOAGE_2);  
%CA(CBR_PCH_AMT_2, ERT_YN_2);
%CA(CBR_PCH_AMT_2, OPLL_YN_2);   
%CA(CBR_PCH_AMT_2, DLV_FRQ_2);  
%CA(CBR_PCH_AMT_2, BRFD_2);       
%CA(CBR_PCH_AMT_2, SMK_YN_2);   
%CA(CBR_PCH_AMT_2, DRK_2);       
%CA(CBR_PCH_AMT_2, EXER_2);    
%CA(CBR_PCH_AMT_2, BMI_2);       
%CA(CBR_PCH_AMT_2, FAM_CBR_2);

%CA(PHX_BBR_YN_2, AGEGP_2);      
%CA(PHX_BBR_YN_2, MENAAGE_2);   
%CA(PHX_BBR_YN_2, MENOAGE_2);  
%CA(PHX_BBR_YN_2, ERT_YN_2);
%CA(PHX_BBR_YN_2, OPLL_YN_2);   
%CA(PHX_BBR_YN_2, DLV_FRQ_2);  
%CA(PHX_BBR_YN_2, BRFD_2);       
%CA(PHX_BBR_YN_2, SMK_YN_2);   
%CA(PHX_BBR_YN_2, DRK_2);       
%CA(PHX_BBR_YN_2, EXER_2);    
%CA(PHX_BBR_YN_2, BMI_2);       
%CA(PHX_BBR_YN_2, FAM_CBR_2);

%CA(AGEGP_2, MENAAGE_2);   
%CA(AGEGP_2, MENOAGE_2);  
%CA(AGEGP_2, ERT_YN_2);
%CA(AGEGP_2, OPLL_YN_2);   
%CA(AGEGP_2, DLV_FRQ_2);  
%CA(AGEGP_2, BRFD_2);       
%CA(AGEGP_2, SMK_YN_2);   
%CA(AGEGP_2, DRK_2);       
%CA(AGEGP_2, EXER_2);    
%CA(AGEGP_2, BMI_2);       
%CA(AGEGP_2, FAM_CBR_2);

%CA(MENAAGE_2, MENOAGE_2);  
%CA(MENAAGE_2, ERT_YN_2);
%CA(MENAAGE_2, OPLL_YN_2);   
%CA(MENAAGE_2, DLV_FRQ_2);  
%CA(MENAAGE_2, BRFD_2);       
%CA(MENAAGE_2, SMK_YN_2);   
%CA(MENAAGE_2, DRK_2);       
%CA(MENAAGE_2, EXER_2);    
%CA(MENAAGE_2, BMI_2);       
%CA(MENAAGE_2, FAM_CBR_2);

%CA(MENOAGE_2, ERT_YN_2);
%CA(MENOAGE_2, OPLL_YN_2);   
%CA(MENOAGE_2, DLV_FRQ_2);  
%CA(MENOAGE_2, BRFD_2);       
%CA(MENOAGE_2, SMK_YN_2);   
%CA(MENOAGE_2, DRK_2);       
%CA(MENOAGE_2, EXER_2);    
%CA(MENOAGE_2, BMI_2);       
%CA(MENOAGE_2, FAM_CBR_2);

%CA(ERT_YN_2, OPLL_YN_2);   
%CA(ERT_YN_2, DLV_FRQ_2);  
%CA(ERT_YN_2, BRFD_2);       
%CA(ERT_YN_2, SMK_YN_2);   
%CA(ERT_YN_2, DRK_2);       
%CA(ERT_YN_2, EXER_2);    
%CA(ERT_YN_2, BMI_2);       
%CA(ERT_YN_2, FAM_CBR_2);

%CA(OPLL_YN_2, DLV_FRQ_2);  
%CA(OPLL_YN_2, BRFD_2);       
%CA(OPLL_YN_2, SMK_YN_2);   
%CA(OPLL_YN_2, DRK_2);       
%CA(OPLL_YN_2, EXER_2);    
%CA(OPLL_YN_2, BMI_2);       
%CA(OPLL_YN_2, FAM_CBR_2);

%CA(DLV_FRQ_2, BRFD_2);       
%CA(DLV_FRQ_2, SMK_YN_2);   
%CA(DLV_FRQ_2, DRK_2);       
%CA(DLV_FRQ_2, EXER_2);    
%CA(DLV_FRQ_2, BMI_2);       
%CA(DLV_FRQ_2, FAM_CBR_2);

%CA(BRFD_2, SMK_YN_2);   
%CA(BRFD_2, DRK_2);       
%CA(BRFD_2, EXER_2);    
%CA(BRFD_2, BMI_2);       
%CA(BRFD_2, FAM_CBR_2);

%CA(SMK_YN_2, DRK_2);       
%CA(SMK_YN_2, EXER_2);    
%CA(SMK_YN_2, BMI_2);       
%CA(SMK_YN_2, FAM_CBR_2);

%CA(DRK_2, EXER_2);    
%CA(DRK_2, BMI_2);       
%CA(DRK_2, FAM_CBR_2);

%CA(EXER_2, BMI_2);       
%CA(EXER_2, FAM_CBR_2);

%CA(BMI_2, FAM_CBR_2);


/************************ 변수 카테고리 개수 줄이기**********************************/
data CL.BR_NCS_0910_TEST; set CL.BR_NCS_0910_TEST; 
format CBR_PCH_AMT_3 $16.;
format CBR_PCH_AMT_4 $16.;
format CBR_PCH_AMT_5 $16.;
format PHX_BBR_YN_3 $16.; 
format AGEGP_3 $16.; 
format AGEGP_4 $16.; 
format MENAAGE_3 $16.; 
format MENOAGE_3 $16.; 
format MENOAGE_4 $16.; 
format ERT_YN_3 $16.; 
format OPLL_YN_3 $16.; 
format OPLL_YN_4 $16.; 
format DLV_FRQ_3 $16.;
format BRFD_3 $16.; 
format BRFD_4 $16.; 
format SMK_YN_3 $16. ;
format DRK_3 $16.; 
format EXER_3 $16. ;
format BMI_3 $16. ;
format FAM_CBR_3 $16.; 
if CBR_PCH_AMT=4 then CBR_PCH_AMT_3='100%'; else if CBR_PCH_AMT in (1,2,3) then CBR_PCH_AMT_3='25-75%';
if CBR_PCH_AMT=4 then CBR_PCH_AMT_4='100%'; else if CBR_PCH_AMT in (1) then CBR_PCH_AMT_4='25%'; else if CBR_PCH_AMT in (2,3) then CBR_PCH_AMT_4='50-75%';
if CBR_PCH_AMT in (1,2) then CBR_PCH_AMT_5='25-50%';  else if CBR_PCH_AMT in (3,4) then CBR_PCH_AMT_5='75-100%';  
if QC_PHX_BBR_YN=1 then PHX_BBR_YN_3='양성종양유'; else if QC_PHX_BBR_YN in (2,3) then PHX_BBR_YN_3='양성종양무,모름'; 
if AGEGP_1=1 then AGEGP_3='AGE<45'; else if AGEGP_1 in (2,3,4,5,6) then AGEGP_3='AGE>=45';
if AGEGP_1 in (1,2) then AGEGP_4='AGE<50'; else if AGEGP_1 in (3,4,5,6) then AGEGP_4='AGE>=50';
if MENAAGE_1=1 then MENAAGE_3='MAAGE<=16'; else if MENAAGE_1=2 then MENAAGE_3='MAAGE<=16'; else if MENAAGE_1=3 then MENAAGE_3='MAAGE>=17'; 
    else if MENAAGE_1=4 then MENAAGE_3='MAAGE>=17'; else if MENAAGE_1=999 then MENAAGE_3='초경연령모름';
if MENOAGE_1=8 then MENOAGE_3='PREMENO'; else if MENOAGE_1=1 then MENOAGE_3='MOAGE<=45'; else if MENOAGE_1 in (2,3,4) then MENOAGE_3='MOAGE>45'; else if MENOAGE_1=999 then MENOAGE_3='폐경연령모름';
if MENOAGE_1=8 then MENOAGE_4='PREMENO'; else if MENOAGE_1 in (1,2) then MENOAGE_4='MOAGE<=50'; else if MENOAGE_1 in (3,4) then MENOAGE_4='MOAGE>50'; else if MENOAGE_1=999 then MENOAGE_4='폐경연령모름';
if ERT_YN=0 then ERT_YN_3='PREMENO,'; else if  ERT_YN in (1,2) then ERT_YN_3='HRT<5YR'; else if ERT_YN=3 then ERT_YN_3='HRT>=5YR'; else if ERT_YN=999 then ERT_YN_3='HRT모름';
if QC_OPLL_YN in (1,999,2,4) then OPLL_YN_3='OC<1YR';  else if QC_OPLL_YN=3 then OPLL_YN_3='OC>=1YR'; 
if QC_OPLL_YN in (1) then OPLL_YN_4='OC_NEVER'; else if QC_OPLL_YN in (2,3,4,999) then OPLL_YN_4='OC_OTHER'; 
if QC_DLV_FRQ in (1,3) then DLV_FRQ_3='자녀0-1';  else if QC_DLV_FRQ=2 then DLV_FRQ_3='자녀2+'; else if QC_DLV_FRQ=999 then DLV_FRQ_3='자녀모름'; 
if BRFD_1=2 then BRFD_3='모유>=1yr';else if BRFD_1 in (0,1) then BRFD_3='<1yr';  else if BRFD_1=999 then BRFD_3='모유모름'; 
if BRFD_1 in (1,2) then BRFD_4='모유함';else if BRFD_1 in (0) then BRFD_4='모유안함';  else if BRFD_1=999 then BRFD_4='모유모름'; 
if Q_SMK_YN=1 then SMK_YN_3='NOSMK'; else if Q_SMK_YN=2 then SMK_YN_3='NOSMK'; else if Q_SMK_YN=3 then SMK_YN_3='CURSMOK'; else if Q_SMK_YN=999 then SMK_YN_3='흡연모름';
if DRK_1=0 then DRK_3='LESSDRK'; else if DRK_1=1 then DRK_3='LESSDRK'; else if DRK_1=2 then DRK_3='MOREDRK';  else if DRK_1=999 then DRK_3='음주모름'; 
if EXER_1=0 then EXER_3='NOEXER'; else if EXER_1=1 then EXER_3='YESEXER';else if EXER_1=2 then EXER_3='YESEXER'; else if EXER_1=999 then EXER_3='운동모름';
if BMI_1=1 then BMI_3='<25'; else if BMI_1=2 then BMI_3='<25'; else if BMI_1=3 then BMI_3='>=25';else if BMI_1=999 then BMI_3='비만모름';
if FAM_CBR=1 then FAM_CBR_3='FAMYES'; else if FAM_CBR=0 then FAM_CBR_3='FAMNO'; else if FAM_CBR=999 then FAM_CBR_3='FAM모름';
run; 


proc freq data= CL.BR_NCS_0910_TEST; tables 
CBR_PCH_AMT*CBR_PCH_AMT_3*CBR_PCH_AMT_4*CBR_PCH_AMT_5/list missing; run; 
QC_PHX_BBR_YN*PHX_BBR_YN_2*PHX_BBR_YN_3
AGEGP_1*AGEGP_2 *AGEGP_3*AGEGP_4
MENAAGE_1*MENAAGE_2 *MENAAGE_3
MENOAGE_1*MENOAGE_2 *MENOAGE_3 *MENOAGE_4 
ERT_YN*ERT_YN_2 *ERT_YN_3
QC_OPLL_YN*OPLL_YN_2 *OPLL_YN_3*OPLL_YN_4
QC_DLV_FRQ*DLV_FRQ_2 *DLV_FRQ_3 
BRFD_1*BRFD_2 *BRFD_3*BRFD_4
Q_SMK_YN*SMK_YN_2 *SMK_YN_3 
DRK_1*DRK_2*DRK_3 
EXER_1*EXER_2 *EXER_3 
BMI_1*BMI_2 *BMI_3 
FAM_CBR*FAM_CBR_2*FAM_CBR_3/list missing; run; 
data TEMP;  set CL.BR_NCS_0910_TEST;
if MENAAGE_1=999 or MENOAGE_1=999 or BMI_1=999 or WSTC_1=999 or FBS_1=999 or TG_1=999 or HDL_1=999 or BP_1=999 then delete; 
FU_YEAR=FU_DAY/365.25; 
run;  /*2500349개 관측값과 146개 변수. 데이터셋 만들때 부터 추적기간 180미만은 제외*/

/**전체**/
/*전체 변수*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=15 plots=all; 
tables CBR_PCH_AMT_3 PHX_BBR_YN_3 AGEGP_3 MENAAGE_3 MENOAGE_3 ERT_YN_3 OPLL_YN_3 DLV_FRQ_3 BRFD_3 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
ods graphics on;
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=15 plots=all; 
tables CBR_PCH_AMT_5 PHX_BBR_YN_3 AGEGP_3 MENAAGE_3 MENOAGE_3 ERT_YN_3 OPLL_YN_3 DLV_FRQ_3 BRFD_3 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=16 plots=all; 
tables CBR_PCH_AMT_4 PHX_BBR_YN_3 AGEGP_4 MENAAGE_3 MENOAGE_4 ERT_YN_3 OPLL_YN_4 DLV_FRQ_3 BRFD_4 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
/*유의한 변수*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=11 plots=all; 
tables CBR_PCH_AMT_5 PHX_BBR_YN_3 FAM_CBR_3 BRFD_3 MENOAGE_3 BMI_3 MENAAGE_3 ERT_YN_3 DLV_FRQ_3 AGEGP_3; 
run; 

/**폐경전**/
/*전체 변수*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=12 plots=all; where MENOAGE_1 in (8); 
tables CBR_PCH_AMT_3 PHX_BBR_YN_3 AGEGP_3 MENAAGE_3 OPLL_YN_3 DLV_FRQ_3 BRFD_3 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
ods graphics on;
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=12 plots=all; where MENOAGE_1 in (8); 
tables CBR_PCH_AMT_5 PHX_BBR_YN_3 AGEGP_3 MENAAGE_3  OPLL_YN_3 DLV_FRQ_3 BRFD_3 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run;  
ods graphics off; 
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=16 plots=all; where MENOAGE_1 in (8); 
tables CBR_PCH_AMT_4 PHX_BBR_YN_3 AGEGP_4 MENAAGE_3 OPLL_YN_4 DLV_FRQ_3 BRFD_4 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
/*유의한 변수*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=8 plots=all; where MENOAGE_1 in (8); 
tables CBR_PCH_AMT_5 PHX_BBR_YN_3 FAM_CBR_3 MENAAGE_3 BRFD_3 DLV_FRQ_3 BMI_3 AGEGP_3; 
run; 
ods graphics off; 

/**폐경후**/
/*전체 변수*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=14 plots=all; where MENOAGE_1 in (1,2,3,4); 
tables CBR_PCH_AMT_3 PHX_BBR_YN_3 AGEGP_3 MENAAGE_3 MENOAGE_3 ERT_YN_3 OPLL_YN_3 DLV_FRQ_3 BRFD_3 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
ods graphics on;
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=14 plots=all; where MENOAGE_1 in (1,2,3,4); 
tables CBR_PCH_AMT_5 PHX_BBR_YN_3 AGEGP_3 MENAAGE_3 MENOAGE_3 ERT_YN_3 OPLL_YN_3 DLV_FRQ_3 BRFD_3 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=14 plots=all; where MENOAGE_1 in (1,2,3,4); 
tables CBR_PCH_AMT_4 PHX_BBR_YN_3 AGEGP_4 MENAAGE_3 MENOAGE_4 ERT_YN_3 OPLL_YN_4 DLV_FRQ_3 BRFD_4 SMK_YN_3 DRK_3 EXER_3 BMI_3 FAM_CBR_3; 
run; 
ods graphics off; 
/*유의한 변수*/
ods graphics on; 
proc corresp data=TEMP out=TEMP1 MCA CP RP OBSERVED EXPECTED DEVIATION CELLCHI2 DIM=8 plots=all; where MENOAGE_1 in (1,2,3,4); 
tables CBR_PCH_AMT_5 PHX_BBR_YN_3 BMI_3 BRFD_3 ERT_YN_3 MENOAGE_3 FAM_CBR_3 MENAAGE_3  DLV_FRQ_3 AGEGP_3; 
run; 
ods graphics off; 
