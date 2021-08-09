libname RE 'H:\도시기반\change'; run;

DATA BASE;  set RE.CORE_0711; run; /*N=211721*/
DATA FU1;  set RE.CT1; run; /*N=65639*/
DATA FU2; set RE.CT2; run; /*N=65639*/

proc contents data=base; run;
proc contents data=fu1; run;
proc contents data=fu2; run; 

proc sql;
create table base_1 as
select ID, SEX, AGE, CA1, CA2, CA3, CA1SP, CA2SP, CA3SP, DS1_FCA1, DS1_FCA2, DS1_FCA3, DS1_FCA1NA, DS1_FCA2NA, DS1_FCA3NA,
           B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B12, B13, B14, B15, B16, B17, B18, B19, B20, B21, B23, B24,
		   MEN_YN, PMAG, MNSAG, CHILD, BRSTF, SMOKE, SMOKE_100, DRINK, EXER, EXERFQ, BENI
from base;
quit;	
proc sql;
create table fu_1 as
select DIST_ID, SEX, AGE, CA1, CA2, CA3, CA1SP, CA2SP, CA3SP, DS1_FCA1, DS1_FCA2, DS1_FCA3, DS1_FCA1NA, DS1_FCA2NA, DS1_FCA3NA,
           B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B12, B13, B14, B15, B16, B17, B18, B19, B20, B21, B23, B24,
		   MEN_YN, PMAG, MNSAG, CHILD, BRSTF, SMOKE, SMOKE_100, DRINK, EXER, EXERFQ, BENI
from fu1;
quit;
proc sql;
create table fu_2 as
select DIST_ID, CT2_SEX, CT2_AGE, CT2_CA1, CT2_CA2, CT2_CA1SP, CT2_CA2SP, CT2_FCA1, CT2_FCA2, CT2_FCA1NA, CT2_FCA2NA, 
           CT2_SS01, CT2_SS02,  CT2_SS03, CT2_SS04, CT2_SS05, CT2_SS06, CT2_SS07, CT2_SS08, CT2_SS09, CT2_SS10, CT2_SS11, CT2_SS12, CT2_SS13, CT2_SS14, CT2_SS15, CT2_SS16, CT2_SS17, CT2_SS18, CT2_SS19, CT2_SS20,
		   CT2_SS21, CT2_SS23, CT2_SS24,
		   CT2_MENS, CT2_P3_SMOKE_100, CT2_P2_DRINK, CT2_EXER, CT2_EXERFQ, CT2_BENI
from fu2;
quit;

/*변수명 바꾸기*/
data fu_1; set fu_1;
rename SEX=FU_SEX  AGE=FU_AGE  CA1=FU_CA1  CA2=FU_CA2  CA3=FU_CA3  CA1SP=FU_CA1SP  CA2SP=FU_CA2SP  CA3SP=FU_CA3SP 
           DS1_FCA1=FU_FCA1  DS1_FCA2=FU_FCA2  DS1_FCA3=FU_FCA3  DS1_FCA1NA=FU_FCA1NA  DS1_FCA2NA=FU_FCA2NA  DS1_FCA3NA=FU_FCA3NA
           B01=FU_B01  B02=FU_B02  B03=FU_B03  B04=FU_B04  B05=FU_B05  B06=FU_B06  B07=FU_B07  B08=FU_B08  B09=FU_B09  B10=FU_B10  B11=FU_B11  
           B12=FU_B12  B13=FU_B13  B14=FU_B14  B15=FU_B15  B16=FU_B16  B17=FU_B17  B18=FU_B18  B19=FU_B19  B20=FU_B20  B21=FU_B21  B23=FU_B23  B24=FU_B24
		   MEN_YN=FU_MEN_YN  PMAG=FU_PMAG  MNSAG=FU_MNSAG  CHILD=FU_CHILD  BRSTF=FU_BRSTF  SMOKE=FU_SMOKE  SMOKE_100=FU_SMOKE_100  DRINK=FU_DRINK  EXER=FU_EXER  EXERFQ=FU_EXERFQ  BENI=FU_BENI;
