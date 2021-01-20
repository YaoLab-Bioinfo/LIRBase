
# options(shiny.maxRequestSize = 200*1024^2)
shinyServer(function(input, output, session) {
  
  # Home
  # observe({
  #   # cb <- htmlwidgets::JS('function(){debugger;HTMLWidgets.staticRender();}')
  #   
  #   output$IRFsummary <- DT::renderDataTable(
  #     dat.spark,
  #     escape = FALSE, rownames= FALSE, selection="none",
  #     options = list(
  #       pageLength = 10, autoWidth = TRUE, bSort=FALSE
  #     )
  #   )
  # })
  
  
  # Browse
  observe({
    HTML.tab <- read.table("icon.tab.txt", head=F, as.is=T, fill=NA, sep="\t")
    colnames(HTML.tab) <- rep("", 8)
    output$HTMLtable <- DT::renderDataTable(HTML.tab,
                                            options = list(pageLength = 10, scrollX = TRUE, lengthMenu = c(5, 10, 20, 30, 50, 55), 
                                                           searchHighlight = TRUE, autoWidth = FALSE, bSort=FALSE),
                                            escape = FALSE, selection=list(mode="single", target="cell"), 
                                            rownames= FALSE
    )
    
    if(length(input$HTMLtable_cells_selected) > 0) {
      HTML.index <- input$HTMLtable_cells_selected
      HTML.index[, 2] <- HTML.index[, 2] + 1
      if(!is.na(HTML.tab[HTML.index])) {
        dat.file.path <<- gsub("\\sheight.+", "", HTML.tab[HTML.index])
        dat.file.path <- gsub(".+src=", "", dat.file.path)
        dat.file.path <- gsub("Icon", "Table", dat.file.path)
        dat.file.path <- gsub("png", "dat.gz", dat.file.path)
        dat.file.path <- paste0("www/", dat.file.path)
        
        HTML.file.path <<- dat.file.path
        dat.content <<- fread(dat.file.path, data.table = F)
        
        dat.spark$AN <- gsub(".+<I>", "", dat.spark$Accession)
        dat.spark$AN <- gsub("</I>", "", dat.spark$AN)
        dat.spark.target <- dat.spark[dat.spark$AN == gsub(".dat.gz", "", basename(dat.file.path)), ]
        dat.spark.target$AN <- NULL
        dat.spark$AN <- NULL
        
        output$LIR_info_num <- DT::renderDataTable(
          dat.spark.target,
          options = list(
            pageLength = 10, dom = 't', scrollX = TRUE, searching = FALSE, autoWidth = FALSE, bSort=FALSE
          ), escape = FALSE, rownames= FALSE, selection="none"
        )
        
        output$Length <- renderPlot({
          par(mar=c(2.9, 3.8, 2.1, 1.1))
          hist(dat.content$Left_len + dat.content$Right_len + dat.content$Loop_len, 
               main = "Total length", xlab = "", col="grey80")
        }, height = "auto", width = "auto")
        
        output$Left_len <- renderPlot({
          par(mar=c(2.1, 1.9, 2.1, 1.1))
          hist(dat.content$Left_len, main = "Left arm length", xlab = "", col="grey80")
        }, height = "auto", width = "auto")
        
        output$Right_len <- renderPlot({
          par(mar=c(2.1, 1.9, 2.1, 1.1))
          hist(dat.content$Right_len, main = "Right arm length", xlab = "", col="grey80")
        }, height = "auto", width = "auto")
        
        output$Loop_len <- renderPlot({
          par(mar=c(2.1, 1.9, 2.1, 1.1))
          hist(dat.content$Loop_len, main = "Loop length", xlab = "", col="grey80")
        }, height = "auto", width = "auto")
        
        output$Match_per <- renderPlot({
          par(mar=c(2.1, 1.9, 2.1, 1.1))
          hist(dat.content$Match_per, main = "Match percent", xlab = "", col="grey80")
        }, height = "auto", width = "auto")
        
        output$Indel_per <- renderPlot({
          par(mar=c(2.1, 1.9, 2.1, 1.1))
          hist(dat.content$Indel_per, main = "Indel percent", xlab = "", col="grey80")
        }, height = "auto", width = "auto")
        
        output$IRFbrowse_title <- renderText("List of all the LIRs identified by IRF (Click on the ID of a LIR to check its details):")
        output$IRFbrowse <- DT::renderDataTable(
          dat.content, extensions = 'Scroller',
          options = list(pageLength = 10, autoWidth = FALSE, lengthMenu = c(10, 20, 30, 50, 100), 
                         searchHighlight = TRUE, scrollX = TRUE),
          rownames= FALSE, filter = 'top', selection=list(mode="single", target="cell")
        )
        
        updateTabsetPanel(session, 'browser_1', selected = 'LIRs annotated by IRF')
      } else {
        NULL
      }
    }
    
    myProxy = DT::dataTableProxy('IRFbrowse')
    
    if (length(input$IRFbrowse_cells_selected) > 0) {
      IRF.index <- input$IRFbrowse_cells_selected
      IRF.index[, 2] <- IRF.index[, 2] + 1
      
      if (IRF.index[, 2] == 1 && !is.na(dat.content[IRF.index])) {
        HTML.file.path <- gsub("Table", "HTML", HTML.file.path)
        HTML.file.path <- gsub("dat.gz", "IRFresult.RData", HTML.file.path)
        load(HTML.file.path)
        
        LIR.gene.op.file.path <- gsub("IRFresult.RData", "LIR_gene_op.txt.gz", HTML.file.path)
        LIR.gene.op.file.path <- gsub("HTML", "LIR_gene_op", LIR.gene.op.file.path)
        
        # basic information
        output$LIR_info_title <- renderText("Information of the selected LIR:")
        output$LIR_info <- DT::renderDataTable(
          dat.content[IRF.index[, 1], ], 
          options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, dom = 't', scrollX = TRUE), 
          escape = FALSE, rownames= FALSE, selection="none"
        )
        
        # Overlap between LIRs and genes
        output$LIR_gene_op_title <- renderText("Overlaps between the selected LIR and genes:")
        output$LIR_gene_op <- DT::renderDataTable({
          if (file.exists(LIR.gene.op.file.path)) {
            LIR.gene.op <- fread(LIR.gene.op.file.path, data.table=F)
            LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% dat.content[IRF.index], ]
            LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
            LIR.gene.op
          } else {
            LIR.gene.op <- data.frame("V1"="No data available!")
            colnames(LIR.gene.op) <- ""
            LIR.gene.op
          }
        }, options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, dom = 't', scrollX = TRUE), 
          escape = FALSE, rownames= FALSE, selection="none"
        )
        
        # sequence
        fasta.file.path <- gsub("HTML", "Fasta", HTML.file.path)
        fasta.file.path <- gsub("IRFresult.RData", "LIR.fa.gz", fasta.file.path)
        fasta.content <- readBStringSet(fasta.file.path)
        LIR.seq.select <- fasta.content[dat.content[IRF.index]]
        tmp.fl <- file.path(tempdir(), "LIR.seq.select.fasta")
        writeXStringSet(LIR.seq.select, file = tmp.fl)
        LIR.seq.select <- readLines(tmp.fl)
        
        output$LIR_sequence_title <- renderText("Sequence of the selected LIR (left flanking seq in lower case - left arm seq in upper case - loop seq in lower case - right arm seq in upper case - right flanking seq in lower case):")
        output$LIR_sequence <- renderText(
          LIR.seq.select, sep = "\n"
        )
        
        # alignment of left against right arm
        LIR.align.select <- LIR.align[[dat.content[IRF.index]]]
        output$LIR_detail_title <- renderText("Alignment of the left and right arms of the selected LIR (* indicates complementary):")
        output$LIR_detail <- renderText(
          LIR.align.select, sep = "\n"
        )
        
        updateTabsetPanel(session, 'browser_1', selected = 'Details of the LIR selected')
        DT::selectCells(myProxy, NULL)
      } else {
        NULL
      }
    }
    
  })
  
	
	# Search LIR by genomic region
  chromosome <- reactive({
    req(input$chooseGenomeReg)
    filter(genome.info, ID == input$chooseGenomeReg)
  })
  
  observeEvent(chromosome(), {
    updateSelectInput(session, "chooseChromosomeReg", choices = unique(chromosome()$chr))
  })
  
  output$searchRegion <- renderUI({
    dat.genome <- chromosome()
    dat.chromosome <- dat.genome[dat.genome$chr == input$chooseChromosomeReg, ]
    
    sliderInput(inputId = "chooseRegion", 
                label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose genomic region</font>')),
                min = 1, max = dat.chromosome$size,
                value = c(1, dat.chromosome$size), width = "90%")
  })
  
  search.region.result <- eventReactive(input$submitSearchReg, {
    dat.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeReg], "/", input$chooseGenomeReg, ".dat.gz")
    dat.file <- paste0("www/Table/", dat.file)
    fasta.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeReg], "/", input$chooseGenomeReg, ".LIR.fa.gz")
    fasta.file <- paste0("www/Fasta/", fasta.file)
    HTML.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeReg], "/", input$chooseGenomeReg, ".IRFresult.RData")
    HTML.file <- paste0("www/HTML/", HTML.file)
    LIR.gene.op.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeReg], "/", input$chooseGenomeReg, ".LIR_gene_op.txt.gz")
    LIR.gene.op.file <- paste0("www/LIR_gene_op/", LIR.gene.op.file)
    
    if (file.exists(dat.file)) {
      dat.search.result <- fread(dat.file, data.table = FALSE)
      dat.search.result <- dat.search.result[dat.search.result$chr == input$chooseChromosomeReg & 
                                               dat.search.result$Left_start >= as.numeric(input$chooseRegion[1]) &
                                               dat.search.result$Right_end <= as.numeric(input$chooseRegion[2]), ]
      fasta.region <- readBStringSet(fasta.file)
      fasta.region <- fasta.region[dat.search.result$ID]
      load(HTML.file)
      result <- list(dat.search.result, fasta.region, LIR.align, LIR.gene.op.file)
    } else {
      sendSweetAlert(
        session = session,
        title = "No LIR found!", type = "error",
        text = "Please choose a genome to search against."
      )
      result <- NULL
    }
  }, ignoreNULL= T)
  
  searchedRegResults <- reactive({
    if (is.null(search.region.result())){
      
    } else {
      results <- search.region.result()
    }
  })
  
  output$LIRsearchRegResult <- DT::renderDataTable({
    if (is.null(search.region.result())) {
      
    } else {
      searchedRegResults()[[1]]
    }
  }, options = list(paging = TRUE, searching = TRUE, searchHighlight = TRUE, scrollX = TRUE, autoWidth = FALSE), 
  rownames= FALSE, filter = 'top', selection = "single")
  
  ## Download structure of LIRs in user searching result
  output$searchRegDownIRFresult.txt <- downloadHandler(
    filename <- function() { paste('LIRs_strucutre_search.txt') },
    content <- function(file) {
      write.table(searchedRegResults()[[1]], file, sep="\t", quote=F, row.names = F)
    }, contentType = 'text/plain'
  )
  
  ## Download sequence of LIRs in user searching result
  output$searchRegDownIRFfasta.txt <- downloadHandler(
    filename <- function() { paste('LIRs_sequence_search.fasta') },
    content <- function(file) {
      writeXStringSet(searchedRegResults()[[2]], file)
    }, contentType = 'text/plain'
  )
  
  ## Overlap between LIR and genes
  output$Search_reg_LIR_gene_op_title <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      "Overlaps between the selected LIR and genes:"
    }
  })
  
  output$Search_reg_LIR_gene_op <- DT::renderDataTable({
    if (is.null(search.region.result()) || is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      if (file.exists(searchedRegResults()[[4]])) {
        LIR.gene.op <- fread(searchedRegResults()[[4]], data.table=F)
        LIR.ID <- searchedRegResults()[[1]]$ID[input$LIRsearchRegResult_rows_selected]
        LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
        LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
        LIR.gene.op
      } else {
        LIR.gene.op <- data.frame("V1"="No data available!")
        colnames(LIR.gene.op) <- ""
        LIR.gene.op
      }
    }
  }, options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, dom = 't', scrollX = TRUE), 
  escape = FALSE, rownames= FALSE, selection="none")
  
  ## Display LIR sequence
  output$LIR_detail_search_reg_fasta_title <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      "Sequence of the selected LIR (left flanking seq in lower case - left arm seq in upper case - loop seq in lower case - right arm seq in upper case - right flanking seq in lower case):"
    }
  })
  
  output$LIR_detail_search_reg_fasta <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      LIR.ID <- searchedRegResults()[[1]]$ID[input$LIRsearchRegResult_rows_selected]
      tmp.fl <- file.path(tempdir(), "t1.fa")
      writeXStringSet(searchedRegResults()[[2]][LIR.ID], file = tmp.fl)
      readLines(tmp.fl)
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_search_reg_title <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      "Alignment of the left and right arms of the selected LIR (* indicates complementary):"
    }
  })
  
  output$LIR_detail_search_reg <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      LIR.ID <- searchedRegResults()[[1]]$ID[input$LIRsearchRegResult_rows_selected]
      searchedRegResults()[[3]][[LIR.ID]]
    }
  }, sep = "\n")
  

  # Search by LIR identifier
  search.ID.result <- eventReactive(input$submitSearchID, {
    if (!is.null(input$chooseGenomeID) && (length(input$chooseGenomeID)>0) && input$chooseGenomeID %in% BLASTdb.fl$Accession) {
      dat.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeID], "/", input$chooseGenomeID, ".dat.gz")
      dat.file <- paste0("www/Table/", dat.file)
      fasta.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeID], "/", input$chooseGenomeID, ".LIR.fa.gz")
      fasta.file <- paste0("www/Fasta/", fasta.file)
      HTML.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeID], "/", input$chooseGenomeID, ".IRFresult.RData")
      HTML.file <- paste0("www/HTML/", HTML.file)
      LIR.gene.op.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$chooseGenomeID], "/", input$chooseGenomeID, ".LIR_gene_op.txt.gz")
      LIR.gene.op.file <- paste0("www/LIR_gene_op/", LIR.gene.op.file)
      
      LIR.id <- unlist(strsplit(input$LIRID, split="\\n"))
      LIR.id <- gsub("^\\s+", "", LIR.id)
      LIR.id <- gsub("\\s+$", "", LIR.id)
      
      if (length(LIR.id) == 0) {
        sendSweetAlert(
          session = session,
          title = "No LIR identifier received!", type = "error",
          text = "Please input LIR identifier in proper format."
        )
        result <- NULL
      } else {
        if (file.exists(dat.file)) {
          dat.search.result <- fread(dat.file, data.table = FALSE)
          
          if (all(LIR.id %in% dat.search.result$ID)) {
            dat.search.result <- dat.search.result[dat.search.result$ID %in% LIR.id, ]
            fasta.ID <- readBStringSet(fasta.file)
            fasta.ID <- fasta.ID[LIR.id]
            load(HTML.file)
            
            result <- list(dat.search.result, fasta.ID, LIR.align, LIR.gene.op.file)
          } else {
            sendSweetAlert(
              session = session,
              title = "Wrong LIR identifier found!", type = "error",
              text = "Please check the identifier of all input LIRs!"
            )
            result <- NULL
          }
        } else {
          result <- NULL
        }
      }
    } else {
      sendSweetAlert(
        session = session,
        title = "Please choose a genome to search!", type = "error",
        text = ""
      )
      result <- NULL
    }
  }, ignoreNULL= T)
  
  searchedIDResults <- reactive({
    if (is.null(search.ID.result())){
      
    } else {
      results <- search.ID.result()
    }
  })
  
  # Update Tab Panel
  observe({
    if (input$submitSearchID >0) {
      isolate({
        if (!is.null(search.ID.result())) {
          updateTabsetPanel(session, 'search_ID', selected = 'Output')
        } else {
          NULL
        }
      })
    } else {NULL}
  })
  
  output$LIRsearchIDResult <- DT::renderDataTable({
      if (is.null(search.ID.result())) {
        search.out <- data.frame("V1"="No LIRs found!")
        colnames(search.out) <- ""
        search.out
      } else {
        searchedIDResults()[[1]]
      }
    }, options = list(paging = TRUE, searching = TRUE, searchHighlight = TRUE, scrollX = TRUE, autoWidth = FALSE), 
    rownames= FALSE, selection = "single")
  
  ## Download structure of LIRs in user searching result
  output$searchIDDownIRFresult.txt <- downloadHandler(
    filename <- function() { paste('LIRs_strucutre_search.txt') },
    content <- function(file) {
      write.table(searchedIDResults()[[1]], file, sep="\t", quote=F, row.names = F)
    }, contentType = 'text/plain'
  )
  
  ## Download sequence of LIRs in user searching result
  output$searchIDDownIRFfasta.txt <- downloadHandler(
    filename <- function() { paste('LIRs_sequence_search.fasta') },
    content <- function(file) {
      writeXStringSet(searchedIDResults()[[2]], file)
    }, contentType = 'text/plain'
  )
  
  ## Overlap between LIR and genes
  output$Search_ID_LIR_gene_op_title <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected)) {
      
    } else {
      "Overlaps between the selected LIR and genes:"
    }
  })
  
  output$Search_ID_LIR_gene_op <- DT::renderDataTable({
    if (is.null(search.ID.result()) || is.null(input$LIRsearchIDResult_rows_selected)) {
      
    } else {
      if (file.exists(searchedIDResults()[[4]])) {
        LIR.gene.op <- fread(searchedIDResults()[[4]], data.table=F)
        LIR.ID <- searchedIDResults()[[1]]$ID[input$LIRsearchIDResult_rows_selected]
        LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
        LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
        LIR.gene.op
      } else {
        LIR.gene.op <- data.frame("V1"="No data available!")
        colnames(LIR.gene.op) <- ""
        LIR.gene.op
      }
    }
  }, options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, dom = 't', scrollX = TRUE), 
  escape = FALSE, rownames= FALSE, selection="none")
  
  ## Display LIR sequence
  output$LIR_detail_search_ID_fasta_title <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      "Sequence of the selected LIR (left flanking seq in lower case - left arm seq in upper case - loop seq in lower case - right arm seq in upper case - right flanking seq in lower case):"
    }
  })
  
  output$LIR_detail_search_ID_fasta <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      LIR.ID <- searchedIDResults()[[1]]$ID[input$LIRsearchIDResult_rows_selected]
      tmp.fl <- file.path(tempdir(), "t2.fa")
      writeXStringSet(searchedIDResults()[[2]][LIR.ID], file = tmp.fl)
      readLines(tmp.fl)
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_search_ID_title <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      "Alignment of the left and right arms of the selected LIR (* indicates complementary):"
    }
  })
  
  output$LIR_detail_search_ID <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      LIR.ID <- searchedIDResults()[[1]]$ID[input$LIRsearchIDResult_rows_selected]
      searchedIDResults()[[3]][[LIR.ID]]
    }
  }, sep = "\n")
  
  observeEvent(input$clear2, {
    updatePickerInput(session, "chooseGenomeID", selected = character(0))
    updateTextInput(session, "LIRID", value="")
  })
  
  ## load example input
  observe({
    if (input$searchIDExam >0) {
      isolate({
        updatePickerInput(session, "chooseGenomeID", selected = "Drosophila_melanogaster")
        updateTextAreaInput(session, "LIRID", value = paste(c("drmm.2L:983450--984514,996778--997842",
          "drmm.2L:1776370--1781782,1795872--1801274", "drmm.2R:1523505--1525931,1527463--1529891",
                                                  "drmm.2L:6431564--6436015,6440661--6445112",
                                                  "drmm.2L:12731893--12735820,12739226--12743092",
                                                  "drmm.3R:56--7751,8029--15736",
                                                  "drmm.3R:14248--20462,20495--26665"
                                                  ), collapse = "\n"))
      })
    } else {NULL}
  })
  
  
  # BLAST
  blast.result <- eventReactive(input$submitBLAST, {
    blast.in.seq <- ""
    if (input$In_blast == "paste") {
      blast.in.seq <- input$BlastSeqPaste
      blast.in.seq <- gsub("^\\s+", "", blast.in.seq)
      blast.in.seq <- gsub("\\s+$", "", blast.in.seq)
    } else if (input$In_blast == "upload") {
      blast.in.seq <- readLines(input$BlastSeqUpload$datapath)
    }
    
    if ((length(blast.in.seq) == 1) && (blast.in.seq == "")) {
      sendSweetAlert(
        session = session,
        title = "No input data received!", type = "error",
        text = NULL
      )
    } else {
      blast.in.file <- gsub("\\s+", "-", Sys.time())
      blast.in.file <- gsub(":", "-", blast.in.file)
      blast.in.file <- paste0(blast.in.file, ".fasta")
      blast.in.file <- file.path(tempdir(), blast.in.file)
      writeLines(blast.in.seq, con = blast.in.file)
      
      blast.db <- input$BLASTdb
      blast.db <- paste0("www/LIRBase_blastdb/", blast.db)
      blast.db.fl <- paste0(blast.db, ".nhr")
      
      if (!all(file.exists(blast.db.fl))) {
        sendSweetAlert(
          session = session,
          title = "BLAST database not found!", type = "error",
          text = NULL
        )
        NULL
      } else if (length(blast.db.fl) > 10) {
        sendSweetAlert(
          session = session,
          title = "No more than 10 BLAST databases are allowed!", type = "error",
          text = NULL
        )
        NULL
      } else {
        blast.out.file <- paste0(blast.in.file, ".blast.out")
        
        blast.cmds <- paste0("blastn -query ", blast.in.file, " -db ", '"', paste(blast.db, sep=" ", collapse = " "), '"', 
                             " -evalue ", input$BLASTev, " -outfmt ", '"6 qseqid qlen sseqid slen length qstart qend sstart send mismatch gapopen pident qcovhsp evalue bitscore"', " -out ", blast.out.file)
        system(blast.cmds, ignore.stdout = TRUE, ignore.stderr = TRUE)
        
        if (file.size(blast.out.file) > 0) {
          blast.out <- read.table(blast.out.file, head=F, as.is=T)
          names(blast.out) <- c("qseqid", "qlen", "sseqid", "slen", "length", "qstart", "qend", "sstart", "send", "mismatch", "gapopen", "pident", "qcovhsp", "evalue", "bitscore")
          blast.out
        } else {
          sendSweetAlert(
            session = session,
            title = "No BLAST hits found!", type = "info",
            text = NULL
          )
          NULL
        }
      }
    }
    
  }, ignoreNULL= T)
  
  blastedResults <- reactive({
    if (is.null(blast.result())){
      
    } else {
      results <- blast.result()
    }
  })
  
  output$BLASTresult <- DT::renderDataTable({
    if (is.null(blast.result())) {
      blast.out <- data.frame("V1"="No BLAST hits found!")
      colnames(blast.out) <- ""
      blast.out
    } else {
      blastedResults()
    }
  }, escape = FALSE, rownames= FALSE, selection="single", filter = 'top',
  options = list(pageLength = 10, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE))
  
  # Update Tab Panel
  observe({
    if (input$submitBLAST >0) {
      isolate({
        if (!is.null(blast.result())) {
          updateTabsetPanel(session, 'BLAST_tab', selected = 'Output')
        } else {
          NULL
        }
      })
    } else {NULL}
  })
  
  ## find LIR details
  blastdb.result <- eventReactive(input$submitBLAST, {
    dat.file <- sapply(input$BLASTdb, function(x) {
      paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == x], "/", x, ".dat.gz")
    })
    dat.file <- paste0("www/Table/", dat.file)
    fasta.file <- sapply(input$BLASTdb, function(x) {
      paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == x], "/", x, ".LIR.fa.gz")
    })
    fasta.file <- paste0("www/Fasta/", fasta.file)
    HTML.file <- sapply(input$BLASTdb, function(x) {
      paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == x], "/", x, ".IRFresult.RData")
    })
    HTML.file <- paste0("www/HTML/", HTML.file)
    LIR.gene.op.file <- sapply(input$BLASTdb, function(x) {
      paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == x], "/", x, ".LIR_gene_op.txt.gz")
    })
    LIR.gene.op.file <- paste0("www/LIR_gene_op/", LIR.gene.op.file)
    
    dat.search.result <- lapply(dat.file, function(x) {
      if (file.exists(x)) {
        y <- fread(x, data.table = FALSE)
        return(y)
      } else {NULL}
    })
    dat.search.result <- rbindlist(dat.search.result)
    class(dat.search.result) <- "data.frame"
    
    fasta.blast <- lapply(fasta.file, function(x) {
      if (file.exists(x)) {
        y <- readBStringSet(x)
        return(y)
      } else {NULL}
    })
    fasta.blast <- do.call(c, fasta.blast)
    
    html.blast <- lapply(HTML.file, function(x) {
      if (file.exists(x)) {
        load(x)
        return(LIR.align)
      } else {NULL}
    })
    html.blast <- do.call(c, html.blast)
    
    LIR.gene.op <- lapply(LIR.gene.op.file, function(x) {
      if (file.exists(x)) {
        y <- fread(x, data.table = FALSE)
        return(y)
      } else {NULL}
    })
    LIR.gene.op <- rbindlist(LIR.gene.op)
    class(LIR.gene.op) <- "data.frame"
    
    result <- list(dat.search.result, fasta.blast, html.blast, LIR.gene.op)
  }, ignoreNULL= T)
  
  blastdbResults <- reactive({
    if (is.null(blastdb.result())){
      
    } else {
      results <- blastdb.result()
    }
  })
  
  ## Download BLAST example input
  output$BLAST_Input.txt <- downloadHandler(
    filename <- function() { paste('BLAST_example_input.txt') },
    content <- function(file) {
      writeLines(exam1.fa, con=file)
    }, contentType = 'text/plain'
  )
  
  ## Download BLAST result
  output$BLASTresult.txt <- downloadHandler(
    filename <- function() { paste('BLAST_Input.txt') },
    content <- function(file) {
      fwrite(blastedResults(), file, sep="\t", quote=F)
    }, contentType = 'text/plain'
  )
  
  output$blastDownIRFresult.txt <- downloadHandler(
    filename <- function() { paste('BLAST_result_IRF_structure.txt') },
    content <- function(file) {
      LIR.ID <- blastedResults()$sseqid
      IRF.str <- blastdbResults()[[1]]
      IRF.str <- IRF.str[IRF.str$ID %in% LIR.ID, ]
      fwrite(IRF.str, file, sep="\t", quote=F)
    }, contentType = 'text/plain'
  )
  
  output$blastDownIRFfasta.txt <- downloadHandler(
    filename <- function() { paste('BLAST_result_IRF_sequence.txt') },
    content <- function(file) {
      LIR.ID <- blastedResults()$sseqid
      writeXStringSet(blastdbResults()[[2]][LIR.ID], file)
    }, contentType = 'text/plain'
  )
  
  ## Visualization of BLAST result
  output$BLAST_plot_1_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      "Overview of the BLAST output"
    }
  })
  
  output$BLAST_plot_1 <- renderPlot({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      query.ID <- blastedResults()$qseqid[input$BLASTresult_rows_selected]
      blast.selected <- blastedResults()
      blast.selected <- blast.selected[blast.selected$qseqid == query.ID, ]
      blast.selected <- blast.selected[order(-blast.selected$bitscore), ]
      if (nrow(blast.selected) >= 30) {
        blast.selected <- blast.selected[1:30, ]
      }
      
      blast.selected$pos <- 0 - (1:nrow(blast.selected))
      p1 <- ggplot(blast.selected) + geom_segment(aes(x=1, y=0, xend=blast.selected$qlen[1], yend=0), color="black", size=1.5)
      p1 <- p1 + geom_segment(aes(x=qstart, y=pos, xend=qend, yend=pos), color="red", size=1.5)
      p1 <- p1 + theme_void()
      p1 <- p1 + ggtitle(query.ID) + theme(plot.title = element_text(size = 20, face = "bold", lineheight=0.7, hjust = 0.5))
      p1
    }
  })
  
  output$BLAST_plot_2_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      "Alignment of a specific query sequence and a LIR in the database"
    }
  })
  
  output$BLAST_plot_2 <- renderPlot({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      LIR.ID <- blastedResults()$sseqid[input$BLASTresult_rows_selected]
      blast.selected <- blastedResults()
      blast.selected <- blast.selected[blast.selected$sseqid == LIR.ID, ]
      
      fa <- blastdbResults()[[2]][LIR.ID]
      fa1 <- as.character(fa)
      x <- str_locate_all(fa1, "[ACGT]")
      y <- x[[1]][,1]
      y.ir <- IRanges(y, y)
      y.df <- as.data.frame(reduce(y.ir))
      
      p1 <- ggplot(blast.selected) + geom_segment(aes(x=sstart, y=qstart, xend=send, yend=qend), size = 1.1)
      p1 <- p1 + xlim(c(1, blast.selected$slen[1])) + ylim(c(-10, blast.selected$qlen[1]))
      p1 <- p1 + xlab(blast.selected$sseqid[1]) + ylab(blast.selected$qseqid[1])
      
      p1 <- p1 + geom_segment(aes(x=y.df$start[1], y=-10, xend=y.df$end[1], yend=-10), 
                              lineend = "round", linejoin = "round", color = "red",
                              size = 1.3, arrow = arrow(length = unit(0.3, "inches")))
      p1 <- p1 + geom_segment(aes(x=y.df$end[2], y=-10, xend=y.df$start[2], yend=-10), 
                              lineend = "round", linejoin = "round", color = "red",
                              size = 1.3, arrow = arrow(length = unit(0.3, "inches")))
      p1 <- p1 + theme_classic()
      p1 <- p1 + theme(axis.text=element_text(size=12),
                       axis.title=element_text(size=14, face="bold"))
      p1
    }
  })
  
  ## Overlap between LIR and genes
  output$Blast_LIR_gene_op_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected)) {
      
    } else {
      "Overlaps between the selected LIR and genes:"
    }
  })
  
  output$Blast_LIR_gene_op <- DT::renderDataTable({
    if ( is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      if ( nrow(blastdbResults()[[4]])>0 ) {
        LIR.gene.op <- blastdbResults()[[4]]
        LIR.ID <- blastedResults()$sseqid[input$BLASTresult_rows_selected]
        LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
        LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
        LIR.gene.op
      } else {
        LIR.gene.op <- data.frame("V1"="No data available!")
        colnames(LIR.gene.op) <- ""
        LIR.gene.op
      }
    }
  }, options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, dom = 't', scrollX = TRUE), 
  escape = FALSE, rownames= FALSE, selection="none")
  
  ## Display LIR sequence
  output$LIR_detail_blast_fasta_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      "Sequence of the selected LIR (left flanking seq in lower case - left arm seq in upper case - loop seq in lower case - right arm seq in upper case - right flanking seq in lower case):"
    }
  })
  
  output$LIR_detail_blast_fasta <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      LIR.ID <- blastedResults()$sseqid[input$BLASTresult_rows_selected]
      tmp.fl <- file.path(tempdir(), "t3.fa")
      writeXStringSet(blastdbResults()[[2]][LIR.ID], file = tmp.fl)
      readLines(tmp.fl)
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_blast_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      "Alignment of the left and right arms of the selected LIR (* indicates complementary):"
    }
  })
  
  output$LIR_detail_blast <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) ) {
      
    } else {
      LIR.ID <- blastedResults()$sseqid[input$BLASTresult_rows_selected]
      blastdbResults()[[3]][[LIR.ID]]
    }
  }, sep = "\n")
  
  ## reset
  observe({
    if (input$clear3 >0) {
      isolate({
        updateSelectInput(session, "In_blast", selected = "paste")
        updateTextAreaInput(session, "BlastSeqPaste", value="")
        updateMultiInput(session, "BLASTdb", selected = character(0))
      })
    } else {NULL}
  })
  
  ## load example
  observe({
    if (input$blastExam >0) {
      isolate({
        updateSelectInput(session, "In_blast", selected = "paste")
        updateTextAreaInput(session, "BlastSeqPaste", value = paste(exam1.fa, collapse = "\n"))
        updateMultiInput(session, "BLASTdb", selected = c("Oryza_sativa.MH63", "Oryza_sativa.Nipponbare"))
      })
    } else {NULL}
  })
  
	
	# Annotate
	observe({
	  if (input$submitP>0) {
	    isolate({
	      pre.Seq <- ""
	      if (input$In_predict == "paste") {
	        pre.Seq <- input$PreSeqPaste
	        pre.Seq <- gsub("^\\s+", "", pre.Seq)
	        pre.Seq <- gsub("\\s+$", "", pre.Seq)
	      } else if (input$In_predict == "upload") {
	        pre.Seq <- readLines(input$PreSeqUpload$datapath)
	      }
	      
	      if ((length(pre.Seq) == 1) && (pre.Seq == "")) {
	        sendSweetAlert(
	          session = session,
	          title = "No input data received!", type = "error",
	          text = NULL
	        )
	      } else if (substr(pre.Seq, 1, 1) != ">") {
	          sendSweetAlert(
	            session = session,
	            title = "'>' expected at beginning of line 1 to indicate the ID of the input sequence!", type = "error",
	            text = NULL
	          )
	      } else {
	        irf.in.file <- gsub("\\s+", "-", Sys.time())
	        irf.in.file <- gsub(":", "-", irf.in.file)
	        irf.in.file <- paste0(irf.in.file, ".fasta")
	        writeLines(pre.Seq, con=irf.in.file)
	        
	        pre.Match <- input$Match
	        pre.Mismatch <- input$Mismatch
	        pre.Delta <- input$Delta
	        pre.PM <- input$PM
	        pre.PI <- input$PI
	        pre.Minscore <- input$Minscore
	        pre.MaxLength <- input$MaxLength
	        pre.MaxLoop <- input$MaxLoop
	        pre.flankLen <- input$flankSeqLen
	        
	        irf.cmds <- paste("irf305.linux.exe", irf.in.file, pre.Match, pre.Mismatch, pre.Delta, pre.PM,
	                          pre.PI, pre.Minscore, pre.MaxLength, pre.MaxLoop, "-d -f", pre.flankLen)
	        system(irf.cmds, ignore.stdout = TRUE, ignore.stderr = TRUE)
	        
	        # The result .dat file
	        dat.file <- paste(irf.in.file, pre.Match, pre.Mismatch, pre.Delta, pre.PM,
	                          pre.PI, pre.Minscore, pre.MaxLength, pre.MaxLoop, "dat", sep=".")
	        
	        if (!file.exists(dat.file)) {
	          sendSweetAlert(
	            session = session,
	            title = "Wrong input data!", type = "error",
	            text = "Please check the content and the format of your input data!"
	          )
	        } else {
	          dat <- readLines(dat.file)
	          dat <- dat[-c(1:8)]
	          dat.seq.idx <- which(grepl("^Sequence:", dat))
	          dat.seq.idx <- c(dat.seq.idx, length(dat) + 1)
	          
	          dat.cont <- lapply(1:(length(dat.seq.idx)-1), function(i){
	            i.seq.id <- dat[dat.seq.idx[i]]
	            i.seq.id <- gsub("Sequence:\\s", "", i.seq.id)
	            i.cont <- dat[dat.seq.idx[i]:(dat.seq.idx[i+1] - 1)]
	            i.cont <- i.cont[grepl("^\\d", i.cont)]
	            if (length(i.cont)>=1) {
	              i.cont <- cbind(i.seq.id, i.cont)
	              return(i.cont)
	            } else {
	              return(NULL)
	            }
	          })
	          
	          dat.cont.df <- do.call(rbind, dat.cont)
	          
	          if (file.exists(dat.file) && !is.null(dat.cont.df) && nrow(dat.cont.df) > 0) {
	            # process the HTML file
	            html.file <- paste(irf.in.file, pre.Match, pre.Mismatch, pre.Delta, pre.PM,
	                               pre.PI, pre.Minscore, pre.MaxLength, pre.MaxLoop, "1.html", sep=".")
	            if (!file.exists(html.file)) {
	              html.file <- paste(irf.in.file, pre.Match, pre.Mismatch, pre.Delta, pre.PM,
	                                 pre.PI, pre.Minscore, pre.MaxLength, pre.MaxLoop, "summary.html", sep=".")
	            }
	            file.copy(from=list.files(pattern="*.html$"), to="www")
	            file.remove(list.files(pattern="*.html$"))
	            
	            getPage <- function() {
	              return(includeHTML(paste0("www/", html.file)))
	            }
	            output$prediction <- renderUI({getPage()})
	            
	            # process the dat file
	            write.table(dat.cont.df, file=dat.file, sep="\t", quote=F, row.names=F, col.names=F)
	            dat.cont.df <- read.table(dat.file, head=F, as.is=T)
	            dat.cont.df <- dat.cont.df[, c(1:11)]
	            names(dat.cont.df) <- c("chr", "Left_start", "Left_end", "Left_len", "Right_start", "Right_end", "Right_len",
	                                    "Loop_len", "Match_per", "Indel_per", "Score")
	            dat.cont.df.bak <- dat.cont.df
	            
	            output$downloadIRFresult <- renderUI({
	              req(dat.cont.df)
	              downloadButton("downloadIRFresult.txt", "Download structure of predicted LIRs", style = "width:100%;", class = "buttDown")
	            })
	            
	            output$downloadIRFresult.txt <- downloadHandler(
	              filename <- function() { paste('LIRs_strucutre_by_IRF.txt') },
	              content <- function(file) {
	                write.table(dat.cont.df.bak, file, sep="\t", quote=F, row.names = F)
	              }, contentType = 'text/plain'
	            )
	            
	            unlink(dat.file)
	            
	            # extract the fasta sequence
	            fa <- readDNAStringSet(irf.in.file)
	            dat.cont.df$Loop_start <- dat.cont.df$Left_end + 1
	            dat.cont.df$Loop_end <- dat.cont.df$Right_start - 1
	            
	            fa.len <- width(fa)
	            names(fa.len) <- names(fa)
	            dat.cont.df$chr_len <- fa.len[dat.cont.df$chr]
	            
	            dat.cont.df$Left_start_N <- pmax(1, dat.cont.df$Left_start - pre.flankLen)
	            dat.cont.df$Right_end_N <- pmin(dat.cont.df$chr_len, dat.cont.df$Right_end + pre.flankLen)
	            
	            dat.cont.df.LF <- subseq(fa[dat.cont.df$chr], dat.cont.df$Left_start_N, dat.cont.df$Left_start - 1)
	            dat.cont.df.RF <- subseq(fa[dat.cont.df$chr], dat.cont.df$Right_end + 1, dat.cont.df$Right_end_N)
	            dat.cont.df.LF <- tolower(dat.cont.df.LF)
	            dat.cont.df.RF <- tolower(dat.cont.df.RF)
	            dat.cont.df.L <- subseq(fa[dat.cont.df$chr], dat.cont.df$Left_start, dat.cont.df$Left_end)
	            dat.cont.df.R <- subseq(fa[dat.cont.df$chr], dat.cont.df$Right_start, dat.cont.df$Right_end)
	            dat.cont.df.Loop <- subseq(fa[dat.cont.df$chr], dat.cont.df$Loop_start, dat.cont.df$Loop_end)
	            dat.cont.df.Loop <- tolower(dat.cont.df.Loop)
	            
	            dat.cont.df.fa <- paste0(dat.cont.df.LF, dat.cont.df.L, dat.cont.df.Loop, dat.cont.df.R, dat.cont.df.RF)
	            dat.cont.df.fa <- BStringSet(dat.cont.df.fa)
	            names(dat.cont.df.fa) <- paste0(dat.cont.df$chr, ":", dat.cont.df$Left_start, "--", dat.cont.df$Left_end, ",",
	                                            dat.cont.df$Right_start, "--", dat.cont.df$Right_end)
	            
	            output$downloadIRFfasta <- renderUI({
	              req(dat.cont.df.fa)
	              downloadButton("downloadIRFfasta.txt", "Download sequence of predicted LIRs", style = "width:100%;", class = "buttDown")
	            })
	            
	            output$downloadIRFfasta.txt <- downloadHandler(
	              filename <- function() { paste('LIRs_sequence_by_IRF.txt') },
	              content <- function(file) {
	                writeXStringSet(dat.cont.df.fa, file)
	              }, contentType = 'text/plain'
	            )
	          } else {
	            # process the HTML file
	            html.file <- paste(irf.in.file, pre.Match, pre.Mismatch, pre.Delta, pre.PM,
	                               pre.PI, pre.Minscore, pre.MaxLength, pre.MaxLoop, "1.html", sep=".")
	            if (!file.exists(html.file)) {
	              html.file <- paste(irf.in.file, pre.Match, pre.Mismatch, pre.Delta, pre.PM,
	                                 pre.PI, pre.Minscore, pre.MaxLength, pre.MaxLoop, "summary.html", sep=".")
	            }
	            file.copy(from=list.files(pattern="*.html$"), to="www")
	            file.remove(list.files(pattern="*.html$"))
	            
	            getPage <- function() {
	              return(includeHTML(paste0("www/", html.file)))
	            }
	            output$prediction <- renderUI({getPage()})
	          }
	        }
	      }
	    })
	  } else {
	    NULL
	  }
	})
	
	## Download example input data
	output$Annotate_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_input_4IRF.txt') },
	  content <- function(file) {
	    writeLines(exam2.fa, con=file)
	  }, contentType = 'text/plain'
	)
	
	observe({
	  if (input$clear1>0) {
	    isolate({
	      updateSelectInput(session, "In_predict", selected = "paste")
	      updateTextAreaInput(session, "PreSeqPaste", value="")
	    })
	  } else {NULL}
	})
	
	observe({
	  if (input$predictExam >0) {
	    isolate({
	      updateSelectInput(session, "In_predict", selected = "paste")
	      updateTextAreaInput(session, "PreSeqPaste", value = paste(exam2.fa, collapse = "\n"))
	    })
	  } else {NULL}
	})
	
	
	# Align
	align.result <- eventReactive(input$submitAlign, {
	  srna.rc <- ""
	  srna.fa.name <- ""
	  if (input$In_align == "paste") {
	    srna.rc.text <- input$AlignInPaste
	    srna.rc.text <- gsub("^\\s+", "", srna.rc.text)
	    srna.rc.text <- gsub("\\s+$", "", srna.rc.text)
	    
	    if (srna.rc.text == "") {
	      sendSweetAlert(
	        session = session,
	        title = "No input data received!", type = "error",
	        text = NULL
	      )
	      NULL
	    } else {
	      srna.rc <- fread(text = srna.rc.text, data.table = FALSE, check.names = FALSE)
	      
	      srna.fa.name <- gsub("\\s+", "-", Sys.time())
	      srna.fa.name <- gsub(":", "-", srna.fa.name)
	      srna.fa.name <- paste0(srna.fa.name, ".fasta")
	    }
	  } else if (input$In_align == "upload") {
	    if (is.null(input$AlignInFile)) {
	      sendSweetAlert(
	        session = session,
	        title = "No input data received!", type = "error",
	        text = NULL
	      )
	      NULL
	    } else {
	      srna.rc <- fread(file = input$AlignInFile$datapath, data.table = FALSE, check.names = FALSE)
	      srna.fa.name <- paste0(input$AlignInFile$name, ".fasta")
	    }
	  }
	  
	  if (srna.rc == "") {
	    sendSweetAlert(
	      session = session,
	      title = "No input data received!", type = "error",
	      text = NULL
	    )
	    NULL
	  } else if (is.null(input$Aligndb)) {
	    sendSweetAlert(
	      session = session,
	      title = "Please choose a LIR database to align!", type = "error",
	      text = NULL
	    )
	    NULL
	  } else {
	    names(srna.rc) <- c("sRNA", "sRNA_read_number")
	    srna.fa <- BStringSet(srna.rc[, 1])
	    names(srna.fa) <- 1:nrow(srna.rc)
	    srna.fa.name <- file.path(tempdir(), srna.fa.name)
	    writeXStringSet(srna.fa, file=srna.fa.name)
	    
	    bowtie.db <- paste0("www/LIRBase_bowtiedb/", input$Aligndb)
	    srna.bowtie <- paste0(srna.fa.name, ".bowtie")
	    
	    bowtie.cmd <- paste0("bowtie -x ", bowtie.db, " -f ", srna.fa.name, " -v 0 -p 5 -k ", input$MaxAlignHit, " > ", srna.bowtie)
	    system(bowtie.cmd, wait = TRUE, timeout = 0)
	    
	    if (file.exists(srna.bowtie) && file.size(srna.bowtie) >0) {
	      bowtie.out <- fread(srna.bowtie, data.table=F, head=F, select=c(1, 3, 4))
	      names(bowtie.out) <- c("ID", "LIR", "Position")
	      srna.rc$ID <- 1:nrow(srna.rc)
	      bowtie.out.1 <- bowtie.out
	      bowtie.out.1$sRNA <- srna.rc$sRNA[bowtie.out.1$ID]
	      bowtie.out.1$sRNA_read_number <- srna.rc$sRNA_read_number[bowtie.out.1$ID]
	      bowtie.out.1$sRNA_size <- nchar(bowtie.out.1$sRNA)
	      bowtie.out.2 <- bowtie.out.1 %>% dplyr::group_by(LIR) %>% dplyr::distinct(sRNA, .keep_all = TRUE)
	      bowtie.out.3 <- bowtie.out.2 %>% dplyr::group_by(LIR, sRNA_size) %>% dplyr::summarise(sRNA_number = dplyr::n(), sRNA_read_number = sum(sRNA_read_number))
	      LIR.rc <- bowtie.out.3 %>% dplyr::group_by(LIR) %>% dplyr::summarise(sRNA_read_count = sum(sRNA_read_number))
	      names(LIR.rc) <- c("LIR", "sRNA_read_number")
	      LIR.rc <- LIR.rc %>% arrange(desc(sRNA_read_number))
	      
	      # sRNA length, percent
	      LIR_read_summary <- bowtie.out.3 %>% group_by(LIR) %>% summarise(sRNA_num = sum(sRNA_number), sRNA_21_22_num = sum(sRNA_number[sRNA_size %in% c(21, 22)]),
	                                                                             sRNA_24_num = sum(sRNA_number[sRNA_size ==24])
	      )
	      
	      LIR_table <- merge(LIR.rc, LIR_read_summary, by = "LIR")
	      LIR_table$sRNA_21_22_percent <- round(LIR_table$sRNA_21_22_num / LIR_table$sRNA_num * 100, 2)
	      LIR_table$sRNA_24_percent <- round(LIR_table$sRNA_24_num / LIR_table$sRNA_num * 100, 2)
	      
	      LIR_table <- LIR_table[, c("LIR", "sRNA_num", "sRNA_21_22_percent", "sRNA_24_percent", 
	                                 "sRNA_read_number")]
	      names(LIR_table)[2] <- "sRNA_number"
	      
	      # sRNA in arm, loop and flank, percent
	      fasta.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$Aligndb], "/", input$Aligndb, ".LIR.fa.gz")
	      fasta.file <- paste0("www/Fasta/", fasta.file)
	      fa <- readBStringSet(fasta.file)
	      fa <- fa[names(fa) %in% LIR_table$LIR]
	      fa.len <- width(fa)
	      names(fa.len) <- names(fa)
	      
	      fa.L <- str_locate_all(as.character(fa), "[ACGT]+")
	      fa.L.nrow <- sapply(fa.L, nrow)
	      fa.arm <- do.call(rbind, fa.L)
	      fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
	      fa.arm$LIR <- rep(names(fa), fa.L.nrow)
	      fa.arm$length <- fa.len[fa.arm$LIR]
	      fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
	      names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
	      
	      fa.flank <- fa.arm %>% group_by(LIR) %>% summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
	      
	      fa.loop <- fa.arm %>% group_by(LIR) %>% summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
	      fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
	      
	      d2.gr <- GRanges(bowtie.out.2$LIR, IRanges(bowtie.out.2$Position, bowtie.out.2$Position))
	      
	      fa.arm.gr <- GRanges(fa.arm$LIR, IRanges(fa.arm$arm_start, fa.arm$arm_end))
	      fa.arm.cnt <- fa.arm
	      fa.arm.cnt$sRNA_in_arm <- countOverlaps(fa.arm.gr, d2.gr)
	      fa.arm.cnt <- fa.arm.cnt %>% group_by(LIR) %>% summarise(sRNA_in_arm = sum(sRNA_in_arm))
	      
	      fa.loop.gr <- GRanges(fa.loop$LIR, IRanges(fa.loop$loop_start, fa.loop$loop_end))
	      fa.loop.cnt <- fa.loop
	      fa.loop.cnt$sRNA_in_loop <- countOverlaps(fa.loop.gr, d2.gr)
	      fa.loop.cnt <- fa.loop.cnt %>% group_by(LIR) %>% summarise(sRNA_in_loop = sum(sRNA_in_loop))
	      
	      fa.flank.gr <- GRanges(fa.flank$LIR, IRanges(fa.flank$flank_start, fa.flank$flank_end))
	      fa.flank.cnt <- fa.flank
	      fa.flank.cnt$sRNA_in_flank <- countOverlaps(fa.flank.gr, d2.gr)
	      fa.flank.cnt <- fa.flank.cnt %>% group_by(LIR) %>% summarise(sRNA_in_flank = sum(sRNA_in_flank))
	      
	      fa.whole.cnt <- Reduce(function(...)merge(..., by="LIR", all=T), list(fa.arm.cnt, fa.loop.cnt, fa.flank.cnt))
	      
	      fa.whole.cnt$sRNA_in_arm[is.na(fa.whole.cnt$sRNA_in_arm)] <- 0
	      fa.whole.cnt$sRNA_in_loop[is.na(fa.whole.cnt$sRNA_in_loop)] <- 0
	      fa.whole.cnt$sRNA_in_flank[is.na(fa.whole.cnt$sRNA_in_flank)] <- 0
	      
	      fa.whole.cnt$sRNA_in_arm_percent <- round(fa.whole.cnt$sRNA_in_arm / (fa.whole.cnt$sRNA_in_arm + fa.whole.cnt$sRNA_in_loop + fa.whole.cnt$sRNA_in_flank) * 100, 2)
	      fa.whole.cnt$sRNA_in_loop_percent <- round(fa.whole.cnt$sRNA_in_loop / (fa.whole.cnt$sRNA_in_arm + fa.whole.cnt$sRNA_in_loop + fa.whole.cnt$sRNA_in_flank) * 100, 2)
	      fa.whole.cnt$sRNA_in_flank_percent <- round(fa.whole.cnt$sRNA_in_flank / (fa.whole.cnt$sRNA_in_arm + fa.whole.cnt$sRNA_in_loop + fa.whole.cnt$sRNA_in_flank) * 100, 2)
	      
	      LIR_table <- merge(LIR_table, fa.whole.cnt, by = "LIR")
	      LIR_table <- LIR_table[, c("LIR", "sRNA_number", "sRNA_21_22_percent", "sRNA_24_percent",
	                                 "sRNA_in_arm_percent", "sRNA_in_loop_percent", "sRNA_in_flank_percent",
	                                 "sRNA_read_number"
	      )]
	      LIR_table <- LIR_table[order(-LIR_table$sRNA_read_number), ]
	      
	      result <- list(bowtie.out.1, bowtie.out.3, sum(srna.rc$sRNA_read_number), LIR_table)
	    } else {
	      sendSweetAlert(
	        session = session,
	        title = "No alignment detected!", type = "error",
	        text = "Please check the input sRNA read count data and the LIR database!"
	      )
	      NULL
	    }
	  }
	})
	
	alignedResults <- reactive({
	  if (is.null(align.result())){
	    
	  } else {
	    result <- align.result()
	  }
	})
	
	output$LIRreadCount <- DT::renderDataTable({
	  if (is.null(align.result())) {
	    NULL
	  } else {
	    alignedResults()[[4]]
	  }
	}, escape = FALSE, rownames= FALSE, selection="single", filter = 'top',
	options = list(pageLength = 10, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE)
	)
	
	# output$Quantify_table_1_title <- renderText({
	#   if (is.null(align.result())) {
	#     
	#   } else {
	#     "Summary of sRNAs aligned to each LIR:"
	#   }
	# })
	# 
	# output$AlignResult <- DT::renderDataTable({
	#   if (is.null(align.result())) {
	#     NULL
	#   } else {
	#     if (!is.null(input$LIRreadCount_rows_selected)) {
	#       align.srna.size <- alignedResults()[[2]]
	#       LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	#       align.srna.size <- align.srna.size[align.srna.size$LIR %in% LIR.ID, ]
	#       align.srna.size
	#     } else {
	#       alignedResults()[[2]]
	#     }
	#   }
	# }, escape = FALSE, rownames= FALSE, selection="none",
	#   options = list(pageLength = 10, autoWidth = FALSE, bSort=FALSE, scrollX=TRUE)
	# )
	
	# Update Tab Panel
	observe({
	  if (input$submitAlign >0) {
	    isolate({
	      if (!is.null(align.result())) {
	        updateTabsetPanel(session, 'Quantify_tab', selected = 'Output')
	      } else {
	        NULL
	      }
	    })
	  } else {NULL}
	})
	
	## Download example input data
	output$Quantify_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_sRNA_read_count_input.txt') },
	  content <- function(file) {
	    dat <- fread("quantify.exam.sRNA.read.count.txt", data.table = F)
	    fwrite(dat, file = file, sep="\t")
	  }, contentType = 'text/plain'
	)
	
	## Download sRNA alignment result
	output$sRNAalignSummary.txt <- downloadHandler(
	  filename <- function() { paste('sRNA_alignment_summary.txt') },
	  content <- function(file) {
	    fwrite(alignedResults()[[2]], file, sep="\t", quote=F)
	  }, contentType = 'text/plain'
	)
	
	output$sRNAalignResult.txt <- downloadHandler(
	  filename <- function() { paste('sRNA_alignment_detail.txt.gz') },
	  content <- function(file) {
	    sRNA.align.detail <- alignedResults()[[1]]
	    sRNA.align.detail <- sRNA.align.detail[, -1]
	    sRNA.align.detail <- sRNA.align.detail[order(sRNA.align.detail$LIR, sRNA.align.detail$Position), ]
	    fwrite(sRNA.align.detail, file, sep="\t", quote=F, compress = "gzip")
	  }, contentType = 'application/gzip'
	)
	
	output$sRNAalignLIRrc.txt <- downloadHandler(
	  filename <- function() { paste('LIR_sRNA_read_count.txt') },
	  content <- function(file) {
	    fwrite(alignedResults()[[4]], file, sep="\t", quote=F)
	  }, contentType = 'text/plain'
	)
	
	## find LIR details
	align.LIR.result <- eventReactive(input$submitAlign, {
	  dat.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$Aligndb], "/", input$Aligndb, ".dat.gz")
	  dat.file <- paste0("www/Table/", dat.file)
	  fasta.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$Aligndb], "/", input$Aligndb, ".LIR.fa.gz")
	  fasta.file <- paste0("www/Fasta/", fasta.file)
	  HTML.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$Aligndb], "/", input$Aligndb, ".IRFresult.RData")
	  HTML.file <- paste0("www/HTML/", HTML.file)
	  LIR.gene.op.file <- paste0(BLASTdb.fl$Division[BLASTdb.fl$Accession == input$Aligndb], "/", input$Aligndb, ".LIR_gene_op.txt.gz")
	  LIR.gene.op.file <- paste0("www/LIR_gene_op/", LIR.gene.op.file)
	  
	  if (file.exists(dat.file)) {
	    dat.search.result <- fread(dat.file, data.table = FALSE)
	    fasta.align <- readBStringSet(fasta.file)
	    load(HTML.file)
	    result <- list(dat.search.result, fasta.align, LIR.align, LIR.gene.op.file)
	  } else {
	    result <- NULL
	  }
	}, ignoreNULL= T)
	
	alignedLIRResults <- reactive({
	  if (is.null(align.LIR.result())){
	    
	  } else {
	    results <- align.LIR.result()
	  }
	})
	
	## Distribution of sRNAs of varying length
	output$Quantify_plot_1_title <- renderText({
	  if (is.null(align.result()) || is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    "Lengths and expression levels of all sRNAs aligned to the selected LIR:"
	  }
	})
	
	output$srna_size_align <- renderPlot({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    align.selected <- alignedResults()[[2]]
	    align.selected <- align.selected[align.selected$LIR == LIR.ID, ]
	    my_bar <- barplot(align.selected$sRNA_number, names.arg = align.selected$sRNA_size, ylab = "Number of sRNA",
	            xlab = "sRNA size (nt)", cex.lab = input$srnasize_axis_label_size, cex.names = input$srnasize_bar_name_size, cex.axis = input$srnasize_axis_tick_size,
	            ylim = c(0, max(align.selected$sRNA_number) * 1.15))
	    my_perc <- round(align.selected$sRNA_number / sum(align.selected$sRNA_number) * 100, 1)
	    my_perc <- paste0(my_perc, "%")
	    text(my_bar, align.selected$sRNA_number + max(align.selected$sRNA_number)/15, my_perc, cex=1)
	  }
	})
	
	output$srnasize_plot.pdf <- downloadHandler(
	  filename <- function() {
	    paste('sRNA_size_barplot.pdf')
	  },
	  content <- function(file) {
	    pdf(file, width = input$srnasize_plot_width / 72, height = input$srnasize_plot_height / 72)
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    align.selected <- alignedResults()[[2]]
	    align.selected <- align.selected[align.selected$LIR == LIR.ID, ]
	    my_bar <- barplot(align.selected$sRNA_number, names.arg = align.selected$sRNA_size, ylab = "Number of sRNA",
	                      xlab = "sRNA size (nt)", cex.lab = input$srnasize_axis_label_size, cex.names = input$srnasize_bar_name_size, cex.axis = input$srnasize_axis_tick_size,
	                      ylim = c(0, max(align.selected$sRNA_number) * 1.15))
	    my_perc <- round(align.selected$sRNA_number / sum(align.selected$sRNA_number) * 100, 1)
	    my_perc <- paste0(my_perc, "%")
	    text(my_bar, align.selected$sRNA_number + max(align.selected$sRNA_number)/15, my_perc, cex=1)
	    dev.off()
	  }, contentType = 'application/pdf')
	
	output$srna_reads_size_align <- renderPlot({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    align.selected <- alignedResults()[[2]]
	    align.selected <- align.selected[align.selected$LIR == LIR.ID, ]
	    my_bar <- barplot(align.selected$sRNA_read_number, names.arg = align.selected$sRNA_size, ylab = "Number of sRNA read",
	            xlab = "sRNA size (nt)", cex.lab = input$readsize_axis_label_size, cex.names = input$readsize_bar_name_size, cex.axis = input$readsize_axis_tick_size,
	            ylim = c(0, max(align.selected$sRNA_read_number) * 1.15))
	    my_perc <- round(align.selected$sRNA_read_number / sum(align.selected$sRNA_read_number) * 100, 1)
	    my_perc <- paste0(my_perc, "%")
	    text(my_bar, align.selected$sRNA_read_number + max(align.selected$sRNA_read_number)/15, my_perc, cex=1)
	  }
	})
	
	output$readsize_plot.pdf <- downloadHandler(
	  filename <- function() {
	    paste('sRNA_read_size_barplot.pdf')
	  },
	  content <- function(file) {
	    pdf(file, width = input$readsize_plot_width / 72, height = input$readsize_plot_height / 72)
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    align.selected <- alignedResults()[[2]]
	    align.selected <- align.selected[align.selected$LIR == LIR.ID, ]
	    my_bar <- barplot(align.selected$sRNA_read_number, names.arg = align.selected$sRNA_size, ylab = "Number of sRNA read",
	                      xlab = "sRNA size (nt)", cex.lab = input$readsize_axis_label_size, cex.names = input$readsize_bar_name_size, cex.axis = input$readsize_axis_tick_size,
	                      ylim = c(0, max(align.selected$sRNA_read_number) * 1.15))
	    my_perc <- round(align.selected$sRNA_read_number / sum(align.selected$sRNA_read_number) * 100, 1)
	    my_perc <- paste0(my_perc, "%")
	    text(my_bar, align.selected$sRNA_read_number + max(align.selected$sRNA_read_number)/15, my_perc, cex=1)
	    dev.off()
	  }, contentType = 'application/pdf')
	
	output$srna_expression <- renderPlot({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    align.selected <- alignedResults()[[1]]
	    lib.read.count <- alignedResults()[[3]]
	    
	    align.LIR <- align.selected[align.selected$LIR == LIR.ID, ]
	    
	    fa <- alignedLIRResults()[[2]][LIR.ID]
	    fa.c <- as.character(fa)
	    fa.len <- width(fa)
	    x <- str_locate_all(fa.c, "[ACGT]")
	    y <- x[[1]][,1]
	    y.ir <- IRanges(y, y)
	    y.df <- as.data.frame(reduce(y.ir))
	    
	    LIR.start.pos <- gsub(".+:", "", align.LIR$LIR[1])
	    LIR.start.pos <- as.integer(gsub("--.+", "", LIR.start.pos))
	    LIT.start.pos.in <- y.df$start[1]
	    LIR.ID.chr <- gsub(":.+", "", LIR.ID)
	    LIR.ID.chr <- substr(LIR.ID.chr, 6, 100)
	    
	    y.df$start <- y.df$start + LIR.start.pos - LIT.start.pos.in
	    y.df$end <- y.df$end + LIR.start.pos - LIT.start.pos.in
	    
	    LIR.ir <- IRanges(y.df$start[1], y.df$end[2])
	    
	    dat <- alignedLIRResults()[[1]]
	    dat <- dat[dat$ID != LIR.ID & dat$chr == LIR.ID.chr, ]
	    dat.ir <- IRanges(dat$Left_start, dat$Right_end)
	    dat.op <- dat[unique(subjectHits(findOverlaps(LIR.ir, dat.ir))), ]
	    
	    if (input$select_LIR_only || nrow(dat.op) == 0) {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      
	      p1 <- ggplot(align.LIR) + geom_point(aes(x=Position, y=TPM, color = factor(sRNA_size)), size = input$srnaexp_point_size)
	      p1 <- p1 + geom_segment(aes(x=y.df$start[1], y=-1, xend=y.df$end[1], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[2], y=-1, xend=y.df$start[2], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[1]+1, y=-1, xend=y.df$start[2]-1, yend=-1), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + ylab("Expression level of sRNAs (TPM)") + xlab("Position")
	      p1 <- p1 + theme_classic()
	      p1 <- p1 + theme(axis.text=element_text(size=input$srnaexp_axis_tick_size),
	                       axis.title=element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                       legend.title=element_text(size=input$srnaexp_legend_title_size), 
	                       legend.text=element_text(size=input$srnaexp_legend_text_size)
	      )
	      p1
	    } else {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      
	      dat.op$yval <- -1 * (1:nrow(dat.op)) * max(align.LIR$TPM)/100
	      
	      p1 <- ggplot(align.LIR) + geom_point(aes(x=Position, y=TPM, color = factor(sRNA_size)),  size = input$srnaexp_point_size)
	      p1 <- p1 + geom_segment(aes(x=y.df$start[1], y=-1, xend=y.df$end[1], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[2], y=-1, xend=y.df$start[2], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[1]+1, y=-1, xend=y.df$start[2]-1, yend=-1), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + geom_segment(data=dat.op, aes(x=Left_start, y=yval, xend=Left_end, yend=yval), 
	                              lineend = "round", linejoin = "round", color = "blue",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(data=dat.op, aes(x=Right_end, y=yval, xend=Right_start, yend=yval), 
	                              lineend = "round", linejoin = "round", color = "blue",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(data=dat.op, aes(x=Left_end+1, y=yval, xend=Right_start-1, yend=yval), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + scale_y_continuous(breaks = round(seq(0, max(align.LIR$TPM)*1.1, length.out = 5)))
	      p1 <- p1 + ylab("Expression level of sRNAs (TPM)") + xlab("Position")
	      p1 <- p1 + theme_classic()
	      p1 <- p1 + theme(axis.text=element_text(size=input$srnaexp_axis_tick_size),
	                       axis.title=element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                       legend.title=element_text(size=input$srnaexp_legend_title_size), 
	                       legend.text=element_text(size=input$srnaexp_legend_text_size)
	      )
	      p1
	    }
	  }
	})
	
	output$srnaexp_plot.pdf <- downloadHandler(
	  filename <- function() {
	    paste('sRNA_expression_plot.pdf')
	  },
	  content <- function(file) {
	    pdf(file, width = input$srnaexp_plot_width / 72, height = input$srnaexp_plot_height / 72)
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    align.selected <- alignedResults()[[1]]
	    lib.read.count <- alignedResults()[[3]]
	    
	    align.LIR <- align.selected[align.selected$LIR == LIR.ID, ]
	    
	    fa <- alignedLIRResults()[[2]][LIR.ID]
	    fa.c <- as.character(fa)
	    fa.len <- width(fa)
	    x <- str_locate_all(fa.c, "[ACGT]")
	    y <- x[[1]][,1]
	    y.ir <- IRanges(y, y)
	    y.df <- as.data.frame(reduce(y.ir))
	    
	    LIR.start.pos <- gsub(".+:", "", align.LIR$LIR[1])
	    LIR.start.pos <- as.integer(gsub("--.+", "", LIR.start.pos))
	    LIT.start.pos.in <- y.df$start[1]
	    LIR.ID.chr <- gsub(":.+", "", LIR.ID)
	    LIR.ID.chr <- substr(LIR.ID.chr, 6, 100)
	    
	    y.df$start <- y.df$start + LIR.start.pos - LIT.start.pos.in
	    y.df$end <- y.df$end + LIR.start.pos - LIT.start.pos.in
	    
	    LIR.ir <- IRanges(y.df$start[1], y.df$end[2])
	    
	    dat <- alignedLIRResults()[[1]]
	    dat <- dat[dat$ID != LIR.ID & dat$chr == LIR.ID.chr, ]
	    dat.ir <- IRanges(dat$Left_start, dat$Right_end)
	    dat.op <- dat[unique(subjectHits(findOverlaps(LIR.ir, dat.ir))), ]
	    
	    if (input$select_LIR_only || nrow(dat.op) == 0) {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      
	      p1 <- ggplot(align.LIR) + geom_point(aes(x=Position, y=TPM, color = factor(sRNA_size)), size = input$srnaexp_point_size)
	      p1 <- p1 + geom_segment(aes(x=y.df$start[1], y=-1, xend=y.df$end[1], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[2], y=-1, xend=y.df$start[2], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[1]+1, y=-1, xend=y.df$start[2]-1, yend=-1), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + ylab("Expression level of sRNAs (TPM)") + xlab("Position")
	      p1 <- p1 + theme_classic()
	      p1 <- p1 + theme(axis.text=element_text(size=input$srnaexp_axis_tick_size),
	                       axis.title=element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                       legend.title=element_text(size=input$srnaexp_legend_title_size), 
	                       legend.text=element_text(size=input$srnaexp_legend_text_size)
	      )
	    } else {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      
	      dat.op$yval <- -1 * (1:nrow(dat.op)) * max(align.LIR$TPM)/100
	      
	      p1 <- ggplot(align.LIR) + geom_point(aes(x=Position, y=TPM, color = factor(sRNA_size)),  size = input$srnaexp_point_size)
	      p1 <- p1 + geom_segment(aes(x=y.df$start[1], y=-1, xend=y.df$end[1], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[2], y=-1, xend=y.df$start[2], yend=-1), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(aes(x=y.df$end[1]+1, y=-1, xend=y.df$start[2]-1, yend=-1), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + geom_segment(data=dat.op, aes(x=Left_start, y=yval, xend=Left_end, yend=yval), 
	                              lineend = "round", linejoin = "round", color = "blue",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(data=dat.op, aes(x=Right_end, y=yval, xend=Right_start, yend=yval), 
	                              lineend = "round", linejoin = "round", color = "blue",
	                              size = 1.1, arrow = arrow(length = unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + geom_segment(data=dat.op, aes(x=Left_end+1, y=yval, xend=Right_start-1, yend=yval), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + scale_y_continuous(breaks = round(seq(0, max(align.LIR$TPM)*1.1, length.out = 5)))
	      p1 <- p1 + ylab("Expression level of sRNAs (TPM)") + xlab("Position")
	      p1 <- p1 + theme_classic()
	      p1 <- p1 + theme(axis.text=element_text(size=input$srnaexp_axis_tick_size),
	                       axis.title=element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                       legend.title=element_text(size=input$srnaexp_legend_title_size), 
	                       legend.text=element_text(size=input$srnaexp_legend_text_size)
	      )
	    }
	    grid.draw(p1)
	    dev.off()
	  }, contentType = 'application/pdf')
	
	## Overlap between LIR and genes
	output$Quantify_LIR_gene_op_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    "Overlaps between the selected LIR and genes:"
	  }
	})
	
	output$Quantify_LIR_gene_op <- DT::renderDataTable({
	  if ( is.null(input$LIRreadCount_rows_selected) ) {
	    
	  } else {
	    if ( file.exists(alignedLIRResults()[[4]]) ) {
	      LIR.gene.op <- fread(alignedLIRResults()[[4]], data.table = F)
	      LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	      LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
	      LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
	      LIR.gene.op
	    } else {
	      LIR.gene.op <- data.frame("V1"="No data available!")
	      colnames(LIR.gene.op) <- ""
	      LIR.gene.op
	    }
	  }
	}, options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, dom = 't', scrollX = TRUE),
	escape = FALSE, rownames= FALSE, selection="none")
	
	## Display LIR sequence
	output$LIR_detail_align_fasta_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    "Sequence of the selected LIR (left flanking seq in lower case - left arm seq in upper case - loop seq in lower case - right arm seq in upper case - right flanking seq in lower case):"
	  }
	})
	
	output$LIR_detail_align_fasta <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    tmp.fl <- file.path(tempdir(), "t4.fa")
	    writeXStringSet(alignedLIRResults()[[2]][LIR.ID], file = tmp.fl)
	    readLines(tmp.fl)
	  }
	}, sep = "\n")
	
	## Display LIR alignment
	output$LIR_detail_align_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    "Alignment of the left and right arms of the selected LIR (* indicates complementary):"
	  }
	})
	
	output$LIR_detail_align <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    alignedLIRResults()[[3]][[LIR.ID]]
	  }
	}, sep = "\n")
	
	observe({
	  if (input$clearAlign>0) {
	    isolate({
	      updateSelectInput(session, "In_align", selected = "paste")
	      updateTextInput(session, "AlignInPaste", value="")
	      updatePickerInput(session, "Aligndb", selected = character(0))
	    })
	  } else {NULL}
	})
	
	observe({
	  if (input$alignExam >0) {
	    isolate({
	      updateSelectInput(session, "In_align", selected = "paste")
	      updateTextAreaInput(session, "AlignInPaste", value = paste(readLines("quantify.exam.sRNA.read.count.txt"), collapse = "\n"))
	      updatePickerInput(session, "Aligndb", selected = "Oryza_sativa.MH63")
	    })
	  } else {NULL}
	})
	
	
	# DEseq2
	observe({
	  if (input$submitDeseq>0) {
	    isolate({
	      count.matrix <- ""
	      if (input$In_deseq == "paste") {
	        count.matrix.text <- input$DeseqPaste
	        count.matrix.text <- gsub("^\\s+", "", count.matrix.text)
	        count.matrix.text <- gsub("\\s+$", "", count.matrix.text)
	        count.matrix <- fread(text=count.matrix.text, data.table=F)
	      } else if (input$In_deseq == "upload") {
	        count.matrix <- fread(input$DeseqUpload$datapath, data.table=F)
	      }
	      
	      rownames(count.matrix) <- count.matrix$LIR
	      count.matrix$LIR <- NULL
	      count.matrix <- as.matrix(count.matrix)
	      
	      sample.info <- ""
	      if (input$In_deseq_table == "paste") {
	        sample.info.text <- input$DeseqTablePaste
	        sample.info.text <- gsub("^\\s+", "", sample.info.text)
	        sample.info.text <- gsub("\\s+$", "", sample.info.text)
	        sample.info <- fread(text=sample.info.text, data.table=F)
	      } else if (input$In_deseq_table == "upload") {
	        sample.info <- fread(input$DeseqTableUpload$datapath, data.table=F)
	      }
	      
	      rownames(sample.info) <- sample.info$sample
	      sample.info$sample <- NULL
	      sample.info$condition <- factor(sample.info$condition)
	      sample.info$type <- factor(sample.info$type)

	      DESeq2.data <- DESeqDataSetFromMatrix(countData = count.matrix,
	                                    colData = sample.info,
	                                    design = ~ condition)
	      
	      keep <- rowSums(counts(DESeq2.data)) >= input$MinReadcount
	      DESeq2.data <- DESeq2.data[keep, ]
	      
	      DESeq2.res <- DESeq(DESeq2.data)
	      DESeq2.res.LFC <- lfcShrink(DESeq2.res, coef=resultsNames(DESeq2.res)[2], type="apeglm")
	      DESeq2.res.vsd <- vst(DESeq2.res, blind=FALSE)
	      DESeq2.res.table <- results(DESeq2.res)
	      
	      DESeq2.res.table.dt <- data.frame(DESeq2.res.table, stringsAsFactors = FALSE)
	      DESeq2.res.table.dt$LIR <- rownames(DESeq2.res.table.dt)
	      DESeq2.res.table.dt <- DESeq2.res.table.dt[, c(7, 1:6)]
	      DESeq2.res.table.dt <- DESeq2.res.table.dt[order(DESeq2.res.table.dt$padj), ]
	      
	      output$DESeqResult <- DT::renderDataTable({
	        if (nrow(DESeq2.res.table) == 0) {
	          NULL
	        } else {
	          DESeq2.res.table.dt
	        }
	      }, escape = FALSE, rownames= FALSE, selection="none",
	         options = list(pageLength = 5, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE)
	      )
	      
	      output$DESeq2_result_table.txt <- downloadHandler(
	        filename <- function() { paste('DESeq2_result.txt') },
	        content <- function(file) {
	          if (nrow(DESeq2.res.table) == 0) {
	            NULL
	          } else {
	            fwrite(DESeq2.res.table.dt, file, sep="\t", quote=F)
	          }
	        }, contentType = 'text/plain'
	      )
	      
	      # MA plot
	      output$MA_plot <- renderPlot({
	        plotMA(DESeq2.res.LFC, ylim = c(input$MA_Y_axis[1], input$MA_Y_axis[2]), main = "MA-plot", cex = input$MA_point_size)
	      })
	      
	      output$MA_plot.pdf <- downloadHandler(
	        filename <- function() {
	          paste('MA_plot.pdf')
	        },
	        content <- function(file) {
	          pdf(file, width = input$MA_plot_width / 72, height = input$MA_plot_height / 72)
	          plotMA(DESeq2.res.LFC, ylim = c(input$MA_Y_axis[1], input$MA_Y_axis[2]), main = "MA-plot", cex = input$MA_point_size)
	          dev.off()
	        }, contentType = 'application/pdf')
	      
	      # Sample distance plot
	      output$sample_dist <- renderPlot({
	        sampleDists <- dist(t(assay(DESeq2.res.vsd)))
	        
	        sampleDistMatrix <- as.matrix(sampleDists)
	        rownames(sampleDistMatrix) <- paste(DESeq2.res.vsd$condition, DESeq2.res.vsd$type, sep="-")
	        colnames(sampleDistMatrix) <- NULL
	        colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
	        pheatmap(sampleDistMatrix,
	                 clustering_distance_rows = sampleDists,
	                 clustering_distance_cols = sampleDists,
	                 col = colors, main = "Sample-to-sample distances")
	      })
	      
	      output$sample_dist_plot.pdf <- downloadHandler(
	        filename <- function() {
	          paste('sample_dist_plot.pdf')
	        },
	        content <- function(file) {
	          pdf(file, width = input$dist_plot_width / 72, height = input$dist_plot_height / 72)
	          sampleDists <- dist(t(assay(DESeq2.res.vsd)))
	          
	          sampleDistMatrix <- as.matrix(sampleDists)
	          rownames(sampleDistMatrix) <- paste(DESeq2.res.vsd$condition, DESeq2.res.vsd$type, sep="-")
	          colnames(sampleDistMatrix) <- NULL
	          colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
	          pheatmap(sampleDistMatrix,
	                   clustering_distance_rows = sampleDists,
	                   clustering_distance_cols = sampleDists,
	                   col = colors, main = "Sample-to-sample distances")
	          dev.off()
	        }, contentType = 'application/pdf')
	      
	      # volcano plot
	      DESeq2.res.table.dt.vp <- DESeq2.res.table.dt
	      DESeq2.res.table.dt.vp$col <- "black"
	      DESeq2.res.table.dt.vp$col[DESeq2.res.table.dt.vp$padj <= 0.05] <- "red"
	      output$volcano_plot <- renderPlot({
	        plot(x=DESeq2.res.table.dt.vp$log2FoldChange, y= -log10(DESeq2.res.table.dt.vp$padj),
	             xlab = "log2 of fold change", ylab = "-log10 of adjusted P value", col = DESeq2.res.table.dt.vp$col, pch=21,
	             xlim = c(input$sliderFoldchange[1], input$sliderFoldchange[2]), ylim = c(input$sliderPvalue[1], input$sliderPvalue[2]),
	             main = "Visualization of DESeq2 result\n with volcano plot", cex = input$volcano_point_size,
	             cex.axis = input$volcano_axis_tick_size, cex.lab = input$volcano_axis_label_size)
	      })
	      
	      output$volcano_plot.pdf <- downloadHandler(
	        filename <- function() {
	          paste('volcano_plot.pdf')
	        },
	        content <- function(file) {
	          pdf(file, width = input$volcano_plot_width / 72, height = input$volcano_plot_height / 72)
	          plot(x=DESeq2.res.table.dt.vp$log2FoldChange, y= -log10(DESeq2.res.table.dt.vp$padj),
	               xlab = "log2 of fold change", ylab = "-log10 of adjusted P value", col = DESeq2.res.table.dt.vp$col, pch=21,
	               xlim = c(input$sliderFoldchange[1], input$sliderFoldchange[2]), ylim = c(input$sliderPvalue[1], input$sliderPvalue[2]),
	               main = "Visualization of DESeq2 result\n with volcano plot", cex = input$volcano_point_size,
	               cex.axis = input$volcano_axis_tick_size, cex.lab = input$volcano_axis_label_size)
	          dev.off()
	        }, contentType = 'application/pdf')
	      
	    })
	  }
	})
	
	## Download example input data
	output$Count_matrix_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_count_matrix.txt') },
	  content <- function(file) {
	    dat <- fread("LIR_sRNA_read_count_matrix.txt", data.table = F)
	    fwrite(dat, file = file, sep="\t")
	  }, contentType = 'text/plain'
	)
	
	output$Sample_info_table_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_sample_information_table.txt') },
	  content <- function(file) {
	    dat <- fread("LIR_sRNA_sample_info.txt", data.table = F)
	    fwrite(dat, file = file, sep="\t")
	  }, contentType = 'text/plain'
	)
	
	observe({
	  if (input$clearDeseq>0) {
	    isolate({
	      updateSelectInput(session, "In_deseq", selected = "paste")
	      updateSelectInput(session, "In_deseq_table", selected = "paste")
	      updateTextInput(session, "DeseqPaste", value="")
	      updateTextInput(session, "DeseqTablePaste", value="")
	    })
	  } else {NULL}
	})
	
	observe({
	  if (input$deseqExam >0) {
	    isolate({
	      updateSelectInput(session, "In_deseq", selected = "paste")
	      updateSelectInput(session, "In_deseq_table", selected = "paste")
	      updateTextAreaInput(session, "DeseqPaste", value = paste(readLines("LIR_sRNA_read_count_matrix.txt"), collapse = "\n"))
	      updateTextAreaInput(session, "DeseqTablePaste", value = paste(readLines("LIR_sRNA_sample_info.txt"), collapse = "\n"))
	    })
	  } else {NULL}
	})
	
	
	# Visualization
	observe({
	  if (input$submitVisualize>0) {
	    isolate({
	      vis.Seq <- input$VisualizePaste
	      vis.Seq <- gsub("^\\s+", "", vis.Seq)
	      vis.Seq <- gsub("\\s+$", "", vis.Seq)
	      
	      if ((length(vis.Seq) == 1) && (vis.Seq == "")) {
	        sendSweetAlert(
	          session = session,
	          title = "No input data received!", type = "error",
	          text = NULL
	        )
	      } else if (substr(vis.Seq, 1, 1) != ">") {
	        sendSweetAlert(
	          session = session,
	          title = "'>' expected at beginning of line 1 to indicate the ID of the input sequence!", type = "error",
	          text = NULL
	        )
	      } else {
	        rnafold.in.file <- gsub("\\s+", "-", Sys.time())
	        rnafold.in.file <- gsub(":", "-", rnafold.in.file)
	        rnafold.in.file <- paste0(rnafold.in.file, ".fasta")
	        rnafold.in.file <- file.path(tempdir(), rnafold.in.file)
	        writeLines(vis.Seq, con=rnafold.in.file)
	        
	        vis.Seq.fa <- readDNAStringSet(rnafold.in.file)
	        if (length(vis.Seq.fa) > 1) {
	          sendSweetAlert(
	            session = session,
	            title = "Only one input sequence is allowed at one time!", type = "error",
	            text = NULL
	          )
	        } else {
	          if (names(vis.Seq.fa) == "") {
	            names(vis.Seq.fa) <- gsub(".fasta$", "", rnafold.in.file)
	            writeXStringSet(vis.Seq.fa, file=rnafold.in.file)
	            vis.Seq.fa <- readDNAStringSet(rnafold.in.file)
	          }
	          vis.Seq.fa.name <- gsub("\\s.+", "", names(vis.Seq.fa))
	          
	          RNAfold.cmds <- paste0("cat ", rnafold.in.file, " | RNAfold ", " -T ", input$temperature)
	          if (input$noGU) {
	            RNAfold.cmds <- paste0(RNAfold.cmds, " --noGU")
	          }
	          if (input$noClosingGU) {
	            RNAfold.cmds <- paste0(RNAfold.cmds, " --noClosingGU")
	          }
	          
	          rnafold.out <- system(RNAfold.cmds, intern = TRUE)
	          
	          ps.file <- paste0(vis.Seq.fa.name, "_ss.ps")
	          system(paste0("ps2pdf ", ps.file))
	          pdf.file <- paste0(vis.Seq.fa.name, "_ss.pdf")
	          file.copy(from=pdf.file, to="www")
	          file.remove(pdf.file)
	          
	          # RNAfold result file
	          if (length(rnafold.out) < 3) {
	            sendSweetAlert(
	              session = session,
	              title = "Wrong input data!", type = "error",
	              text = "Please check the content and the format of your input data!"
	            )
	          } else {
	            ## Display RNAfold result in text
	            output$RNAfold_2nd_structure_text_title <- renderText({
	              "Predicted secondary structure of the potential RNA encoded by the LIR:"
	            })
	            
	            output$RNAfold_textview <- renderUI({
	              verbatimTextOutput("RNAfold_2nd_structure_text")
	            })
	            
	            output$RNAfold_2nd_structure_text <- renderText({
	              tmp.fl <- file.path(tempdir(), "rnafold.out.fa")
	              rnafold.out.BS <- BStringSet(rnafold.out)
	              writeXStringSet(rnafold.out.BS, file = tmp.fl, width = 120)
	              rnafold.out.format <- readLines(tmp.fl)
	              rnafold.out.format <- rnafold.out.format[rnafold.out.format != ">"]
	              rnafold.out.format
	            }, sep = "\n")
	            
	            output$RNAfold_pdfview <- renderUI({
	              tags$iframe(style = "height:900px; width:100%; scrolling=yes", src = pdf.file)
	            })
	            
	            ## Download
	            output$downloadLIRstrText <- downloadHandler(
	              filename <- function() { paste('LIR_hpRNA_2nd_structure.txt') },
	              content <- function(file) {
	                writeLines(rnafold.out, file)
	              }, contentType = 'text/plain'
	            )
	            
	            output$downloadLIRstrPS <- downloadHandler(
	              filename <- function() { paste('LIR_hpRNA_2nd_structure.ps') },
	              content <- function(file) {
	                if (file.exists(ps.file)) {
	                  file.copy(ps.file, file)
	                } else {
	                  NULL
	                }
	              }, contentType = NULL
	            )
	            
	          }
	        }
	      }
	    })
	  } else {
	    NULL
	  }
	})
	
	observe({
	  if (input$clearVisualize >0) {
	    isolate({
	      updateTextAreaInput(session, "VisualizePaste", value="")
	    })
	  } else {NULL}
	})
	
	observe({
	  if (input$VisualizeExam >0) {
	    isolate({
	      updateTextAreaInput(session, "VisualizePaste", value = paste(exam3.fa, collapse = "\n"))
	    })
	  } else {NULL}
	})
	
	
	# Annotated inverted repeats of 424 genomes
	output$downloadTable = shiny::renderDataTable({
	  IRF_result <- read.csv("IRF_result.csv", head=T, as.is=T)
	  IRF_result
	}, options = list(lengthMenu = c(20, 30, 50), pageLength = 20, scrollX = TRUE,
	                  searching = TRUE, autoWidth = FALSE, bSort=FALSE), escape = FALSE)
  
	output$BLASTdbdownloadTable = shiny::renderDataTable({
	  BLAST_db_down <- read.table("BLASTdb_download.txt", head=T, as.is=T, sep="\t")
	  BLAST_db_down
	}, options = list(lengthMenu = c(20, 30, 50), pageLength = 20, scrollX = TRUE,
	                  searching = TRUE, autoWidth = FALSE, bSort=FALSE), escape = FALSE)
	
	output$BowtiedbdownloadTable = shiny::renderDataTable({
	  Bowtie_db_down <- read.table("Bowtiedb_download.txt", head=T, as.is=T, sep="\t")
	  Bowtie_db_down
	}, options = list(lengthMenu = c(20, 30, 50), pageLength = 20, scrollX = TRUE,
	                  searching = TRUE, autoWidth = FALSE, bSort=FALSE), escape = FALSE)
	
	# Information of 424 genomes
	output$genomeTable = shiny::renderDataTable({
	  genomes <- read.csv("All_genomes.csv", head=T, as.is=T)
	  genomes$Source <- paste0("<a href='", genomes$Source,"' target='_blank'>", genomes$Source,"</a>")
	  genomes$Publication <- paste0("<a href='https://doi.org/", genomes$Publication,"' target='_blank'>", genomes$Publication,"</a>")
	  genomes
	}, options = list(lengthMenu = c(20, 30, 50), pageLength = 20, scrollX = TRUE,
	                    searching = TRUE, autoWidth = FALSE, bSort=FALSE), escape = FALSE)
	
	# output$pdfview <- renderUI({
	#   tags$iframe(style = "height:900px; width:100%; scrolling=yes", src = "Tutorial.pdf")
	# })

})

