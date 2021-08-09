libname a "C:\Users\USER01\Desktop\예방의학회";
/*data set (대상자 data 2개)*/
Data a.base; set a.core_0711; run; /*N=211721*/
Data a.FU1; set a.CT1; run; /*N=65639*/
Data a.FU2; set a.CT2; run; /*N=65639*/
Proc contents data=a.base; run;
Proc contents data=a.fu1; run;
Proc contents data=a.fu2; run;

proc sql;
create table a.base_1 as
select  ID, SEX, AGE, CA1, CA2, CA3, CA1SP, CA2SP, CA3SP, DS1_FCA1, DS1_FCA2, DS1_FCA3, DS1_FCA1NA, DS1_FCA2NA, DS1_FCA3NA,
           B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B12, B13, B14, B15, B16, B17, B18, B19, B20, B21, B23, B24,
		   MEN_YN, PMAG, MNSAG, CHILD, BRSTF, SMOKE, SMOKE_100, DRINK, EXER, EXERFQ, BENI
from a.base;
quit;
proc sql;
create table a.fu_1 as
select DIST_ID, SEX, AGE, CA1, CA2, CA3, CA1SP, CA2SP, CA3SP, DS1_FCA1, DS1_FCA2, DS1_FCA3, DS1_FCA1NA, DS1_FCA2NA, DS1_FCA3NA,
           B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B12, B13, B14, B15, B16, B17, B18, B19, B20, B21, B23, B24,
		   MEN_YN, PMAG, MNSAG, CHILD, BRSTF, SMOKE, SMOKE_100, DRINK, EXER, EXERFQ, BENI
from a.fu1;
quit;
proc sql;
create table a.fu_2 as
select DIST_ID, CT2_SEX, CT2_AGE, CT2_CA1, CT2_CA2, CT2_CA1SP, CT2_CA2SP, CT2_FCA1, CT2_FCA2, CT2_FCA1NA, CT2_FCA2NA, 
           CT2_SS01, CT2_SS02,  CT2_SS03, CT2_SS04, CT2_SS05, CT2_SS06, CT2_SS07, CT2_SS08, CT2_SS09, CT2_SS10, CT2_SS11, CT2_SS12, CT2_SS13, CT2_SS14, CT2_SS15, CT2_SS16, CT2_SS17, CT2_SS18, CT2_SS19, CT2_SS20,
		   CT2_SS21, CT2_SS23, CT2_SS24,
		   CT2_MENS, CT2_P3_SMOKE_100, CT2_P2_DRINK, CT2_EXER, CT2_EXERFQ, CT2_BENI
from a.fu2;
quit;

/* 변수명 바꾸기*/
data a.fu_1; set a.fu_1;
rename SEX=FU_SEX  AGE=FU_AGE  CA1=FU_CA1  CA2=FU_CA2  CA3=FU_CA3  CA1SP=FU_CA1SP  CA2SP=FU_CA2SP  CA3SP=FU_CA3SP 
           DS1_FCA1=FU_FCA1  DS1_FCA2=FU_FCA2  DS1_FCA3=FU_FCA3  DS1_FCA1NA=FU_FCA1NA  DS1_FCA2NA=FU_FCA2NA  DS1_FCA3NA=FU_FCA3NA
           B01=FU_B01  B02=FU_B02  B03=FU_B03  B04=FU_B04  B05=FU_B05  B06=FU_B06  B07=FU_B07  B08=FU_B08  B09=FU_B09  B10=FU_B10  B11=FU_B11  
           B12=FU_B12  B13=FU_B13  B14=FU_B14  B15=FU_B15  B16=FU_B16  B17=FU_B17  B18=FU_B18  B19=FU_B19  B20=FU_B20  B21=FU_B21  B23=FU_B23  B24=FU_B24
		   MEN_YN=FU_MEN_YN  PMAG=FU_PMAG  MNSAG=FU_MNSAG  CHILD=FU_CHILD  BRSTF=FU_BRSTF  SMOKE=FU_SMOKE  SMOKE_100=FU_SMOKE_100  DRINK=FU_DRINK  EXER=FU_EXER  EXERFQ=FU_EXERFQ  BENI=FU_BENI;