run;

/*MERGE CT1&CT2*/
proc sql;
create table fu as
select *
from fu_1 a left join fu_2 b
on a.dist_id=b.dist_id;
run; /*N=65639*/

proc freq data=base_1;
table CA1 CA2 CA3 CA1SP CA2SP CA3SP; run;
proc freq data=fu_1;
table FU_CA1 FU_CA2 FU_CA3 FU_CA1SP FU_CA2SP FU_CA3SP; run; /*유방암 416*/
proc freq data=fu_2;
table CT2_CA1 CT2_CA2 CT2_CA1SP CT2_CA2SP; run; /*유방암 255*/

/*base data 암제거*/
data base_1; set base_1;
if CA1=2 then delete;
if CA2=2 then delete;
if CA3=2 then delete; run;

proc sql ; 
create table re.bc  as 
select * 
from fu a inner join base_1 b 
on a.DIST_ID = b.ID  ;
run; /*N=63337*/
proc freq data=re.bc;
table CA1 CA2 CA3 CA1SP CA2SP CA3SP FU_CA1 FU_CA2 FU_CA3 FU_CA1SP FU_CA2SP FU_CA3SP CT2_CA1 CT2_CA2 CT2_CA1SP CT2_CA2SP; run; /*유방암 246*/

DATA temp; set re.bc; run;

/*여자만 추출*/
data temp; set temp;
if sex=1 then delete; run; /*N=41593*/
proc freq data=temp;
table CT2_CA1 CT2_CA2 CT2_CA1SP CT2_CA2SP; run; /*유방암 245*/


/*유방암 발생자 묶기*/
data temp; set temp;
if CT2_CA1SP=4 then bcyn=1;
else if CT2_CA2SP=4 then bcyn=1;
else bcyn=0; run;
proc freq data=temp;
table bcyn; run;

/*******************************************/
/*유방암 발생자만 추출 N= 245*/
PROC SQL;
CREATE TABLE bc_y AS
SELECT *
FROM temp
WHERE BCYN=1 ;
QUIT;
/*******************************************/

/*지방변수 다시 구하기(지방9kcal/g)*/
data temp; set temp;
if CT2_SS03 then fat=CT2_SS03*9; run;
/*문자형을 숫자형으로 바꾸기*/
data test; set temp;
S01=input(CT2_SS01,8.);
S02=input(CT2_SS02,8.);
S03=input(fat,8.);
S04=input(CT2_SS04,8.);
S05=input(CT2_SS05,8.);
S06=input(CT2_SS06,8.);
S07=input(CT2_SS07,8.);
S08=input(CT2_SS08,8.);
S09=input(CT2_SS09,8.);
S10=input(CT2_SS10,8.);
S11=input(CT2_SS11,8.);
S12=input(CT2_SS12,8.);
S13=input(CT2_SS13,8.);
S14=input(CT2_SS14,8.);
S15=input(CT2_SS15,8.);
S16=input(CT2_SS16,8.);
S17=input(CT2_SS17,8.);
S18=input(CT2_SS18,8.);
S19=input(CT2_SS19,8.);
S20=input(CT2_SS20,8.);
S21=input(CT2_SS21,8.);
S23=input(CT2_SS23,8.);
S24=input(CT2_SS24,8.);
run;

