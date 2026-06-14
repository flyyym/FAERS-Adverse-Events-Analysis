/* 10. 合并DRUG和REAC（药物-不良事件对） */
proc sql;
    create table DRUG_AE as
    select 
        drug.PRIMARYID,
        drug.DRUGNAME,
        reac.PT as AE_TERM
    from DRUG_ps as drug
    inner join REAC_raw as reac on drug.PRIMARYID = reac.PRIMARYID;
quit;

/* 11. 再合并人口学信息 */
proc sql;	
    create table FINAL_ANALYSIS as
    select 
        a.*,
        b.AGE_GRP,
        b.SEX_STD,
        b.REPORT_YEAR,
        b.REGION
    from DRUG_AE a
    left join DEMO_analysis b on a.PRIMARYID = b.PRIMARYID;
quit;

/* 保存最终分析数据集到output库 */
data mylib.FINAL_ANALYSIS;
    set FINAL_ANALYSIS;
run;
