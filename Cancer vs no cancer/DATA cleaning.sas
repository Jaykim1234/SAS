libname A 'C:\Users\USER01\Desktop\sas\5-21 ����\���� 2\Data';
libname B 'C:\Users\USER01\Desktop\sas\5-21 ����\���� 2\Data analysis';


/*****************�⺻����***************/
proc contents data=a.ctbs0413_01_examinee; run;
/*�ߺ��� ����*/
data ctbs0413_01_examinee; set a.ctbs0413_01_examinee; run;                           proc sort data= ctbs0413_01_examinee nodupkey; by NIHID; run;       /*�ߺ��� ����: ��ü 173357��*/
proc freq data=a.ctbs0413_01_examinee; tables DS1_SEX DS1_AGE; run;   /*���� 58,491��, ���� 111,592��, ���� 35��~74��*/


/***************���� ���ŷ�***************/
proc contents data=a.ctbs0413_02_disease; run;
proc freq data=a.ctbs0413_02_disease; tables DS1_CA1*DS1_CA1SP DS1_CA2*DS1_CA2SP DS1_CA3*DS1_CA3SP DS1_CA1SP*DS1_CA2SP*DS1_CA3SP/list missing; run;

/*���� �߻� ���� �� �߻���� ����: 758�� - ���� missing 11��, 20�� ���� �߻� 2�� (1��, 13��)*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='1' or DS1_CA2SP='1' or DS1_CA3SP='1'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run; 
/*���� �߻� ���� �� �߻���� ����: 103�� - ���� missing 1��, 20�� ���� �߻� 2�� (1��, 2��)*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='2' or DS1_CA2SP='2' or DS1_CA3SP='2'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*����� �߻� ���� �� �߻���� ����: 405�� - ���� missing 9��, 20�� ���� �߻� 1�� (6��)*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='3' or DS1_CA2SP='3' or DS1_CA3SP='3'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*����� �߻� ���� �� �߻���� ����: 920�� - ���� missing 11��, 20�� ���� �߻� 1�� (17��)*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='4' or DS1_CA2SP='4' or DS1_CA3SP='4'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*�ڱð�ξ� �߻� ���� �� �߻���� ����: 641�� - ���� missing 13��*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='5' or DS1_CA2SP='5' or DS1_CA3SP='5'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*��� �߻� ���� �� �߻���� ����: 111�� - ���� missing 1��*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='6' or DS1_CA2SP='6' or DS1_CA3SP='6'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*���󼱾� �߻� ���� �� �߻���� ����: 942�� - ���� missing 9��*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='7' or DS1_CA2SP='7' or DS1_CA3SP='7'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*�������� �߻� ���� �� �߻���� ����: 90�� - ���� missing 1��*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='8' or DS1_CA2SP='8' or DS1_CA3SP='8'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*�汤�� �߻� ���� �� �߻���� ����: 75�� - ���� missing 0��*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='9' or DS1_CA2SP='9' or DS1_CA3SP='9'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;
/*��Ÿ��  �߻� ���� �� �߻���� ����: 75�� - ���� missing 0��*/
proc freq data=a.ctbs0413_02_disease; where DS1_CA1SP='10' or DS1_CA2SP='10' or DS1_CA3SP='10'; tables DS1_CA1AG DS1_CA2AG DS1_CA3AG DS1_CA1AG*DS1_CA2AG*DS1_CA3AG/list missing; run;


/*****************������ dataset �и�, �Ϲ߻� ���� ���� �� ī�װ� ȭ***************/
proc sort data=a.ctbs0413_01_examinee; by NIHID; run;
proc sort data=a.ctbs0413_02_disease; by NIHID; run;
data a; merge a.ctbs0413_01_examinee a.ctbs0413_02_disease; by NIHID; run;

/*******��ü��*******/
data B.TOTAL; set a; 
/*��*/
   if DS1_CA1='2' or DS1_CA2='2' or DS1_CA3='2' then CA=1; else CA=0; 