/*영양소 사분위수 구하기*/
PROC MEANS DATA=test NOPRINT;VAR s01; OUTPUT OUT=n01 Q1=Q1 Q3=Q3; RUN;
PROC MEANS DATA=test NOPRINT;VAR s02; OUTPUT OUT=n02 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s03; OUTPUT OUT=n03 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s04; OUTPUT OUT=n04 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s05; OUTPUT OUT=n05 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s06; OUTPUT OUT=n06 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s07; OUTPUT OUT=n07 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s08; OUTPUT OUT=n08 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s09; OUTPUT OUT=n09 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s10; OUTPUT OUT=n10 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s11; OUTPUT OUT=n11 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s12; OUTPUT OUT=n12 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s13; OUTPUT OUT=n13 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s14; OUTPUT OUT=n14 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s15; OUTPUT OUT=n15 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s16; OUTPUT OUT=n16 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s17; OUTPUT OUT=n17 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s18; OUTPUT OUT=n18 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s19; OUTPUT OUT=n19 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s20; OUTPUT OUT=n20 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s21; OUTPUT OUT=n21 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s23; OUTPUT OUT=n23 Q1=Q1 Q3=Q3;RUN;
PROC MEANS DATA=test NOPRINT;VAR s24; OUTPUT OUT=n24 Q1=Q1 Q3=Q3;RUN;

PROC SQL;
CREATE TABLE nu1 AS
SELECT* , Q3-Q1 AS IQR
FROM n01 ; QUIT;
PROC SQL;
CREATE TABLE nu2 AS
SELECT* , Q3-Q1 AS IQR
FROM n02 ; QUIT;
PROC SQL;
CREATE TABLE nu3 AS
SELECT* , Q3-Q1 AS IQR
FROM n03 ; QUIT;
PROC SQL;
CREATE TABLE nu4 AS
SELECT* , Q3-Q1 AS IQR
FROM n04 ; QUIT;
PROC SQL;
CREATE TABLE nu5 AS
SELECT* , Q3-Q1 AS IQR
FROM n05 ; QUIT;
PROC SQL;
CREATE TABLE nu6 AS
SELECT* , Q3-Q1 AS IQR
FROM n06 ; QUIT;
PROC SQL;
CREATE TABLE nu7 AS
SELECT* , Q3-Q1 AS IQR
FROM n07 ; QUIT;
PROC SQL;
CREATE TABLE nu8 AS
SELECT* , Q3-Q1 AS IQR
FROM n08 ; QUIT;
PROC SQL;
CREATE TABLE nu9 AS
SELECT* , Q3-Q1 AS IQR
FROM n09 ; QUIT;
PROC SQL;
CREATE TABLE nu10 AS
SELECT* , Q3-Q1 AS IQR
FROM n10 ; QUIT;
PROC SQL;
CREATE TABLE nu11 AS
SELECT* , Q3-Q1 AS IQR
FROM n11 ; QUIT;
PROC SQL;
CREATE TABLE nu12 AS
SELECT* , Q3-Q1 AS IQR
FROM n12 ; QUIT;
PROC SQL;
CREATE TABLE nu13 AS
SELECT* , Q3-Q1 AS IQR
FROM n13 ; QUIT;
PROC SQL;
CREATE TABLE nu14 AS
SELECT* , Q3-Q1 AS IQR
FROM n14 ; QUIT;
PROC SQL;
CREATE TABLE nu15 AS
SELECT* , Q3-Q1 AS IQR
FROM n15 ; QUIT;
PROC SQL;
CREATE TABLE nu16 AS
SELECT* , Q3-Q1 AS IQR
FROM n16 ; QUIT;
PROC SQL;
CREATE TABLE nu17 AS
SELECT* , Q3-Q1 AS IQR
FROM n17 ; QUIT;
PROC SQL;
CREATE TABLE nu18 AS
SELECT* , Q3-Q1 AS IQR
FROM n18 ; QUIT;
PROC SQL;
CREATE TABLE nu19 AS
SELECT* , Q3-Q1 AS IQR
FROM n19 ; QUIT;
PROC SQL;
CREATE TABLE nu20 AS
SELECT* , Q3-Q1 AS IQR
FROM n20 ; QUIT;
PROC SQL;
CREATE TABLE nu21 AS
SELECT* , Q3-Q1 AS IQR
FROM n21 ; QUIT;
PROC SQL;
CREATE TABLE nu23 AS
SELECT* , Q3-Q1 AS IQR
FROM n23 ; QUIT;
PROC SQL;
CREATE TABLE nu24 AS
SELECT* , Q3-Q1 AS IQR
FROM n24 ; QUIT;

