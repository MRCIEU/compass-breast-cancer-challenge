# COMPASS challenge: using multi-omic data to predict breast cancer outcome

Background and instructions presentation: [pdf](slides.pdf) [pptx](slides.pptx)

## Data preprocessing information 

> Malik, V., Kalakoti, Y. & Sundar, D. Deep learning assisted
> multi-omics integration for survival and drug-response prediction in
> breast cancer. BMC Genomics 22, 214
> (2021). https://doi.org/10.1186/s12864-021-07524-2

> "TCGA BRCA multi-omics datasets, along with their clinical
> information was available for more than 1000 patients, including
> 1089, 977, 1097, 1078, 1093 and 887 patient’s GISTIC2 CNV, mutation,
> methylation, miRNA, RNA and protein expression data
> respectively. The pre-processed TCGA dataset was obtained using
> FireBrowse utility (http://firebrowse.org). For RNA, z-scaled RSEM
> values of RNA expression were used and for miRNA log2-RPM values
> were retrieved. Protein expression and methylation data (β values)
> obtained from database were already scaled. Binary data was obtained
> for mutation of genes and GISTIC2 calculated CNV data was obtained
> directly from FireBrowse. The dataset was screened by filtering
> patients and features with more than 20% missing values. Further
> missing values in the omics dataset were imputed using R package
> impute [44]. An overlapping set of 314 patients was obtained for
> which all six-omics datasets along with their clinical information
> was available. The final processed data was observed to be class
> imbalanced. Therefore, an oversampling technique called Synthetic
> Minority Oversampling TEchnique (SMOTE) [45] was employed to balance
> the data that increases our sample set from 314 to 532."

## Downloading and preparing the dataset

Considered using the TCGAbiolinks R package to download TCGA data
but ran into installation problems.
Instead, I compiled a list of files to download from the GDAC website:
http://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/BRCA/20160128
See `files.txt` in this directory.

Data files will be downloaded to the `FILES_DIR` directory
(see [variables.txt](variables.txt)). 

```
bash download-data.sh files.txt
```

Clinical outcome data has been cleaned up as part of the
PanCancer Atlas project
(https://gdc.cancer.gov/about-data/publications/pancanatlas).

> Liu J, Lichtenberg T, Hoadley KA, et al. An Integrated TCGA Pan-Cancer
> Clinical Data Resource to Drive High-Quality Survival Outcome
> Analytics. Cell. 2018;173(2):400-416.e11. doi:10.1016/j.cell.2018.02.052

This publication cautions against using overall survival as an outcome
because the follow-up isn't long enough.
Recommends progression-free interval (PFI) or
disease-free interval (DFI).
PFI and DFI are available in Supplementary Table 1
(https://api.gdc.cancer.gov/data/1b5f413e-a8d1-4d10-92eb-7c4ae739ed81).
The table is downloaded to the `PAN_CANCER_DIR` directory
using the following script.

```
bash download-pan-cancer-clinical.sh
```

The dataset will be generated
from the downloaded files to the `FULL_DIR` directory
using the followin script.

```
bash extract-data.sh
```

This dataset is then split into training and testing subsets
in the `TRAINING_DIR` and `TESTING_DIR` directories, respectively.
```
bash split-data.sh
```

Prepare annotations of the data in order to link between
the different types. Creates three annotation files:
- `TRAINING_DIR/methylation-annotation.txt` Links CpG sites to genes.
- `TRAINING_DIR/protein-annotation.txt` Links proteins to genes.
- `TRAINING_DIR/mirna-targets.txt` Links microRNA genes to protein-coding target genes.
- `TRAINING_DIR/gene-annotation.txt` Provides information about the locations of genes in the genome.

```
bash annotate-data.sh
```

The following script loads the training dataset,
constructs a very simple predictor and then
tests it in the testing dataset. 
```
bash run-test.sh
```

## Methods

We used the z-scaled RSEM estimates of mRNA expression.

We used the log2 RPM estimates of miRNA expression.

The mutation data was analysed as a matrix of mutation
counts for each gene and each samples.