/*������ȯ*/
   if DS1_HTN='2' then DS1_HTN_1=1; else DS1_HTN_1=0;     /*������*/
   if DS1_DM='2' then DS1_DM_1=1; else DS1_DM_1=0;         /*�索*/
   if DS1_LIP='2' then DS1_LIP_1=1; else DS1_LIP_1=0;          /*��������*/
   if DS1_CVA='2' then DS1_CVA_1=1; else DS1_CVA_1=0;      /*������*/ 
   if DS1_MI='2' then DS1_MI_1=1; else DS1_MI_1=0;              /*������/�ɱٰ����*/
   if DS1_STOMUL='2' or DS1_GASTRO='2' or DS1_ULCER='2' or DS1_GASULCER='2' or DS1_DUOULCER='2' then DS1_ULCER_1=1; else DS1_ULCER_1=0;     /*����, ��/��������˾�*/  
   if DS1_POL='2' then DS1_POL_1=1; else DS1_POL_1=0;     /*������*/
   if DS1_LIV='2' then DS1_LIV_1=1; else DS1_LIV_1=0;      /*�޼�����ȯ*/
   if DS1_FLIV='2' then DS1_FLIV_1=1; else DS1_FLIV_1=0;      /*���氣*/
   if DS1_CLIV='2' then DS1_CLIV_1=1; else DS1_CLIV_1=0;      /*��������/���溯*/
   if DS1_GB='2' then DS1_GB_1=1; else DS1_GB_1=0;           /*�㼮��/�㳶��*/
   if DS1_RESP='2' or DS1_BRON='2' or DS1_ASTH='2' then DS1_ASTHMA_1=1; else DS1_ASTHMA_1=0;     /*õ��/�����������*/  
   if DS1_THY='2' then DS1_THY_1=1; else DS1_THY_1=0;           /*������ȯ*/
   if DS1_ARTH='2' then DS1_ARTH_1=1; else DS1_ARTH_1=0;     /*������*/
   if DS1_OSTE='2' then DS1_OSTE_1=1; else DS1_OSTE_1=0;     /*��ٰ���*/
   if DS1_EYE='2' or DS1_CATA='2' or DS1_GLAU='2' then DS1_EYE_1=1; else DS1_EYE_1=0;     /*�鳻��/�쳻*/  
   if DS1_DEP='2' then DS1_DEP_1=1; else DS1_DEP_1=0;     /*�����*/
   Total_Chronic=DS1_HTN_1+DS1_DM_1+DS1_LIP_1+DS1_CVA_1+DS1_MI_1+DS1_ULCER_1+DS1_POL_1+DS1_LIV_1+DS1_FLIV_1+DS1_CLIV_1+DS1_GB_1+DS1_ASTHMA_1+DS1_THY_1+DS1_ARTH_1+DS1_OSTE_1+DS1_EYE_1+ DS1_DEP_1; 
    if Total_Chronic=0 then Total_Chronic_1=0; else Total_Chronic_1=1; 
  /*����ȯ��*/
	if Total_Chronic=0 and CA=0 then NO_DZ=1; else NO_DZ=0;
run; 

