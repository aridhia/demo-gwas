#!/bin/bash

# See http://zzz.bwh.harvard.edu/plink/ for more instructions about PLINK

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DATA_DIR='/files/gwas/data'
OUT_DIR='/files/gwas/output'

echo 'Outputs will be written to: '$OUT_DIR
echo 'Running Sample Quality Control'

echo 'Filtering samples that have more than 10% of the genotype calls missing'
plink   --file $OUT_DIR/maf --recode --mind 0.10 --out $OUT_DIR/mind_removed

echo 'Checking sex'
plink   --file $OUT_DIR/mind_removed --recode --check-sex --out $OUT_DIR/check_sex


echo 'Checking for cryptic relatedness'
plink   --file $OUT_DIR/check_sex --recode --min 0.20 --genome --out $OUT_DIR/cryptic


echo 'Removing SNPs located in sex chromosome'
plink   --file $OUT_DIR/maf --recode --chr 1-22 --out $OUT_DIR/chr22