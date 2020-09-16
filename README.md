
# GWAS Demo

This repository walks you through a standard approach to case/control **genome wide association studies (GWAS)** using the data from a Late Onset Alzheimer's Disease study *([Webster et al., 2009](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2667989/pdf/main.pdf)).*

This *[Youtube](https://www.youtube.com/watch?v=u8xH3EGO6uw&feature=youtu.be)* video shows all the steps for the GWAS demo.

# Introduction to GWAS

Genome-wide association study (GWAS) is a hypotheses-free method for **identifying associations between genetic regions and traits** (incl. diseases). GWAS typically **searches for small variations**, known as single-nucleotide polymorphisms (**SNPs**), that occur more frequently in people with a particular disease than in people without the disease. GWAS already has seen success at identifying SNPs related to conditions such as diabetes, Parkinson's and Crohn's.

# General Approach to GWAS

Researchers use **two groups of participants**: people with the disease being studied **(case group)** and similar people without the disease **(control group)**. **DNA is obtained from each participant** by scanning their blood sample/cell on automated laboratory machines. The machines survey each participant’s genome for strategically selected **markers of genetic variation (SNPs)**. If certain variations are found to be significantly more frequent in people with the disease compared to people without the disease, the **variations are said to be associated with the disease**.

The SNPs associated with the disease are **identified by testing for statistical significance between cases and controls**. Results are typically displayed in a **Manhattan plot** with -log10(p-value) plotted against the position in the genome. Two lines are added to indicate the genome-wide **significance threshold** (p=5.0×10−8) and the cut-off level for selecting single-nucleotide polymorphisms for replication study (p=1.0×10−5). An example Manhattan plot is illustrated below.
<br>
<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/1/12/Manhattan_Plot.png" width="80%" height="80%" alt="alt text">
</p>

# Case Study: Late-Onset Alzheimer's Disease
Webster et al. *(2009)* study investigated the genetic control of human brain transcript expression in Late Onset Alzheimer's Disease. The paper did multiple types of analysis but we will only implement a simple case/control GWAS using the data from this study to **identify genetic variants assoaciated with the Late-Onset Alzheimer's Disease**. 

GWAS study included 364 participants of European descent with either confirmed LOAD or no neuropathology present (176 cases + 188 controls). 

# GWAS Analysis

First, you will need do **download the raw data**, which is in bioinformatics software PLINK text format  (detailed instructions can be found [here](https://github.com/aridhia/demo-gwas/blob/master/gwas/data/data_instructions.txt)). The data is composed of two files: _*.map_ file, which contains SNP information such as chromosome number, variant ID, and so on; _*.ped_ file contains sample pedigree information and genotype calls. 

The GWAS analysis was divided into three steps:

 1. **Data Quality Control (QC)**: remove samples and variants that do not meet the quality control criteria.
2. **Association testing**: statistical significance testing between cases and controls.
3. **Results visualisation**. The results are typically displayed in a Manhattan plot. 


### Quality Control and Association Testing
For the QC step, two Jupyter Notebooks were produced: a general and a detailed version. The latter one walks you throught the QC process step-by-step explaining all the underlying concepts. 

To run these Notebooks, you will need to have **PLINK 1.90 beta** installed as a command line tool. The installation instructions can be found [here](https://www.cog-genomics.org/plink/). The Notebook is written in R, so you also need an R kernel, which can be easily downloaded by opening an R console and running:
```
install.packages('IRkernel')
```
Then you also need to make the kernel available to Jupyter. The following command will install the kernel spec system-wide. If you want it to be available just to the current user, set user to `TRUE`:
```
IRkernel::installspec(user = FALSE)
```
Running cells in the notebook executes PLINK commands in the background. 
If you want to see what each step did, you can check the _\*.log_ files in the *output* folder. 

Once the QC step is complete, association testing is also done from the same notebook by calling PLINK. 

# Visualizing Results

A Shiny app was created for visualizing the GWAS results. 

The app can be run from the R console:
```
library(shiny)
runApp("app.R")
```

The app has four tabs:
1. **An interactive Manhattan plot** showing the the negative logarithm of the p-value plotted against the position in the genome. The red line represents a genome-wide significance threshold, thus SNPs above it will be associated with the Late Onset Alzheimer's Disease. You can hover your mouse over the SNPs to display the variant information. 

 <br>
<p align="center">
<img src="/media/app_manhattan.jpg" width="80%" height="80%" alt="alt text">
</p>

2. **Circular and Rectangular Manhattan plots**: not interactive, more controls for changing the plot parameters as well as functionality for zooming into a single chromosome. 
 
 <br>
<p align="center">
<img src="/media/circular_manhattan.png" width="80%" height="80%" alt="alt text">
</p>
 
3. **Quantile-quantile (QQ) plots**, showing the observed vs expected p value. 
 
 <br>
<p align="center">
<img src="/media/qq.png" width="80%" height="80%" alt="alt text">
</p>

3. **SNP density plots**. 
 
 <br>
<p align="center">
<img src="/media/snp_density.png" width="80%" height="80%" alt="alt text">
</p>