PROC SQL;
CREATE TABLE nu1_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu1 ; QUIT;
PROC SQL;
CREATE TABLE nu2_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu2 ; QUIT;
PROC SQL;
CREATE TABLE nu3_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu3 ; QUIT;
PROC SQL;
CREATE TABLE nu4_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu4 ; QUIT;
PROC SQL;
CREATE TABLE nu5_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu5 ; QUIT;
PROC SQL;
CREATE TABLE nu6_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu6 ; QUIT;
PROC SQL;
CREATE TABLE nu7_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu7 ; QUIT;
PROC SQL;
CREATE TABLE nu8_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu8 ; QUIT;
PROC SQL;
CREATE TABLE nu9_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu9 ; QUIT;
PROC SQL;
CREATE TABLE nu10_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu10 ; QUIT;
PROC SQL;
CREATE TABLE nu11_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu11 ; QUIT;
PROC SQL;
CREATE TABLE nu12_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu12 ; QUIT;
PROC SQL;
CREATE TABLE nu13_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu13 ; QUIT;
PROC SQL;
CREATE TABLE nu14_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu14 ; QUIT;
PROC SQL;
CREATE TABLE nu15_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu15 ; QUIT;
PROC SQL;
CREATE TABLE nu16_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu16 ; QUIT;
PROC SQL;
CREATE TABLE nu17_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu17 ; QUIT;
PROC SQL;
CREATE TABLE nu18_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu18 ; QUIT;
PROC SQL;
CREATE TABLE nu19_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu19 ; QUIT;
PROC SQL;
CREATE TABLE nu20_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu20 ; QUIT;
PROC SQL;
CREATE TABLE nu21_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu21 ; QUIT;
PROC SQL;
CREATE TABLE nu23_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu23 ; QUIT;
PROC SQL;
CREATE TABLE nu24_1 AS
SELECT* , Q1-1.5*IQR AS MINOUT, Q3+1.5*IQR AS MAXOUT
FROM nu24 ; QUIT;

/*이상치 제거*/
DATA test; SET test;
IF s01<'349.2195' THEN S01='.';
ELSE IF s02<'5.52259' THEN S02='.';
ELSE IF s03<'-75.277' THEN S03='.';
ELSE IF s04<'44.60555' THEN S04='.';
ELSE IF s05<'-117.90465' THEN S05='.';
ELSE IF s06<'94.2499' THEN S06='.';
ELSE IF s07<'0.53134' THEN S07='.';
ELSE IF s08<'0.059' THEN S08='.';
ELSE IF s09<'-109.8451' THEN S09='.';
ELSE IF s10<'-637.3305' THEN S10='.';
ELSE IF s11<'0.07569725' THEN S11='.';
ELSE IF s12<'-0.06361375' THEN S12='.';
ELSE IF s13<'1.192605' THEN S13='.';
ELSE IF s14<'-35.36755' THEN S14='.';
ELSE IF s15<'0.886009' THEN S15='.';
ELSE IF s16<'0.1641585' THEN S16='.';
ELSE IF s17<'-19.9387' THEN S17='.';
ELSE IF s18<'-61.918495' THEN S18='.';
ELSE IF s19<'-691.9225' THEN S19='.';
ELSE IF s20<'-0.2265675' THEN S20='.';
ELSE IF s21<'-0.222979' THEN S21='.';
ELSE IF s23<'-0.629258' THEN S23='.';
ELSE IF s24<'-109.66335' THEN S24='.'; RUN;
DATA test; SET test;
IF s01>'2657.3835' THEN B01='.';
ELSE IF s02>'93.70203' THEN B02='.';
ELSE IF s03>'499.9878' THEN B03='.';
ELSE IF s04>'489.39475' THEN B04='.';
ELSE IF s05>'880.61095' THEN B05='.';
ELSE IF s06>'1438.1699' THEN B06='.';
ELSE IF s07>'16.278188' THEN B07='.';
ELSE IF s08>'3832.835' THEN B08='.';
ELSE IF s09>'879.5853' THEN B09='.';
ELSE IF s10>'4243.8255' THEN B10='.';
ELSE IF s11>'1.58816725' THEN B11='.';
ELSE IF s12>'1.57788665' THEN B12='.';
ELSE IF s13>'23.600757' THEN B13='.';
ELSE IF s14>'214.98757' THEN B14='.';
ELSE IF s15>'12.767425' THEN B15='.';
ELSE IF s16>'2.5291385' THEN B16='.';
ELSE IF s17>'376.8349' THEN B17='.';
ELSE IF s18>'187.182265' THEN B18='.';
ELSE IF s19>'4393.0975' THEN B19='.';
ELSE IF s20>'22.2721645' THEN B20='.';
ELSE IF s21>'9.795861' THEN B21='.';
ELSE IF s23>'14.443174' THEN B23='.';
ELSE IF s24>'433.51609' THEN B24='.'; RUN;