run;
/*MERGE CT1&CT2*/
proc sql;
create table a.fu as /*새파일 만듬*/
select *
from a.fu_1 as a left join fu_2 b
on a.DIST_ID=b.DIST_ID;
quit;

proc freq data=a.base_1;
table CA1 CA2 CA3 CA1SP CA2SP CA3SP; run;
proc freq data=a.fu_1;
table FU_CA1 FU_CA2 FU_CA3 FU_CA1SP FU_CA2SP FU_CA3SP; run; /*유방암 416*/
proc freq data=a.fu_2;
table CT2_CA1 CT2_CA2 CT2_CA1SP CT2_CA2SP; run; /*유방암 255*/

/*base data 암제거*/
data a.base_1; set a.base_1;
if CA1=2 then delete;
if CA2=2 then delete;
if CA3=2 then delete; run;

proc sql ; 
create table a.bc  as 
select * 
from a.fu a inner join a.base_1 b 
on a.DIST_ID = b.ID  ;
run;
proc freq data=a.bc;
table CA1 CA2 CA3 CA1SP CA2SP CA3SP FU_CA1 FU_CA2 FU_CA3 FU_CA1SP FU_CA2SP FU_CA3SP CT2_CA1 CT2_CA2 CT2_CA1SP CT2_CA2SP; run;

/*검진 두번 받은 사람 중에서 여자*/
data a.bc;
set a.bc;
if sex='1' then delete;
run;
proc freq data=a.bc; 
table  CT2_CA1 CT2_CA2 CT2_CA1SP CT2_CA2SP; run;

/*지방(Fat)을 kcal로 바꾸기*/
data a.bc;
set a.bc;
fat=CT2_SS03*9;
run;
/*여성 중 유방암 진단받은 사람(245명), 유방암 아닌 사람(41348명)*/ 
data a.bc;
set a.bc;
if CT2_CA1SP = 4  then br=1;
if CT2_CA2SP = 4 then br=1;
if br=. then br=0;
run;
proc freq data=a.bc; table br/list missing; run;

