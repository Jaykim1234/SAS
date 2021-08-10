

/************************Decision Tree****************************/

libname KJH "/userdata07/room284/data_source/ANALYSIS/KJH";


data KJH.BR_NCS_0910; set KJH.tree_missing0; run; 


data KJH.BR_NCS_0910_1; set KJH.BR_NCS_0910;
/*흡연량 산출을 위해 pack-year 계산*/
if Q_SMK_PRE_DRT=0 then Q_SMK_PRE_DRT_1=0.1; else Q_SMK_PRE_DRT_1=Q_SMK_PRE_DRT; /*0이면 곱하면 0이 되어서 0.1로 변환*/
if Q_SMK_PRE_AMT=0 then Q_SMK_PRE_AMT_1=0.1; else Q_SMK_PRE_AMT_1=Q_SMK_PRE_AMT;
if Q_SMK_NOW_DRT=0 then Q_SMK_NOW_DRT_1=0.1; else Q_SMK_NOW_DRT_1=Q_SMK_NOW_DRT; 
if Q_SMK_NOW_AMT_V09N=0 then Q_SMK_NOW_AMT_V09N_1=0.1; else Q_SMK_NOW_AMT_V09N_1=Q_SMK_NOW_AMT_V09N; 
if Q_SMK_YN=1 then PACK_YR=0; 
   else if Q_SMK_YN=2 then PACK_YR=(Q_SMK_PRE_DRT_1*Q_SMK_PRE_AMT_1)/20; 
   else if Q_SMK_YN=3 then PACK_YR=(Q_SMK_NOW_DRT_1*Q_SMK_NOW_AMT_V09N_1)/20;
/*주당 음주량 계산*/
if Q_DRK_FRQ_V09N=0 then Q_DRK_FRQ_V09N_1=0.1; else Q_DRK_FRQ_V09N_1=Q_DRK_FRQ_V09N; 
if Q_DRK_AMT_V09N=0 then Q_DRK_AMT_V09N_1=0.1; else Q_DRK_AMT_V09N_1=Q_DRK_AMT_V09N; 
if Q_DRK_FRQ_V09N=0 and Q_DRK_AMT_V09N=0 then DRK_WK=0; 
   else if Q_DRK_FRQ_V09N=. and Q_DRK_AMT_V09N=0 then DRK_WK=0; 
   else if Q_DRK_FRQ_V09N=0 and Q_DRK_AMT_V09N=. then DRK_WK=0; 
   else DRK_WK=Q_DRK_FRQ_V09N_1*Q_DRK_AMT_V09N_1; 
/*총 운동단위*/
if Q_PA_VD=. then Q_PA_VD_1=0; else Q_PA_VD_1=Q_PA_VD; 
if Q_PA_MD=. then Q_PA_MD_1=0; else Q_PA_MD_1=Q_PA_MD; 
if Q_PA_WALK=. then Q_PA_WALK_1=0; else Q_PA_WALK_1=Q_PA_WALK; 
if Q_PA_VD=. and Q_PA_MD=. and Q_PA_WALK=. then EXER=.; 
   else EXER=Q_PA_VD_1+Q_PA_MD_1+Q_PA_WALK_1; 
/*초경연령: QC_MNC_AGE 그대로 함*/ 
/*폐경여부*/ 
if QC_MNS_YN=1 then MNS_YN_1=1; 
   else if QC_MNS_YN in (3) then MNS_YN_1=2; 
   else MNS_YN_1=.;
/*폐경연령*/ 
if MNS_YN_1=1 then MNP_AGE=0; 
   else if MNS_YN_1=. then MNP_AGE=.; 
   else MNP_AGE=QC_MNP_AGE;  
/*폐경후 호르몬요법*/
if QC_MNS_YN in (1,2) then ERT_YN=0; 
   else if QC_ERT_YN in (.,5) then ERT_YN=.; 
   else if QC_ERT_YN in (1) then ERT_YN=1; 
   else if QC_ERT_YN in (2,3) then ERT_YN=2;
   else if QC_ERT_YN in (4) then ERT_YN=3;  
/*유방암 가족력*/
if QC_PFHX_CBR_PRT=2 then FAM_CBR=1; 
   else if QC_PFHX_CBR_BRT=2 then FAM_CBR=1; 
   else if QC_PFHX_CBR_SST=2 then FAM_CBR=1; 
   else if QC_PFHX_CBR_CDR=2 then FAM_CBR=1;  else FAM_CBR=0; 
