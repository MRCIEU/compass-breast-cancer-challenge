#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

url <- args[1]
output.filename <- args[2]

url<-"https://api.gdc.cancer.gov/data/1b5f413e-a8d1-4d10-92eb-7c4ae739ed81"
output.filename <- "../data/pan-cancer-files/TCGA-CDR-SupplementalTableS1.txt"
args <- c(url,output.filename)

cat("download-pan-cancer-clinical.r", paste(args,collapse=" "), "\n")

xlsx.filename <- sub("txt$","xlsx",output.filename)

download.file(
    url,
    destfile=xlsx.filename)

library(readxl)

dat <- read_xlsx(xlsx.filename, sheet=1)

write.table(dat,file=output.filename,sep="\t",row.names=F,col.names=T)