/*문자형을 숫자형으로 바꾸기*/
data a.number;
set a.bc;
S01=input(CT2_SS01,8.);
run;
data a.number;
set a.number;
S02=input(CT2_SS02,8.);
run;
data a.number;
set a.number;
S03=input(fat,8.);
run;
data a.number;
set a.number;
S04=input(CT2_SS04,8.);
run;
data a.number;
set a.number;
S05=input(CT2_SS05,8.);
run;
data a.number;
set a.number;
S06=input(CT2_SS06,8.);
run;
data a.number;
set a.number;
S07=input(CT2_SS07,8.);
run;
data a.number;
set a.number;
S08=input(CT2_SS08,8.);
run;
data a.number;
set a.number;
S09=input(CT2_SS09,8.);
run;
data a.number;
set a.number;
S10=input(CT2_SS10,8.);
run;
data a.number;
set a.number;
S11=input(CT2_SS11,8.);
run;
data a.number;
set a.number;
S12=input(CT2_SS12,8.);
run;
data a.number;
set a.number;
S13=input(CT2_SS13,8.);
run;
data a.number;
set a.number;
S14=input(CT2_SS14,8.);
run;
data a.number;
set a.number;
S15=input(CT2_SS15,8.);
run;
data a.number;
set a.number;
S16=input(CT2_SS16,8.);
run;
data a.number;
set a.number;
S17=input(CT2_SS17,8.);
run;
data a.number;
set a.number;
S18=input(CT2_SS18,8.);
run;
data a.number;
set a.number;
S19=input(CT2_SS19,8.);
run;
data a.number;
set a.number;
S20=input(CT2_SS20,8.);
run;
data a.number;
set a.number;
S21=input(CT2_SS21,8.);
run;
data a.number;
set a.number;
S23=input(CT2_SS23,8.);
run;
data a.number;
set a.number;
S24=input(CT2_SS24,8.);
run;
/*영양소 4분위수 구하기*/
proc means data=a.number noprint;
var S01;
output out=a.b01 q1=q1 q3=q3;
run;
proc sql;
create table nu1 AS
Select *, q3-q1 AS IQR
From a.b01; 
quit;
proc means data=a.number noprint;
var B02;
output out=a.b02 q1=q1 q3=q3;
run;
proc sql;
create table nu2 AS
Select *, q3-q1 AS IQR
From a.b02; 
quit;
proc means data=a.number noprint;
var S03;
output out=a.b03  q1=q1 q3=q3;
run;
proc sql;
create table nu3 AS
Select *, q3-q1 AS IQR
From a.b03; 
quit;
proc means data=a.two2 noprint;
var B04;
output out=a.b04  q1=q1 q3=q3;
run;
proc sql;
create table nu4 AS
Select *, q3-q1 AS IQR
From a.b04; 
quit;
proc means data=a.two2 noprint;
var B05;
output out=a.b05  q1=q1 q3=q3;
run;
proc sql;
create table nu5 AS
Select *, q3-q1 AS IQR
From a.b05; 
quit;
proc means data=a.two2 noprint;
var B06;
output out=a.b06  q1=q1 q3=q3;
run;
proc sql;
create table nu6 AS
Select *, q3-q1 AS IQR
From a.b06; 
quit;
proc means data=a.two2 noprint;
var B07;
output out=a.b07  q1=q1 q3=q3;
run;
proc sql;
create table nu7 AS
Select *, q3-q1 AS IQR
From a.b07; 
quit;
proc means data=a.two2 noprint;
var B08;
output out=a.b08  q1=q1 q3=q3;
run;
proc sql;
create table nu8 AS
Select *, q3-q1 AS IQR
From a.b08; 
quit;
proc means data=a.two2 noprint;
var B09;
output out=a.b09  q1=q1 q3=q3;
run;
proc sql;
create table nu9 AS
Select *, q3-q1 AS IQR
From a.b09; 
quit;
proc means data=a.two2 noprint;
var B10;
output out=a.b10  q1=q1 q3=q3;
run;
proc sql;
create table nu10 AS
Select *, q3-q1 AS IQR
From a.b10; 
quit;
proc means data=a.two2 noprint;
var B11;
output out=a.b11  q1=q1 q3=q3;
run;
proc sql;
create table nu11 AS
Select *, q3-q1 AS IQR
From a.b11; 
quit;
proc means data=a.two2 noprint;
var B12;
output out=a.b12  q1=q1 q3=q3;
run;
proc sql;
create table nu12 AS
Select *, q3-q1 AS IQR
From a.b12; 
quit;
proc means data=a.two2 noprint;
var B13;
output out=a.b13  q1=q1 q3=q3;
run;
proc sql;
create table nu13 AS
Select *, q3-q1 AS IQR
From a.b13; 
quit;
proc means data=a.two2 noprint;
var B14;
output out=a.b14  q1=q1 q3=q3;
run;
proc sql;
create table nu14 AS
Select *, q3-q1 AS IQR
From a.b14; 
quit;
proc means data=a.two2 noprint;
var B15;
output out=a.b15  q1=q1 q3=q3;
run;
proc sql;
create table nu15 AS
Select *, q3-q1 AS IQR
From a.b15; 
quit;
proc means data=a.two2 noprint;
var B16;
output out=a.b16  q1=q1 q3=q3;
run;
proc sql;
create table nu16 AS
Select *, q3-q1 AS IQR
From a.b16; 
quit;
proc means data=a.two2 noprint;
var B17;
output out=a.b17  q1=q1 q3=q3;
run;
proc sql;
create table nu17 AS
Select *, q3-q1 AS IQR
From a.b17; 
quit;
proc means data=a.two2 noprint;
var B18;
output out=a.b18  q1=q1 q3=q3;
run;
proc sql;
create table nu18 AS
Select *, q3-q1 AS IQR
From a.b18; 
quit;
proc means data=a.two2 noprint;
var B19;
output out=a.b19  q1=q1 q3=q3;
run;
proc sql;
create table nu19 AS
Select *, q3-q1 AS IQR
From a.b19; 
quit;
proc means data=a.two2 noprint;
var B20;
output out=a.b20  q1=q1 q3=q3;
run;
proc sql;
create table nu20 AS
Select *, q3-q1 AS IQR
From a.b20; 
quit;
proc means data=a.two2 noprint;
var B21;
output out=a.b21  q1=q1 q3=q3;
run;
proc sql;
create table nu21 AS
Select *, q3-q1 AS IQR
From a.b21; 
quit;
proc means data=a.two2 noprint;
var B23;
output out=a.b23 q1=q1 q3=q3;
run;
proc sql;
create table nu23 AS
Select *, q3-q1 AS IQR
From a.b23; 
quit;
proc means data=a.two2 noprint;
var B24;
output out=a.b24 q1=q1 q3=q3;
run;
proc sql;
create table nu24 AS
Select *, q3-q1 AS IQR
From a.b24; 
quit;
proc sql;
create table nu1_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu1; 
quit;
proc sql;
create table nu2_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu2; 
quit;
proc sql;
create table nu3_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu3; 
quit;
proc sql;
create table nu4_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu4; 
quit;
proc sql;
create table nu5_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu5; 
quit;
proc sql;
create table nu6_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu6; 
quit;
proc sql;
create table nu7_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu7; 
quit;
proc sql;
create table nu8_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu8; 
quit;
proc sql;
create table nu9_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu9; 
quit;
proc sql;
create table nu10_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu10; 
quit;
proc sql;
create table nu11_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu11; 
quit;
proc sql;
create table nu12_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu12; 
quit;
proc sql;
create table nu13_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu13; 
quit;
proc sql;
create table nu14_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu14; 
quit;
proc sql;
create table nu15_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu15; 
quit;
proc sql;
create table nu16_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu16; 
quit;
proc sql;
create table nu17_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu17; 
quit;
proc sql;
create table nu18_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu18; 
quit;
proc sql;
create table nu19_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu19; 
quit;
proc sql;
create table nu20_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu20; 
quit;
proc sql;
create table nu21_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu21; 
quit;
proc sql;
create table nu23_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu23; 
quit;
proc sql;
create table nu24_1 AS
select*, q1-1.5*IQR AS MINOUT, q3+1.5*IQR AS MAXOUT 
from nu24; 
quit;
/*이상치 제거*/
data a.two2; set a.two2;
if B01<'448.96208879' then B01='.';
else if B02<'3.1240475819' then B02='.';
else if BB03<'-89.39015743' then BB03='.';
else if B04<'88.901915057' then B04='.';
else if B05<'-152.7784895' then B05='.';
else if B06<'71.0589913' then B06='.';
else if B07<'-0.573531219' then B07='.';
else if B08<'-216.3288857' then B08='.';
else if B09<'-206.8420561' then B09='.';
else if B10<'-913.0678986' then B10='.';
else if B11<'0.0338252702' then B11='.';
else if B12<'-0.121625812' then B12='.';
else if B13<'0.6669774439' then B13='.';
else if B14<'-50.99570414' then B14='.';
else if B15<'0.7498511984' then B15='.';
else if B16<'0.0450879113' then B16='.';
else if B17<'-44.83489658' then B17='.';
else if B18<'-62.48194228' then B18='.';
else if B19<'-1196.980256' then B19='.';
else if B20<'-2.344800637' then B20='.';
else if B21<'-0.79941563' then B21='.';
else if B23<'-1.648536473' then B23='.';
else if B24<'-109.5770195' then B24='.';
run;
data a.two2; set a.two2;
if B01>'2875.9689861' then B01='.';
else if B02>'106.29930446' then B02='.';
else if BB03>'525.72989363' then BB03='.';
else if B04>'509.63623442' then B04='.';
else if B05>'1007.5956796' then B05='.';
else if B06>'1617.6189315' then B06='.'; 
else if B07>'19.289226104' then B07='.';
else if B08>'4514.1485771' then B08='.';
else if B09>'1057.7582712' then B09='.';
else if B10>'5397.1960192' then B10='.';
else if B11>'1.8155892436' then B11='.';
else if B12>'1.8187704982' then B12='.';
else if B13>'26.075592463' then B13='.';
else if B14>'258.16186269' then B14='.';
else if B15>'13.976028162' then B15='.';
else if B16>'2.9372956623' then B16='.';
else if B17>'452.99242754' then B17='.';
else if B18>'184.2624126' then B18='.';
else if B19>'5365.8460138' then B19='.';
else if B20>'28.589960402' then B20='.';
else if B21>'11.744123708' then B21='.';
else if B23>'16.676190474' then B23='.';
else if B24>'406.64349591' then B24='.';
run;

