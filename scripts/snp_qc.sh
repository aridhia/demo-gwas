#!/bin/bash

# See http://zzz.bwh.harvard.edu/plink/ for more instructions about PLINK

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DATA_DIR='/files/gwas/data'
OUT_DIR='/files/gwas/output'

echo 'Output files will be written to: '$OUT_DIR
echo 'Running SNP Quality Control'

echo 'Testing whether the input data can be read into correctly'
plink   --covar $DATA_DIR/samples.covar --file $DATA_DIR/adgwas --recode --out $OUT_DIR/input_test --silent

echo 'Filtering variants that have more than 10% of genotype calls missing'
plink   --file $OUT_DIR/input_test --recode --geno 0.10 --out $OUT_DIR/geno_removed --silent

echo 'Running Hardy-Weinberg equilibrium test'
plink   --file $OUT_DIR/geno_removed --recode --hwe 0.05 --out $OUT_DIR/hwe --silent

echo 'Running Minor Allele Frequency filter'
plink   --file $OUT_DIR/hwe --recode --maf 0.01 --out $OUT_DIR/maf --silent