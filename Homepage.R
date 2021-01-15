Homepage <- dashboardPage(
  dashboardHeader(disable = T),
  dashboardSidebar(disable = T),
  dashboardBody(
    column(
      width = 10,
      offset = 1,
      titleBox(title = "LIRBase: A web server for comprehensive analysis of siRNAs derived from long inverted repeat in eukaryotic genomes")
    ),
    column(
      width = 10,
      offset = 1,
      textBox(
        width = 12,
        p("We identified a total of 6,619,473", strong("long inverted repeats (LIR, longer than 800 nt)"), "in 424 eukaryotic genomes and implemented various functionalities for analysis of LIRs and small RNAs derived from LIRs.")
      )
    ),
    
    column(
      width = 10,
      offset = 1,
      titleBox(title = "Long inverted repeat, long hpRNA and siRNA")
    ),
    column(
      width = 10,
      offset = 1,
      textBox(
        width = 12,
        p("An inverted repeat is a single stranded nucleotide sequence followed by its reverse complement at the downstream. The intervening sequence between the initial sequence and the reverse complement can be any length including zero. When transcribed,", strong("long inverted repeat can form long hairpin RNA genes (hpRNAs),"), "which are much longer than typical animal or plant pre-miRNAs. Henderson et al. reported the biogenesis of small interfering RNAs (siRNAs) from long inverted repeat in ", em("Arabidopsis thaliana"), "for the first time [1].", "Okamura et al. systematically characterized the ", strong("biogenesis pathway of 21-22-nucleotide siRNAs from long hpRNAs encoded by LIRs"), " in ", em("Drosophila"), "[2]. They found that Dicer-2, Hen1 and Argonaute 2 played vital roles in this siRNA biogenesis pathway. This siRNA biogenesis pathway was further characterized in", em("Arabidopsis"), " soon (Dunoyer et al. 2010) [3].")
      )
    ),

    column(
      width = 10,
      offset = 1,
      sectionBox(
        title = "Statistics",
        fluidRow(
          valueBox("6,619,473", "Long inverted repeats", width = 4),
          valueBox("424", "Eukaryotic genomes", color = "purple", width = 4),
          valueBox(374, "Species", color = "yellow", width = 4)
        ),
        fluidRow(
          valueBox("297,317", "LIRs in 77 metazoa genomes", color = "fuchsia", width = 4),
          valueBox("1,731,978", "LIRs in 139 plant genomes", color = "navy", width = 4),
          valueBox("4,590,178", "LIRs in 208 vertebrate genomes", color = "olive", width = 4),
        )
      )
    ),

    column(
      width = 10,
      offset = 1,
      sectionBox(
        title = "Functionalities of LIRBase",
          fluidRow(
            module_Box(
              width = 4, height='230px',
              title = "Browse",
              imgSrc = "Browse.png",
              text = "Browse LIRs identified in 424 eukaryotic genomes for the sequences, structures of LIRs and the overlaps between LIRs and genes."
            ),
            module_Box(
              width = 4, height='230px',
              title = "Search by genomic location",
              imgSrc = "SearchByReg.png",
              text = "Search LIRBase for long inverted repeats in a specific genome by genomic locations."
            ),
			module_Box(
              width = 4, height='230px',
              title = "Search by LIR identifier",
              imgSrc = "SearchByLIRID.png",
              text = "Search LIRBase for long inverted repeats in a specific genome by the identifiers of LIRs."
            )
          ),
          fluidRow(
            module_Box(
              width = 4, height='250px',
              title = "BLAST",
              imgSrc = "BLAST.png",
              text = "Search LIRBase by sequence similarity using BLAST."
            ),
			module_Box(
              width = 4, height='250px',
              title = "Annotate",
              imgSrc = "Annotate.png",
              text = "Detect and annotate long inverted repeats in user-uploaded DNA sequences."
            ),
			module_Box(
              width = 4, height='250px',
              title = "Quantify",
              imgSrc = "Quantify.png",
              text = "Identify LIRs encoding candidate long hpRNAs by aligning sRNA sequencing data to LIRs."
            )
          ),
		  fluidRow(
            module_Box(
              width = 4, height='230px',
              title = "DESeq",
              imgSrc = "DESeq.png",
              text = "Perform differential expression analysis of LIRs or small RNAs between different biological samples/tissues."
            ),
			module_Box(
              width = 4, height='230px',
              title = "Visualize",
              imgSrc = "Visualize.png",
              text = "Predict and visualize the secondary structure of potential long hpRNA encoded by a LIR."
            ),
			module_Box(
              width = 4, height='230px',
              title = "Download",
              imgSrc = "Download.png",
              text = "Download LIRs of 424 eukaryotic genomes, as well as the BLAST and Bowtie index database."
            )
          )
      )
    ),

    fluidRow(
      column(
        width = 10,
        offset = 1,
        box(
          title = span(strong("Why LIR and LIRBase?"), style = "font-size:20px"),
          width = 12,
          solidHeader = TRUE,
          collapsible = FALSE,
          status = "warning",
          includeMarkdown("Home.md")
        )
      )
    )
  )
)