data a.kcal; /*kcal 1900이상 초과=1, 1900이하 권장량 이하=2*/
set a.two2;
if 40<=AGE<50 and B01>1900 then stan01=1;
if B01<=1900 then stan01=0;
if 50<=AGE<65 and B01>1700 then stan01=1;
if B01<=1700 then stan01=0;
if 65<=AGE<75 and B01>1600 then stan01=1;
if B01<=1600 then  stan01=0;
if 75<=AGE and B01>1500 then stan01=1;
if B01<=1500 then stan01=0;
run;
proc freq data=a.kcal; table br*stan01/chisq; run;

data a.protein; 
set a.kcal;
if 40<=AGE<50 and B02>50 then stan02=1;
if B02<=50 then stan02=0;
if 50<=AGE<65 and B02>50 then stan02=1;
if B02<=50 then stan02=0;
if 65<=AGE<75 and B02>50 then stan02=1;
if B02<=50 then  stan02=0;
if 75<=AGE and B02>50 then stan02=1;
if B02<=50 then stan02=0;
run;
proc freq data=a.protein; table br*stan02/chisq; run;

data a.fat; 
set a.protein;
if 40<=AGE<50 and B03>570 then stan03=1;
if B03<=570 then stan03=0;
if 50<=AGE<65 and B03>510 then stan03=1;
if B03<=510 then stan03=0;
if 65<=AGE<75 and B03>480 then stan03=1;
if B03<=480 then  stan03=0;
if 75<=AGE and B03>450 then stan03=1;
if B03<=450 then stan03=0;
run;
proc freq data=a.fat; table br*stan03/chisq; run;