/*위암 가족력*/
if QC_PFHX_CST_PRT=2 then FAM_CST=1; 
   else if QC_PFHX_CST_BRT=2 then FAM_CST=1; 
   else if QC_PFHX_CST_SST=2 then FAM_CST=1; 
   else if QC_PFHX_CST_CDR=2 then FAM_CST=1; else FAM_CST=0; 
/*대장암 가족력*/
if QC_PFHX_CCR_PRT=2 then FAM_CCR=1; 
   else if QC_PFHX_CCR_BRT=2 then FAM_CCR=1; 
   else if QC_PFHX_CCR_SST=2 then FAM_CCR=1; 
   else if QC_PFHX_CCR_CDR=2 then FAM_CCR=1; else FAM_CCR=0; 
/*간암 가족력*/
if QC_PFHX_CLV_PRT=2 then FAM_CLV=1; 
   else if QC_PFHX_CLV_BRT=2 then FAM_CLV=1; 
   else if QC_PFHX_CLV_SST=2 then FAM_CLV=1; 
   else if QC_PFHX_CLV_CDR=2 then FAM_CLV=1; else FAM_CLV=0; 
/*자궁경부암 가족력*/
if QC_PFHX_CCX_PRT=2 then FAM_CCX=1; 
   else if QC_PFHX_CCX_BRT=2 then FAM_CCX=1; 
   else if QC_PFHX_CCX_SST=2 then FAM_CCX=1; 
   else if QC_PFHX_CCX_CDR=2 then FAM_CCX=1; else FAM_CCX=0; 
/*기타암 가족력*/
if QC_PFHX_ETC_PRT=2 then FAM_ETC=1; 
   else if QC_PFHX_ETC_BRT=2 then FAM_ETC=1; 
   else if QC_PFHX_ETC_SST=2 then FAM_ETC=1; 
   else if QC_PFHX_ETC_CDR=2 then FAM_ETC=1; else FAM_ETC=0; 
/*결과변수*/
if CA=. then CA=0; 
if C50=. then C50=0; 
if D05=. then D05=0;
run; 
proc freq data=KJH.BR_NCS_0910_1;  tables 
/*흡연관련*/ PACK_YR*Q_SMK_YN*Q_SMK_PRE_DRT*Q_SMK_PRE_AMT*Q_SMK_NOW_DRT*Q_SMK_NOW_AMT_V09N
/*음주관련*/ DRK_WK*Q_DRK_FRQ_V09N*Q_DRK_AMT_V09N
/*신체활동*/ EXER*Q_PA_VD*Q_PA_MD*Q_PA_WALK
/*폐경관련*/ MNS_YN_1*QC_MNS_YN MNP_AGE*MNS_YN_1*QC_MNP_AGE ERT_YN*MNS_YN_1*QC_ERT_YN
/*유방암가족력*/ FAM_CBR*QC_PFHX_CBR_PRT*QC_PFHX_CBR_BRT*QC_PFHX_CBR_SST*QC_PFHX_CBR_CDR
/*위암가족력*/ FAM_CST*QC_PFHX_CST_PRT*QC_PFHX_CST_BRT*QC_PFHX_CST_SST*QC_PFHX_CST_CDR
/*대장암가족력*/ FAM_CCR*QC_PFHX_CCR_PRT*QC_PFHX_CCR_BRT*QC_PFHX_CCR_SST*QC_PFHX_CCR_CDR
/*간암가족력*/ FAM_CLV*QC_PFHX_CLV_PRT*QC_PFHX_CLV_BRT*QC_PFHX_CLV_SST*QC_PFHX_CLV_CDR
/*자궁경부암가족력*/ FAM_CCX*QC_PFHX_CCX_PRT*QC_PFHX_CCX_BRT*QC_PFHX_CCX_SST*QC_PFHX_CCX_CDR
/*기타암가족력*/ FAM_ETC*QC_PFHX_ETC_PRT*QC_PFHX_ETC_BRT*QC_PFHX_ETC_SST*QC_PFHX_ETC_CDR
/list missing; run; 
/********** Delete missing variables ********/
data KJH.tree_missing0; set KJH.BR_NCS_0910;
if CBR_JDG_CBR=. then delete; 
else if CBR_PCH_AMT=. then delete; /**/
else if CBR_FND1=. then delete; 
else if QC_PHX_BBR_YN=. then delete; /**/
else if QC_MNC_AGE=. then delete; /**/
else if MNS_YN_1=. then delete; /**/
else if MNP_AGE=. then delete; /**/
else if ERT_YN=. then delete; 
else if QC_DLV_FRQ=. then delete; /*출산 자녀 명수*/
else if QC_BRFD_DRT=. then delete; /* Breast feeding period*/
else if QC_OPLL_YN=. then delete; 
else if G1E_HGHT=. then delete; 
else if G1E_WGHT=. then delete;    /*허리둘레*/
else if G1E_BP_SYS=. then delete; /*Blood pressure (Max)*/
else if G1E_BP_DIA=. then delete;  /*Blood pressure (Min)*/
else if G1E_HGB=. then delete;      /* 혈액소 수치*/
else if G1E_FBS=. then delete; 		/*공복혈당 수치*/
else if G1E_TOT_CHOL=. then delete; /**/
else if G1E_SGOT=. then delete; 	/*AST(SGOT) 수치*/
else if G1E_SGPT=. then delete;		 /*ALT(SGPT) 수치*/
else if G1E_GGT=. then delete; 		/*감마지피티  수치*/
else if G1E_WSTC=. then delete; 	/**/
else if G1E_TG=. then delete; 		/*트리글리세라이드 수치*/
else if G1E_HDL=. then delete;		/*HDL 콜레스테롤 수치*/
else if G1E_LDL=. then delete; 		/*혈액검사(LDL- 콜레스테롤 실 측정값*/
else if Q_SMK_YN=. then delete;   /*흡연*/
else if Q_DRK_FRQ_V09N=. then delete;  /*주당 음주량 */
else if EXER=. then delete;  /**/
else if FAM_CBR=. then delete;  /*가족력*/
run;  /*WORK.TEMP은(는) 4110781개 관측값과 129개 변수*/
proc freq data=KJH.tree_missing0; tables QC_MNS_YN*C50*D05 EXMD_BZ_YYYY/list missing; run; 

