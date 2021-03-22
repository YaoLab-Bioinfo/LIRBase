
Homepage <- dashboardPage(
  dashboardHeader(disable = T),
  dashboardSidebar(disable = T),
  
  dashboardBody(
    tags$head(tags$style("section.content { overflow-y: hidden; }")),
    fluidRow(
      column(
        width = 10,
        offset = 1,
        titleBox(title = "LIRBase: A web application for comprehensive analysis of siRNAs derived from long inverted repeat in 424 eukaryotic genomes")
      )
    ),
    
    fluidRow(
      column(
        width = 10,
        offset = 1,
        textBox(
          width = 12,
          p("We identified a total of 6,619,473", strong("long inverted repeats (LIR, longer than 800 nt)"), "in 424 eukaryotic genomes and implemented various functionalities for analysis of LIRs and small RNAs derived from LIRs.")
        ),
        box(
          width = 12,
          HTML("<p class='aligncenter'><img src='header.png' width='100%' height='100%' /></p>
            <style>
            .aligncenter {
              text-align: center;
            }
          </style>")
        )
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
          box(width = 4,
              actionBttn("Browse_butt", "Browse", 
                         icon = icon("folder-open-o", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Browse LIRBase by species/genomes")
          ),
          
          box(width = 4,
              actionBttn("SearchByReg_butt", "Search by genomic location", 
                         icon = icon("search", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Search LIRBase by genomic locations")
          ),
          
          box(width = 4,
              actionBttn("SearchByLIRID_butt", "Search by LIR identifier", 
                         icon = icon("search", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Search LIRBase by the identifiers of LIRs")
          )
        ),
        
        fluidRow(
          box(width = 4,
              actionBttn("BLAST_butt", "BLAST", 
                         icon = icon("rocket", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Search LIRBase by sequence similarity using BLAST")
          ),
          
          box(width = 4,
              actionBttn("Annotate_butt", "Annotate", 
                         icon = icon("cogs", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Detect and annotate long inverted repeats in user-uploaded DNA sequences")
          ),
          
          box(width = 4,
              actionBttn("Quantify_butt", "Quantify", 
                         icon = icon("upload", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Identify candidate LIRs encoding long hpRNAs by aligning sRNA sequencing data to LIRs")
          )
        ),
        
        fluidRow(
          box(width = 4,
              actionBttn("DESeq_butt", "DESeq", 
                         icon = icon("eercast", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Differential expression analysis of LIRs or small RNAs between different biological samples/tissues")
          ),
          
          box(width = 4,
              actionBttn("Target_butt", "Target", 
                         icon = icon("bullseye", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Identify protein-coding genes targeted by the small RNAs derived from a LIR")
          ),
          
          box(width = 4,
              actionBttn("Visualize_butt", "Visualize", 
                         icon = icon("file-image-o", class = NULL, lib = "font-awesome"),
                         block = TRUE, size = "lg", style="unite", color="default"),
              h4("Predict and visualize the secondary structure of potential long hpRNA encoded by a LIR")
          )
        )
      )
    )
    
  )
)