data a.carbo; /*탄수화물*/
set a.fat;
if 40<=AGE<50 and B04>130 then stan04=1;
if B04<=130 then stan04=0;
if 50<=AGE<65 and B04>130 then stan04=1;
if B04<=130 then stan04=0;
if 65<=AGE<75 and B04>130 then stan04=1;
if B04<=130 then  stan04=0;
if 75<=AGE and B04>130 then stan04=1;
if B04<=130 then stan04=0;
run;
proc freq data=a.carbo; table br*stan04/chisq; run;

data a.cal; /*칼슘*/ 
set a.carbo;
if 40<=AGE<50 and B05>700 then stan05=1;
if B05<=700 then stan05=0;
if 50<=AGE<65 and B05>800 then stan05=1;
if B05<=800 then stan05=0;
if 65<=AGE<75 and B05>800 then stan05=1;
if B05<=800 then  stan05=0;
if 75<=AGE and B05>800 then stan05=1;
if B05<=800 then stan05=0;
run;
proc freq data=a.cal; table br*stan05/chisq; run;

data a.P; /*인*/ 
set a.cal;
if 40<=AGE<50 and B06>700 then stan06=1;
if B06<=700 then stan06=0;
if 50<=AGE<65 and B06>700 then stan06=1;
if B06<=700 then stan06=0;
if 65<=AGE<75 and B06>700 then stan06=1;
if B06<=700 then  stan06=0;
if 75<=AGE and B06>700 then stan06=1;
if B06<=700 then stan06=0;
run;
proc freq data=a.P; table br*stan06/chisq; run;