ods graphics on;
proc hpsplit data = KJH.tree_missing0;
	class CBR_JDG_CBR CBR_PCH_AMT CBR_FND1 QC_PHX_BBR_YN QC_MNC_AGE MNS_YN_1 ERT_YN QC_DLV_FRQ 
QC_BRFD_DRT QC_OPLL_YN G1E_HGHT G1E_WGHT G1E_BP_SYS G1E_BP_DIA G1E_HGB G1E_FBS G1E_TOT_CHOL 
G1E_SGOT G1E_SGPT G1E_GGT G1E_WSTC G1E_TG G1E_HDL G1E_LDL Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR;
	MODEL CBR_JDG_CBR = CBR_PCH_AMT CBR_FND1 QC_PHX_BBR_YN QC_MNC_AGE MNS_YN_1 ERT_YN QC_DLV_FRQ 
QC_BRFD_DRT QC_OPLL_YN G1E_HGHT G1E_WGHT G1E_BP_SYS G1E_BP_DIA G1E_HGB G1E_FBS G1E_TOT_CHOL 
G1E_SGOT G1E_SGPT G1E_GGT G1E_WSTC G1E_TG G1E_HDL G1E_LDL Q_SMK_YN Q_DRK_FRQ_V09N EXER FAM_CBR ;
	prune  costcomplexity;
	grow entropy;
	partition fraction(validate =0.3, seed = 42);
	output out = scored;
run;
ods graphics off;

ods graphics on;
proc hpsplit data = KJH.tree_missing0;
	class CBR_JDG_CBR CBR_FND1 CBR_PCH_AMT  ;
	MODEL CBR_JDG_CBR =  CBR_FND1 CBR_PCH_AMT  ;
	prune  costcomplexity;
	grow entropy;
	partition fraction(validate =0.3, seed = 42);
	output out = scored;
run;
ods graphics off;

ods graphics on;
proc logistic data = KJH.tree_missing0;
	class CBR_JDG_CBR CBR_PCH_AMT CBR_FND1  G1E_SGOT ;
	MODEL CBR_JDG_CBR = CBR_PCH_AMT CBR_FND1G1E_SGOT;
run;
ods graphics off;


ods graphics on;
proc logistic data = KJH.tree_missing0;
	class CBR_JDG_CBR CBR_PCH_AMT CBR_FND1 MNS_YN_1 ;
	MODEL CBR_JDG_CBR = CBR_PCH_AMT CBR_FND1 MNS_YN_1;
run;
ods graphics off;