data B.TOTAL; set B.TOTAL; 
  /*���� ����*/
     if DS1_CA1SP='1' or DS1_CA2SP='1' or DS1_CA3SP='1' then GA_C=1; else GA_C=0; 
  /*���� �߻� ���� ����*/
     if DS1_CA1SP='1' and DS1_CA2SP='1' then GA_AGE=min(DS1_CA1AG, DS1_CA2AG); 
           else if DS1_CA1SP='1' then GA_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='1' then GA_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='1' then GA_AGE=DS1_CA3AG+0; 
   /*���� �߻� �� ��� �⵵*/
            if GA_AGE=99999 then GA_YR=99999; else GA_YR= DS1_AGE-GA_AGE; 

  /*���� ����*/
     if DS1_CA1SP='2' or DS1_CA2SP='2' or DS1_CA3SP='2' then LI_C=1; else LI_C=0; 
  /*���� �߻� ���� ����*/
     if DS1_CA1SP='2' and DS1_CA2SP='2' then LI_AGE=min(DS1_CA1AG, DS1_CA2AG); 
           else if DS1_CA1SP='2' then LI_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='2' then LI_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='2' then LI_AGE=DS1_CA3AG+0; 
  /*���� �߻� �� ��� �⵵*/
            if LI_AGE=99999 then LI_YR=99999; else LI_YR= DS1_AGE-LI_AGE; 

   /*����� ����*/
      if DS1_CA1SP='3' or DS1_CA2SP='3' or DS1_CA3SP='3' then CO_C=1; else CO_C=0; 
   /*����� �߻� ���� ����*/
            if DS1_CA1SP='3' then CO_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='3' then CO_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='3' then CO_AGE=DS1_CA3AG+0; 
   /*����� �߻� �� ��� �⵵*/
            if CO_AGE=99999 then CO_YR=99999; else CO_YR= DS1_AGE-CO_AGE;

   /*����� ����*/
      if DS1_CA1SP='4' or DS1_CA2SP='4' or DS1_CA3SP='4' then BR_C=1; else BR_C=0; 
   /*����� �߻� ���� ����*/
            if DS1_CA1SP='4' and DS1_CA2SP='4' then BR_AGE=min(DS1_CA1AG, DS1_CA2AG); 
    else if DS1_CA1SP='4' then BR_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='4' then BR_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='4' then BR_AGE=DS1_CA3AG+0; 
   /*����� �߻� �� ��� �⵵*/
            if BR_AGE=99999 then BR_YR=99999; else BR_YR= DS1_AGE-BR_AGE;

   /*�ڱð�ξ� ����*/
      if DS1_CA1SP='5' or DS1_CA2SP='5' or DS1_CA3SP='5' then CE_C=1; else CE_C=0; 
   /*�ڱð�ξ� �߻� ���� ����*/
            if DS1_CA1SP='5' and DS1_CA2SP='5' then CE_AGE=min(DS1_CA1AG, DS1_CA2AG); 
    else if DS1_CA1SP='5' then CE_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='5' then CE_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='5' then CE_AGE=DS1_CA3AG+0; 
   /*�ڱð�ξ� �߻� �� ��� �⵵*/
            if CE_AGE=99999 then CE_YR=99999; else CE_YR= DS1_AGE-CE_AGE;

    /*��� ����*/
     if DS1_CA1SP='6' or DS1_CA2SP='6' or DS1_CA3SP='6' then LU_C=1; else LU_C=0; 
   /*��� �߻� ���� ����*/
	         if DS1_CA1SP='6' and DS1_CA2SP='6' then LU_AGE=min(DS1_CA1AG, DS1_CA2AG); 
     else if DS1_CA1SP='6' then LU_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='6' then LU_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='6' then LU_AGE=DS1_CA3AG+0; 
   /*��� �߻� �� ��� �⵵*/
            if LU_AGE=99999 then LU_YR=99999; else LU_YR= DS1_AGE-LU_AGE;

    /*���󼱾� ����*/ 
      if DS1_CA1SP='7' or DS1_CA2SP='7' or DS1_CA3SP='7' then THY_C=1; else THY_C=0; 
   /*���󼱾� �߻� ���� ����*/
            if DS1_CA1SP='7' and DS1_CA2SP='7' then THY_AGE=min(DS1_CA1AG, DS1_CA2AG); 
    else if DS1_CA1SP='7' then THY_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='7' then THY_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='7' then THY_AGE=DS1_CA3AG+0; 
   /*���󼱾� �߻� �� ��� �⵵*/
            if THY_AGE=99999 then THY_YR=99999; else THY_YR= DS1_AGE-THY_AGE;

    /*�������� ����*/ 
    if DS1_CA1SP='8' or DS1_CA2SP='8' or DS1_CA3SP='8' then PRO_C=1; else PRO_C=0; 
   /*�������� �߻� ���� ����*/
	         if DS1_CA1SP='8' and DS1_CA2SP='8' then PRO_AGE=min(DS1_CA1AG, DS1_CA2AG); 
     else if DS1_CA1SP='8' then PRO_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='8' then PRO_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='8' then PRO_AGE=DS1_CA3AG+0; 
   /*�������� �߻� �� ��� �⵵*/
            if PRO_AGE=99999 then PRO_YR=99999; else PRO_YR= DS1_AGE-PRO_AGE;

    /*�汤�� ����*/ 
    if DS1_CA1SP='9' or DS1_CA2SP='9' or DS1_CA3SP='9' then BL_C=1; else BL_C=0; 
   /*�汤�� �߻� ���� ����*/
	         if DS1_CA1SP='9' and DS1_CA2SP='9' then BL_AGE=min(DS1_CA1AG, DS1_CA2AG); 
      else if DS1_CA1SP='9' then BL_AGE=DS1_CA1AG+0; else if  DS1_CA2SP='9' then BL_AGE=DS1_CA2AG+0; else if  DS1_CA3SP='9' then BL_AGE=DS1_CA3AG+0; 
   /*�汤�� �߻� �� ��� �⵵*/
            if BL_AGE=99999 then BL_YR=99999; else BL_YR= DS1_AGE-BL_AGE;

	/*�ٸ��� ����*/
    if DS1_CA1SP='10' or DS1_CA2SP='10' or DS1_CA3SP='10' then OT_C=1; else OT_C=0; 