data a.Fe; /*철*/ 
set a.P;
if 40<=AGE<50 and B07>14 then stan07=1;
if B07<=14 then stan07=0;
if 50<=AGE<65 and B07>8 then stan07=1;
if B07<=8 then stan07=0;
if 65<=AGE<75 and B07>8 then stan07=1;
if B07<=8 then  stan07=0;
if 75<=AGE and B07>7 then stan07=1;
if B07<=7 then stan07=0;
run;
proc freq data=a.Fe; table br*stan07/chisq; run;

data a.K; /*칼륨*/ 
set a.Fe;
if 40<=AGE<50 and B08>3500 then stan08=1;
if B08<=3500 then stan08=0;
if 50<=AGE<65 and B08>3500 then stan08=1;
if B08<=3500 then stan08=0;
if 65<=AGE<75 and B08>3500 then stan08=1;
if B08<=3500 then  stan08=0;
if 75<=AGE and B08>3500 then stan08=1;
if B08<=3500 then stan08=0;
run;
proc freq data=a.K; table br*stan08/chisq; run;

data a.vitA; /*비타민A*/ 
set a.K;
if 40<=AGE<50 and B09>650 then stan09=1;
if B09<=650 then stan09=0;
if 50<=AGE<65 and B09>600 then stan09=1;
if B09<=600 then stan09=0;
if 65<=AGE<75 and B09>600 then stan09=1;
if B09<=600 then  stan09=0;
if 75<=AGE and B09>600 then stan09=1;
if B09<=600 then stan09=0;
run;
proc freq data=a.vitA; table br*stan09/chisq; run;

data a.Na; /*나트륨*/ 
set a.vitA;
if 40<=AGE<50 and B10>1500 then stan10=1;
if B10<=1500 then stan10=0;
if 50<=AGE<65 and B10>1500 then stan10=1;
if B10<=1500 then stan10=0;
if 65<=AGE<75 and B10>1500 then stan10=1;
if B10<=1500 then  stan10=0;
if 75<=AGE and B10>1500 then stan10=1;
if B10<=1500 then stan10=0;
run;
proc freq data=a.Na; table br*stan10/chisq; run;


data a.VitB1; /*비타민B1*/ 
set a.Na;
if 40<=AGE<50 and B11>1.1 then stan11=1;
if B11<=1.1 then stan11=0;
if 50<=AGE<65 and B11>1.1 then stan11=1;
if B11<=1.1 then stan11=0;
if 65<=AGE<75 and B11>1  then stan11=1;
if B11<=1  then stan11=0;
if 75<=AGE and B11>0.8  then stan11=1;
if B11<=0.8  then stan11=0;
run;
proc freq data=a.VitB1; table br*stan11/chisq; run;

data a.VitB2; /*비타민B2*/ 
set a.VitB1;
if 40<=AGE<50 and B12>1.2 then stan12=1;
if B12<=1.2 then stan12=0;
if 50<=AGE<65 and B12>1.2 then stan12=1;
if B12<=1.2 then stan12=0;
if 65<=AGE<75 and B12>1.1  then stan12=1;
if B12<=1.1  then stan12=0;
if 75<=AGE and B12>1 then stan12=1;
if B12<=1  then stan12=0;
run;
proc freq data=a.VitB2; table br*stan12/chisq; run;

data a.nia; /*니아신*/ 
set a.VitB2;
if 40<=AGE<50 and B13>14 then stan13=1;
if B13<=14 then stan13=0;
if 50<=AGE<65 and B13>14 then stan13=1;
if B13<=14 then stan13=0;
if 65<=AGE<75 and B13>13  then stan13=1;
if B13<=13  then stan13=0;
if 75<=AGE and B13>12 then stan13=1;
if B13<=12  then stan13=0;
run;
proc freq data=a.nia; table br*stan13/chisq; run;

