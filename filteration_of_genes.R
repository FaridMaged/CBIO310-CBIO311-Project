install.packages("dplyr")   # For data manipulation
install.packages("ggplot2")  # For visualization
install.packages("pheatmap") # For heatmap visualization
install.packages("openxlsx") # For saving to Excel
# Load required libraries
library(dplyr)
library(ggplot2)
library(pheatmap)  # For heatmap visualization
library(openxlsx)   # For saving to Excel
# Set your working directory to the folder where your files are located
setwd("D:\\Advanced")  # Replace with your folder path
getwd()
# Load the data
table1 <- read.table("GSE172114.top.table.tsv", sep = "\t", header = TRUE)
table2 <- read.table("GSE137143.top.table.tsv", sep = "\t", header = TRUE)
# Standardize column names for merging
table1 <- table1 %>% rename(Gene = GeneID, log2FC_1 = log2FoldChange, p_value_1 = pvalue, padj_1 = padj)
table2 <- table2 %>% rename(Gene = GeneID, log2FC_2 = log2FoldChange, p_value_2 = pvalue, padj_2 = padj)
# Merge the two tables by Gene
merged_table <- merge(table1, table2, by = "Gene")
# Filter based on log2 fold change and create additional columns for up/down regulation
upregulated_genes <- merged_table %>%
  filter(log2FC_1 > 1.1) %>%
  mutate(Regulation = "Upregulated")
downregulated_genes <- merged_table %>%
  filter(log2FC_1 < -1.1) %>%
  mutate(Regulation = "Downregulated")
# Combine upregulated and downregulated genes into one dataframe
filtered_genes <- bind_rows(upregulated_genes, downregulated_genes)
# Save the filtered results to files
write.csv(upregulated_genes, "upregulated_genes3.csv", row.names = FALSE)
write.csv(downregulated_genes, "downregulated_genes3.csv", row.names = FALSE)
write.csv(filtered_genes, "filtered_genes3.csv", row.names = FALSE)
# Volcano Plot
ggplot(merged_table, aes(x = log2FC_1, y = -log10(padj_1))) +
  geom_point(aes(color = ifelse(log2FC_1 > 1.1, "Upregulated",
                                ifelse(log2FC_1 < -1.1, "Downregulated", "Neutral")))) +
  scale_color_manual(values = c("Upregulated" = "red", "Downregulated" = "blue", "Neutral" = "gray")) +
  labs(title = "Volcano Plot", x = "Log2 Fold Change", y = "-Log10(Adjusted P-value)") +
  theme_minimal()

# Save the Volcano Plot
ggsave("volcano_plot.png", width = 6, height = 4)
# Generate the heatmap with proper color mapping and gene selection

# Prepare data for heatmap: Select genes and log2 fold change
heatmap_data <- filtered_genes %>%
  dplyr::select(Gene, log2FC_1, log2FC_2)
rownames(heatmap_data) <- heatmap_data$Gene
heatmap_data <- heatmap_data %>%
  dplyr::select(-Gene) %>%  # Remove the Gene column
  as.matrix()


# Assign colors based on fold change for heatmap
heatmap_colors <- ifelse(heatmap_data[, 1] > 1.1, "red", 
                         ifelse(heatmap_data[, 1] < -1.1, "blue", "gray"))

# Define a custom color palette for the heatmap to match the volcano plot colors
color_palette <- colorRampPalette(c("blue", "white", "red"))(50)

# Load the tibble package to use column_to_rownames
library(tibble)

# Prepare data for heatmap: Select genes and log2 fold change
# Select columns and set rownames manually
selected_data <- filtered_genes %>%
  dplyr::select(Gene, log2FC_1, log2FC_2)

rownames(selected_data) <- selected_data$Gene  # Set rownames
selected_data <- selected_data[, -1]  # Remove the "Gene" column
heatmap_data <- as.matrix(selected_data)  # Convert to matrix

# Assign colors based on fold change for heatmap
heatmap_colors <- ifelse(heatmap_data[, 1] > 1.1, "red", 
                         ifelse(heatmap_data[, 1] < -1.1, "blue", "gray"))

# Define a custom color palette for the heatmap to match the volcano plot colors
color_palette <- colorRampPalette(c("blue", "white", "red"))(50)

# Generate the heatmap
pheatmap(heatmap_data, 
         cluster_rows = TRUE, 
         cluster_cols = TRUE, 
         show_rownames = TRUE, 
         scale = "none",  # No scaling to show raw values, similar to volcano plot
         color = color_palette,  # Use the custom color palette
         main = "Heatmap of Log2 Fold Changes")

# Save the heatmap as a file
ggsave("heatmap_plot.png", width = 6, height = 6)