/*나이대별 권장량으로 나누기*/
DATA test; SET test;
if 40<=CT2_AGE<=49 and s01<=1900 then b01_1=0;
else if 40<=CT2_AGE<=49 and s01>1900 then b01_1=1;
if 50<=CT2_AGE<=64 and s01<=1700 then b01_1=0;
else if 50<=CT2_AGE<=64 and s01>1700 then b01_1=1;
if 65<=CT2_AGE<=74 and s01<=1600 then b01_1=0;
else if 65<=CT2_AGE<=74 and s01>1600 then b01_1=1;
if 75<=CT2_AGE and s01<=1500 then b01_1=0;
else if 75<=CT2_AGE and s01>1500 then b01_1=1; 
if s01=. then b01_1=.;

if 40<=CT2_AGE<=49 and s02<=50 then b02_1=0;
else if 40<=CT2_AGE<=49 and s02>50 then b02_1=1;
if 50<=CT2_AGE<=64 and s02<=50 then b02_1=0;
else if 50<=CT2_AGE<=64 and s02>50 then b02_1=1;
if 65<=CT2_AGE<=74 and s02<=50 then b02_1=0;
else if 65<=CT2_AGE<=74 and s02>50 then b02_1=1;
if 75<=CT2_AGE and s02<=50 then b02_1=0;
else if 75<=CT2_AGE and s02>50 then b02_1=1; 
if s02=. then b02_1=.;

if 40<=CT2_AGE<=49 and s03<=570 then b03_1=0;
else if 40<=CT2_AGE<=49 and s03>570 then b03_1=1;
if 50<=CT2_AGE<=64 and s03<=510 then b03_1=0;
else if 50<=CT2_AGE<=64 and s03>510 then b03_1=1;
if 65<=CT2_AGE<=74 and s03<=480 then b03_1=0;
else if 65<=CT2_AGE<=74 and s03>480 then b03_1=1;
if 75<=CT2_AGE and s03<=450 then b03_1=0;
else if 75<=CT2_AGE and s03>450 then b03_1=1; 
if s03=. then b03_1=.;

if 40<=CT2_AGE<=49 and s04<=130 then b04_1=0;
else if 40<=CT2_AGE<=49 and s04>130 then b04_1=1;
if 50<=CT2_AGE<=64 and s04<=130 then b04_1=0;
else if 50<=CT2_AGE<=64 and s04>130 then b04_1=1;
if 65<=CT2_AGE<=74 and s04<=130 then b04_1=0;
else if 65<=CT2_AGE<=74 and s04>130 then b04_1=1;
if 75<=CT2_AGE and s04<=130 then b04_1=0;
else if 75<=CT2_AGE and s04>130 then b04_1=1; 
if s04=. then b04_1=.;