run;

proc freq data=B.TOTAL; tables CA*Total_Chronic_1*NO_DZ /list missing; run; GA_C LI_C CO_C BR_C CE_C LU_C THY_C PRO_C BL_C
GA_C*GA_AGE*GA_YR LI_C*LI_AGE*LI_YR CO_C*CO_AGE*CO_YR BR_C*BR_AGE*BR_YR CE_C*CE_AGE*CE_YR LU_C*LU_AGE*LU_YR THY_C*THY_AGE*THY_YR PRO_C*PRO_AGE*PRO_YR BL_C*BL_AGE*BL_YR
/list missing; run;
data a; set B.TOTAL; if CA=1; run; 

/*****************������ data �� ���̱�***************/
proc sort data=B.TOTAL; by NIHID; run;
proc sort data=a.CTBS0413_04_drug; by NIHID; run;
proc sort data=a.CTBS0413_05_famhis; by NIHID; run;
proc sort data=a.CTBS0413_07_gen; by NIHID; run;
proc sort data=a.CTBS0413_08_habit1; by NIHID; run;
proc sort data=a.CTBS0413_09_habit2; by NIHID; run;
proc sort data=a.CTBS0413_10_pwi; by NIHID; run;
proc sort data=a.CTBS0413_11_femd; by NIHID; run;
proc sort data=a.CTBS0413_12_diet; by NIHID; run;
proc sort data=a.CTBS0413_13_ffqnutri; by NIHID; run;
proc sort data=a.CTBS0413_14_anthropom; by NIHID; run;
proc sort data=a.CTBS0413_15_biochem; by NIHID; run;


/*********************************��ü �м� dataset*************************************/

data B.TOTAL_1;  merge B.TOTAL a.CTBS0413_04_drug a.CTBS0413_05_famhis a.CTBS0413_07_gen a.CTBS0413_08_habit1 a.CTBS0413_09_habit2 a.CTBS0413_10_pwi 
                             a.CTBS0413_11_femd a.CTBS0413_12_diet a.CTBS0413_13_ffqnutri a.CTBS0413_14_anthropom a.CTBS0413_15_biochem; by NIHID; run;
data B.TOTAL_1; set B.TOTAL_1;     if CA=1 then group=1; else if Total_Chronic_1=1 then group=2; else if NO_DZ=1 then group=3; run; 
proc freq data=B.TOTAL_1; tables group*CA*Total_Chronic_1*NO_DZ/list missing; run; 


/*�� ���� ����*/
proc freq data=B.TOTAL_1; tables DS1_SMOKE*DS1_SMOKE_100/list missing; run;
data B.TOTAL_2; set B.TOTAL_1;
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then csmok=9; 
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then csmok=1;
	else if DS1_SMOKE in ('1', '2') or  DS1_SMOKE_100 in ('1', '2') then csmok=0;
            if DS1_SMOKE in ('66666', '99999') and  DS1_SMOKE_100 in ('66666', '99999') then psmok=9; 
    else if DS1_SMOKE='3' or DS1_SMOKE_100='3' then psmok=2;
	else if DS1_SMOKE in ('2') or  DS1_SMOKE_100 in ('2') then psmok=1; 
	else if DS1_SMOKE in ('1') or  DS1_SMOKE_100 in ('1') then psmok=0; run; 
proc freq data=B.TOTAL_2; tables csmok csmok*DS1_SMOKE*DS1_SMOKE_100 psmok*DS1_SMOKE*DS1_SMOKE_100/list missing; run;

/*���� ���� ����*/
proc freq data=B.TOTAL_1;  tables DS1_DRINK/list missing; run;
data B.TOTAL_2;  set B.TOTAL_2; 
            if DS1_DRINK in ('66666', '99999') then cdrink=9; 
    else if DS1_DRINK='3' then cdrink=1;
	else if DS1_DRINK in ('1', '2') then cdrink=0;
            if DS1_DRINK in ('66666', '99999') then pdrink=9; 
    else if DS1_DRINK='3' then pdrink=2;
	else if DS1_DRINK='2' then pdrink=1;
	else if DS1_DRINK in ('1') then pdrink=0; run; 
proc freq data=B.TOTAL_2; tables DS1_DRINK*cdrink*pdrink /list missing; run;

