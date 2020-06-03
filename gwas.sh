#!/bin/bash

# See http://zzz.bwh.harvard.edu/plink/ for more instructions about PLINK

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR='/home/gabi/Desktop/gwas_tutorial/test2'
echo 'Working directory is: '$DIR


echo 'Running Quality Control'

# Test whether the input data can be read into correctly
./plink   --covar $DIR/samples.covar --file $DIR/adgwas --recode --out $DIR/input_test

# Hardy-Weinberg equilibrium test
./plink   --file $DIR/input_test --recode --hwe 0.05 --out $DIR/hwe

# Minor Allele Frequency filter
./plink   --file $DIR/hwe --recode --maf 0.01 --out $DIR/maf

# Filter variants that have more than 10% of genotype calls missing
./plink   --file $DIR/maf --recode --geno 0.10 --out $DIR/geno_removed

# Filter samples that have more than 10% of the genotype calls missing
./plink   --file $DIR/geno_removed --recode --mind 0.10 --out $DIR/mind_removed

# Keep only autosomal SNPs
./plink   --file $DIR/mind_removed --recode --chr 1-22 --out $DIR/chr22

# Sex check
./plink   --file $DIR/adgwas --recode --check-sex --out $DIR/check_sex




echo 'Population structure'

# Filter for cryptic relatedness
./plink   --file $DIR/chr22 --recode --min 0.20 --genome --out $DIR/cryptic

# Run the Principal Component Analysis
./plink   --file $DIR/cryptic --recode --pca var-wts --out $DIR/pca



echo 'Running association testing'

# Run association test on all SNPs:
./plink   --file $DIR/cryptic --recode --logistic --allow-no-sex --ci 0.95 --adjust --out $DIR/assoc_nopca

# Run association test on the first PC
./plink   --file $DIR/pca --recode --logistic --covar $DIR/pca.eigenvec --covar-number 1 --allow-no-sex --ci 0.95 --adjust --out $DIR/pca1