if 40<=CT2_AGE<=49 and s05<=700 then b05_1=0;
else if 40<=CT2_AGE<=49 and s05>700 then b05_1=1;
if 50<=CT2_AGE<=64 and s05<=800 then b05_1=0;
else if 50<=CT2_AGE<=64 and s05>800 then b05_1=1;
if 65<=CT2_AGE<=74 and s05<=800 then b05_1=0;
else if 65<=CT2_AGE<=74 and s05>800 then b05_1=1;
if 75<=CT2_AGE and s05<=800 then b05_1=0;
else if 75<=CT2_AGE and s05>800 then b05_1=1; 
if s05=. then b05_1=.;

if 40<=CT2_AGE<=49 and s06<=580 then b06_1=0;
else if 40<=CT2_AGE<=49 and s06>580 then b06_1=1;
if 50<=CT2_AGE<=64 and s06<=580 then b06_1=0;
else if 50<=CT2_AGE<=64 and s06>580 then b06_1=1;
if 65<=CT2_AGE<=74 and s06<=580 then b06_1=0;
else if 65<=CT2_AGE<=74 and s06>580 then b06_1=1;
if 75<=CT2_AGE and s06<=580 then b06_1=0;
else if 75<=CT2_AGE and s06>580 then b06_1=1; 
if s06=. then b06_1=.;

if 40<=CT2_AGE<=49 and s07<=14 then b07_1=0;
else if 40<=CT2_AGE<=49 and s07>14 then b07_1=1;
if 50<=CT2_AGE<=64 and s07<=8 then b07_1=0;
else if 50<=CT2_AGE<=64 and s07>8 then b07_1=1;
if 65<=CT2_AGE<=74 and s07<=8 then b07_1=0;
else if 65<=CT2_AGE<=74 and s07>8 then b07_1=1;
if 75<=CT2_AGE and s07<=7 then b07_1=0;
else if 75<=CT2_AGE and s07>7 then b07_1=1; 
if s07=. then b07_1=.;

if 40<=CT2_AGE<=49 and s08<=3500 then b08_1=0;
else if 40<=CT2_AGE<=49 and s08>3500 then b08_1=1;
if 50<=CT2_AGE<=64 and s08<=3500 then b08_1=0;
else if 50<=CT2_AGE<=64 and s08>3500 then b08_1=1;
if 65<=CT2_AGE<=74 and s08<=3500 then b08_1=0;
else if 65<=CT2_AGE<=74 and s08>3500 then b08_1=1;
if 75<=CT2_AGE and s08<=3500 then b08_1=0;
else if 75<=CT2_AGE and s08>3500 then b08_1=1; 
if s08=. then b08_1=.;

if 40<=CT2_AGE<=49 and s09<=650 then b09_1=0;
else if 40<=CT2_AGE<=49 and s09>650 then b09_1=1;
if 50<=CT2_AGE<=64 and s09<=600 then b09_1=0;
else if 50<=CT2_AGE<=64 and s09>600 then b09_1=1;
if 65<=CT2_AGE<=74 and s09<=600 then b09_1=0;
else if 65<=CT2_AGE<=74 and s09>600 then b09_1=1;
if 75<=CT2_AGE and s09<=550 then b09_1=0;
else if 75<=CT2_AGE and s09>550 then b09_1=1; 
if s09=. then b09_1=.;