data a.vitc; /*비타민C*/ 
set a.nia;
if 40<=AGE<50 and B14>100 then stan14=1;
if B14<=100 then stan14=0;
if 50<=AGE<65 and B14>100 then stan14=1;
if B14<=100 then stan14=0;
if 65<=AGE<75 and B14>100  then stan14=1;
if B14<=100  then stan14=0;
if 75<=AGE and B14>100 then stan14=1;
if B14<=100  then stan14=0;
run;
proc freq data=a.vitc; table br*stan14/chisq; run;

data a.zinc; /*아연*/ 
set a.vitc;
if 40<=AGE<50 and B15>8 then stan15=1;
if B15<=8 then stan15=0;
if 50<=AGE<65 and B15>8 then stan15=1;
if B15<=8 then stan15=0;
if 65<=AGE<75 and B15>7  then stan15=1;
if B15<=7  then stan15=0;
if 75<=AGE and B15>7 then stan15=1;
if B15<=7  then stan15=0;
run;
proc freq data=a.zinc; table br*stan15/chisq; run;

data a.Vit6; /*비타민B6*/ 
set a.zinc;
if 40<=AGE<50 and B16>1.4 then stan16=1;
if B16<=1.4 then stan16=0;
if 50<=AGE<65 and B16>1.4 then stan16=1;
if B16<=1.4 then stan16=0;
if 65<=AGE<75 and B16>1.4  then stan16=1;
if B16<=1.4  then stan16=0;
if 75<=AGE and B16>1.4 then stan16=1;
if B16<=1.4  then stan16=0;
run;
proc freq data=a.Vit6; table br*stan16/chisq; run;


data a.Fol; /*엽산*/ 
set a.Vit6;
if 40<=AGE<50 and B17>400 then stan17=1;
if B17<=400 then stan17=0;
if 50<=AGE<65 and B17>400 then stan17=1;
if B17<=400 then stan17=0;
if 65<=AGE<75 and B17>400  then stan17=1;
if B17<=400 then stan17=0;
if 75<=AGE and B17>400 then stan17=1;
if B17<=400 then stan17=0;
run;
proc freq data=a.Fol; table br*stan17/chisq; run;


data a.reti; /*레티놀*/ 
set a.Fol;
if 40<=AGE<50 and B18>900then stan18=1;
if B18<=900 then stan18=0;
if 50<=AGE<65 and B18>900 then stan18=1;
if B18<=900 then stan18=0;
if 65<=AGE<75 and B18>900  then stan18=1;
if B18<=900 then stan18=0;
if 75<=AGE and B18>900 then stan18=1;
if B18<=900 then stan18=0;
run;
proc freq data=a.reti; table br*stan18/chisq; run;

data a.fiber; /*섬유*/ 
set a.reti;
if 40<=AGE<50 and B21>20then stan21=1;
if B21<=20 then stan21=0;
if 50<=AGE<65 and B21>20 then stan21=1;
if B21<=20 then stan21=0;
if 65<=AGE<75 and B21>20  then stan21=1;
if B21<=20 then stan21=0;
if 75<=AGE and B21>20 then stan21=1;
if B21<=20 then stan21=0;
run;
proc freq data=a.fiber; table br*stan21/chisq; run;

data a.vitE; /*비타민E*/ 
set a.fiber;
if 40<=AGE<50 and B23>12then stan23=1;
if B23<=12 then stan23=0;
if 50<=AGE<65 and B23>12 then stan23=1;
if B23<=12 then stan23=0;
if 65<=AGE<75 and B23>12  then stan23=1;
if B23<=12 then stan23=0;
if 75<=AGE and B23>12 then stan23=1;
if B23<=12 then stan23=0;
run;
proc freq data=a.vitE; table br*stan23/chisq; run;


data a.chol; /*콜레스테롤*/ 
set a.vitE;
if 40<=AGE<50 and B24>180 then stan24=1;
if B24<=180 then stan24=0;
if 50<=AGE<65 and B24>120 then stan24=1;
if B24<=120 then stan24=0;
if 65<=AGE<75 and B23>50 then stan24=1;
if B24<=50 then stan24=0;
if 75<=AGE and B24>20 then stan24=1;
if B24<=20 then stan24=0;
run;
proc freq data=a.chol; table br*stan24/chisq; run;
