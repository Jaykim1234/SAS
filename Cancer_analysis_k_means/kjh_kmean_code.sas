libname KJH "/userdata07/room284/data_source/ANALYSIS/KJH";

proc contents data=KJH.br_gr_09_10_1; run; 
data KJH.kmean_tmp; set KJH.br_gr_09_10_1; run; 


/*Checking the contents of the  original datasets*/
proc means data = KJH.kmean_tmp N Nmiss mean median max min;
run;
        
/********** Delete missing values ********/
data KJH.br_gr_09_10_2; set  KJH.br_gr_09_10_1;
if Q_PHX_DX_ETC=. then delete; 
else if G1E_HB_DRK=. then delete; /**/
else if G1E_HB_SMK=. then delete; 
else if G1E_HB_PA=. then delete; /**/
else if G1E_BMI=. then delete; /**/
else if G1E_TOT_CHOL=. then delete; /**/
else if G1E_FBS=. then delete; /**/
else if G1E_BP_SYS=. then delete; 
else if G1E_BP_DIA=. then delete; /**/
run;  

/*Rename new dataset*/
data KJH.data_trimmed; set KJH.br_gr_09_10_2; run; 


** Standardized the data to analyze all on equal scale;
proc standard data = KJH.data_trimmed
	mean = 0 std = 1 out = KJH.data_trimmed_std;
	var &clus_vars.;
run;

** Check for the outliers ;
/*Without Standardization*/
proc means data = KJH.data_trimmed min max;
	title 'Before capping outliers';
	var &clus_vars.;
run;

/*With Standardization*/
proc means data = KJH.data_trimmed_std min max;
	title 'Before capping outliers';
	var &clus_vars.;
run;
proc contents data=KJH.data_trimmed_std ; run; 
/*Checking the contents of the standardized datasets*/
proc means data = KJH.kmean_tmp_std N Nmiss mean median max min;
run;


/*5% Ramdom sampling for fast code checking*/

/*raw data with missing values*/
PROC SURVEYSELECT DATA=KJH.data_trimmed METHOD=SRS RATE=0.05 OUT=KJH.data_trimmed_sampling_005; RUN;
/*raw data without missing values*/
PROC SURVEYSELECT DATA=KJH.data_trimmed_std METHOD=SRS RATE=0.05 OUT=KJH.data_trimmed_std_sampling_005; RUN;


/*Find the best k value with visualisation*/
/*Randomly selected data was used because of too long time for processing*/

/* With original data*/
ods graphics on;
proc cluster data = KJH.data_trimmed_sampling_005
method= centroid ccc
print= 15 outtree=Tree;
var Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
run;
ods graphics off;

/* With standardized data*/
ods graphics on;
proc cluster data = KJH.data_trimmed_std_sampling_005
method= centroid ccc
print= 15 outtree=Tree;
var Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
run;
ods graphics off;


/*WIth standardized data*/
/**Do k-means clustering with maxiter 100**/
 
PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=3 MAXITER=100;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '3 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=5 MAXITER=100;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '5 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=11 MAXITER=100;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '11 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=12 MAXITER=100;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '12 clustering';
RUN;


/**Do k-means clustering with maxiter 1000**/
 
PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=3 MAXITER=100000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '3 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=5 MAXITER=1000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '5 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=11 MAXITER=1000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '11 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=12 MAXITER=1000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '12 clustering';
RUN;



/**Do k-means clustering with maxiter 100000**/
 
PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=3 MAXITER=100000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '3 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=5 MAXITER=100000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '5 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=11 MAXITER=100000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '11 clustering';
RUN;

PROC FASTCLUS DATA=KJH.data_trimmed_std OUT=KJH.OUTTEST MAXC=12 MAXITER=100000;
VAR Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA; 
title '12 clustering';
RUN;


*******************************************************************************************************************************************
**   Codes that errors are not resolved **

** Clustering Variables;
%let clus_vars = Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_BMI G1E_TOT_CHOL G1E_FBS G1E_BP_SYS G1E_BP_DIA;


** Capping ourliers for all clustering variable.
	Truncate to -3 or +3 if any value is outside the range of mean -3 std too mean +3 std;