if 40<=CT2_AGE<=49 and s10<=1500 then b10_1=0;
else if 40<=CT2_AGE<=49 and s10>1500 then b10_1=1;
if 50<=CT2_AGE<=64 and s10<=1500 then b10_1=0;
else if 50<=CT2_AGE<=64 and s10>1500 then b10_1=1;
if 65<=CT2_AGE<=74 and s10<=1500 then b10_1=0;
else if 65<=CT2_AGE<=74 and s10>1500 then b10_1=1;
if 75<=CT2_AGE and s10<=1500 then b10_1=0;
else if 75<=CT2_AGE and s10>1500 then b10_1=1; 
if s10=. then b10_1=.;

if 40<=CT2_AGE<=49 and s11<=1.1 then b11_1=0;
else if 40<=CT2_AGE<=49 and s11>1.1 then b11_1=1;
if 50<=CT2_AGE<=64 and s11<=1.1 then b11_1=0;
else if 50<=CT2_AGE<=64 and s11>1.1 then b11_1=1;
if 65<=CT2_AGE<=74 and s11<=1.0 then b11_1=0;
else if 65<=CT2_AGE<=74 and s11>1.0 then b11_1=1;
if 75<=CT2_AGE and s11<=0.8 then b11_1=0;
else if 75<=CT2_AGE and s11>0.8 then b11_1=1; 
if s11=. then b11_1=.;

if 40<=CT2_AGE<=49 and s12<=1.2 then b12_1=0;
else if 40<=CT2_AGE<=49 and s12>1.2 then b12_1=1;
if 50<=CT2_AGE<=64 and s12<=1.2 then b12_1=0;
else if 50<=CT2_AGE<=64 and s12>1.2 then b12_1=1;
if 65<=CT2_AGE<=74 and s12<=1.1 then b12_1=0;
else if 65<=CT2_AGE<=74 and s12>1.1 then b12_1=1;
if 75<=CT2_AGE and s12<=1.0 then b12_1=0;
else if 75<=CT2_AGE and s12>1.0 then b12_1=1; 
if s12=. then b12_1=.;

if 40<=CT2_AGE<=49 and s13<=14 then b13_1=0;
else if 40<=CT2_AGE<=49 and s13>14 then b13_1=1;
if 50<=CT2_AGE<=64 and s13<=14 then b13_1=0;
else if 50<=CT2_AGE<=64 and s13>14 then b13_1=1;
if 65<=CT2_AGE<=74 and s13<=13 then b13_1=0;
else if 65<=CT2_AGE<=74 and s13>13 then b13_1=1;
if 75<=CT2_AGE and s13<=12 then b13_1=0;
else if 75<=CT2_AGE and s13>12 then b13_1=1; 
if s13=. then b13_1=.;

if 40<=CT2_AGE<=49 and s14<=100 then b14_1=0;
else if 40<=CT2_AGE<=49 and s14>100 then b14_1=1;
if 50<=CT2_AGE<=64 and s14<=100 then b14_1=0;
else if 50<=CT2_AGE<=64 and s14>100 then b14_1=1;
if 65<=CT2_AGE<=74 and s14<=100 then b14_1=0;
else if 65<=CT2_AGE<=74 and s14>100 then b14_1=1;
if 75<=CT2_AGE and s14<=100 then b14_1=0;
else if 75<=CT2_AGE and s14>100 then b14_1=1; 
if s14=. then b14_1=.;

if 40<=CT2_AGE<=49 and s15<=8 then b15_1=0;
else if 40<=CT2_AGE<=49 and s15>8 then b15_1=1;
if 50<=CT2_AGE<=64 and s15<=8 then b15_1=0;
else if 50<=CT2_AGE<=64 and s15>8 then b15_1=1;
if 65<=CT2_AGE<=74 and s15<=7 then b15_1=0;
else if 65<=CT2_AGE<=74 and s15>7 then b15_1=1;
if 75<=CT2_AGE and s15<=7 then b15_1=0;
else if 75<=CT2_AGE and s15>7 then b15_1=1; 
if s15=. then b15_1=.;

