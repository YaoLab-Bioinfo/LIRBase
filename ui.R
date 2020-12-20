
LIR_Info_Title <- paste("Number_of_LIR: number of LIRs identified by IRF;",
                        "Length: length of a LIR;",
                        "Left_len: length of the left arm of a LIR;",
                        "Right_len: length of the right arm of a LIR;",
                        "Loop_len: length of the loop between the left and the right arm;",
                        "Match_per: percentage of sequence matches between the left and the right arm;",
                        "Indel_per: percentage of indels between the left and the right arm;",
                        sep = "<br>")

Blast_Info_Title <- paste("qseqid: Query sequence ID;",
                        "qlen: Query sequence length;",
                        "sseqid: Subject sequence ID;",
                        "slen: Subject sequence length;",
                        "length: Alignment length;",
                        "qstart: Start of alignment in query;",
                        "qend: End of alignment in query;",
                        "sstart: Start of alignment in subject;",
                        "send: End of alignment in subject;",
                        "mismatch: Number of mismatches;",
                        "gapopen: Number of gap openings;",
                        "pident: Percentage of identical matches;",
                        "qcovhsp: Query Coverage Per HSP;",
                        "evalue: Expect value;",
                        "bitscore: Bit score;",
                        sep = "<br>")

shinyUI(
  navbarPage(
    title = "LIRBase", 
    windowTitle = "Welcome to LIRBase!",
    
    ## Home
    tabPanel("Home", 
             tags$head(
               tags$style("
                 input[type='file'] {width:5em;}
                 .toggleButton {width:100%;}
                 .clearButton {float:right; font-size:12px;}
                 .fa-angle-down:before, .fa-angle-up:before {float:right;}
                 .popover{text-align:left;width:500px;background-color:#000000;}
                 .popover-title{color:#FFFFFF;font-size:16px;background-color:#000000;border-color:#000000;}
                 .jhr{display: inline; vertical-align: top; padding-left: 10px;}

                 #sidebarPanel_1 {width:25em;}
                 #mainPanel_1 {left:28em; position:absolute; min-width:27em;}
                 .popover{max-width: 60%;}
              "),
               
               tags$style(HTML(".shiny-output-error-validation {color: red;}")),
               tags$style(HTML(
                 ".checkbox {margin: 0}
                 .checkbox p {margin: 0;}
                 .shiny-input-container {margin-bottom: 0;}
                 .navbar-default .navbar-brand {color: black; font-size:150%;}
                 .navbar-default .navbar-nav > li > a {color:black; font-size:120%;}
                 .shiny-input-container:not(.shiny-input-container-inline) {width: 100%;}
               ")),
               tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});'))
             ),
             
             icon = icon("home", class = NULL, lib = "font-awesome"),
             
             # htmlwidgets::getDependency('sparkline'),
             # dataTableOutput("IRFsummary")
             
             includeMarkdown("Home.md")
    ),
    
    # Browse
    tabPanel(
      "Browse",
      icon = icon("folder-open-o", class = NULL, lib = "font-awesome"),
      
      tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});')),
                tags$style(
                  HTML(
                    "
            #inputs-table {
              border-collapse: collapse;
            }
            
            #inputs-table td {
              padding: 3px;
              vertical-align: bottom;
            }

            .multicol .shiny-options-group{
                            -webkit-column-count: 2; /* Chrome, Safari, Opera */
              -moz-column-count: 2;    /* Firefox */
              column-count: 2;
              -moz-column-fill: balanced;
              -column-fill: balanced;
            }
            .checkbox{
              margin-top: 0px !important;
              -webkit-margin-after: 1px !important; 
            }
            "
                  ) #/ HTML
                ) #/ style
      ), #/ head
      
      tabsetPanel(id = "browser_1",
                  tabPanel("Species",
                           dataTableOutput('HTMLtable')
                  ),
                  
                  tabPanel("LIRs annotated by IRF",
                           fixedRow(
                             column(6,
                                    tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Long inverted repeats identified by IRF</b></font>'),
                                             bsButton("qLIRInfoTitle", label="", icon=icon("question"), style="info", size="small")),
                                    bsPopover("qLIRInfoTitle", title = LIR_Info_Title, content = NULL, trigger = "focus", options = list(container = "body"))
                             )
                           ),
                           
                           dataTableOutput("LIR_info_num"),
                           
                           fixedRow(
                             column(2,
                                    plotOutput("Length", height = "200px", width = "200px")
                             ),
                             column(2,
                                    plotOutput("Left_len", height = "200px", width = "200px")
                             ),
                             column(2,
                                    plotOutput("Right_len", height = "200px", width = "200px")
                             ),
                             column(2,
                                    plotOutput("Loop_len", height = "200px", width = "200px")
                             ),
                             column(2,
                                    plotOutput("Match_per", height = "200px", width = "200px")
                             ),
                             column(2,
                                    plotOutput("Indel_per", height = "200px", width = "200px")
                             )
                           ),
                           
                           br(),
                           textOutput("IRFbrowse_title"),
                           tags$head(tags$style("#IRFbrowse_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                           )),
                           dataTableOutput("IRFbrowse")
                  ),
                  
                  tabPanel("Details of the LIR selected",
                           textOutput("LIR_info_title"),
                           tags$head(tags$style("#LIR_info_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                           )),
                           dataTableOutput("LIR_info"),
                           br(),
                           
                           textOutput("LIR_gene_op_title"),
                           tags$head(tags$style("#LIR_gene_op_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                           )),
                           dataTableOutput("LIR_gene_op"),
                           br(),
                           
                           fixedRow(
                             column(6,
                                    textOutput("LIR_sequence_title"),
                                    tags$head(tags$style("#LIR_sequence_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    verbatimTextOutput("LIR_sequence", placeholder = FALSE)
                             ),
                             column(6,
                                    textOutput("LIR_detail_title"),
                                    tags$head(tags$style("#LIR_detail_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    verbatimTextOutput("LIR_detail")
                             )
                           )
                  )
      )
      
    ),
    
    
    # Search
    navbarMenu(
      "Search",
      icon = icon("search", class = NULL, lib = "font-awesome"),
      
      tabPanel(h5("Search by genomic location"),
               fixedRow(
                 column(6,
                        tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Search by genomic region</b></font>'),
                                 bsButton("qSearchRegTitle", label="", icon=icon("question"), style="info", size="small")),
                        bsPopover("qSearchRegTitle", "Search for the information of long inverted repeats identified in any of the 424 genomes by genomic regions!", trigger = "focus")
                 )
               ),
               
               fixedRow(
                 column(6,
                        multiInput(
                          inputId = "chooseGenomeReg",
                          label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose genome</font>')),
                          choices = NULL, width = '100%',
                          choiceNames = BLASTdb.fl$Accession,
                          choiceValues = BLASTdb.fl$Accession,
                          options = list(
                            enable_search = TRUE, limit = 1,
                            non_selected_header = "Choose from:",
                            selected_header = "You have selected:"
                          )
                        )
                 ),
                 column(6,
                        selectInput(inputId = "chooseChromosomeReg", 
                                    label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose chromosome</font>')),
                                    choices = NULL, width = '100%'),
                        
                        uiOutput("searchRegion"),
                        br(),
                        
                        actionButton("submitSearchReg", strong("Search!",
                                                               bsButton("qpSearchReg", label="", icon=icon("question"), style="info", size="small")
                        ), styleclass = "success"),
                        conditionalPanel(condition="input.submitSearchReg != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
                        bsPopover("qpSearchReg", "Click this button to start the search!", trigger = "focus")
                 )
               ),
               
               br(),
               fluidRow(
                 column(6,
                        downloadButton("searchRegDownIRFresult.txt", "Download the structure of LIRs in the search result", style = "width:95%;", class = "buttDown"),
                        tags$head(tags$style(".buttDown{background-color:black; color: white; font-size: 20px;}"))
                 ),
                 column(6,
                        downloadButton("searchRegDownIRFfasta.txt", "Download the sequence of LIRs in the search result", style = "width:95%;", class = "buttDown")
                 )
               ),
               
               br(),
               dataTableOutput("LIRsearchRegResult"),
               br(),
               
               fixedRow(
                 textOutput("Search_reg_LIR_gene_op_title"),
                 tags$head(tags$style("#Search_reg_LIR_gene_op_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                 )),
                 dataTableOutput("Search_reg_LIR_gene_op"),
                 br(),
                 
                 column(6, 
                        textOutput("LIR_detail_search_reg_fasta_title"),
                        tags$head(tags$style("#LIR_detail_search_reg_fasta_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                        )),
                        verbatimTextOutput("LIR_detail_search_reg_fasta")
                 ),
                 column(6, 
                        textOutput("LIR_detail_search_reg_title"),
                        tags$head(tags$style("#LIR_detail_search_reg_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                        )),
                        verbatimTextOutput("LIR_detail_search_reg")
                 )
               )
      ),
      
      tabPanel(h5("Search by LIR identifier"),
               fixedRow(
                 column(6,
                        tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Search by LIR identifier</b></font>'),
                                 bsButton("qSearchIDTitle", label="", icon=icon("question"), style="info", size="small")),
                        bsPopover("qSearchIDTitle", "Search for the information of long inverted repeats identified in any of the 424 genomes by the identifier of LIRs!", trigger = "focus")
                 )
               ),
               
               tabsetPanel(id = "search_ID",
                           tabPanel("Input",
                                    fluidRow(
                                      column(6,
                                             textAreaInput("LIRID", label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Input LIR identifiers</font>')),
                                                           value = "", resize = "vertical", height='400px', width = '100%', 
                                                           placeholder = "One item in one row")
                                      ),
                                      column(6,
                                             pickerInput(
                                               inputId = "chooseGenomeID",
                                               label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose genome</font>')),
                                               width = '100%', selected = NULL,
                                               choices = list(
                                                 Metazoa = BLASTdb.fl$Accession[BLASTdb.fl$Division == "Metazoa"],
                                                 Plant = BLASTdb.fl$Accession[BLASTdb.fl$Division == "Plant"],
                                                 Vertebrate = BLASTdb.fl$Accession[BLASTdb.fl$Division == "Vertebrate"]
                                               ),
                                               options = list(
                                                 `live-search` = TRUE
                                               )
                                             ),
                                             
                                             br(),
                                             actionButton("submitSearchID", strong("Search!",
                                                                                   bsButton("qpSearchID", label="", icon=icon("question"), style="info", size="small")
                                             ), styleclass = "success"),
                                             actionButton("clear2", strong("Reset"), styleclass = "warning"),
                                             actionButton("searchIDExam", strong("Load example"), styleclass = "info"),
                                             conditionalPanel(condition="input.submitSearchID != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
                                             bsPopover("qpSearchID", "Click this button to start the search!", trigger = "focus")
                                      )
                                    )
                           ),
                           
                           tabPanel("Output",
                                    fluidRow(
                                      column(6,
                                             downloadButton("searchIDDownIRFresult.txt", "Download structure of LIRs in the search result", style = "width:100%;", class = "buttDown"),
                                      ),
                                      column(6,
                                             downloadButton("searchIDDownIRFfasta.txt", "Download sequence of LIRs in the search result", style = "width:100%;", class = "buttDown")
                                      )
                                    ),
                                    
                                    br(),
                                    dataTableOutput("LIRsearchIDResult"),
                                    br(),
                                    
                                    fixedRow(
                                      textOutput("Search_ID_LIR_gene_op_title"),
                                      tags$head(tags$style("#Search_ID_LIR_gene_op_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                      )),
                                      dataTableOutput("Search_ID_LIR_gene_op"),
                                      br(),
                                      
                                      column(6, 
                                             textOutput("LIR_detail_search_ID_fasta_title"),
                                             tags$head(tags$style("#LIR_detail_search_ID_fasta_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                             )),
                                             verbatimTextOutput("LIR_detail_search_ID_fasta")
                                      ),
                                      column(6, 
                                             textOutput("LIR_detail_search_ID_title"),
                                             tags$head(tags$style("#LIR_detail_search_ID_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                             )),
                                             verbatimTextOutput("LIR_detail_search_ID")
                                      )
                                    )
                           )
               )
      )
    ),
    
    
    # Blast
    tabPanel(
      "Blast",
      icon = icon("rocket", class = NULL, lib = "font-awesome"),
      
      tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Search LIRBase by sequence similarity using BLAST</b></font>'),
               bsButton("qBlastTitle", label="", icon=icon("question"), style="info", size="small")),
      bsPopover("qBlastTitle", title = Blast_Info_Title, content = NULL, trigger = "focus"),
      
      tabsetPanel(id = "BLAST_tab",
                  tabPanel("Input",
                           fixedRow(
                             column(5,
                                    selectInput("In_blast", label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Paste or upload input data?</font>'),
                                                                             bsButton("qBlastIn", label="", icon=icon("question"), style="info", size="small")
                                    ), choices = list("Paste input data" = "paste", 
                                                      "Upload input data" = "upload"), 
                                    selected = "paste"),
                                    bsPopover("qBlastIn", "The input data must be DNA sequence in fasta format.", trigger = "focus"),
                                    
                                    conditionalPanel(condition="input.In_blast == 'paste'", 
                                                     textAreaInput("BlastSeqPaste", label = h4("Input sequence"),
                                                                   value = "", resize = "vertical", height='400px', width = '100%',
                                                                   placeholder = "The sequence must be in fasta format")
                                    ),
                                    conditionalPanel(condition="input.In_blast == 'upload'", 
                                                     fileInput("BlastSeqUpload",
                                                               label = h4("Upload file"), multiple = FALSE, width = "100%"),
                                                     downloadButton("BLAST_Input.txt", "Download example BLAST input data", style = "width:100%;", class = "buttDown")
                                    )
                             ),
                             column(4,
                                    multiInput(
                                      inputId = "BLASTdb",
                                      label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose BLAST databases</font>'),
                                                       bsButton("qblastDB", label="", icon=icon("question"), style="info", size="small")
                                      ),
                                      choices = NULL, width = '100%', 
                                      choiceNames = BLASTdb.fl$Accession,
                                      choiceValues = BLASTdb.fl$Accession,
                                      options = list(
                                        enable_search = TRUE,
                                        non_selected_header = "Choose from:",
                                        selected_header = "You have selected:"
                                      )
                                    ),
                                    bsPopover("qblastDB", "Choose one or multiple BLAST database to search against.",
                                              trigger = "focus")
                             ),
                             column(3,
                                    textInput("BLASTev", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">E-value cutoff</font>'),
                                                                          bsButton("qBLASTev", label="", icon=icon("question"), style="info", size="small")), 
                                              value = "10", width = NULL, placeholder = NULL),
                                    bsPopover("qBLASTev", "Set E-value threshold to filter the BLAST output.",
                                              trigger = "focus"),
                                    textInput("BLASTht", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Maximum no. of hits</font>'),
                                                                          bsButton("qBLASTht", label="", icon=icon("question"), style="info", size="small")), 
                                              value = "10", width = NULL, placeholder = NULL),
                                    bsPopover("qBLASTht", "Maximum number of BLAST hits to report for each subject.",
                                              trigger = "focus"),
                                    
                                    br(),
                                    
                                    actionButton("submitBLAST", strong("BLAST!",
                                                                       bsButton("qBLASTGO", label="", icon=icon("question"), style="info", size="small")
                                    ), styleclass = "success"),
                                    actionButton("clear3", strong("Reset"), styleclass = "warning"),
                                    actionButton("blastExam", strong("Load example"), styleclass = "info"),
                                    conditionalPanel(condition="input.submitBLAST != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
                                    bsPopover("qBLASTGO", "Click this button to start the BLAST alignment!",
                                              trigger = "focus"),
                                    
                             )
                           )
                  ),
                  tabPanel("Output",
                           fixedRow(
                             column(4,
                                    downloadButton("BLASTresult.txt", "Download the BLAST result", style = "width:100%;", class = "buttDown")
                             ),
                             column(4,
                                    downloadButton("blastDownIRFresult.txt", "Download structure of LIRs in the BLAST result", style = "width:100%;", class = "buttDown")
                             ),
                             column(4,
                                    downloadButton("blastDownIRFfasta.txt", "Download sequence of LIRs in the BLAST result", style = "width:100%;", class = "buttDown")
                             )
                           ),
                           
                           br(),
                           dataTableOutput("BLASTresult"),
                           
                           div(
                             column(6,
                                    textOutput("BLAST_plot_1_title"),
                                    tags$head(tags$style("#BLAST_plot_1_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(plotOutput("BLAST_plot_1", height = "500px", width = "95%"))
                             ),
                             column(6,
                                    textOutput("BLAST_plot_2_title"),
                                    tags$head(tags$style("#BLAST_plot_2_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(plotOutput("BLAST_plot_2", height = "500px", width = "95%"))
                             )
                           ),
                           
                           br(),
                           
                           fixedRow(
                             column(11,
                                    textOutput("Blast_LIR_gene_op_title"),
                                    tags$head(tags$style("#Blast_LIR_gene_op_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    dataTableOutput("Blast_LIR_gene_op")
                             ),
                             br(),
                             
                             column(6, 
                                    textOutput("LIR_detail_blast_fasta_title"),
                                    tags$head(tags$style("#LIR_detail_blast_fasta_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(verbatimTextOutput("LIR_detail_blast_fasta"))
                             ),
                             column(6, 
                                    textOutput("LIR_detail_blast_title"),
                                    tags$head(tags$style("#LIR_detail_blast_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(verbatimTextOutput("LIR_detail_blast"))
                             )
                           )
                  )
      )
    ),
    
    
    # Annotate
    tabPanel(
      "Annotate",
      icon = icon("cogs", class = NULL, lib = "font-awesome"),
      
      sidebarPanel(width=4,
                   tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Annotate LIRs in user-uploaded DNA sequences</b></font>'),
                            bsButton("qAnnotateTitle", label="", icon=icon("question"), style="info", size="small")),
                   bsPopover("qAnnotateTitle", "Detect long inverted repeats using IRF (https://tandem.bu.edu/irf/irf.download.html)!", trigger = "focus"),
                   
                   selectInput("In_predict", label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Paste or upload input data?</font>'),
                                                              bsButton("qPredictIn", label="", icon=icon("question"), style="info", size="small")
                   ), choices = list("Paste input data" = "paste", 
                                     "Upload input data" = "upload"), 
                                     selected = "paste"),
                   bsPopover("qPredictIn", "The input data must be DNA sequence in fasta format. Each sequence should have a unique ID start with >.", trigger = "focus"),
                   conditionalPanel(condition="input.In_predict == 'paste'", 
                                    textAreaInput("PreSeqPaste", label = h4("Input sequence"),
                                                  value = "", resize = "vertical", height='220px', width = '100%',
                                                  placeholder = "The sequence must be in fasta format")
                   ),
                   conditionalPanel(condition="input.In_predict == 'upload'", 
                                    fileInput("PreSeqUpload",
                                              label = h4("Upload file"), multiple = FALSE, width = "100%"),
                                    downloadButton("Annotate_Input.txt", "Download example input data", style = "width:100%;", class = "buttDown")
                   ),
                   
                   br(),
                   actionButton("submitP", strong("Submit!",
                                                  bsButton("qp10", label="", icon=icon("question"), style="info", size="small")
                   ), styleclass = "success"),
                   actionButton("clear1", strong("Clear"), styleclass = "warning"),
                   actionButton("predictExam", strong("Load example"), styleclass = "info"),
                   conditionalPanel(condition="input.submitP != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
                   bsPopover("qp10", "Click this button to start the annotation!",
                             trigger = "focus"),
                   br(),br(),
                   
                   sliderInput("Match", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Matching weight</font>'),
                                                            bsButton("qp2", label="", icon=icon("question"), style="info", size="small")
                   ),
                   min=1, max=10, value=2, step=1),
                   bsPopover("qp2", "Weight for sequence matches between the left arm and the right arm of a LIR.",
                             trigger = "focus"),
                   
                   sliderInput("Mismatch", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Mismatching penalty</font>'),
                                                         bsButton("qp3", label="", icon=icon("question"), style="info", size="small")
                   ),
                   min=1, max=10, value=3, step=1),
                   bsPopover("qp3", "Penalty for mismatches between the left arm and the right arm of a LIR.",
                             trigger = "focus"),

                   sliderInput("Delta", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Indel penalty</font>'),
                                                      bsButton("qp4", label="", icon=icon("question"), style="info", size="small")
                   ),
                   min=3, max=10, value=5, step=1),
                   bsPopover("qp4", "Penalty for indels between the left arm and the right arm of a LIR.",
                             trigger = "focus"),
                   
                   sliderInput("PM", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Match probability</font>'),
                                                      bsButton("qp5", label="", icon=icon("question"), style="info", size="small")
                   ),
                   min=60, max=100, value=80, step=1),
                   bsPopover("qp5", "The minimum sequence matches (%) required between the left arm and the right arm of a LIR.",
                             trigger = "focus"),
                   
                   sliderInput("PI", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Indel probability</font>'),
                                                            bsButton("qp6", label="", icon=icon("question"), style="info", size="small")
                   ),
                   min=0, max=40, value=10, step=1),
                   bsPopover("qp6", "The maximum percent of indels allowed between the left arm and the right arm of a LIR.",
                             trigger = "focus"),
                   
                   sliderInput("Minscore", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Min alignment score</font>'),
                                                            bsButton("qp7", label="", icon=icon("question"), style="info", size="small")
                                                            ),
                               min=40, max=2000, value=40, step=1),
                   bsPopover("qp7", "Minimum alignment score to report.",
                             trigger = "focus"),
                   
                   sliderInput("MaxLength", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Max stem length</font>'),
                                                bsButton("qp8", label="", icon=icon("question"), style="info", size="small")
                   ), value = 100000, min = 10000, step = 1, max = 500000),
                   bsPopover("qp8", "Maximum stem length to report.",
                             trigger = "focus"),
                   
                   sliderInput("MaxLoop", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Max loop length</font>'),
                                                              bsButton("qp9", label="", icon=icon("question"), style="info", size="small")
                   ), value = 50000, min = 1000, max = 100000, step = 1),
                   bsPopover("qp9", "Results with loop length larger than this value will be removed.",
                             trigger = "focus"),
                   
                   sliderInput("flankSeqLen", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Length of flanking sequence</font>'),
                                                                       bsButton("qp11", label="", icon=icon("question"), style="info", size="small")),
                             value = 200, min = 0, max = 500, step = 1
                   ),
                   bsPopover("qp11", "The length of flanking sequences to display for a LIR.",
                             trigger = "focus")
                   
      ),
      
      mainPanel(
        fixedRow(
          column(6, uiOutput("downloadIRFresult")),
          column(6, uiOutput("downloadIRFfasta"))
        ),
        htmlOutput("prediction")
      )
    ),
    
    
    # Quantification
    tabPanel(
      "Quantify",
      icon = icon("upload", class = NULL, lib = "font-awesome"),
      
      tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Annotate and quantify the expression level of LIRs using sRNA sequencing data</b></font>'),
               bsButton("qQuantifyTitle", label="", icon=icon("question"), style="info", size="small")),
      bsPopover("qQuantifyTitle", "Align sRNA sequencing data to all the LIRs of a genome using Bowtie.", trigger = "focus"),
      
      tabsetPanel(id = "Quantify_tab",
                  tabPanel("Input",
                           fixedRow(
                             column(6,
                                    selectInput("In_align", label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Input sRNA read count data</font>'),
                                                                             bsButton("qAlignIn", label="", icon=icon("question"), style="info", size="small")
                                    ), choices = list("Paste input data" = "paste", 
                                                      "Upload input data" = "upload"),
                                    selected = "paste"),
                                    bsPopover("qAlignIn", "The input data must be a table with two columns. The 1st column is the sequence of sRNAs and the 2nd column is the read count of each sRNA. The column name is optional.", trigger = "focus"),
                                    conditionalPanel(condition="input.In_align == 'paste'", 
                                                     textAreaInput("AlignInPaste", label = h4("Paste sRNA read count"),
                                                                   value = "", resize = "vertical", height='400px', width = '100%',
                                                                   placeholder = "The input data")
                                    ),
                                    conditionalPanel(condition="input.In_align == 'upload'", 
                                                     fileInput("AlignInFile",
                                                               label = h4("Upload sRNA read count file"), multiple = FALSE, width = "100%"),
                                                     downloadButton("Quantify_Input.txt", "Download example input data", style = "width:100%;", class = "buttDown")
                                    )
                             ),
                             
                             column(6,
                                    pickerInput(
                                      inputId = "Aligndb",
                                      label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose a LIR database to align the sRNA data</font>'),
                                                       bsButton("qAligndb", label="", icon=icon("question"), style="info", size="small")),
                                      selected = NULL, width = '100%',
                                      choices = list(
                                        Metazoa = Bowtiedb.fl$Accession[Bowtiedb.fl$Division == "Metazoa"],
                                        Plant = Bowtiedb.fl$Accession[Bowtiedb.fl$Division == "Plant"],
                                        Vertebrate = Bowtiedb.fl$Accession[Bowtiedb.fl$Division == "Vertebrate"]
                                      ),
                                      options = list(
                                        `live-search` = TRUE
                                      )
                                    ),
                                    bsPopover("qAligndb", "Choose a single database to align the sRNA data.",
                                              trigger = "focus"),
                                    
                                    br(),
                                    sliderInput("MaxAlignHit", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Max number of alignment hits of sRNA</font>'),
                                                                                bsButton("qMAH", label="", icon=icon("question"), style="info", size="small")
                                    ), value = 50, min = 1, step = 1, max = 100),
                                    bsPopover("qMAH", "Maximum number of alignments per read to report.",
                                              trigger = "focus"),
                                    
                                    br(),
                                    
                                    actionButton("submitAlign", strong("Align!",
                                                                       bsButton("qAlign", label="", icon=icon("question"), style="info", size="small")
                                    ), styleclass = "success"),
                                    actionButton("clearAlign", strong("Reset"), styleclass = "warning"),
                                    actionButton("alignExam", strong("Load example"), styleclass = "info"),
                                    conditionalPanel(condition="input.submitAlign != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
                                    conditionalPanel(condition="input.alignExam != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
                                    bsPopover("qAlign", "Click this button to start the alignment!",
                                              trigger = "focus")
                             )
                             
                             # column(4,
                             #        switchInput(
                             #          inputId = "mRNAseq",
                             #          label = "Upload mRNA sequencing data?", onLabel = "Yes",
                             #          offLabel = "No", labelWidth = "100%", size = "large"
                             #        ),
                             #        
                             #        conditionalPanel(condition = "input.mRNAseq",
                             #                         fileInput("mRNA_read_1", label = h4("mRNA sequencing read 1",
                             #                                                             bsButton("qmRNA1", label="", icon=icon("question"), style="info", size="small")),
                             #                                   multiple = FALSE),
                             #                         bsPopover("qmRNA1", "The sequence must be in fastq format.",
                             #                                   trigger = "focus"),
                             #                         fileInput("mRNA_read_2", label = h4("mRNA sequencing read 2",
                             #                                                             bsButton("qmRNA2", label="", icon=icon("question"), style="info", size="small")),
                             #                                   multiple = FALSE),
                             #                         bsPopover("qmRNA2", "The sequence must be in fastq format.",
                             #                                   trigger = "focus")
                             #        )
                             # )
                           )
                  ),
                  tabPanel("Output",
                           fixedRow(
                             column(4,
                                    downloadButton("sRNAalignSummary.txt", "Download sRNA alignment summary", style = "width:100%;", class = "buttDown")
                             ),
                             column(4,
                                    downloadButton("sRNAalignResult.txt", "Download sRNA alignment result", style = "width:100%;", class = "buttDown")
                             ),
                             column(4,
                                    downloadButton("sRNAalignLIRrc.txt", "Download sRNA read count of aligned LIRs", style = "width:100%;", class = "buttDown")
                             )
                           ),
                           
                           br(),
                           
                           fixedRow(
                             column(6,
                                    textOutput("Quantify_table_2_title"),
                                    tags$head(tags$style("#Quantify_table_2_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    dataTableOutput("LIRreadCount")
                             ),
                             
                             column(6,
                                    textOutput("Quantify_table_1_title"),
                                    tags$head(tags$style("#Quantify_table_1_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(dataTableOutput("AlignResult"))
                             )
                           ),
                           
                           br(),
                           
                           fixedRow(
                             textOutput("Quantify_plot_1_title"),
                             tags$head(tags$style("#Quantify_plot_1_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                             )),
                             
                             column(4,
                                    jqui_resizable(withSpinner(plotOutput("srna_size_align", height = "350px", width = '95%'))),
                                    jqui_resizable(withSpinner(plotOutput("srna_reads_size_align", height = "300px", width = '95%')))
                             ),
                             column(8,
                                    jqui_resizable(withSpinner(plotOutput("srna_expression", height = "700px", width = '95%')))
                             )
                           ),
                           br(),
                           
                           fixedRow(
                             column(11,
                                    textOutput("Quantify_LIR_gene_op_title"),
                                    tags$head(tags$style("#Quantify_LIR_gene_op_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    dataTableOutput("Quantify_LIR_gene_op")
                             ),
                             br(),
                             
                             column(6, 
                                    textOutput("LIR_detail_align_fasta_title"),
                                    tags$head(tags$style("#LIR_detail_align_fasta_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(verbatimTextOutput("LIR_detail_align_fasta"))
                             ),
                             column(6, 
                                    textOutput("LIR_detail_align_title"),
                                    tags$head(tags$style("#LIR_detail_align_title{color: red;
                                       font-size: 22px;
                                       font-style: bold;
                                      }"
                                    )),
                                    withSpinner(verbatimTextOutput("LIR_detail_align"))
                             )
                           )
                  )
        
      )
    ),
    
    
    # DESeq2
    tabPanel(
      "DESeq",
      icon = icon("eercast", class = NULL, lib = "font-awesome"),
      
      sidebarPanel(
        tags$div(HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Detect differentially expressed LIRs or sRNAs</b></font>'),
                 bsButton("qDESeqTitle", label="", icon=icon("question"), style="info", size="small")),
        bsPopover("qDESeqTitle", "The R package DESeq2 is used to detect differentially expressed LIRs between samples.", trigger = "focus"),
        
        selectInput("In_deseq", label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Paste or upload a count matrix?</font>'),
                                                   bsButton("qDeseqIn", label="", icon=icon("question"), style="info", size="small")
        ), choices = list("Paste input data" = "paste", 
                          "Upload input data" = "upload"), 
        selected = "paste"),
        bsPopover("qDeseqIn", "The input data must be a count matrix. Check the example data for the format of a count matrix.", trigger = "focus"),
        conditionalPanel(condition="input.In_deseq == 'paste'", 
                         textAreaInput("DeseqPaste", label = h4("Input count matrix"),
                                       value = "", resize = "vertical", height='180px', width = '100%',
                                       placeholder = "A count matrix in correct format")
        ),
        conditionalPanel(condition="input.In_deseq == 'upload'", 
                         fileInput("DeseqUpload",
                                   label = h4("Upload file"), multiple = FALSE, width = "100%"),
                         downloadButton("Count_matrix_Input.txt", "Download example count matrix", style = "width:100%;", class = "buttDown")
        ),
        
        selectInput("In_deseq_table", label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Paste or upload a sample information table?</font>'),
                                                 bsButton("qDeseqInTable", label="", icon=icon("question"), style="info", size="small")
        ), choices = list("Paste input data" = "paste", 
                          "Upload input data" = "upload"), 
        selected = "paste"),
        bsPopover("qDeseqInTable", "The sample in the count matrix and the sample in the information table must be in the same order. Check the example data for the format of a sample information table.", trigger = "focus"),
        conditionalPanel(condition="input.In_deseq_table == 'paste'", 
                         textAreaInput("DeseqTablePaste", label = h4("Input sample information table"),
                                       value = "", resize = "vertical", height='180px', width = '100%',
                                       placeholder = "A sample information table in correct format")
        ),
        conditionalPanel(condition="input.In_deseq_table == 'upload'", 
                         fileInput("DeseqTableUpload",
                                   label = h4("Upload file"), multiple = FALSE, width = "100%"),
                         downloadButton("Sample_info_table_Input.txt", "Download example sample information table", style = "width:100%;", class = "buttDown")
        ),
        
        sliderInput("MinReadcount", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Min read count required for a row of the count matrix</font>'),
                                                  bsButton("qMinReadcount", label="", icon=icon("question"), style="info", size="small")
        ), value = 10, min = 10, step = 1, max = 100),
        bsPopover("qMinReadcount", "Rows with total read count across all samples smaller than this value would be removed from the count matrix.",
                  trigger = "focus"),
        
        br(),
        actionButton("submitDeseq", strong("Submit!",
                                       bsButton("qsubmitDeseq", label="", icon=icon("question"), style="info", size="small")
        ), styleclass = "success"),
        actionButton("clearDeseq", strong("Clear"), styleclass = "warning"),
        actionButton("deseqExam", strong("Load example"), styleclass = "info"),
        conditionalPanel(condition="input.submitDeseq != '0'", busyIndicator(HTML("<p style='color:red;font-size:30px;'>Calculation In progress...</p>"), wait = 0)),
        bsPopover("qsubmitDeseq", "Click this button to start the calculation!",
                  trigger = "focus"),
        br(),br(),
        
        sliderInput("sliderFoldchange", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">X axis limits of the volcano plot</font>')), 
                    min = -10, max = 10, value = c(-2, 2)),
        sliderInput("sliderPvalue", label = tags$div(HTML('<i class="fa fa-play"></i> <font size="3" color="red">Y axis limits of the volcano plot</font>')), 
                    min = 0, max = 30, value = c(0, 10))
      ),
      
      mainPanel(
        downloadButton("DESeq2_result_table.txt", "Differentially expressed LIRs identified by DESeq2", style = "width:50%;", class = "buttDown"),
        br(),br(),
        dataTableOutput("DESeqResult"),
        br(),
        
        fluidRow(
          column(6,
                 jqui_resizable(plotOutput("MA_plot", height = "350px", width = '350px'))
          ),
          
          column(6,
                 jqui_resizable(plotOutput("volcano_plot", height = "350px", width = '350px'))
          )
        ),
        
        fixedRow(
          column(6,
                 jqui_resizable(plotOutput("sample_dist", height = "350px", width = '450px'))
          )
        )
      )
    ),
    

    # Download
    tabPanel(
      "Download",
      icon = icon("download", class = NULL, lib = "font-awesome"),

      tabsetPanel(id = "download_1",
                  tabPanel(h4("Annotated long inverted repeats of 424 genomes"),
                           shiny::dataTableOutput("downloadTable")
                  ),
                  tabPanel(h4("BLASTN database"),
                           shiny::dataTableOutput("BLASTdbdownloadTable")
                  ),
                  tabPanel(h4("Bowtie database"),
                           shiny::dataTableOutput("BowtiedbdownloadTable")
                  )
      )
    ),
    
    
    # Genomes
    tabPanel(
      "Genomes",
      icon = icon("info", class = NULL, lib = "font-awesome"),
      
      h4("Information of 424 genomes collected in this database."),
      shiny::dataTableOutput("genomeTable"), width='100%'
    ),
    

    ## Help
    navbarMenu("Help", icon = icon("book", class = NULL, lib = "font-awesome"),
               tabPanel(h5("Tutorial"),
                        includeMarkdown("Home.md")
                        ),
               tabPanel(h5("Installation"),
                        includeMarkdown("README.md")
             )
             
    )
    
  )
)

