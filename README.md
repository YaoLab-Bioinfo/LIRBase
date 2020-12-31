LIRBase
========

>A total of 424 eukaryote genomes were collected and the **long inverted repeats (longer than 800 nt)** in these genomes were systematically identified. The following functionalities are implemented in LIRBase.  

>1. **Browse long inverted repeats (LIR) identified in 424 eukaryotic genomes** for the sequences, structures of LIRs, and the overlaps between LIRs and genes.  
>2. **Search** LIRBase for **long inverted repeats** in a specific genome **by genomic locations**.  
>3. **Search** LIRBase for **long inverted repeats** in a specific genome **by the identifiers** of long inverted repeats.  
>4. Search LIRBase by sequence similarity using **BLAST**.  
>5. **Detect and annotate long inverted repeats** in user-uploaded DNA sequences.  
>6. **Align small RNA sequencing data to long inverted repeats** of a specific genome to detect the origination of small RNAs from long inverted repeats and quantify the expression level of small RNAs and long inverted repeats.  
>7. Perform **differential expression analysis of long inverted repeats or small RNAs** between different biological samples/tissues.  

*****

#	Use LIRBase online

>LIRBase is deployed at <a href="http://venyao.xyz/lirbase/" target="_blank">venyao.xyz/lirbase/</a> for online use.  

*****

#	Deploy LIRBase on local or web Linux server

**Step 1: Install R**  

>Please check CRAN (<a href="https://cran.r-project.org/" target="_blank">cran.r-project.org</a>) for the installation of R.

**Step 2: Install the R Shiny package and other packages required by LIRBase**  

>Start an R session and run these lines in R:  

```
# try an http CRAN mirror if https CRAN mirror doesn't work  
install.packages("data.table")
install.packages("DT")
install.packages("ggplot2")
install.packages("grid")
install.packages("gridExtra")
install.packages("htmlwidgets")
install.packages("pheatmap")
install.packages("RColorBrewer")
install.packages("shiny")
install.packages("shinyBS")
install.packages("shinycssloaders")
install.packages("shinydashboard")
install.packages("shinydisconnect")
install.packages("shinyjqui")
install.packages("shinyWidgets")
install.packages("stringr")
install.packages("tidyr")
install.packages("dplyr")

install.packages("BiocManager")
BiocManager::install("apeglm")
BiocManager::install("Biostrings")
BiocManager::install("DESeq2")
BiocManager::install("IRanges")

# install shinysky
install.packages("devtools")
devtools::install_github("venyao/ShinySky", force=TRUE)
```

>For more information, please check the following pages:  
<a href="https://cran.r-project.org/web/packages/shiny/index.html" target="_blank">cran.r-project.org/web/packages/shiny/index.html</a>  
<a href="https://github.com/rstudio/shiny" target="_blank">github.com/rstudio/shiny</a>  
<a href="https://shiny.rstudio.com/" target="_blank">shiny.rstudio.com</a>  

**Step 3: Install Shiny-Server**

>Please check the following pages for the installation of shiny-server.  
<a href="https://www.rstudio.com/products/shiny/download-server/" target="_blank">rstudio.com/products/shiny/download-server/</a>  
<a href="https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source" target="_blank">github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source</a>  

**Step 4: Install BLAST+**

>Download and install BLAST+ on your system PATH. Check <a href="https://opensource.com/article/17/6/set-path-linux" target="_blank">opensource.com/article/17/6/set-path-linux</a> for the setting of system PATH in Linux.  
>Please check <a href="https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download" target="_blank">blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download</a> for the download and installation of BLAST+.

**Step 5: Install Bowtie**

>Download and install Bowtie on your system PATH. Check <a href="https://opensource.com/article/17/6/set-path-linux" target="_blank">opensource.com/article/17/6/set-path-linux</a> for the setting of system PATH in Linux.  
>Please check <a href="http://bowtie-bio.sourceforge.net/index.shtml" target="_blank">bowtie-bio.sourceforge.net/index.shtml and github.com/BenLangmead/bowtie</a> for the download and installation of Bowtie.

**Step 6: Upload source files of LIRBase**

>Put the directory containing the code and data of LIRBase to /srv/shiny-server.  
The BLASTN database files downloaded from the **Download menu of LIRBase** should be placed in the **LIRBase_blastdb** directory under the **www** directory of LIRBase.  
The downloaded Bowtie index files downloaded from the **Download menu of LIRBase** should be placed in the **LIRBase_bowtiedb** directory under the **www** directory of LIRBase.  
The downloaded **Inverted_repeat_structure** files downloaded from the **Download menu of LIRBase** should be placed in the **Table** directory under the **www** directory of LIRBase.  
The downloaded **Inverted_repeat_sequence** files downloaded from the **Download menu of LIRBase** should be placed in the **Fasta** directory under the **www** directory of LIRBase.  
The downloaded **IRF_stem_alignment** files downloaded from the **Download menu of LIRBase** should be placed in the **HTML** directory under the **www** directory of LIRBase.


**Step 7: Configure shiny server (/etc/shiny-server/shiny-server.conf)**

```
# Define the user to spawn R Shiny processes
run_as shiny;

# Define a top-level server which will listen on a port
server {  
  # Use port 3838  
  listen 3838;  
  # Define the location available at the base URL  
  location /lirbase {  
    # Directory containing the code and data of LIRBase  
    app_dir /srv/shiny-server/LIRBase;  
    # Directory to store the log files  
    log_dir /var/log/shiny-server;  
  }  
}  
```

**Step 8: Change the owner of the LIRBase directory**

```
$ chown -R shiny /srv/shiny-server/LIRBase  
```

**Step 9: Start Shiny-Server**

```
$ start shiny-server  
```

>Now, the LIRBase app is available at http://IPAddressOfTheServer:3838/LIRBase/ 
(Remeber to replace IPAddressOfTheServer as the actual IP address of your Linux server). 


