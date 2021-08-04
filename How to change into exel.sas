ods listing close;
ods chtml file = 'C:\Users\USER01\Desktop\5-21 °úÁ¦\Data analysis\result\BC_UNI_HR.xls';

proc freq data = b.thesis; tables ds1_sex/list missing; run;

ods chtml close;
ods listing;


ods listing close;
ods chtml file = '{Location}\BC_UNI_HR.xls';

proc means data = temp n nmiss min median max; var QC_MNC_AGE; run;
proc freq data = temp; tables QC_MNC_AGE_1 QC_MNC_AGE_2/list missing; run;

proc phreg data=temp;
class QC_MNC_AGE_1(param = ref ref = '1') QC_MNC_AGE_2(param = ref ref = '1'); 
model  FU_DAY*BCA(0)= QC_MNC_AGE/risklimits; run; 

proc phreg data=temp;
class QC_MNC_AGE_1(param = ref ref = '1') QC_MNC_AGE_2(param = ref ref = '1'); 
model  FU_DAY*BCA(0)= QC_MNC_AGE_1/risklimits; run; 

proc phreg data=temp;
class QC_MNC_AGE_1(param = ref ref = '1') QC_MNC_AGE_2(param = ref ref = '1'); 
model  FU_DAY*BCA(0)= QC_MNC_AGE_2/risklimits; run; 

ods chtml close;
ods listing;
