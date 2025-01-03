# CBIO310-CBIO311-Project  VIDEO PRESENTATION: https://shorturl.at/LqTSf
#COVID-19 and multiple sclerosis (MS) exhibit overlapping molecular mechanisms that may contribute to their disease progression. This study utilized gene expression datasets to identify differentially expressed genes (DEGs) and performed Gene Set Enrichment Analysis (GSEA) to uncover shared pathways.
#[This documentation will be as concise as possible]
#1-The GEO2R Accession numbers for the data used: Multiple sclerosis: GSE137143 and SARS-COV2: GSE172114
#2-Highlighted two groups for each accession number (Control and Sample) to compare their data separately, GEO2R provided most plots, except volcano plot & heatmap which were created using R later.
#3-Used R to create a program (filteration_of_genes.R)that seperated the genes based on the Log2FoldChange with a threshold of 1.2 to identify gene regulation. In order for this R code to work with you, you must check that the file paths are adjusted and that the data sets are correctly installed to your selected file path, results may vary depending on the selected data sets.
#4-filteration_of_genes.R was used on the tsv files 'GSE137143.top.table.tsv' and 'GSE172114.top.table.tsv' to extract 3 files, [filtered_genes3.csv , upregulated_genes3.csv , downregulated_genes3.csv] 
#5-filteration_of_genes.R also presented the volcano plot & heatmap using ggplot2 & pheatmap.
#6-G:profiler was used with input as upregulated_genes.csv , downregulated_genes.csv to identify the common pathways which are shared between the two groups. #KEGG displayed 0 results here, but Reactome showed results with both upregulated AND downregulated genes. (https://reactome.org/)
#7-ShinyGo was also used to identify the common pathways and the result was downloaded as a csv file (enrichment_all(1).csv), ShinyGo results use KEGG (https://www.genome.jp/kegg/) as their primary database.
