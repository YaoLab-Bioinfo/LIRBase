<div align='center' ><font size='70'>Tutorial of LIRBase</font></div>

- <font size=4>**Source code**: [https://github.com/venyao/LIRBase](https://github.com/venyao/LIRBase)</font>
- <font size=4>**Online use**: [http://venyao.xyz/lirbase/](http://venyao.xyz/lirbase/)</font>
- <font size=4>**Contact:** [yaowen@henau.edu.cn](mailto:yaowen@henau.edu.cn)</font>

>&emsp;&emsp;**LIRBase** is a web server for comprehensive analysis of **siRNAs** (small interfering RNA) derived from **long inverted repeat** in eukaryotic genomes.

>&emsp;&emsp;Using IRF ([https://tandem.bu.edu/irf/irf.download.html](https://tandem.bu.edu/irf/irf.download.html)), we identified a total of 6,619,473 long inverted repeats in the whole genomes of 424 eukaryotes, including 297,317 LIRs in 77 metazoa genomes, 1,731,978 LIRs in 139 plant genomes and 4,585,178 LIRs in 208 vertebrate genomes. LIRBase is deployed at [http://venyao.xyz/lirbase/](http://venyao.xyz/lirbase/) for online use.

>&emsp;&emsp;The homepage of **LIRBase** displays the main functionalities of LIRBase (Figure 1). The definition of long inverted repeat, the biogenesis pathway of siRNAs from long inverted repeat and the biological roles of siRNAs generated in this pathway are elaborated in the homepage of LIRBase. These results implied that a platform for comprehensive annotation and analysis of siRNAs derived from long inverted repeat is in urgent need.

<div align=center><img src="Fig1.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 1. The homepage of LIRBase.</font></div>  


## **1. Browse LIRBase for long inverted repeats identified in 424 eukaryotic genomes**

>&emsp;&emsp;The images and the species names of 424 eukaryotes are listed in the &quot;Species&quot; panel of the &quot;Browse&quot; menu of LIRBase (Figure 2). Click of the image or the species name of any genome would take you to the &quot;LIRs annotated by IRF&quot; panel of the &quot;Browse&quot; menu, which displays all the LIRs identified in the selected genome (Figure 3). A brief summary of all the LIRs of the selected genome and a table of all the LIRs showing the structure of each LIR is demonstrated in the &quot;LIRs annotated by IRF&quot; panel. Click of the ID of any LIR in the table of all LIRs would take you to the &quot;Details of the LIR selected&quot; panel of the &quot;Browse&quot; menu, which displays the sequence, structure of the selected LIR and the overlaps between the selected LIRs and gene (Figure 3 and 4).

<div align=center><img src="Fig2.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 2. Species name and images of 424 eukaryotic genomes listed in the &quot;Species&quot; panel of the &quot;Browse&quot; menu.</font></div>  

<br/>

<div align=center><img src="Fig3.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 3. List of all the LIRs identified by IRF for a selected genome.</font></div>  

<br/>

<div align=center><img src="Fig4.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 4. Detailed information of a selected LIR.</font></div>  

## **2. Search LIRBase for LIRs in a specific genome by genomic locations**

>&emsp;&emsp;LIRBase allows searching for LIRs of any of the 424 eukaryotic genomes by genomic locations (Figure 5). The detailed steps are shown in Figure 6.

<div align=center><img src="Fig5.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 5. The &quot;Search by genomic location&quot; submenu of the &quot;Search&quot; menu.</font></div>  

<br/>

<div align=center><img src="Fig6.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 6. Steps to search LIRBase by genomic location.</font></div>  

## **3. Search LIRBase for LIRs in a specific genome by the identifiers of LIRs**

>&emsp;&emsp;LIRBase allows searching for LIRs of any of the 424 eukaryotic genomes by the identifiers (IDs) of long inverted repeats (Figure 7). The detailed steps are shown in Figure 8. After clicking the &quot;Search&quot; button in the &quot;Input&quot; panel shown in Figure 8, the results would be displayed in the &quot;Output&quot; panel (Figure 9).

<div align=center><img src="Fig7.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 7. The &quot;Search by LIR identifier&quot; submenu of the &quot;Search&quot; menu.</font></div>  

<br/>

<div align=center><img src="Fig8.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 8. Steps to search LIRBase by LIR identifiers.</font></div>  

<br/>

<div align=center><img src="Fig9.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 9. The &quot;Output&quot; panel of the &quot;Search by LIR identifier&quot; submenu.</font></div>  

## **4. Search LIRBase by sequence similarity using BLAST**

>&emsp;&emsp;Users can choose to search LIRBase by sequence similarity utilizing BLAST (Figure 10). A graphical interface was implemented in LIRBase for users to perform BLAST alignment through the NCBI BLAST+ program. BLASTN databases were constructed for all the LIRs identified in each of the 424 eukaryotic genomes. Users can choose to BLAST against any one or more genomes. The detailed steps to perform BLAST in LIRBase in shown in Figure 10.

<div align=center><img src="Fig10.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 10. Steps to BLAST in LIRBase.</font></div>  

<br/>

>&emsp;&emsp;Once the BLAST alignment is finished, you would be taken to the &quot;Output&quot; panel of the &quot;Blast&quot; menu, which displays the BLAST result in details (Figure 11). You can view and download the whole BLAST results, which was shown as a table. By clicking a row of this table, you can view the detailed information of a BLAST hit, including the alignment of a query sequence and a subject LIR sequence in the BLAST database represented by this BLAST hit. The structure, sequence of the LIR in this BLAST hit and the overlaps between this LIR and genes in the corresponding genome was also shown in the &quot;Output&quot; panel after clicking a row of the BLAST result table (Figure 11).

<div align=center><img src="Fig11.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 11. The &quot;Output&quot; panel of the &quot;Blast&quot; menu.</font></div>  

## **5. Detect and annotate long inverted repeats in user-uploaded DNA sequences**

>&emsp;&emsp;The software IRF ([https://tandem.bu.edu/irf/irf.download.html](https://tandem.bu.edu/irf/irf.download.html)) was utilized to identify long inverted repeats in the 424 eukaryotic genomes collected in LIRBase. IRF can only be used in the command line. We implemented a graphical interface for users to annotate long inverted repeats in user-uploaded DNA sequences by IRF (Figure 12). The detailed steps to annotate LIRs in user-uploaded DNA sequences are shown in Figure 12. The input DNA sequences for IRF can be pasted in a text area provided or be uploaded from a local text file. The input data must be DNA sequence in fasta format. Each sequence should have a unique ID start with ">".

<div align=center><img src="Fig12.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 12. The &quot;Annotate&quot; menu of LIRBase to annotate LIRs in user-uploaded DNA sequences.</font></div>  

<br/>

>&emsp;&emsp;The sequences and structures of LIRs identified by IRF can be downloaded as text files (Figure 12). The result of IRF can also be viewed in HTML pages (Figrue12 and 13).

<div align=center><img src="Fig13.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 13. The LIRs identified by IRF viewed in HTML pages.</font></div>  

## **6. Identify candidate LIRs encoding long hpRNAs by aligning sRNA sequencing data to LIRs**

>&emsp;&emsp;When transcribed, long inverted repeat can form long hairpin RNA genes (hpRNAs), which are much longer than typical animal or plant pre-miRNAs. Henderson et al. (2006) reported the biogenesis of small interfering RNAs (siRNAs) from long inverted repeat in _Arabidopsis thaliana_ for the first time. This siRNA biogenesis pathway was soon reported and verified in other animals and plants.

>&emsp;&emsp;To facilitate the annotation of small RNAs derived from LIRs archived in LIRBase, we implemented a functionality in LIRBase allowing alignment of user-uploaded small RNA sequencing data to all the identified LIRs of a genome (Figure 14). The input data should be read count of small RNAs rather than the raw small sequencing data as shown in Figure 14. The input small RNA read count data can be pasted in a text area provided or be uploaded from a local text file.

>&emsp;&emsp;After clicking the &quot;Align!&quot; button, the alignment would be performed. The alignment results would be displayed in the &quot;Output&quot; panel of the &quot;Quantify&quot; menu (Figure 15). The detailed alignment result, the summary of alignment and the sRNA read count of aligned LIRs can be downloaded. What&#39;s more, the summary of alignment result and the sRNA read count of aligned LIRs can be viewed as data tables in the HTML page. By clicking on a single row of the table of sRNA alignment summary, the size distributions of sRNAs and the alignment of sRNAs to the LIR would be plotted. The detailed information of the chosen LIR would be displayed at the bottom of the &quot;Output&quot; panel.

<div align=center><img src="Fig14.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 14. The &quot;Quantify&quot; menu of LIRBase to align small RNA sequencing data to a LIR database.</font></div>  

<br/>

<div align=center><img src="Fig15.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 15. The &quot;Output&quot; panel of the &quot;Quantify&quot; menu of LIRBase.</font></div>  

>&emsp;&emsp;For each LIR in the table of sRNA alignment summary, the number of sRNAs aligned to the LIR, the number of sRNA sequencing reads aligned to the LIR, the percentage of 21-nt and 22-nt sRNAs among all sRNAs aligned to the LIR, the percentage of 24-nt sRNAs among all sRNAs aligned to the LIR, the percentage of sRNAs aligned to the arms of the LIR among all sRNAs aligned to the LIR, the percentage of sRNAs aligned to the loop of the LIR among all sRNAs aligned to the LIR, the percentage of sRNAs aligned to the flanking sequences of the LIR among all sRNAs aligned to the LIR, are displayed in different columns. At the top of this table, we can set the values of different columns to identify LIRs encoding candidate long hpRNAs. For example, we can identify LIRs encoding candidate long hpRNAs in the genome of Minghui 63 with the following request: (1) a minimum of 90 sRNAs aligned to the LIR, (2) a minimum of 80% sRNAs aligned to the arms of the LIR, (3) a minimum of 50% sRNAs should be 21 or 22 nt (Figure 16).

<div align=center><img src="Fig16.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 16. Set the values of different columns of the table of sRNA alignment summary to identify LIRs encoding candidate long hpRNAs.</font></div>  

## **7. Differential expression analysis of long inverted repeats and small RNAs**

>&emsp;&emsp;By aligning small RNA sequencing data to a LIRBase, we can obtain the small RNA read count for each LIR in a genome. With multiple biological samples/tissues, we can perform differential expression analysis of long inverted repeats between different biological samples/tissues (Figure 17). The R package DESeq2 ([http://www.bioconductor.org/packages/release/bioc/html/DESeq2.html](http://www.bioconductor.org/packages/release/bioc/html/DESeq2.html)) was utilized to perform differential expression analysis. A read count matrix and a sample information table are required as input data for the differential expression analysis. The sample in the count matrix and the sample in the information table must be in the same order. Check the example data provided by LIRBase for the format of a sample information table.

>&emsp;&emsp;The results of DESeq2 can be downloaded as a plain text file or can be viewed in a data table in the HTML page (Figure 17). In addition, the MA-plot and the volcano plot showing the identified differentially expressed LIRs/sRNAs are also generated. A heatmap displaying the sample-to-sample distance is shown at the bottom of the &quot;DESeq&quot; menu.

<div align=center><img src="Fig17.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 17. The &quot;DESeq&quot; menu of LIRBase to perform differential expression analysis of LIRs/sRNAs.</font></div>  

## **8. Predict and visualize the secondary structure of the potential hpRNA encoded by a LIR**

>We utilized the RNAfold software to predict and visualize the secondary structure of the potential hpRNA encoded by a LIR (Figure 18). The DNA sequence of a single LIR should be inputted at a time. The secondary structure in dot-bracket notation and the secondary structure in PDF image are displayed in the output, which can also be downloaded.

<div align=center><img src="Fig18.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 18. The 'Visualize' menu of LIRBase.</font></div>  

## **9. Download LIRs of 424 eukaryotic genomes, the BLAST database and the Bowtie index database**

>&emsp;&emsp;In addition to be used online at [http://venyao.xyz/lirbase/](http://venyao.xyz/lirbase/), LIRBase can be deployed on a personal local or web Linux server. Deployment of LIRBase is platform independent, i.e., LIRBase can be deployed on any platform with the R environment available. The detailed steps are described in the &quot;Installation&quot; submenu of the &quot;Help&quot; menu of LIRBase (Figure 19). The source code of LIRBase is deposited in GitHub ([https://github.com/venyao/LIRBase](https://github.com/venyao/LIRBase)). As the file size of identified LIRs and the corresponding BLAST/Bowtie databases of the 424 eukaryotic genomes are too large, these datasets were not uploaded to GitHub. Instead, these data can be downloaded from [http://venyao.xyz/lirbase/](http://venyao.xyz/lirbase/) through the &quot;Download&quot; menu (Figure 20).

<div align=center><img src="Fig19.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 19. The &quot;Installation&quot; submenu of the &quot;Help&quot; menu of LIRBase.</font></div>  

<br/>

<div align=center><img src="Fig20.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 20. The &quot;Download&quot; menu of LIRBase.</font></div>  

## **10. Information of 424 genomes collected in LIRBase**

>&emsp;&emsp;The information of 424 genomes collected in LIRBase is displayed in the &quot;Genomes&quot; menu of LIRBase (Figure 21).

<div align=center><img src="Fig21.png" width="85%" height="85%" align=center /></div>
<div align=center><font color=blue size=5>Figure 21. The &quot;Genomes&quot; menu of LIRBase.</font></div>  

<br/>