if 40<=CT2_AGE<=49 and s16<=1.4 then b16_1=0;
else if 40<=CT2_AGE<=49 and s16>1.4 then b16_1=1;
if 50<=CT2_AGE<=64 and s16<=1.4 then b16_1=0;
else if 50<=CT2_AGE<=64 and s16>1.4 then b16_1=1;
if 65<=CT2_AGE<=74 and s16<=1.4 then b16_1=0;
else if 65<=CT2_AGE<=74 and s16>1.4 then b16_1=1;
if 75<=CT2_AGE and s16<=1.4 then b16_1=0;
else if 75<=CT2_AGE and s16>1.4 then b16_1=1; 
if s16=. then b16_1=.;

if 40<=CT2_AGE<=49 and s17<=400 then b17_1=0;
else if 40<=CT2_AGE<=49 and s17>400 then b17_1=1;
if 50<=CT2_AGE<=64 and s17<=400 then b17_1=0;
else if 50<=CT2_AGE<=64 and s17>400 then b17_1=1;
if 65<=CT2_AGE<=74 and s17<=400 then b17_1=0;
else if 65<=CT2_AGE<=74 and s17>400 then b17_1=1;
if 75<=CT2_AGE and s17<=400 then b17_1=0;
else if 75<=CT2_AGE and s17>400 then b17_1=1; 
if s17=. then b17_1=.;

if 40<=CT2_AGE<=49 and s21<=20 then b21_1=0;
else if 40<=CT2_AGE<=49 and s21>20 then b21_1=1;
if 50<=CT2_AGE<=64 and s21<=20 then b21_1=0;
else if 50<=CT2_AGE<=64 and s21>20 then b21_1=1;
if 65<=CT2_AGE<=74 and s21<=20 then b21_1=0;
else if 65<=CT2_AGE<=74 and s21>20 then b21_1=1;
if 75<=CT2_AGE and s21<=20 then b21_1=0;
else if 75<=CT2_AGE and s21>20 then b21_1=1; 
if s21=. then b21_1=.;

if 40<=CT2_AGE<=49 and s23<=12 then b23_1=0;
else if 40<=CT2_AGE<=49 and s23>12 then b23_1=1;
if 50<=CT2_AGE<=64 and s23<=12 then b23_1=0;
else if 50<=CT2_AGE<=64 and s23>12 then b23_1=1;
if 65<=CT2_AGE<=74 and s23<=12 then b23_1=0;
else if 65<=CT2_AGE<=74 and s23>12 then b23_1=1;
if 75<=CT2_AGE and s23<=12 then b23_1=0;
else if 75<=CT2_AGE and s23>12 then b23_1=1; 
if s23=. then b23_1=.;

if 40<=CT2_AGE<=49 and s24<=180 then b24_1=0;
else if 40<=CT2_AGE<=49 and s24>180 then b24_1=1;
if 50<=CT2_AGE<=64 and s24<=120 then b24_1=0;
else if 50<=CT2_AGE<=64 and s24>120 then b24_1=1;
if 65<=CT2_AGE<=74 and s24<=50 then b24_1=0;
else if 65<=CT2_AGE<=74 and s24>50 then b24_1=1;
if 75<=CT2_AGE and s24<=20 then b24_1=0;
else if 75<=CT2_AGE and s24>20 then b24_1=1; 
if s24=. then b24_1=.;run;

proc freq data=test;
tables b01_1 b02_1 b03_1 b04_1 b05_1 b06_1 b07_1 b08_1  b09_1  b10_1 b11_1 b12_1 b13_1 b14_1 b15_1 b16_1 b17_1 b21_1 b23_1 b24_1;
RUN;
proc freq data=test;
tables BCYN*(b01_1 b02_1 b03_1 b04_1 b05_1 b06_1 b07_1 b08_1  b09_1  b10_1 b11_1 b12_1 b13_1 b14_1 b15_1 b16_1 b17_1 b21_1 b23_1 b24_1)/chisq;
run;