**  First trial for clustering. There is an error here
/*%macro cap_outliers(is_dsn);*/
/**/
/*	data &in_dsn.;*/
/*		set &in_dsn.;*/
/*		%do i = 1 %to %sysfunc(countw(&clus_vars.));*/
/*			if %scan(&clus_vars., &i.) < -3 then  %scan(&clus_vars., &i.)  = -3;*/
/*			if %scan(&clus_vars., &i.) >  3 then  %scan(&clus_vars., &i.)  =  3;*/
/*		%end;*/
/*	run;*/
/*	*/
/*	proc means data = KJH.kmean_tmp_std min max;*/
/*		title "After capping outliers";*/
/*		var &clus_vars.;*/
/*	run;*/
/**/
/*%mend cap_outliers;*/

%cap_outliers(KJH.kmean_tmp_std);




**Run k- Means Clustering;
** Error
%macro k_means_clus(in_dsn, maxiter = );

	** Run K-Means clustering with a differenent number of clusters;
/*	%do k = 2 %to &maxiter.;*/
/*		ods output CCC = CCC&k.(keep = value rename (value = ccc));*/
/*		ods output PseudoFStat = F_stat&k.(keep = value rename = (value = f_value));*/
/*		proc fastclus data = KJH.kmean_tmp_std maxiter = 100*/
/*				maxclusters= &k. out = cust_clus&k.;*/
/*			var &clus_vars.;*/
/*		run;*/
/**/
/*		data = ccc&k;*/
/*			set ccc&k.;*/
/*			cluster = &k.;*/
/*		run;*/
/**/
/*		data = F_stat&k;*/
/*			set F_stat&k.;*/
/*			cluster = &k.;*/
/*		run;*/
/*		*/
/*		proc append base= ccc data = ccc&k.; run;*/
/*		proc delete data   = ccc&k.; run;*/
/*		proc append base = F_stat data =  F_stat&k.; run;*/
/*		proc delete data    =  F_stat&k.; run;*/
/**/
/*	%end; ** End of k=1 to maxiter;*/

** Plot CCC against against number of  clusters;
**Error
/*	proc sgplot data = ccc;*/
/*		series y= ccc x= cluster;*/
/*		yaxis label = 'Cubic Clustering Criterion (CCC)';*/
/*		xasis lable = 'Number of Cluster';*/
/*	quit;*/
/*%mend k_mean_clus;*/
/**/
/**/
/*%k means clus(cust fact std, maxiter = 15);*/


**Another way ;

** Performing cluster Analysis;

/* There is an error here too. Probalbly because of missing values*/

/*ods graphics on;*/
/**/
proc cluster data = KJH.CHECKING
method= centroid ccc
print= 15 outtree=Tree;

var Q_SMK_YN Q_SMK_DRT Q_DRK_AMT_V09N Q_DRK_FRQ_V09N Q_MH_STR;
run;

ods graphics off;


/*Q_SMK_YN Q_SMK_DRT Q_DRK_AMT_V09N Q_DRK_FRQ_V09N Q_MH_STR*/


/* Third way*/
/*Run fastclus for k from 3 to 8*/
%macro doFASTCLUS;

	%do k=3 %to 8;
		proc fastclus
			data = KJH.CHECKING
			out  = KJH.CHECKING2
			maxiter = 100
			converge= 0
			/*run to complete convergence*/
			radius = 100

			/*look for nitial centroids that are far apart */
			maxclusters= &k
			summary;
		run;
	%end;
%mend;
%doFASTCLUS


proc sgplot	
	data = KJH.CHECKING;
	scatter x =  K y= Gap
	markerattrs = (color= 'STPK'  symbol = 'circleFilled');
	xaxis grid integer values== (3 to 8 by 1);
	yaxis lable = ' Values';
run

/* To auto select the best value between 3 and 8*/

proc hpclus
	data = KJH.CHECKING
	maxclusters = 8
	maxiter = 100
	seed = 54321
/*set seed for pesudo -random number generator */
	NOC = ABC(B = 1 minclusters =3 align =PCA);
	/* Select best k betwwen 3 and 8 using ABC */



proc fastclus data = KJH.CHECKING out=KJH.test1 maxc= 3;
var Q_PHX_DX_ETC G1E_HB_DRK G1E_HB_SMK G1E_HB_PA G1E_FBS G1E_BP_SYS G1E_BP_DIA;
title 'Fastclus Analysis';
RUN;

	
