#!/bin/bash

# See http://zzz.bwh.harvard.edu/plink/ for more instructions about PLINK

OUT_DIR='/files/gwas/output'

echo 'Running association testing'

# Run association test on all SNPs:
plink   --file $OUT_DIR/cryptic --recode --logistic --allow-no-sex --ci 0.95 --adjust --out $OUT_DIR/assoc_nopca

# Population structure: do PCA and run just on the PC1?