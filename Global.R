
options(warn=-1)
options(max.print=10000)
options(shiny.maxRequestSize=6000*1024^2)

# library(data.table)
# library(DT)
# library(ggplot2)
# library(grid)
# library(gridExtra)
# library(htmlwidgets)
# library(pheatmap)
# library(RColorBrewer)
library(shiny)
library(shinyBS)
# library(shinycssloaders)
library(shinydashboard)
# library(shinydisconnect)
# library(shinyjqui)
# library(shinyWidgets)
# library(stringr)
# library(tidyr)
# library(XML)

# library(apeglm)
# library(Biostrings)
# library(DESeq2)
# library(GenomicRanges)

# library(shinysky)
# library(dplyr)
`%>%` <- magrittr::`%>%`


# load("genome.info.RData")

BLASTdb.fl <- read.table("BLASTdb.txt", head=T, as.is=T)

