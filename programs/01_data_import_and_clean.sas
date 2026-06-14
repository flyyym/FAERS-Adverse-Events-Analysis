/* 1.定义逻辑库（方便引用）*/
libname mylib '/home/你的用户名/FAERS_AE_Project/output';

/* 2.设置输出格式（最终生成RTF报告）*/
ods rtf file='/home/你的用户名/FAERS_AE_Project/output/FAERS_Report.rtf'
	style= journal;		
							
title "FAERS Adverse Event Reporting Analysis";
footnote "Data soure: FDA FAERS quarterly data";

/*3.导入DEMO数据*/
proc import datafile='/home/你的用户名/FAERS_AE_Project/data/DEMO25Q1.txt'
	out=DEMO_raw dbms=dlm replace;  
	delimiter= "$";		
	getnames=yes;		
	guessingrows =10000;	
run;

/*4.查看导入是否正确*/
proc contents data=DEMO_raw; run; 	
proc print data=DEMO_raw(obs=10); run;	

/*5.去重:每个CASEID 保留最新版本
（通过fda_dt（fda接受日期）和Primaryid（每次报告版本号）进行去重）*/
proc sort data=DEMO_raw; 
	by CASEID descending fda_dt descending Primaryid; 
run; 
data DEMO_dedup;
	set DEMO_raw;
	by CASEID;
	if first.CASEID;	*保留每个病例的最新报告;
run;

/*6派生分析变量：年龄组、报告年份、性别标准化*/
data DEMO_analysis;
	set demo_dedup;
	
	 /* 将 EVENT_DT 从 YYYYMMDD 数值转换为 SAS 日期，再提取年份 */
    if EVENT_DT > 0 then do;
        SAS_DATE = input(put(EVENT_DT, 8.), yymmdd8.);
        REPORT_YEAR = year(SAS_DATE);
    end;
    else REPORT_YEAR = .;
	
	/*年龄清洗：根据年龄单位转化为年*/
	if AGE_COD = "YR" then AGE_YEARS = AGE;
    else if AGE_COD = "MON" then AGE_YEARS = AGE/12;
    else if AGE_COD = "DAY" then AGE_YEARS = AGE/365.25;
    else AGE_YEARS = .;

	 /* 年龄分组 */
    if AGE_YEARS < 18 then AGE_GRP = "1: <18";
    else if AGE_YEARS < 65 then AGE_GRP = "2: 18-64";
    else if AGE_YEARS >= 65 then AGE_GRP = "3: >=65";
    else AGE_GRP = "Missing";
    
    /* 性别 */
    if upcase(SEX) = "M" then SEX_STD = "Male"; *upcase()统一大写判断;
    else if upcase(SEX) = "F" then SEX_STD = "Female";
    else SEX_STD = "Unknown";
    
    /* 地区简略（美国 vs 其他） */
    if upcase(OCCUR_COUNTRY) = "US" then REGION = "United States";
    else REGION = "Other";
run;


/* 7. 导入DRUG数据 */
proc import datafile='/home/你的用户名/FAERS_AE_Project/data/DRUG25Q1.txt'
    out=DRUG_raw dbms=dlm replace;
    delimiter='$'; 
    getnames=yes; 
    guessingrows=10000;
run;

/* 8. 筛选首要怀疑药物（PS） */
data DRUG_ps;
    set DRUG_raw;
    where upcase(ROLE_COD) = "PS";
run;


/* 9. 导入REAC数据 */
proc import datafile='/home/你的用户名/FAERS_AE_Project/data/REAC25Q1.txt'
    out=REAC_raw dbms=dlm replace;
    delimiter='$'; 
    getnames=yes; 
    guessingrows=10000;
run;


/* 去除完全重复的AE记录（一个病例同一个PT只保留一次） */
proc sort data=REAC_raw nodupkey; by PRIMARYID PT; run; 
*PT 首选术语，即不良事件术语、nodupkey表示按by变量删除重复;
