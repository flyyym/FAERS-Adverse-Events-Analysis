/* 12. 报告级别的人口学特征（先对报告去重） */
proc sort data=DEMO_analysis out=DEMO_unique nodupkey; by PRIMARYID; run;

/* 表1：人口学特征 */
title2 "Table 1. Demographic Characteristics of Reports";
proc freq data=DEMO_unique;
    tables SEX_STD AGE_GRP REGION / missing;
run;

/* 表2：最常见不良事件（Top 20） */
proc freq data=FINAL_ANALYSIS order=freq noprint; 
    tables AE_TERM / nopercent nocum out=ae_freq;
run; 
data ae_top20; set ae_freq(obs=20); run;
title2 "Table 2. Top 20 Reported Adverse Events (PT)";
proc print data=ae_top20 noobs;
    var AE_TERM COUNT;
run;

/* 表3：最常见药物（Top 20） */
proc freq data=FINAL_ANALYSIS order=freq noprint;
    tables DRUGNAME / nopercent nocum out=drug_freq;
run;
data drug_top20; set drug_freq(obs=20); run;
title2 "Table 3. Top 20 Drugs (Primary Suspect)";
proc print data=drug_top20 noobs;
    var DRUGNAME COUNT;
run;

/* 图1：报告数量按年份趋势（条形图） */
title1 "Figure 1. Number of Reports by Year";
proc sgplot data=DEMO_unique;
    vbar REPORT_YEAR / fillattrs=(color=steelblue);
    xaxis label="Year" integer values=(2010 to 2025 by 2)  fitpolicy=rotate; 
    yaxis label="Number of Reports";
run;


/* 图2：年龄组分布（条形图） */
title1 "Figure 2. Age Group Distribution";
proc sgplot data=DEMO_unique;
    hbar AGE_GRP / fillattrs=(color=steelblue) datalabel;
    xaxis label="Number of Reports";
    yaxis label="Age Group" discreteorder=data;
run;

ods rtf close; 