/*� ���� ����*/
proc freq data=B.TOTAL_1;  tables DS1_EXER DS1_EXERFQ DS1_EXERDU DS1_EXER* DS1_EXERFQ* DS1_EXERDU/list missing; run;
data B.TOTAL_2;  set B.TOTAL_2; 
          if DS1_EXER in ('66666', '99999') then cexer=9; else if DS1_EXER='2' then cexer=1; else if DS1_EXER in ('1') then cexer=0; 
          if DS1_EXERFQ=1 then cexer_n=1.5; else if DS1_EXERFQ=2 then cexer_n=3.5; else if DS1_EXERFQ=3 then cexer_n=5.5; else if DS1_EXERFQ=4 then cexer_n=7; 
  else if DS1_EXER in ('1') then cexer_n=0; else if DS1_EXERFQ='99999' then cexer_n=99999; 
          if cexer_n not in (99999) and DS1_EXERDU not in ('77777', '99999') then cexer_wk=cexer_n*DS1_EXERDU; else if cexer_n in (99999) or DS1_EXERDU in ('99999') then cexer_wk=99999; else if DS1_EXER in ('1') then cexer_wk=0;
		  if 0=<cexer_wk<150 then cexer_wk1=1; else if 150=<cexer_wk<99999 then cexer_wk1=2; else if cexer_wk=99999 then cexer_wk1=99;
		  if cexer_wk=0 then cexer_wk2=1; else if 0<cexer_wk<150 then cexer_wk2=2; else if 150=<cexer_wk<99999 then cexer_wk2=3; else if cexer_wk=99999 then cexer_wk2=99;
run; 
proc freq data=B.TOTAL_2; tables cexer cexer_n cexer_wk /list missing; run;


/*BMI, WH ratio*/
proc freq data=B.TOTAL_1;  tables DS1_HEIGHT DS1_WEIGHT DS1_WAIST DS1_HIP/list missing nopercent nocol norow; run;
data B.TOTAL_2;  set B.TOTAL_2; 
            if DS1_HEIGHT in ('66666', '99999') or DS1_WEIGHT in ('66666', '99999') then cbmi=99999; 
    else if DS1_HEIGHT not in ('66666', '99999') and DS1_WEIGHT not in ('66666', '99999') then cbmi=DS1_WEIGHT/((DS1_HEIGHT/100)*(DS1_HEIGHT/100)); 
		    if 0<cbmi<25 then cbmi1=1; else if 25<=cbmi<99999 then cbmi1=2; else if cbmi=99999 then cbmi1=99999;
			if 0<cbmi<23 then cbmi2=1; else if 23<=cbmi<99999 then cbmi2=2; else if cbmi=99999 then cbmi2=99999;
	        if 0<cbmi<18.5 then cbmi3=1; else if 18.5<=cbmi<23 then cbmi3=2; else if 23<=cbmi<25 then cbmi3=3; else if 25<=cbmi<99999 then cbmi3=4;else if cbmi=99999 then cbmi3=99999;
            if DS1_WAIST in ('66666', '99999') or DS1_HIP in ('66666', '99999') then cwhratio=99999; 
    else if DS1_WAIST not in ('66666', '99999') and DS1_HIP not in ('66666', '99999') then cwhratio=DS1_WAIST/DS1_HIP;  
	        if 0<cwhratio<0.85 then cwhratio1=1; else if 0.85<=cwhratio<99999 then cwhratio1=2; else if cwhratio=99999 then cwhratio1=99999;
run;
proc freq data=B.TOTAL_2; tables cbmi cbmi1 cbmi2 cbmi3 cwhratio cwhratio1; run;
proc freq data=B.TOTAL_2; where cbmi^=99999; tables (cbmi1 cbmi2 cbmi3 cwhratio1)*group/chisq; run;
proc freq data=B.TOTAL_2; tables (cbmi2 )*group/chisq; run;

/*����������*/
proc freq data=B.TOTAL_1; tables DS1_SS01 DS1_SS02 DS1_SS03 DS1_SS04; run;
data B.TOTAL_2;  set B.TOTAL_2; 
    cenergy=DS1_SS01+0;     cprotein=DS1_SS02+0;     cfat=DS1_SS03+0;     csugar=DS1_SS04+0; run;
proc freq data=B.TOTAL_2; tables cenergy cprotein cfat csugar ; run;
proc univariate data=B.TOTAL_2;  var cenergy cprotein cfat csugar ; run;


