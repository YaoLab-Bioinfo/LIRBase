
options(warn=-1)
options(max.print=10000)
options(shiny.maxRequestSize=6000*1024^2)

library(data.table)
library(DT)
library(ggplot2)
library(grid)
library(gridExtra)
library(htmlwidgets)
library(pheatmap)
library(RColorBrewer)
library(shiny)
library(shinyBS)
library(shinycssloaders)
library(shinyjqui)
library(shinyWidgets)
library(stringr)
library(tidyr)

library(apeglm)
library(Biostrings)
library(DESeq2)
library(IRanges)

library(shinysky)
library(dplyr)

load("genome.info.RData")
load("dat.summary.RData")

BLASTdb.fl <- read.table("BLASTdb.txt", head=T, as.is=T)
Bowtiedb.fl <- read.table("Bowtiedb.txt", head=T, as.is=T)
exam1.fa <- readLines("exam1.fa")
exam2.fa <- readLines("exam2.fa")

