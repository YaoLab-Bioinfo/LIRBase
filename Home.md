
<font size="6" color="red"><b>LIRBase:</b></font><font size="5" color="red"><b> A web server for comprehensive analysis of siRNAs derived from long inverted repeat in eukaryotic genomes</b></font>

<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Functionalities of LIRBase</b></font>  

>1. **Browse long inverted repeats (LIR) identified in 424 eukaryotic genomes** for the sequences, structures of LIRs and the overlaps between LIRs and genes.  
>2. **Search** LIRBase for **long inverted repeats** in a specific genome **by genomic regions**.  
>3. **Search** LIRBase for **long inverted repeats** in a specific genome **by the identifiers** of long inverted repeats.  
>4. Search LIRBase by sequence similarity using **BLAST**.  
>5. **Detect and annotate long inverted repeats** in user-uploaded DNA sequences.  
>6. **Align small RNA sequencing data to long inverted repeats** of a specific genome to detect the origination of small RNAs from long inverted repeats and quantify the expression level of small RNAs and long inverted repeats.  
>7. Perform **differential expression analysis of long inverted repeats and small RNAs** between different biological samples/tissues.  

>A typical long inverted repeat and the small RNAs originated from the LIR analyzed utilizing LIRBase are demonstrated in the following image.  

<p class="aligncenter"><img src="LIR_rice.png" width="85%" height="70%" /></p>
<style>
.aligncenter {
    text-align: center;
}
</style>

<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Long inverted repeat</b></font>  
>An inverted repeat is a single stranded nucleotide sequence followed by its reverse complement at the downstream. 
>The intervening sequence between the initial sequence and the reverse complement can be any length including zero. 
>**Long inverted repeat (LIR) can form secondary stem-loop structures in prokaryotic and eukaryotic genomes**.

<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Long inverted repeat and small RNA</b></font>  
>When transcribed, long inverted repeat can form long hairpin RNA genes (hpRNAs), which are much longer than typical animal or plant pre-miRNAs.
>Okamura et al. reported the **biogenesis of 21–22-nucleotide small interfering RNAs (siRNAs) from long hpRNAs** in *Drosophila* for the first time [1].
>They found that Dicer-2, Hen1 and Argonaute 2 played vital roles in this siRNA biogenesis pathway. This siRNA biogenesis pathway was soon reported in *Arabidopsis* (Dunoyer et al. 2010) [2].

<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>siRNA derived from long inverted repeats play important biological roles</b></font>  
>In 2018, Lin et al. identified two long hpRNAs in *Drosophila simulans*, which could be processed into 21-nt siRNAs [3]. 
>These siRNAs could then repress the expression of the *Dox* and *MDox* genes which promotes X chromosome transmission by suppressing Y-bearing sperm.
>As a result, the **two long hpRNAs and the derived siRNAs are critical to the maintenance of balanced sex ratio** in the offsprings of *Drosophila simulans*.
>The biological functions of siRNAs derived from long inverted repeats in plants were also reported in recent years.
>In apple, a long hpRNA and the generated siRNAs contributed to the resistance of apple to leaf spot disease [4].
>In soybean, a long hpRNA and the derived 22-nt siRNAs regulate the seed coat color of soybean [5].

<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Comprehensive identification of LIRs in 424 eukaryotic genomes</b></font>  
>In 2013, **Axtell urgently called on the comprehensive genome-wide identification and annotation of long inverted repeats and long hpRNAs** [6].
>However, genome-wide identification and annotation of long inverted repeats were only conducted in very few organisms.
>None database or web server for annotation and analysis of long inverted repeats and long hpRNAs exist up to now.
>Using IRF (https://tandem.bu.edu/irf/irf.download.html) [7], we identified a total of 6,619,473 long inverted repeats in the whole genomes of 424 eukaryotes, including 297,317 LIRs in 77 metazoa genomes, 1,731,978 LIRs in 139 plant genomes and 4,590,178 LIRs in 208 vertebrate genomes.
>We requested a minimum length of 400 nt for both stems of the long inverted repeat identified by IRF, to remove potential miniature inverted-repeat transposable element (MITE) or Alu element from the result of IRF.


<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>References</b></font>   
>1. Okamura et al. (2008), <a href="https://www.nature.com/articles/nature07015" target="_blank">The <i>Drosophila</i> hairpin RNA pathway generates endogenous short interfering RNAs</a>, Nature  
>2. Dunoyer et al. (2010), <a href="https://www.embopress.org/doi/full/10.1038/emboj.2010.65" target="_blank">An endogenous, systemic RNAi pathway in plants</a>, EMBO J (Note: This article had been retracted due to image irregularities, while the authors considered that the core conclusions of the published paper remain valid.)  
>3. Lin et al. (2018), <a href="https://doi.org/10.1016/j.devcel.2018.07.004" target="_blank">The hpRNA/RNAi Pathway Is Essential to Resolve Intragenomic Conflict in the *Drosophila* Male Germline</a>, Developmental Cell  
>4. Zhang et al. (2018), <a href="http://www.plantcell.org/content/30/8/1924" target="_blank">A Single-Nucleotide Polymorphism in the Promoter of a Hairpin RNA Contributes to *Alternaria alternata* Leaf Spot Resistance in Apple (*Malus × domestica*)</a>, Plant Cell  
>5. Jia et al. (2020), <a href="http://www.plantcell.org/content/32/12/3662" target="_blank">Soybean DICER-LIKE2 Regulates Seed Coat Color via Production of Primary 22-Nucleotide Small Interfering RNAs from Long Inverted Repeats</a>, Plant Cell  
>6. Axtell et al. (2013), <a href="https://www.annualreviews.org/doi/abs/10.1146/annurev-arplant-050312-120043" target="_blank">Classification and Comparison of Small RNAs from Plants</a>, Annual Review of Plant Biology  
>7. Warburton et al. (2004), <a href="https://genome.cshlp.org/content/14/10a/1861.abstract" target="_blank">Inverted Repeat Structure of the Human Genome: The X-Chromosome Contains a Preponderance of Large, Highly Homologous Inverted Repeats That Contain Testes Genes</a>, Genome Research  


