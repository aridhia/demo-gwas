# GWAS Demo

A demonstration of reproducing the analysis from a genome wide association study (GWAS).

# Introduction to GWAS

**Genome-wide association study (GWAS)** is a hypotheses-free method for **identifying associations between genetic regions and traits** (incl. diseases). GWAS typically **searches for small variations**, known as single-nucleotide polymorphisms (**SNPs**), that occur more frequently in people with a particular disease than in people without the disease. GWAS already has seen success at identifying SNPs related to conditions such as diabetes, Parkinson and Crohn.

# General Approach to GWAS

Researchers use **two groups of participants**: people with the disease being studied **(case group)** and similar people without the disease **(control group)**. **DNA is obtained from each participant** by scanning the blood sample/cell on automated laboratory machines. The machines survey each participant’s genome for strategically selected **markers of genetic variation (SNPs)**. If certain variations are found to be significantly more frequent in people with the disease compared to people without the disease, the **variations are said to be associated with the disease**.

The SNPs associated with the disease are **identified by testing for statistical significance between cases and controls**. Results are typically displayed in a **Manhattan plot** with -log10(p-value) plotted against the position in the genome. Two lines are added to indicate the genome-wide **significance threshold** (p=5.0×10−8) and the cut-off level for selecting single-nucleotide polymorphisms for replication study (p=1.0×10−5). An example Manhattan plot is illustrated below.
<br>
<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/1/12/Manhattan_Plot.png" width="80%" height="80%" alt="alt text">
</p>

# Case Study: Late-Onset Alzheimer's Disease
Webster et al. *(2009)* surveyed the relationship between the human brain transcriptome and genome in a series of neuropathologically normal postmortem samples. The first step in the analysis was to identify SNPs associated with the **late-onset Alzheimer's disease** (LOAD). GWAS study included 364 participants of European descent with either confirmed LOAD or no neuropathology present (case/control groups). 

# GWAS Analysis in PLINK
First, you will need do download the raw data (link given below), place it in the *data* folder, and extract all the files:  https://drive.google.com/drive/folders/1ud5F9WN9Xx3oXIkb5xIg1b_zz1nzp3IR

You following three files will be used for the analyses:
        ◦ **adgwas.map** Pmap files that contain the position of each SNP on the chromosomes relative to the Human Genome. The pmap file is in the 4 column format.
        ◦ **adgwas.ped** Pedigree file that contains genotypes calls from 502,627 SNPs on the 364 samples are given as well as anonymous individual identifiers for each sample. Data is not filtered for call rates, allele frequencies or Hardy Weinberg equilibrium. Data is not imputed. Alleles are coded as A, C, G, T and missing=0.
        ◦ **samples.covar** Group and member names correspond to individual identifiers given in the pedigree files. All covariates used in the analysis are listed. Columns are as follows: Group identifier, Individual identifier, Diagnosis (1=unaffected, 2=affected), Age, APOE (Apolipoprotein E), Region (1=frontal, 2=parietal, 3=temporal, 4=cerebellar), postmortem interval (PMI), Site, Hybridization Date.
        
Now that data is ready, we can run the analyses. First, we will run the quality control. This step was divided into two bits: **SNP quality control** and **Sample quality control**. 

To run the quality control scripts, first you need to make the bash files executable:
```
sudo chmod +x *.sh
```
Then you can run the SNP and Sample quality control by executing the bash files:
```
./snp_qc.sh
./sample_qc.sh
```
If you want to see what each step did, you can check the \*.log files in the *output* folder. Now that the data has been pre-processed, we can run GWAS by executing the following command:

```
./gwas.sh
```
