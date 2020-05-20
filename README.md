# GWAS Demo

A demonstration of reproducing the analysis from a genome wide association study (GWAS).

# Introduction to GWAS

**Genome-wide association study (GWAS)** is a hypotheses-free method for **identifying associations between genetic regions and traits** (incl. diseases). GWAS typically **searches for small variations**, known as single-nucleotide polymorphisms (**SNPs**), that occur more frequently in people with a particular disease than in people without the disease. GWAS already has seen success at identifying SNPs related to conditions such as diabetes, Parkinson and Crohn.

# General Approach to GWAS

Researchers use **two groups of participants**: people with the disease being studied **(case group)** and similar people without the disease **(control group)**. **DNA is obtained from each participant** by scanning the blood sample/cell on automated laboratory machines. The machines survey each participant’s genome for strategically selected **markers of genetic variation (SNPs)**. If certain variations are found to be significantly more frequent in people with the disease compared to people without the disease, the **variations are said to be associated with the disease**.

The SNPs associated with the disease are **identified by testing for statistical significance between cases and controls**. Results are typically displayed in a **Manhattan plot** with -log10(p-value) plotted against the position in the genome. Two lines are added to indicate the genome-wide **significance threshold** (p=5.0×10−8) and the cut-off level for selecting single-nucleotide polymorphisms for replication study (p=1.0×10−5). An example Manhattan plot is illustrated below.
<br></br>
<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/1/12/Manhattan_Plot.png" width="80%" height="80%" alt="alt text">
</p>

# Demo
Implementation description
