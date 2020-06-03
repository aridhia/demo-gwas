library(qqman)
library(data.table)

# Make the Manhattan plot on the gwasResults dataset
gwas <- fread("/home/gabi/Desktop/gwas/scripts/pca1.assoc.logistic", select = c('CHR', 'SNP', 'BP', 'P'))
manhattan(gwas, chr="CHR", bp="BP", snp="SNP", p="P", ylim=c(0, 10))



