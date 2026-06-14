# FAERS 药品不良反应事件描述性统计分析

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 项目简介

本项目基于 FDA 不良反应报告系统（FAERS）2025 年第一季度的公开数据，使用 SAS 进行数据清洗、合并和描述性统计分析，旨在展示统计编程师在真实世界数据处理中的核心技能，包括数据去重、派生变量创建、多表连接、生成统计报表及可交付成果（RTF 报告）。

## 数据来源

- **FDA FAERS 数据库**：[官方下载页面](https://fis.fda.gov/extensions/FPD-QDE-FAERs/FPD-QDE-FAERs.html)（选择季度数据，ASCII 格式）
- 使用数据集：`DEMO`（人口学信息）、`DRUG`（药物信息）、`REAC`（不良事件术语）

## 分析内容

1. **数据清洗**
   - DEMO 表去重：每个 `CASEID` 保留 `FDA_DT` 最新的报告
   - 筛选首要怀疑药物（`ROLE_CODE = 'PS'`）
   - REAC 表去除完全重复的 `PRIMARYID+PT` 记录
2. **派生变量**
   - 年龄转换为年并分组（<18, 18-64, ≥65）
   - 性别标准化（Male/Female/Unknown）
   - 报告年份（`REPORT_YEAR`）从 `EVENT_DT` 提取
   - 地区分组（美国 / 其他）
3. **统计分析**
   - 人口学特征分布（Table 1）
   - 最常见不良事件 Top 20（Table 2）
   - 最常见首要怀疑药物 Top 20（Table 3）
   - 报告数量按年份趋势图（Figure 1）
   - 年龄组分布图（Figure 2）
4. **报告输出**
   - 使用 `ODS RTF` 生成可直接提交的 Word 报告（`FAERS_Report.rtf`）

## 关键分析结果

### Top 5 最常见不良事件

| 排名 | 不良事件术语 (PT) | 报告数 |
| :--- | :--- | ---: |
| 1 | Off label use | 42,563 |
| 2 | Drug ineffective | 25,652 |
| 3 | Fatigue | 24,233 |
| 4 | Product dose omission issue | 22,384 |
| 5 | Diarrhoea | 21,472 |

> 注：“超说明书使用”和“药物无效”是最常报告的两种事件，提示临床实践中需关注用药规范性和疗效监测。

### 其他发现
- 女性报告比例略高于男性（约58% vs 42%）
- 18-64 岁成年人是主要报告人群（约65%）
- 报告数量呈逐年上升趋势（具体年份趋势见报告图表）

## 文件结构
FAERS-Adverse-Events-Analysis/
├── README.md # 项目说明
├── LICENSE # MIT 许可证
├── programs/ # SAS 代码
│ ├── 01_import_and_clean.sas
│ ├── 02_merge_data.sas
│ └── 03_analysis_and_report.sas
└── output/ # 输出报告
└── FAERS_Report.rtf


## 如何运行

1. **下载数据**：从 [FDA FAERS 页面](https://fis.fda.gov/extensions/FPD-QDE-FAERs/FPD-QDE-FAERs.html) 下载 2025Q1 的 ASCII 数据包，解压得到 `DEMO.txt`, `DRUG.txt`, `REAC.txt`。
2. **放置数据**：将上述三个文件放入 `data/` 文件夹（需自行创建）。
3. **修改路径**：在 SAS 程序中，将文件读入路径改为你的实际路径（或使用相对路径 `./data/`）。
4. **运行 SAS 代码**：按顺序执行 `01_import_and_clean.sas` → `02_merge_data.sas` → `03_analysis_and_report.sas`。
5. **查看报告**：在 `output/` 文件夹中找到 `FAERS_Report.rtf`，用 Word 打开。

## 环境要求

- SAS 9.4 或 SAS Studio（需要 SAS/STAT 和 SAS/GRAPH 模块）
- 建议使用 SAS Studio 3.x 及以上版本

## 作者

- flyyym- [GitHub主页链接](https://github.com/flyyym)

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

