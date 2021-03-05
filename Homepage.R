Homepage <- dashboardPage(
  dashboardHeader(disable = T),
  dashboardSidebar(disable = T),
  
  dashboardBody(
  tags$head(tags$style("section.content { overflow-y: hidden; }")),
  
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
      sectionBox(
        title = "Statistics",
        fluidRow(
          valueBox("6,619,473", "Long inverted repeats", width = 4, color="blue"),
          valueBox("424", "Eukaryotic genomes", width = 4, color="blue"),
          valueBox(374, "Species", width = 4, color="blue")
        ),
        fluidRow(
          valueBox("297,317", "LIRs in 77 metazoa genomes", width = 4, color="blue"),
          valueBox("1,731,978", "LIRs in 139 plant genomes", width = 4, color="blue"),
          valueBox("4,590,178", "LIRs in 208 vertebrate genomes", width = 4, color="blue"),
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
              width = 4, height='230px', color="blue",
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
              text = "Identify candidate LIRs encoding long hpRNAs by aligning sRNA sequencing data to LIRs."
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
              title = "Target",
              imgSrc = "Target.png",
              text = "Identify protein-coding genes targeted by the small RNAs derived from a LIR."
            ),
			module_Box(
              width = 4, height='230px',
              title = "Visualize",
              imgSrc = "Visualize.png",
              text = "Predict and visualize the secondary structure of potential long hpRNA encoded by a LIR."
            )
          )
      )
    )

  )
)
