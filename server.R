
# options(shiny.maxRequestSize = 200*1024^2)
shinyServer(function(input, output, session) {

  # Home
  observeEvent(input$Browse_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Invertebrate metazoa</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$metazoa_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Invertebrate metazoa</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$plant_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Plant</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$vertebrate_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Vertebrate</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$SearchByReg_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Search by genomic location</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$SearchByLIRID_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Search by LIR identifier</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$BLAST_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>BLAST</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$Annotate_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:18px'>Annotate</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$Quantify_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>Quantify</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$DESeq_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:17px'>DESeq</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$Target_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:18px'>Target</strong>"))
  }, ignoreInit = TRUE)
  
  observeEvent(input$Visualize_butt, {
    updateNavbarPage(session, "The_page", selected = HTML("<strong style='font-size:18px'>Visualize</strong>"))
  }, ignoreInit = TRUE)
  
  
  # Browse Metazoa
  HTML.tab_Metazoa <- read.table("icon.tab_Metazoa.txt", head=F, as.is=T, fill=NA, sep="\t")
  colnames(HTML.tab_Metazoa) <- rep("", 8)
  output$HTMLtable_Metazoa <- DT::renderDataTable(HTML.tab_Metazoa,
                                          options = list(pageLength = 10, scrollX = TRUE, lengthMenu = c(5, 10, 20, 30, 50, 55), 
                                                         searchHighlight = TRUE, autoWidth = FALSE, bSort=FALSE),
                                          escape = FALSE, selection=list(mode="single", target="cell"), 
                                          rownames= FALSE
  )
  
  observe({
    if(length(input$HTMLtable_Metazoa_cells_selected) > 0) {
      HTML.index <- input$HTMLtable_Metazoa_cells_selected
      HTML.index[, 2] <- HTML.index[, 2] + 1
      if(!is.na(HTML.tab_Metazoa[HTML.index]) && HTML.tab_Metazoa[HTML.index] != "") {
        updateTabsetPanel(session, 'browser_Metazoa', selected = HTML("<strong style='font-size:18px'>LIRs of Invertebrate metazoa</strong>"))
        
        dat.file.path_Metazoa <<- gsub("\\sheight.+", "", HTML.tab_Metazoa[HTML.index])
        dat.file.path_Metazoa <- gsub(".+src=", "", dat.file.path_Metazoa)
        dat.file.path_Metazoa <- gsub("Icon", "Table", dat.file.path_Metazoa)
        dat.file.path_Metazoa <- gsub("png", "dat.gz", dat.file.path_Metazoa)
        dat.file.path_Metazoa <- paste0("www/", dat.file.path_Metazoa)
        
        HTML.file.path_Metazoa <<- dat.file.path_Metazoa
        dat.content_Metazoa <<- data.table::fread(dat.file.path_Metazoa, data.table = F)
        
        dat.spark.path_Metazoa <- gsub("Table", "Spark_data", dat.file.path_Metazoa)
        dat.spark.path_Metazoa <- gsub("dat.gz", "RData", dat.spark.path_Metazoa)
        load(dat.spark.path_Metazoa)
        dat.spark.target$AN <- NULL

        output$LIR_info_num_Metazoa <- DT::renderDataTable(
          dat.spark.target,
          options = list(
            scrollX = TRUE, searching = FALSE, autoWidth = FALSE, bSort=FALSE,
            drawCallback = htmlwidgets::JS('function(){debugger;HTMLWidgets.staticRender();}'),
            initComplete = DT::JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
              "}")
          ), escape = FALSE, rownames= FALSE, selection="none"
        )
        
        output$IRFbrowse_title_Metazoa <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>List of all the LIRs identified by IRF (Click on a row to check the details of the selected LIR):</b></font>')
          )
        output$IRFbrowse_Metazoa <- DT::renderDT({
          DT::datatable(
            dat.content_Metazoa, extensions = 'Buttons',
            options = list(pageLength = 5, autoWidth = FALSE, lengthMenu = c(5, 10, 20, 30, 50, 100), 
                           searchHighlight = TRUE, scrollX = TRUE,
                           buttons = list('pageLength', 'copy', 
                                       list(extend = 'csv',   filename =  paste("LIRs", gsub(".dat.gz$", "", basename(dat.file.path_Metazoa)), sep = "_")),
                                       list(extend = 'excel', filename =  paste("LIRs", gsub(".dat.gz$", "", basename(dat.file.path_Metazoa)), sep = "_"))
                                       ), 
                           dom = 'Bfrtip',
                           columnDefs=list(list(targets="_all")),
                           initComplete = DT::JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                             "}")
            ), rownames= FALSE, filter = 'top', selection="single"
          )
          
        }, server = TRUE)
      } else {
        NULL
      }
    } else {
      output$LIR_info_num_Metazoa <- DT::renderDataTable(
        NULL
      )
      
      output$IRFbrowse_title_Metazoa <- renderText(
        NULL
      )
      
      output$IRFbrowse_Metazoa <- DT::renderDataTable(
        NULL
      )
      
    }
  })
  
  observe({
    if (length(input$IRFbrowse_Metazoa_rows_selected) > 0) {
      IRF.index <- input$IRFbrowse_Metazoa_rows_selected
      
      if (!is.na(dat.content_Metazoa$ID[IRF.index])) {
        HTML.file.path_Metazoa <- gsub("Table", "HTML", HTML.file.path_Metazoa)
        HTML.file.path_Metazoa <- gsub("dat.gz", "IRFresult.RData", HTML.file.path_Metazoa)
        load(HTML.file.path_Metazoa)
        
        LIR.gene.op.file.path_Metazoa <- gsub("IRFresult.RData", "LIR_gene_op.txt.gz", HTML.file.path_Metazoa)
        LIR.gene.op.file.path_Metazoa <- gsub("HTML", "LIR_gene_op", LIR.gene.op.file.path_Metazoa)
        
        # Overlap between LIRs and genes
        output$LIR_gene_op_title_Metazoa <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
        )
        output$LIR_gene_op_Metazoa <- DT::renderDT({
          if (file.exists(LIR.gene.op.file.path_Metazoa)) {
            LIR.gene.op_Metazoa <- data.table::fread(LIR.gene.op.file.path_Metazoa, data.table=F)
            LIR.gene.op_Metazoa <- LIR.gene.op_Metazoa[LIR.gene.op_Metazoa$ID %in% dat.content_Metazoa$ID[IRF.index], ]
            LIR.gene.op_Metazoa <- LIR.gene.op_Metazoa[, !colnames(LIR.gene.op_Metazoa) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
          } else {
            LIR.gene.op_Metazoa <- data.frame("V1"="No data available!")
            colnames(LIR.gene.op_Metazoa) <- ""
          }
          
          DT::datatable(
            LIR.gene.op_Metazoa,
            options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
                           buttons = list('copy', 
                                       list(extend = 'csv',   filename =  "LIR_gene_overlap_in_Browse_result"),
                                       list(extend = 'excel', filename =  "LIR_gene_overlap_in_Browse_result")
                                       ),
                           dom = 'Bfrtip',
                           columnDefs=list(list(targets="_all")),
                           initComplete = DT::JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                             "}")
            ), escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons"
          )
        }, server = FALSE)
        
        # sequence
        fasta.file.path_Metazoa <- gsub("HTML", "Fasta", HTML.file.path_Metazoa)
        fasta.file.path_Metazoa <- gsub("IRFresult.RData", "LIR.fa.gz", fasta.file.path_Metazoa)
        fasta.content_Metazoa <- Biostrings::readBStringSet(fasta.file.path_Metazoa)
        LIR.seq.select.fa <- fasta.content_Metazoa[dat.content_Metazoa$ID[IRF.index]]
        tmp.fl <- file.path(tempdir(), "LIR.seq.select.fasta")
        Biostrings::writeXStringSet(LIR.seq.select.fa, file = tmp.fl, width=20000)
        LIR.seq.select <- readLines(tmp.fl)
        
        output$LIR_sequence_title_Metazoa <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
        )
        output$LIR_sequence_Metazoa <- renderText({
          fa <- LIR.seq.select.fa
          fa.len <- Biostrings::width(fa)
          names(fa.len) <- names(fa)
          
          fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
          fa.L.nrow <- sapply(fa.L, nrow)
          fa.arm <- do.call(rbind, fa.L)
          fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
          fa.arm$LIR <- rep(names(fa), fa.L.nrow)
          fa.arm$length <- fa.len[fa.arm$LIR]
          fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
          names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
          
          fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
          
          fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
          fa.loop <- fa.loop[fa.loop$loop_start <= fa.loop$loop_end, ]
          
          fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
          fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
          if (nrow(fa.loop) >0) {
            fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
            paste0(">", names(fa), "<br>",
                   '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
                   '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
                   '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
            )
          } else {
            paste0(">", names(fa), "<br>",
                   '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa), "</b></font>",
                   '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
            )
          }
        })
        
        # alignment of left against right arm
        LIR.align.select <- LIR.align[[dat.content_Metazoa$ID[IRF.index]]]
        output$LIR_detail_title_Metazoa <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
        )
        output$LIR_detail_Metazoa <- renderText(
          LIR.align.select, sep = "\n"
        )
      } else {
        NULL
      }
    } else {
      output$LIR_gene_op_title_Metazoa <- renderText(
        NULL
      )
      output$LIR_gene_op_Metazoa <- DT::renderDataTable(
        NULL
      )
      
      output$LIR_sequence_title_Metazoa <- renderText(
        NULL
      )
      output$LIR_sequence_Metazoa <- renderText(
        NULL
      )
      
      output$LIR_detail_title_Metazoa <- renderText(
        NULL
      )
      output$LIR_detail_Metazoa <- renderText(
        NULL
      )
      
    }
  })
  
  
  # Browse Plant
  HTML.tab_Plant <- read.table("icon.tab_Plant.txt", head=F, as.is=T, fill=NA, sep="\t")
  colnames(HTML.tab_Plant) <- rep("", 8)
  output$HTMLtable_Plant <- DT::renderDataTable(HTML.tab_Plant,
                                                  options = list(pageLength = 10, scrollX = TRUE, lengthMenu = c(5, 10, 20, 30, 50, 55), 
                                                                 searchHighlight = TRUE, autoWidth = FALSE, bSort=FALSE),
                                                  escape = FALSE, selection=list(mode="single", target="cell"), 
                                                  rownames= FALSE
  )
  
  observe({
    if(length(input$HTMLtable_Plant_cells_selected) > 0) {
      HTML.index <- input$HTMLtable_Plant_cells_selected
      HTML.index[, 2] <- HTML.index[, 2] + 1
      if(!is.na(HTML.tab_Plant[HTML.index]) && HTML.tab_Plant[HTML.index] != "") {
        updateTabsetPanel(session, 'browser_Plant', selected = HTML("<strong style='font-size:18px'>LIRs of Plant</strong>"))
        
        dat.file.path_Plant <<- gsub("\\sheight.+", "", HTML.tab_Plant[HTML.index])
        dat.file.path_Plant <- gsub(".+src=", "", dat.file.path_Plant)
        dat.file.path_Plant <- gsub("Icon", "Table", dat.file.path_Plant)
        dat.file.path_Plant <- gsub("png", "dat.gz", dat.file.path_Plant)
        dat.file.path_Plant <- paste0("www/", dat.file.path_Plant)
        
        HTML.file.path_Plant <<- dat.file.path_Plant
        dat.content_Plant <<- data.table::fread(dat.file.path_Plant, data.table = F)
        
        dat.spark.path_Plant <- gsub("Table", "Spark_data", dat.file.path_Plant)
        dat.spark.path_Plant <- gsub("dat.gz", "RData", dat.spark.path_Plant)
        load(dat.spark.path_Plant)
        dat.spark.target$AN <- NULL
        
        output$LIR_info_num_Plant <- DT::renderDataTable(
          dat.spark.target,
          options = list(
            scrollX = TRUE, searching = FALSE, autoWidth = FALSE, bSort=FALSE,
            drawCallback = htmlwidgets::JS('function(){debugger;HTMLWidgets.staticRender();}'),
            initComplete = DT::JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
              "}")
          ), escape = FALSE, rownames= FALSE, selection="none"
        )
        
        output$IRFbrowse_title_Plant <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>List of all the LIRs identified by IRF (Click on a row to check the details of the selected LIR):</b></font>')
        )
        output$IRFbrowse_Plant <- DT::renderDT({
          DT::datatable(
            dat.content_Plant, extensions = 'Buttons',
            options = list(pageLength = 5, autoWidth = FALSE, lengthMenu = c(5, 10, 20, 30, 50, 100), 
                           searchHighlight = TRUE, scrollX = TRUE,
                           buttons = list('pageLength', 'copy', 
                                          list(extend = 'csv',   filename =  paste("LIRs", gsub(".dat.gz$", "", basename(dat.file.path_Plant)), sep = "_")),
                                          list(extend = 'excel', filename =  paste("LIRs", gsub(".dat.gz$", "", basename(dat.file.path_Plant)), sep = "_"))
                           ), 
                           dom = 'Bfrtip',
                           columnDefs=list(list(targets="_all")),
                           initComplete = DT::JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                             "}")
            ), rownames= FALSE, filter = 'top', selection="single"
          )
          
        }, server = TRUE)
      } else {
        NULL
      }
    } else {
      output$LIR_info_num_Plant <- DT::renderDataTable(
        NULL
      )
      
      output$IRFbrowse_title_Plant <- renderText(
        NULL
      )
      
      output$IRFbrowse_Plant <- DT::renderDataTable(
        NULL
      )
      
    }
  })
  
  observe({
    if (length(input$IRFbrowse_Plant_rows_selected) > 0) {
      IRF.index <- input$IRFbrowse_Plant_rows_selected
      
      if (!is.na(dat.content_Plant$ID[IRF.index])) {
        HTML.file.path_Plant <- gsub("Table", "HTML", HTML.file.path_Plant)
        HTML.file.path_Plant <- gsub("dat.gz", "IRFresult.RData", HTML.file.path_Plant)
        load(HTML.file.path_Plant)
        
        LIR.gene.op.file.path_Plant <- gsub("IRFresult.RData", "LIR_gene_op.txt.gz", HTML.file.path_Plant)
        LIR.gene.op.file.path_Plant <- gsub("HTML", "LIR_gene_op", LIR.gene.op.file.path_Plant)
        
        # Overlap between LIRs and genes
        output$LIR_gene_op_title_Plant <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
        )
        output$LIR_gene_op_Plant <- DT::renderDT({
          if (file.exists(LIR.gene.op.file.path_Plant)) {
            LIR.gene.op_Plant <- data.table::fread(LIR.gene.op.file.path_Plant, data.table=F)
            LIR.gene.op_Plant <- LIR.gene.op_Plant[LIR.gene.op_Plant$ID %in% dat.content_Plant$ID[IRF.index], ]
            LIR.gene.op_Plant <- LIR.gene.op_Plant[, !colnames(LIR.gene.op_Plant) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
          } else {
            LIR.gene.op_Plant <- data.frame("V1"="No data available!")
            colnames(LIR.gene.op_Plant) <- ""
          }
          
          DT::datatable(
            LIR.gene.op_Plant,
            options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
                           buttons = list('copy', 
                                          list(extend = 'csv',   filename =  "LIR_gene_overlap_in_Browse_result"),
                                          list(extend = 'excel', filename =  "LIR_gene_overlap_in_Browse_result")
                           ),
                           dom = 'Bfrtip',
                           columnDefs=list(list(targets="_all")),
                           initComplete = DT::JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                             "}")
            ), escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons"
          )
        }, server = FALSE)
        
        # sequence
        fasta.file.path_Plant <- gsub("HTML", "Fasta", HTML.file.path_Plant)
        fasta.file.path_Plant <- gsub("IRFresult.RData", "LIR.fa.gz", fasta.file.path_Plant)
        fasta.content_Plant <- Biostrings::readBStringSet(fasta.file.path_Plant)
        LIR.seq.select.fa <- fasta.content_Plant[dat.content_Plant$ID[IRF.index]]
        tmp.fl <- file.path(tempdir(), "LIR.seq.select.fasta")
        Biostrings::writeXStringSet(LIR.seq.select.fa, file = tmp.fl, width=20000)
        LIR.seq.select <- readLines(tmp.fl)
        
        output$LIR_sequence_title_Plant <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
        )
        output$LIR_sequence_Plant <- renderText({
          fa <- LIR.seq.select.fa
          fa.len <- Biostrings::width(fa)
          names(fa.len) <- names(fa)
          
          fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
          fa.L.nrow <- sapply(fa.L, nrow)
          fa.arm <- do.call(rbind, fa.L)
          fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
          fa.arm$LIR <- rep(names(fa), fa.L.nrow)
          fa.arm$length <- fa.len[fa.arm$LIR]
          fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
          names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
          
          fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
          
          fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
          fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
          
          fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
          fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
          if (nrow(fa.loop) >0) {
            fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
            paste0(">", names(fa), "<br>",
                   '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
                   '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
                   '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
            )
          } else {
            paste0(">", names(fa), "<br>",
                   '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa), "</b></font>",
                   '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
            )
          }
        })
        
        # alignment of left against right arm
        LIR.align.select <- LIR.align[[dat.content_Plant$ID[IRF.index]]]
        output$LIR_detail_title_Plant <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
        )
        output$LIR_detail_Plant <- renderText(
          LIR.align.select, sep = "\n"
        )
      } else {
        NULL
      }
    } else {
      output$LIR_gene_op_title_Plant <- renderText(
        NULL
      )
      output$LIR_gene_op_Plant <- DT::renderDataTable(
        NULL
      )
      
      output$LIR_sequence_title_Plant <- renderText(
        NULL
      )
      output$LIR_sequence_Plant <- renderText(
        NULL
      )
      
      output$LIR_detail_title_Plant <- renderText(
        NULL
      )
      output$LIR_detail_Plant <- renderText(
        NULL
      )
      
    }
  })
  
  
  # Browse Vertebrate
  HTML.tab_Vertebrate <- read.table("icon.tab_Vertebrate.txt", head=F, as.is=T, fill=NA, sep="\t")
  colnames(HTML.tab_Vertebrate) <- rep("", 8)
  output$HTMLtable_Vertebrate <- DT::renderDataTable(HTML.tab_Vertebrate,
                                                options = list(pageLength = 10, scrollX = TRUE, lengthMenu = c(5, 10, 20, 30, 50, 55), 
                                                               searchHighlight = TRUE, autoWidth = FALSE, bSort=FALSE),
                                                escape = FALSE, selection=list(mode="single", target="cell"), 
                                                rownames= FALSE
  )
  
  observe({
    if(length(input$HTMLtable_Vertebrate_cells_selected) > 0) {
      HTML.index <- input$HTMLtable_Vertebrate_cells_selected
      HTML.index[, 2] <- HTML.index[, 2] + 1
      if(!is.na(HTML.tab_Vertebrate[HTML.index]) && HTML.tab_Vertebrate[HTML.index] != "") {
        updateTabsetPanel(session, 'browser_Vertebrate', selected = HTML("<strong style='font-size:18px'>LIRs of Vertebrate</strong>"))
        
        dat.file.path_Vertebrate <<- gsub("\\sheight.+", "", HTML.tab_Vertebrate[HTML.index])
        dat.file.path_Vertebrate <- gsub(".+src=", "", dat.file.path_Vertebrate)
        dat.file.path_Vertebrate <- gsub("Icon", "Table", dat.file.path_Vertebrate)
        dat.file.path_Vertebrate <- gsub("png", "dat.gz", dat.file.path_Vertebrate)
        dat.file.path_Vertebrate <- paste0("www/", dat.file.path_Vertebrate)
        
        HTML.file.path_Vertebrate <<- dat.file.path_Vertebrate
        dat.content_Vertebrate <<- data.table::fread(dat.file.path_Vertebrate, data.table = F)
        
        dat.spark.path_Vertebrate <- gsub("Table", "Spark_data", dat.file.path_Vertebrate)
        dat.spark.path_Vertebrate <- gsub("dat.gz", "RData", dat.spark.path_Vertebrate)
        load(dat.spark.path_Vertebrate)
        dat.spark.target$AN <- NULL
        
        output$LIR_info_num_Vertebrate <- DT::renderDataTable(
          dat.spark.target,
          options = list(
            scrollX = TRUE, searching = FALSE, autoWidth = FALSE, bSort=FALSE,
            drawCallback = htmlwidgets::JS('function(){debugger;HTMLWidgets.staticRender();}'),
            initComplete = DT::JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
              "}")
          ), escape = FALSE, rownames= FALSE, selection="none"
        )
        
        output$IRFbrowse_title_Vertebrate <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>List of all the LIRs identified by IRF (Click on a row to check the details of the selected LIR):</b></font>')
        )
        output$IRFbrowse_Vertebrate <- DT::renderDT({
          DT::datatable(
            dat.content_Vertebrate, extensions = 'Buttons',
            options = list(pageLength = 5, autoWidth = FALSE, lengthMenu = c(5, 10, 20, 30, 50, 100), 
                           searchHighlight = TRUE, scrollX = TRUE,
                           buttons = list('pageLength', 'copy', 
                                          list(extend = 'csv',   filename =  paste("LIRs", gsub(".dat.gz$", "", basename(dat.file.path_Vertebrate)), sep = "_")),
                                          list(extend = 'excel', filename =  paste("LIRs", gsub(".dat.gz$", "", basename(dat.file.path_Vertebrate)), sep = "_"))
                           ), 
                           dom = 'Bfrtip',
                           columnDefs=list(list(targets="_all")),
                           initComplete = DT::JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                             "}")
            ), rownames= FALSE, filter = 'top', selection="single"
          )
          
        }, server = TRUE)
      } else {
        NULL
      }
    } else {
      output$LIR_info_num_Vertebrate <- DT::renderDataTable(
        NULL
      )
      
      output$IRFbrowse_title_Vertebrate <- renderText(
        NULL
      )
      
      output$IRFbrowse_Vertebrate <- DT::renderDataTable(
        NULL
      )
      
    }
  })
  
  observe({
    if (length(input$IRFbrowse_Vertebrate_rows_selected) > 0) {
      IRF.index <- input$IRFbrowse_Vertebrate_rows_selected
      
      if (!is.na(dat.content_Vertebrate$ID[IRF.index])) {
        HTML.file.path_Vertebrate <- gsub("Table", "HTML", HTML.file.path_Vertebrate)
        HTML.file.path_Vertebrate <- gsub("dat.gz", "IRFresult.RData", HTML.file.path_Vertebrate)
        load(HTML.file.path_Vertebrate)
        
        LIR.gene.op.file.path_Vertebrate <- gsub("IRFresult.RData", "LIR_gene_op.txt.gz", HTML.file.path_Vertebrate)
        LIR.gene.op.file.path_Vertebrate <- gsub("HTML", "LIR_gene_op", LIR.gene.op.file.path_Vertebrate)
        
        # Overlap between LIRs and genes
        output$LIR_gene_op_title_Vertebrate <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
        )
        output$LIR_gene_op_Vertebrate <- DT::renderDT({
          if (file.exists(LIR.gene.op.file.path_Vertebrate)) {
            LIR.gene.op_Vertebrate <- data.table::fread(LIR.gene.op.file.path_Vertebrate, data.table=F)
            LIR.gene.op_Vertebrate <- LIR.gene.op_Vertebrate[LIR.gene.op_Vertebrate$ID %in% dat.content_Vertebrate$ID[IRF.index], ]
            LIR.gene.op_Vertebrate <- LIR.gene.op_Vertebrate[, !colnames(LIR.gene.op_Vertebrate) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
          } else {
            LIR.gene.op_Vertebrate <- data.frame("V1"="No data available!")
            colnames(LIR.gene.op_Vertebrate) <- ""
          }
          
          DT::datatable(
            LIR.gene.op_Vertebrate,
            options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
                           buttons = list('copy', 
                                          list(extend = 'csv',   filename =  "LIR_gene_overlap_in_Browse_result"),
                                          list(extend = 'excel', filename =  "LIR_gene_overlap_in_Browse_result")
                           ),
                           dom = 'Bfrtip',
                           columnDefs=list(list(targets="_all")),
                           initComplete = DT::JS(
                             "function(settings, json) {",
                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                             "}")
            ), escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons"
          )
        }, server = FALSE)
        
        # sequence
        fasta.file.path_Vertebrate <- gsub("HTML", "Fasta", HTML.file.path_Vertebrate)
        fasta.file.path_Vertebrate <- gsub("IRFresult.RData", "LIR.fa.gz", fasta.file.path_Vertebrate)
        fasta.content_Vertebrate <- Biostrings::readBStringSet(fasta.file.path_Vertebrate)
        LIR.seq.select.fa <- fasta.content_Vertebrate[dat.content_Vertebrate$ID[IRF.index]]
        tmp.fl <- file.path(tempdir(), "LIR.seq.select.fasta")
        Biostrings::writeXStringSet(LIR.seq.select.fa, file = tmp.fl, width=20000)
        LIR.seq.select <- readLines(tmp.fl)
        
        output$LIR_sequence_title_Vertebrate <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
        )
        output$LIR_sequence_Vertebrate <- renderText({
          fa <- LIR.seq.select.fa
          fa.len <- Biostrings::width(fa)
          names(fa.len) <- names(fa)
          
          fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
          fa.L.nrow <- sapply(fa.L, nrow)
          fa.arm <- do.call(rbind, fa.L)
          fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
          fa.arm$LIR <- rep(names(fa), fa.L.nrow)
          fa.arm$length <- fa.len[fa.arm$LIR]
          fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
          names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
          
          fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
          
          fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
          fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
          
          fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
          fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
          if (nrow(fa.loop) >0) {
            fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
            paste0(">", names(fa), "<br>",
                   '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
                   '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
                   '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
            )
          } else {
            paste0(">", names(fa), "<br>",
                   '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
                   '<font color="darkcyan"><b>', as.character(fa.arm.fa), "</b></font>",
                   '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
            )
          }
        })
        
        # alignment of left against right arm
        LIR.align.select <- LIR.align[[dat.content_Vertebrate$ID[IRF.index]]]
        output$LIR_detail_title_Vertebrate <- renderText(
          HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
        )
        output$LIR_detail_Vertebrate <- renderText(
          LIR.align.select, sep = "\n"
        )
      } else {
        NULL
      }
    } else {
      output$LIR_gene_op_title_Vertebrate <- renderText(
        NULL
      )
      output$LIR_gene_op_Vertebrate <- DT::renderDataTable(
        NULL
      )
      
      output$LIR_sequence_title_Vertebrate <- renderText(
        NULL
      )
      output$LIR_sequence_Vertebrate <- renderText(
        NULL
      )
      
      output$LIR_detail_title_Vertebrate <- renderText(
        NULL
      )
      output$LIR_detail_Vertebrate <- renderText(
        NULL
      )
      
    }
  })
  
  
	# Search LIR by genomic region
  chromosome <- reactive({
    req(input$chooseGenomeReg)
    if (!exists("genome.info")) {load("genome.info.RData")}
    dplyr::filter(genome.info, ID == input$chooseGenomeReg)
  })
  
  observeEvent(chromosome(), {
    shinyWidgets::updatePickerInput(session, "chooseChromosomeReg", choices = unique(chromosome()$chr))
  })
  
  output$searchRegion <- renderUI({
    dat.genome <- chromosome()
    dat.chromosome <- dat.genome[dat.genome$chr == input$chooseChromosomeReg, ]
    
    if (exists("dat.chromosome") && !is.null(dat.chromosome$size) && nrow(dat.chromosome)>0) {
      sliderInput(inputId = "chooseRegion", 
                  label = tags$div(HTML('<i class="fa fa-play" aria-hidden="true"></i> <font size="4" color="red">Choose genomic region</font>')),
                  min = 1, max = dat.chromosome$size,
                  value = c(1, dat.chromosome$size), width = "100%")
    }
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
      dat.search.result <- data.table::fread(dat.file, data.table = FALSE)
      dat.search.result <- dat.search.result[dat.search.result$chr == input$chooseChromosomeReg & 
                                               dat.search.result$Left_start >= as.numeric(input$chooseRegion[1]) &
                                               dat.search.result$Right_end <= as.numeric(input$chooseRegion[2]), ]
      fasta.region <- Biostrings::readBStringSet(fasta.file)
      fasta.region <- fasta.region[dat.search.result$ID]
      load(HTML.file)
      result <- list(dat.search.result, fasta.region, LIR.align, LIR.gene.op.file)
    } else {
      shinyWidgets::sendSweetAlert(
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
  
  output$LIRsearchRegResult <- DT::renderDT({
    if (is.null(search.region.result())) {
      LIR.search.reg.table <- NULL
    } else {
      LIR.search.reg.table <- searchedRegResults()[[1]]
    }
    
    DT::datatable(
      LIR.search.reg.table,
      options = list(lengthMenu = c(5, 10, 20, 30, 50), pageLength = 5, searching = TRUE, searchHighlight = TRUE, scrollX = TRUE, autoWidth = FALSE,
                     buttons = list('pageLength', 'copy', 
                                 list(extend = 'csv',   filename = "LIRs_in_searched_regions"),
                                 list(extend = 'excel', filename = "LIRs_in_searched_regions")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      ), rownames= FALSE, filter = 'top', selection = "single", extensions = "Buttons"
    )
  }, server = TRUE)
  
  ## Download structure of LIRs in user searching result
  output$searchRegDownIRFresult.txt <- downloadHandler(
    filename <- function() { paste('LIRs_strucutre_search.txt') },
    content <- function(file) {
      if (is.null(search.region.result())) {
        NULL
      } else {
        write.table(searchedRegResults()[[1]], file, sep="\t", quote=F, row.names = F)
      }
    }, contentType = 'text/plain'
  )
  
  ## Download sequence of LIRs in user searching result
  output$searchRegDownIRFfasta.txt <- downloadHandler(
    filename <- function() { paste('LIRs_sequence_search.fasta') },
    content <- function(file) {
      if (is.null(search.region.result())) {
        NULL
      } else {
        Biostrings::writeXStringSet(searchedRegResults()[[2]], file)
      }
    }, contentType = 'text/plain'
  )
  
  ## Overlap between LIR and genes
  output$Search_reg_LIR_gene_op_title <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
    }
  })
  
  output$Search_reg_LIR_gene_op <- DT::renderDT({
    if (is.null(search.region.result()) || is.null(input$LIRsearchRegResult_rows_selected)) {
      LIR.gene.op <- NULL
    } else {
      if (file.exists(searchedRegResults()[[4]])) {
        LIR.gene.op <- data.table::fread(searchedRegResults()[[4]], data.table=F)
        LIR.ID <- searchedRegResults()[[1]]$ID[input$LIRsearchRegResult_rows_selected]
        LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
        LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
        LIR.gene.op
      } else {
        LIR.gene.op <- data.frame("V1"="No data available!")
        colnames(LIR.gene.op) <- ""
      }
    }
    
    DT::datatable(
      LIR.gene.op,
      options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
                     buttons = list('copy', 
                                 list(extend = 'csv',   filename = "genes_overlap_with_LIR_in_searched_region"),
                                 list(extend = 'excel', filename = "genes_overlap_with_LIR_in_searched_region")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      ), 
      escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons"
    )
  }, server = FALSE)
  
  ## Display LIR sequence
  output$LIR_detail_search_reg_fasta_title <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
    }
  })
  
  output$LIR_detail_search_reg_fasta <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      LIR.ID <- searchedRegResults()[[1]]$ID[input$LIRsearchRegResult_rows_selected]
      # tmp.fl <- file.path(tempdir(), "t1.fa")
      # Biostrings::writeXStringSet(searchedRegResults()[[2]][LIR.ID], file = tmp.fl, width=20000)
      # readLines(tmp.fl)
      
      fa <- searchedRegResults()[[2]][LIR.ID]
      fa.len <- Biostrings::width(fa)
      names(fa.len) <- names(fa)
      
      fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
      fa.L.nrow <- sapply(fa.L, nrow)
      fa.arm <- do.call(rbind, fa.L)
      fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
      fa.arm$LIR <- rep(names(fa), fa.L.nrow)
      fa.arm$length <- fa.len[fa.arm$LIR]
      fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
      names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
      
      fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
      
      fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
      fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
      
      fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
      fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
      fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
      
      paste0(">", LIR.ID, "<br>",
	         '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
             '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
             '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
      )
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_search_reg_title <- renderText({
    if (is.null(input$LIRsearchRegResult_rows_selected)) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
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
        shinyWidgets::sendSweetAlert(
          session = session,
          title = "No LIR identifier received!", type = "error",
          text = "Please input LIR identifier in proper format."
        )
        result <- NULL
      } else {
        if (file.exists(dat.file)) {
          dat.search.result <- data.table::fread(dat.file, data.table = FALSE)
          
          LIR.id <- intersect(LIR.id, dat.search.result$ID)
          
          if (length(LIR.id)>0) {
            dat.search.result <- dat.search.result[dat.search.result$ID %in% LIR.id, ]
            fasta.ID <- Biostrings::readBStringSet(fasta.file)
            fasta.ID <- fasta.ID[LIR.id]
            load(HTML.file)
            
            result <- list(dat.search.result, fasta.ID, LIR.align, LIR.gene.op.file)
          } else {
            shinyWidgets::sendSweetAlert(
              session = session,
              title = "Wrong LIR identifiers!", type = "error",
              text = "Please check the identifier of all input LIRs!"
            )
            result <- NULL
          }
        } else {
          result <- NULL
        }
      }
    } else {
      shinyWidgets::sendSweetAlert(
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
          updateTabsetPanel(session, 'search_ID', selected = HTML("<strong style='font-size:18px'>Output</strong>"))
        } else {
          NULL
        }
      })
    } else {NULL}
  })
  
  output$LIRsearchIDResult <- DT::renderDT({
    if (is.null(search.ID.result())) {
      search.out <- data.frame("V1"="No LIRs found!")
      colnames(search.out) <- ""
    } else {
      search.out <- searchedIDResults()[[1]]
    }
    
    DT::datatable(
      search.out,
      options = list(paging = TRUE, searchHighlight = TRUE, scrollX = TRUE,
                     searching = TRUE, autoWidth = FALSE, bSort=FALSE,
                     buttons = list('pageLength', 'copy', 
                                 list(extend = 'csv',   filename = "LIRs_searched_by_ID"),
                                 list(extend = 'excel', filename = "LIRs_searched_by_ID")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      ), rownames= FALSE, selection = "single", extensions = "Buttons"
    )
  }, server = TRUE)
  
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
      Biostrings::writeXStringSet(searchedIDResults()[[2]], file)
    }, contentType = 'text/plain'
  )
  
  ## Overlap between LIR and genes
  output$Search_ID_LIR_gene_op_title <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected)) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
    }
  })
  
  output$Search_ID_LIR_gene_op <- DT::renderDT({
    if (is.null(search.ID.result()) || is.null(input$LIRsearchIDResult_rows_selected)) {
      LIR.gene.op <- NULL
    } else {
      if (file.exists(searchedIDResults()[[4]])) {
        LIR.gene.op <- data.table::fread(searchedIDResults()[[4]], data.table=F)
        LIR.ID <- searchedIDResults()[[1]]$ID[input$LIRsearchIDResult_rows_selected]
        LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
        LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
      } else {
        LIR.gene.op <- data.frame("V1"="No data available!")
        colnames(LIR.gene.op) <- ""
      }
    }
    
    DT::datatable(
      LIR.gene.op, 
      options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
                     buttons = list('copy',
                                 list(extend = 'csv',   filename = "genes_overlap_with_LIR_searched_by_ID"),
                                 list(extend = 'excel', filename = "genes_overlap_with_LIR_searched_by_ID")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      ), escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons"
    )
  }, server = FALSE)
  
  ## Display LIR sequence
  output$LIR_detail_search_ID_fasta_title <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
    }
  })
  
  output$LIR_detail_search_ID_fasta <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      LIR.ID <- searchedIDResults()[[1]]$ID[input$LIRsearchIDResult_rows_selected]
      # tmp.fl <- file.path(tempdir(), "t2.fa")
      # Biostrings::writeXStringSet(searchedIDResults()[[2]][LIR.ID], file = tmp.fl, width=20000)
      # readLines(tmp.fl)
      
      fa <- searchedIDResults()[[2]][LIR.ID]
      fa.len <- Biostrings::width(fa)
      names(fa.len) <- names(fa)
      
      fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
      fa.L.nrow <- sapply(fa.L, nrow)
      fa.arm <- do.call(rbind, fa.L)
      fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
      fa.arm$LIR <- rep(names(fa), fa.L.nrow)
      fa.arm$length <- fa.len[fa.arm$LIR]
      fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
      names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
      
      fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
      
      fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
      fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
      
      fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
      fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
      fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
      
      paste0(">", LIR.ID, "<br>",
	         '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
             '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
             '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
      )
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_search_ID_title <- renderText({
    if (is.null(input$LIRsearchIDResult_rows_selected) || is.null(search.ID.result())) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
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
    shinyWidgets::updatePickerInput(session, "chooseGenomeID", selected = character(0))
    updateTextInput(session, "LIRID", value="")
  })
  
  ## load example input
  observe({
    if (input$searchIDExam >0) {
      isolate({
        shinyWidgets::updatePickerInput(session, "chooseGenomeID", selected = "Drosophila_melanogaster")
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
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "No input data received!", type = "error",
        text = NULL
      )
    } else {
      blast.in.file <- uuid::UUIDgenerate()
      blast.in.file <- paste0(blast.in.file, ".fasta")
      blast.in.file <- file.path(tempdir(), blast.in.file)
      writeLines(blast.in.seq, con = blast.in.file)
      
      blast.db <- input$BLASTdb
      blast.db <- paste0("www/LIRBase_blastdb/", blast.db)
      blast.db.fl <- paste0(blast.db, ".nhr")
      
      if (!all(file.exists(blast.db.fl))) {
        shinyWidgets::sendSweetAlert(
          session = session,
          title = "BLAST database not found!", type = "error",
          text = NULL
        )
        NULL
      } else if (length(blast.db.fl) > 10) {
        shinyWidgets::sendSweetAlert(
          session = session,
          title = "No more than 10 BLAST databases are allowed!", type = "error",
          text = NULL
        )
        NULL
      } else {
        blast.out.file <- paste0(blast.in.file, ".blast.out")
        
        blast.cmds <- paste0("blastn -query ", blast.in.file, " -db ", '"', paste(blast.db, sep=" ", collapse = " "), '"', 
                             " -evalue ", input$BLASTev, " -outfmt 5", " -out ", blast.out.file)
        system(blast.cmds, ignore.stdout = TRUE, ignore.stderr = TRUE)
        
        if (file.size(blast.out.file) > 0) {
          XML::xmlParse(blast.out.file)
        } else {
          shinyWidgets::sendSweetAlert(
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
    if (is.null(blast.result())) {
      
    } else {
      xmltop = XML::xmlRoot(blast.result())
      
      #the first chunk is for multi-fastas
      x <- which(sapply(blast.result()["//Iteration//Iteration_hits//Hit//Hsp//Hsp_num"], XML::xmlValue) == "1")
      y <- sapply(blast.result()["//Iteration//Iteration_hits//Hit//Hit_def"], XML::xmlValue)
      x1 <- c(x[-1], length(sapply(blast.result()["//Iteration//Iteration_hits//Hit//Hsp//Hsp_num"], XML::xmlValue)) + 1)
      z <- sapply(blast.result()["//Iteration//Iteration_hits//Hit//Hit_def"], XML::xmlValue)
      d <- sapply(blast.result()["//Iteration//Iteration_hits//Hit//Hit_len"], XML::xmlValue)
      
      results <- XML::xpathApply(blast.result(), '//Iteration', function(row){
        qseqid <- XML::getNodeSet(row, 'Iteration_query-def') %>% sapply(., XML::xmlValue)
        qlen <- XML::getNodeSet(row, 'Iteration_query-len') %>% sapply(., XML::xmlValue)
        qstart <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_query-from')  %>% sapply(., XML::xmlValue)
        qend <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_query-to')  %>% sapply(., XML::xmlValue)
        sstart <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_hit-from')  %>% sapply(., XML::xmlValue)
        send <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_hit-to')  %>% sapply(., XML::xmlValue)
        bitscore <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_bit-score')  %>% sapply(., XML::xmlValue)
        evalue <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_evalue')  %>% sapply(., XML::xmlValue)
        gaps <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_gaps')  %>% sapply(., XML::xmlValue)
        length <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_align-len')  %>% sapply(., XML::xmlValue)
        identity <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hsp//Hsp_identity')  %>% sapply(., XML::xmlValue)
        pident <- round(as.integer(identity) / as.integer(length) * 100, 2)
        cbind(qseqid, qlen, qstart, qend, sstart, send, bitscore, evalue, gaps, pident, length)
      })
      
      #this ensures that NAs get added for no hits
      results <- plyr::rbind.fill( lapply(results, function(y) {as.data.frame((y), stringsAsFactors=FALSE)} ))
      results <- results[!is.na(results$qstart), ]
      
      if (ncol(results) != 11) {
        results <- NULL
      } else {
        results$sseqid <- rep(z, x1-x)
        results$sslen <- rep(d, x1-x)
        
        results <- results[, c("qseqid", "qlen", "sseqid", "sslen", "qstart", "qend", "sstart", 
                               "send", "bitscore", "evalue", "gaps", "pident", "length")]
      }
      results
    }
  })
  
  output$BLASTresult <- DT::renderDT({
    if (is.null(blast.result()) || is.null(blastedResults())) {
      blast.out <- data.frame("V1"="No BLAST hits found!")
      colnames(blast.out) <- ""
    } else {
      blast.out <- blastedResults()
    }
    
    DT::datatable(
      blast.out,
      escape = FALSE, rownames= FALSE, selection="single", filter = 'top', extensions = "Buttons",
      options = list(pageLength = 5, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE,
                     buttons = list('pageLength', 'copy', 
                                 list(extend = 'csv',   filename = "BLAST_result"),
                                 list(extend = 'excel', filename = "BLAST_result")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      )
    )
  }, server = TRUE)
  
  # Update Tab Panel
  observe({
    if (input$submitBLAST >0) {
      isolate({
        if (!is.null(blast.result())) {
          updateTabsetPanel(session, 'BLAST_tab', selected = HTML("<strong style='font-size:18px'>Output</strong>"))
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
        y <- data.table::fread(x, data.table = FALSE)
        return(y)
      } else {NULL}
    })
    dat.search.result <- data.table::rbindlist(dat.search.result)
    class(dat.search.result) <- "data.frame"
    
    fasta.blast <- lapply(fasta.file, function(x) {
      if (file.exists(x)) {
        y <- Biostrings::readBStringSet(x)
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
        y <- data.table::fread(x, data.table = FALSE)
        return(y)
      } else {NULL}
    })
    LIR.gene.op <- data.table::rbindlist(LIR.gene.op)
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
      exam1.fa <- readLines("exam1.fa")
      writeLines(exam1.fa, con=file)
    }, contentType = 'text/plain'
  )
  
  ## Download BLAST result
  output$BLASTresult.txt <- downloadHandler(
    filename <- function() { paste('BLAST_Result.txt') },
    content <- function(file) {
      data.table::fwrite(blastedResults(), file, sep="\t", quote=F)
    }, contentType = 'text/plain'
  )
  
  output$blastDownIRFresult.txt <- downloadHandler(
    filename <- function() { paste('BLAST_result_IRF_structure.txt') },
    content <- function(file) {
      LIR.ID <- blastedResults()$sseqid
      IRF.str <- blastdbResults()[[1]]
      IRF.str <- IRF.str[IRF.str$ID %in% LIR.ID, ]
      data.table::fwrite(IRF.str, file, sep="\t", quote=F)
    }, contentType = 'text/plain'
  )
  
  output$blastDownIRFfasta.txt <- downloadHandler(
    filename <- function() { paste('BLAST_result_IRF_sequence.txt') },
    content <- function(file) {
      LIR.ID <- blastedResults()$sseqid
      Biostrings::writeXStringSet(blastdbResults()[[2]][LIR.ID], file)
    }, contentType = 'text/plain'
  )
  
  #this chunk gets the alignment information from a clicked row
  output$BLAST_hit_summary <- shiny::renderTable({
    if(is.null(input$BLASTresult_rows_selected) || is.null(blastedResults())) {
      
    } else {
      clicked = input$BLASTresult_rows_selected
      tableout<- data.frame(blastedResults()[clicked,])
      tableout <- t(tableout)
      names(tableout) <- c("")
      rownames(tableout) <- c("query ID","query length", "subject ID", "subject length", "query start", "query end", 
                              "subject start", "subject end", "bit-score", "e-value", "gaps", "percentage of identical matches", "alignment length")
      colnames(tableout) <- NULL
      data.frame(tableout)
    }
  }, rownames =T, colnames =F)
  
  output$BLAST_hit_detail_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())) {
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>The detailed alignment for the selected BLAST hit:</b></font>')
    }
  })
  
  output$BLAST_hit_detail <- renderText({
    if(is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())){
      NULL
    }
    else{
      xmltop = XML::xmlRoot(blast.result())
      
      clicked = input$BLASTresult_rows_selected
      #loop over the xml to get the alignments
      align <- XML::xpathApply(blast.result(), '//Iteration', function(row){
        top <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_qseq') %>% sapply(., XML::xmlValue)
        mid <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_midline') %>% sapply(., XML::xmlValue)
        bottom <- XML::getNodeSet(row, 'Iteration_hits//Hit//Hit_hsps//Hsp//Hsp_hseq') %>% sapply(., XML::xmlValue)
        rbind(top, mid, bottom)
      })
      
      #split the alignments every 100 carachters to get a "wrapped look"
      alignx <- do.call("cbind", align)
      splits <- strsplit(gsub("(.{100})", "\\1,", alignx[1:3,clicked]), ",")
      
      #paste them together with returns '\n' on the breaks
      split_out <- lapply(1:length(splits[[1]]), function(i){
        rbind(paste0("Q: ", splits[[1]][i],"\n"), paste0("M: ", splits[[2]][i],"\n"), paste0("S: ", splits[[3]][i], "\n"), "\n")
      })
      split_out[[1]][1] <- paste0(" ", split_out[[1]][1])
      unlist(split_out)
    }
  })
  
  
  ## Overlap between LIR and genes
  output$Blast_LIR_gene_op_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blastedResults())) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
    }
  })
  
  output$Blast_LIR_gene_op <- DT::renderDT({
    if ( is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())) {
      LIR.gene.op <- NULL
    } else {
      if ( nrow(blastdbResults()[[4]])>0 ) {
        LIR.gene.op <- blastdbResults()[[4]]
        LIR.ID <- blastedResults()$sseqid[input$BLASTresult_rows_selected]
        LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
        LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
        
      } else {
        LIR.gene.op <- data.frame("V1"="No data available!")
        colnames(LIR.gene.op) <- ""
      }
    }
    
    DT::datatable(
      LIR.gene.op,
      options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
                     buttons = list('copy', 
                                 list(extend = 'csv',   filename = "genes_overlap_with_LIR_in_BLAST_result"),
                                 list(extend = 'excel', filename = "genes_overlap_with_LIR_in_BLAST_result")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      ), escape = FALSE, rownames= FALSE, selection="none"
    )
  }, server = FALSE)
  
  ## Display LIR sequence
  output$LIR_detail_blast_fasta_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
    }
  })
  
  output$LIR_detail_blast_fasta <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())) {
      
    } else {
      LIR.ID <- blastedResults()$sseqid[input$BLASTresult_rows_selected]
      # tmp.fl <- file.path(tempdir(), "t3.fa")
      # Biostrings::writeXStringSet(blastdbResults()[[2]][LIR.ID], file = tmp.fl, width=20000)
      # readLines(tmp.fl)
      
      fa <- blastdbResults()[[2]][LIR.ID]
      fa.len <- Biostrings::width(fa)
      names(fa.len) <- names(fa)
      
      fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
      fa.L.nrow <- sapply(fa.L, nrow)
      fa.arm <- do.call(rbind, fa.L)
      fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
      fa.arm$LIR <- rep(names(fa), fa.L.nrow)
      fa.arm$length <- fa.len[fa.arm$LIR]
      fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
      names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
      
      fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
      
      fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
      fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
      
      fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
      fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
      fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
      
      paste0(">", LIR.ID, "<br>",
	         '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
             '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
             '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
      )
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_blast_title <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
    }
  })
  
  output$LIR_detail_blast <- renderText({
    if (is.null(input$BLASTresult_rows_selected) || is.null(blast.result()) || is.null(blastedResults())) {
      
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
        shinyWidgets::updateMultiInput(session, "BLASTdb", selected = character(0))
      })
    } else {NULL}
  })
  
  ## load example
  observe({
    if (input$blastExam >0) {
      isolate({
        updateSelectInput(session, "In_blast", selected = "paste")
        updateTextAreaInput(session, "BlastSeqPaste", value = paste(readLines("exam1.fa"), collapse = "\n"))
        shinyWidgets::updateMultiInput(session, "BLASTdb", selected = c("Oryza_sativa.MH63", "Oryza_sativa.Nipponbare"))
      })
    } else {NULL}
  })
  
	
	# Annotate
  annotate.result <- eventReactive(input$submitP, {
    pre.Seq <- ""
    if (input$In_predict == "paste") {
      pre.Seq <- input$PreSeqPaste
      pre.Seq <- gsub("^\\s+", "", pre.Seq)
      pre.Seq <- gsub("\\s+$", "", pre.Seq)
    } else if (input$In_predict == "upload") {
      pre.Seq <- readLines(input$PreSeqUpload$datapath)
    }
    
    if ((length(pre.Seq) == 1) && (pre.Seq == "")) {
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "No input data received!", type = "error",
        text = NULL
      )
    } else if (substr(pre.Seq, 1, 1) != ">") {
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "'>' expected at beginning of line 1 to indicate the ID of the input sequence!", type = "error",
        text = NULL
      )
    } else {
      irf.in.file <- uuid::UUIDgenerate()
      irf.in.file <- paste0(irf.in.file, ".fasta")
      writeLines(pre.Seq, con=irf.in.file)
      
      ## test sequence ID
      pre.Seq.test <- Biostrings::readDNAStringSet(irf.in.file)
      names(pre.Seq.test) <- gsub("^\\s+", "", names(pre.Seq.test))
      names(pre.Seq.test) <- gsub("\\s+$", "", names(pre.Seq.test))
      if (any(names(pre.Seq.test) == "")) {
        shinyWidgets::sendSweetAlert(
          session = session,
          title = "Wrong input data!", type = "error",
          text = "Empty sequence ID is not allowed!"
        )
      } else {
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
          shinyWidgets::sendSweetAlert(
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
            html.lst <- list.files(patter=paste0(irf.in.file, ".*.txt.html$"), full=T)
            html.all.lst <- list.files(patter=paste0(irf.in.file, ".*.html$"), full=T)
            
            dat.html <- sapply(html.lst, function(i) {
              d <- readLines(i)
              x.name <- which(grepl("NAME=", d))
              x.stat <- which(grepl("Statistics", d))
              x.chr.id <- gsub("Sequence: ", "", d[10])
              
              LIR.align <- lapply(1:length(x.name), function(i) {
                i.con <- d[(x.name[i] + 5) : (x.stat[i]-4)]
                return(i.con)
              })
              
              x.name <- d[x.name + 1]
              x.name <- gsub("\\s+Loop:.+", "", x.name)
              x.name <- gsub(".+\\s", "", x.name)
              names(LIR.align) <- x.name
              names(LIR.align) <- paste0(x.chr.id, ":", names(LIR.align))
              
              return(LIR.align)
            }, USE.NAMES = FALSE)
            dat.html <- do.call(c, dat.html)
            unlink(html.all.lst)
            
            # process the dat file
            write.table(dat.cont.df, file=dat.file, sep="\t", quote=F, row.names=F, col.names=F)
            dat.cont.df <- read.table(dat.file, head=F, as.is=T)
            dat.cont.df <- dat.cont.df[, c(1:11)]
            names(dat.cont.df) <- c("chr", "Left_start", "Left_end", "Left_len", "Right_start", "Right_end", "Right_len",
                                    "Loop_len", "Match_per", "Indel_per", "Score")
            dat.cont.df.bak <- dat.cont.df
            dat.cont.df.bak$ID = paste0(dat.cont.df.bak$chr, ":", dat.cont.df.bak$Left_start, "--", dat.cont.df.bak$Left_end, ",",
                                        dat.cont.df.bak$Right_start, "--", dat.cont.df.bak$Right_end)
            dat.cont.df.bak <- dat.cont.df.bak[, c(12, 1:11)]
            dat.cont.df.bak <- dat.cont.df.bak[dat.cont.df.bak$Left_len >= 400 & dat.cont.df.bak$Right_len >= 400, ]
            
            unlink(dat.file)
            
            # extract the fasta sequence
            fa <- Biostrings::readDNAStringSet(irf.in.file)
            dat.cont.df$Loop_start <- dat.cont.df$Left_end + 1
            dat.cont.df$Loop_end <- dat.cont.df$Right_start - 1
            
            fa.len <- Biostrings::width(fa)
            names(fa.len) <- names(fa)
            dat.cont.df$chr_len <- fa.len[dat.cont.df$chr]
            
            dat.cont.df$Left_start_N <- pmax(1, dat.cont.df$Left_start - pre.flankLen)
            dat.cont.df$Right_end_N <- pmin(dat.cont.df$chr_len, dat.cont.df$Right_end + pre.flankLen)
            
            dat.cont.df.LF <- Biostrings::subseq(fa[dat.cont.df$chr], dat.cont.df$Left_start_N, dat.cont.df$Left_start - 1)
            dat.cont.df.RF <- Biostrings::subseq(fa[dat.cont.df$chr], dat.cont.df$Right_end + 1, dat.cont.df$Right_end_N)
            dat.cont.df.LF <- tolower(dat.cont.df.LF)
            dat.cont.df.RF <- tolower(dat.cont.df.RF)
            dat.cont.df.L <- Biostrings::subseq(fa[dat.cont.df$chr], dat.cont.df$Left_start, dat.cont.df$Left_end)
            dat.cont.df.R <- Biostrings::subseq(fa[dat.cont.df$chr], dat.cont.df$Right_start, dat.cont.df$Right_end)
            dat.cont.df.Loop <- Biostrings::subseq(fa[dat.cont.df$chr], dat.cont.df$Loop_start, dat.cont.df$Loop_end)
            dat.cont.df.Loop <- tolower(dat.cont.df.Loop)
            
            dat.cont.df.fa <- paste0(dat.cont.df.LF, dat.cont.df.L, dat.cont.df.Loop, dat.cont.df.R, dat.cont.df.RF)
            dat.cont.df.fa <- Biostrings::BStringSet(dat.cont.df.fa)
            names(dat.cont.df.fa) <- paste0(dat.cont.df$chr, ":", dat.cont.df$Left_start, "--", dat.cont.df$Left_end, ",",
                                            dat.cont.df$Right_start, "--", dat.cont.df$Right_end)
            dat.cont.df.fa <- dat.cont.df.fa[names(dat.cont.df.fa) %in% dat.cont.df.bak$ID, ]
            
            return(list(dat.cont.df.bak, dat.cont.df.fa, dat.html))
          } else {
            return(NULL)
          }
        }
      }
    }
    
  })
  
  annotateResults <- reactive({
    if (is.null(annotate.result())){
      
    } else {
      result <- annotate.result()
    }
  })
  
  output$prediction <- DT::renderDT({
    if (is.null(annotate.result())) {
      annotate.table <- NULL
    } else {
      annotate.table <- annotateResults()[[1]]
    }
    
    DT::datatable(
      annotate.table,
      escape = FALSE, rownames= FALSE, selection="single", 
      options = list(pageLength = 10, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE,
                     buttons = list('pageLength', 'copy', 
                                 list(extend = 'csv',   filename = "LIRs_annotated_in_user_input_seq"),
                                 list(extend = 'excel', filename = "LIRs_annotated_in_user_input_seq")
                                 ),
                     dom = 'Bfrtip',
                     columnDefs=list(list(targets="_all")),
                     initComplete = DT::JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                       "}")
      )
    )
  }, server = FALSE)
  
  output$downloadIRFresult.txt <- downloadHandler(
    filename <- function() { paste('LIRs_strucutre_by_IRF.txt') },
    content <- function(file) {
      write.table(annotateResults()[[1]], file, sep="\t", quote=F, row.names = F)
    }, contentType = 'text/plain'
  )
  
  output$downloadIRFfasta.txt <- downloadHandler(
    filename <- function() { paste('LIRs_sequence_by_IRF.txt') },
    content <- function(file) {
      Biostrings::writeXStringSet(annotateResults()[[2]], file)
    }, contentType = 'text/plain'
  )
  
  ## Display LIR sequence
  output$LIR_detail_annotate_fasta_title <- renderText({
    if (is.null(input$prediction_rows_selected)) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
    }
  })
  
  output$LIR_detail_annotate_fasta <- renderText({
    if (is.null(input$prediction_rows_selected)) {
      
    } else {
      LIR.ID <- annotateResults()[[1]]$ID[input$prediction_rows_selected]
      # tmp.fl <- file.path(tempdir(), "Anno1.fa")
      # Biostrings::writeXStringSet(annotateResults()[[2]][LIR.ID], file = tmp.fl, width=20000)
      # readLines(tmp.fl)
      
      fa <- annotateResults()[[2]][LIR.ID]
      fa.len <- Biostrings::width(fa)
      names(fa.len) <- names(fa)
      
      fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
      fa.L.nrow <- sapply(fa.L, nrow)
      fa.arm <- do.call(rbind, fa.L)
      fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
      fa.arm$LIR <- rep(names(fa), fa.L.nrow)
      fa.arm$length <- fa.len[fa.arm$LIR]
      fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
      names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
      
      fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
      
      fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
      fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
      
      fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
      fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
      fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
      
      paste0(">", LIR.ID, "<br>",
	         '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
             '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
             '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
             '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
      )
    }
  }, sep = "\n")
  
  ## Display LIR alignment
  output$LIR_detail_annotate_title <- renderText({
    if (is.null(input$prediction_rows_selected)) {
      
    } else {
      HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
    }
  })
  
  output$LIR_detail_annotate <- renderText({
    if (is.null(input$prediction_rows_selected)) {
      
    } else {
      LIR.ID <- annotateResults()[[1]]$ID[input$prediction_rows_selected]
      annotateResults()[[3]][[LIR.ID]]
    }
  }, sep = "\n")
	
	## Download example input data
	output$Annotate_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_input_4IRF.txt') },
	  content <- function(file) {
	    exam2.fa <- readLines("exam2.fa")
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
	      updateTextAreaInput(session, "PreSeqPaste", value = paste(readLines("exam2.fa"), collapse = "\n"))
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
	      shinyWidgets::sendSweetAlert(
	        session = session,
	        title = "No input data received!", type = "error",
	        text = NULL
	      )
	      NULL
	    } else {
	      srna.rc <- data.table::fread(text = srna.rc.text, data.table = FALSE, check.names = FALSE)
	      
	      srna.fa.name <- uuid::UUIDgenerate()
	      srna.fa.name <- paste0(srna.fa.name, ".fasta")
	    }
	  } else if (input$In_align == "upload") {
	    if (is.null(input$AlignInFile)) {
	      shinyWidgets::sendSweetAlert(
	        session = session,
	        title = "No input data received!", type = "error",
	        text = NULL
	      )
	      NULL
	    } else {
	      srna.rc <- data.table::fread(file = input$AlignInFile$datapath, data.table = FALSE, check.names = FALSE)
	      srna.fa.name <- paste0(input$AlignInFile$name, ".fasta")
	    }
	  }
	  
	  if (srna.rc == "") {
	    shinyWidgets::sendSweetAlert(
	      session = session,
	      title = "No input data received!", type = "error",
	      text = NULL
	    )
	    NULL
	  } else if (is.null(input$Aligndb)) {
	    shinyWidgets::sendSweetAlert(
	      session = session,
	      title = "Please choose a LIR database to align!", type = "error",
	      text = NULL
	    )
	    NULL
	  } else {
	    names(srna.rc) <- c("sRNA", "sRNA_read_number")
	    srna.fa <- Biostrings::BStringSet(srna.rc[, 1])
	    names(srna.fa) <- 1:nrow(srna.rc)
	    srna.fa.name <- file.path(tempdir(), srna.fa.name)
	    Biostrings::writeXStringSet(srna.fa, file=srna.fa.name)
	    
	    bowtie.db <- paste0("www/LIRBase_bowtiedb/", input$Aligndb)
	    srna.bowtie <- paste0(srna.fa.name, ".bowtie")
	    
	    bowtie.cmd <- paste0("bowtie -x ", bowtie.db, " -f ", srna.fa.name, " -v ", input$MaxAlignMismatch, " -p 5 -k ", input$MaxAlignHit, " > ", srna.bowtie)
	    system(bowtie.cmd, wait = TRUE, timeout = 0)
	    
	    if (file.exists(srna.bowtie) && file.size(srna.bowtie) >0) {
	      bowtie.out <- data.table::fread(srna.bowtie, data.table=F, head=F, select=c(1, 3, 4))
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
	      LIR.rc <- LIR.rc %>% dplyr::arrange(dplyr::desc(sRNA_read_number))
	      
	      # sRNA length, percent
	      LIR_read_summary <- bowtie.out.3 %>% dplyr::group_by(LIR) %>% dplyr::summarise(sRNA_num = sum(sRNA_number), sRNA_21_22_num = sum(sRNA_number[sRNA_size %in% c(21, 22)]),
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
	      fa <- Biostrings::readBStringSet(fasta.file)
	      fa <- fa[names(fa) %in% LIR_table$LIR]
	      fa.len <- Biostrings::width(fa)
	      names(fa.len) <- names(fa)
	      
	      fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
	      fa.L.nrow <- sapply(fa.L, nrow)
	      fa.arm <- do.call(rbind, fa.L)
	      fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
	      fa.arm$LIR <- rep(names(fa), fa.L.nrow)
	      fa.arm$length <- fa.len[fa.arm$LIR]
	      fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
	      names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
	      
	      fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
	      
	      fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
	      fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
	      
	      d2.gr <- GenomicRanges::GRanges(bowtie.out.2$LIR, IRanges::IRanges(bowtie.out.2$Position, bowtie.out.2$Position))
	      
	      fa.arm.gr <- GenomicRanges::GRanges(fa.arm$LIR, IRanges::IRanges(fa.arm$arm_start, fa.arm$arm_end))
	      fa.arm.cnt <- fa.arm
	      fa.arm.cnt$sRNA_in_arm <- GenomicRanges::countOverlaps(fa.arm.gr, d2.gr)
	      fa.arm.cnt <- fa.arm.cnt %>% dplyr::group_by(LIR) %>% dplyr::summarise(sRNA_in_arm = sum(sRNA_in_arm))
	      
	      fa.loop.gr <- GenomicRanges::GRanges(fa.loop$LIR, IRanges::IRanges(fa.loop$loop_start, fa.loop$loop_end))
	      fa.loop.cnt <- fa.loop
	      fa.loop.cnt$sRNA_in_loop <- GenomicRanges::countOverlaps(fa.loop.gr, d2.gr)
	      fa.loop.cnt <- fa.loop.cnt %>% dplyr::group_by(LIR) %>% dplyr::summarise(sRNA_in_loop = sum(sRNA_in_loop))
	      
	      fa.flank.gr <- GenomicRanges::GRanges(fa.flank$LIR, IRanges::IRanges(fa.flank$flank_start, fa.flank$flank_end))
	      fa.flank.cnt <- fa.flank
	      fa.flank.cnt$sRNA_in_flank <- GenomicRanges::countOverlaps(fa.flank.gr, d2.gr)
	      fa.flank.cnt <- fa.flank.cnt %>% dplyr::group_by(LIR) %>% dplyr::summarise(sRNA_in_flank = sum(sRNA_in_flank))
	      
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
	      shinyWidgets::sendSweetAlert(
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
	
	output$LIRreadCount <- DT::renderDT({
	  if (is.null(align.result())) {
	    LIR.rc.table <- NULL
	  } else {
	    LIR.rc.table <- alignedResults()[[4]]
	  }
	  
	  DT::datatable(
	    LIR.rc.table,
	    escape = FALSE, rownames= FALSE, selection="single", filter = 'top',
	    options = list(pageLength = 10, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE,
	                   buttons = list('pageLength', 'copy', 
	                               list(extend = 'csv',   filename = "sRNA_read_count_of_LIRs"),
	                               list(extend = 'excel', filename = "sRNA_read_count_of_LIRs")
	                               ),
	                   dom = 'Bfrtip',
	                   columnDefs=list(list(targets="_all")),
	                   initComplete = DT::JS(
	                     "function(settings, json) {",
	                     "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
	                     "}")
	    )
	  )
	}, server = TRUE)
	
	# Update Tab Panel
	observe({
	  if (input$submitAlign >0) {
	    isolate({
	      if (!is.null(align.result())) {
	        updateTabsetPanel(session, 'Quantify_tab', selected = HTML("<strong style='font-size:18px'>Output</strong>"))
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
	    dat <- data.table::fread("quantify.exam.sRNA.read.count.txt", data.table = F)
	    data.table::fwrite(dat, file = file, sep="\t")
	  }, contentType = 'text/plain'
	)
	
	## Download sRNA alignment result
	output$sRNAalignSummary.txt <- downloadHandler(
	  filename <- function() { paste('sRNA_alignment_summary.txt') },
	  content <- function(file) {
	    data.table::fwrite(alignedResults()[[2]], file, sep="\t", quote=F)
	  }, contentType = 'text/plain'
	)
	
	output$sRNAalignResult.txt <- downloadHandler(
	  filename <- function() { paste('sRNA_alignment_detail.txt.gz') },
	  content <- function(file) {
	    withProgress(message = 'Downloading..', value = 0, detail = 'This may take a while...', {
	      sRNA.align.detail <- alignedResults()[[1]]
	      sRNA.align.detail <- sRNA.align.detail[, -1]
	      sRNA.align.detail <- sRNA.align.detail[order(sRNA.align.detail$LIR, sRNA.align.detail$Position), ]
	      data.table::fwrite(sRNA.align.detail, file, sep="\t", quote=F, compress = "gzip")
	    })
	  }, contentType = 'application/gzip'
	)
	
	output$sRNAalignLIRrc.txt <- downloadHandler(
	  filename <- function() { paste('LIR_sRNA_read_count.txt') },
	  content <- function(file) {
	    data.table::fwrite(alignedResults()[[4]], file, sep="\t", quote=F)
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
	    dat.search.result <- data.table::fread(dat.file, data.table = FALSE)
	    fasta.align <- Biostrings::readBStringSet(fasta.file)
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
	    HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Lengths and expression levels of all sRNAs aligned to the selected LIR:</b></font>')
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
	    fa.len <- Biostrings::width(fa)
	    x <- stringr::str_locate_all(fa.c, "[ACGT]")
	    y <- x[[1]][,1]
	    y.ir <- IRanges::IRanges(y, y)
	    y.df <- as.data.frame(IRanges::reduce(y.ir))
	    
	    if (nrow(y.df) == 1) {
	      start.1 <- y.df$start
	      start.2 <- y.df$start + y.df$width/2
	      end.1 <- y.df$start + y.df$width/2 - 1
	      end.2 <- y.df$end
	      width.2 <- y.df$width / 2
	      y.df <- data.frame(start = c(start.1, start.2), end =c(end.1, end.2), 
	                         width = width.2, stringsAsFactors = FALSE)
	    }
	    
	    LIR.start.pos <- gsub(".+:", "", align.LIR$LIR[1])
	    LIR.start.pos <- as.integer(gsub("--.+", "", LIR.start.pos))
	    LIT.start.pos.in <- y.df$start[1]
	    LIR.ID.chr <- gsub(":.+", "", LIR.ID)
	    LIR.ID.chr <- substr(LIR.ID.chr, 6, 100)
	    
	    y.df$start <- y.df$start + LIR.start.pos - LIT.start.pos.in
	    y.df$end <- y.df$end + LIR.start.pos - LIT.start.pos.in
	    
	    LIR.ir <- IRanges::IRanges(y.df$start[1], y.df$end[2])
	    
	    dat <- alignedLIRResults()[[1]]
	    dat <- dat[dat$ID != LIR.ID & dat$chr == LIR.ID.chr, ]
	    dat.ir <- IRanges::IRanges(dat$Left_start, dat$Right_end)
	    dat.op <- dat[unique(S4Vectors::subjectHits(IRanges::findOverlaps(LIR.ir, dat.ir))), ]
	    
	    if (input$select_LIR_only || nrow(dat.op) == 0) {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      max.TPM <- max(align.LIR$TPM)
	      
	      p1 <- ggplot2::ggplot(align.LIR) + ggplot2::geom_point(ggplot2::aes(x=Position, y=TPM, color = factor(sRNA_size)), size = input$srnaexp_point_size)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$start[1], y=-max.TPM/100, xend=y.df$end[1], yend=-max.TPM/100), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[2], y=-max.TPM/100, xend=y.df$start[2], yend=-max.TPM/100), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[1]+1, y=-max.TPM/100, xend=y.df$start[2]-1, yend=-max.TPM/100), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + ggplot2::scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + ggplot2::ylab("Expression level of sRNAs (TPM)") + ggplot2::xlab("Position")
	      p1 <- p1 + ggplot2::theme_classic()
	      p1 <- p1 + ggplot2::theme(axis.text=ggplot2::element_text(size=input$srnaexp_axis_tick_size),
	                       axis.title=ggplot2::element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                       legend.title=ggplot2::element_text(size=input$srnaexp_legend_title_size), 
	                       legend.text=ggplot2::element_text(size=input$srnaexp_legend_text_size)
	      )
	      p1
	    } else {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      max.TPM <- max(align.LIR$TPM)
	      
	      dat.op$yval <- -1 * (1:nrow(dat.op)) * max(align.LIR$TPM)/100 - max.TPM/100
	      
	      p1 <- ggplot2::ggplot(align.LIR) + ggplot2::geom_point(ggplot2::aes(x=Position, y=TPM, color = factor(sRNA_size)),  
	                                                             size = input$srnaexp_point_size)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$start[1], y=-max.TPM/100, xend=y.df$end[1], yend=-max.TPM/100), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[2], y=-max.TPM/100, xend=y.df$start[2], yend=-max.TPM/100), 
	                              lineend = "round", linejoin = "round", color = "red",
	                              size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[1]+1, y=-max.TPM/100, xend=y.df$start[2]-1, yend=-max.TPM/100), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + ggplot2::geom_segment(data=dat.op, ggplot2::aes(x=Left_start, y=yval, xend=Left_end, yend=yval), 
	                              lineend = "round", linejoin = "round", color = "blue",
	                              size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(data=dat.op, ggplot2::aes(x=Right_end, y=yval, xend=Right_start, yend=yval), 
	                              lineend = "round", linejoin = "round", color = "blue",
	                              size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(data=dat.op, ggplot2::aes(x=Left_end+1, y=yval, xend=Right_start-1, yend=yval), 
	                              size = 0.6, color="grey60")
	      p1 <- p1 + ggplot2::scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + ggplot2::scale_y_continuous(breaks = round(seq(0, max(align.LIR$TPM)*1.1, length.out = 5)))
	      p1 <- p1 + ggplot2::ylab("Expression level of sRNAs (TPM)") + ggplot2::xlab("Position")
	      p1 <- p1 + ggplot2::theme_classic()
	      p1 <- p1 + ggplot2::theme(axis.text=ggplot2::element_text(size=input$srnaexp_axis_tick_size),
	                       axis.title=ggplot2::element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                       legend.title=ggplot2::element_text(size=input$srnaexp_legend_title_size), 
	                       legend.text=ggplot2::element_text(size=input$srnaexp_legend_text_size)
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
	    fa.len <- Biostrings::width(fa)
	    x <- stringr::str_locate_all(fa.c, "[ACGT]")
	    y <- x[[1]][,1]
	    y.ir <- IRanges::IRanges(y, y)
	    y.df <- as.data.frame(IRanges::reduce(y.ir))
	    
	    if (nrow(y.df) == 1) {
	      start.1 <- y.df$start
	      start.2 <- y.df$start + y.df$width/2
	      end.1 <- y.df$start + y.df$width/2 - 1
	      end.2 <- y.df$end
	      width.2 <- y.df$width / 2
	      y.df <- data.frame(start = c(start.1, start.2), end =c(end.1, end.2), 
	                         width = width.2, stringsAsFactors = FALSE)
	    }
	    
	    LIR.start.pos <- gsub(".+:", "", align.LIR$LIR[1])
	    LIR.start.pos <- as.integer(gsub("--.+", "", LIR.start.pos))
	    LIT.start.pos.in <- y.df$start[1]
	    LIR.ID.chr <- gsub(":.+", "", LIR.ID)
	    LIR.ID.chr <- substr(LIR.ID.chr, 6, 100)
	    
	    y.df$start <- y.df$start + LIR.start.pos - LIT.start.pos.in
	    y.df$end <- y.df$end + LIR.start.pos - LIT.start.pos.in
	    
	    LIR.ir <- IRanges::IRanges(y.df$start[1], y.df$end[2])
	    
	    dat <- alignedLIRResults()[[1]]
	    dat <- dat[dat$ID != LIR.ID & dat$chr == LIR.ID.chr, ]
	    dat.ir <- IRanges::IRanges(dat$Left_start, dat$Right_end)
	    dat.op <- dat[unique(S4Vectors::subjectHits(IRanges::findOverlaps(LIR.ir, dat.ir))), ]
	    
	    if (input$select_LIR_only || nrow(dat.op) == 0) {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      max.TPM <- max(align.LIR$TPM)
	      
	      p1 <- ggplot2::ggplot(align.LIR) + ggplot2::geom_point(ggplot2::aes(x=Position, y=TPM, color = factor(sRNA_size)), size = input$srnaexp_point_size)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$start[1], y=-max.TPM/100, xend=y.df$end[1], yend=-max.TPM/100), 
	                                       lineend = "round", linejoin = "round", color = "red",
	                                       size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[2], y=-max.TPM/100, xend=y.df$start[2], yend=-max.TPM/100), 
	                                       lineend = "round", linejoin = "round", color = "red",
	                                       size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[1]+1, y=-max.TPM/100, xend=y.df$start[2]-1, yend=-max.TPM/100), 
	                                       size = 0.6, color="grey60")
	      p1 <- p1 + ggplot2::scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + ggplot2::ylab("Expression level of sRNAs (TPM)") + ggplot2::xlab("Position")
	      p1 <- p1 + ggplot2::theme_classic()
	      p1 <- p1 + ggplot2::theme(axis.text=ggplot2::element_text(size=input$srnaexp_axis_tick_size),
	                                axis.title=ggplot2::element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                                legend.title=ggplot2::element_text(size=input$srnaexp_legend_title_size), 
	                                legend.text=ggplot2::element_text(size=input$srnaexp_legend_text_size)
	      )
	    } else {
	      align.LIR$Position <- align.LIR$Position + LIR.start.pos - LIT.start.pos.in
	      align.LIR$TPM <- round(align.LIR$sRNA_read_number / lib.read.count * 1e6, 2)
	      max.TPM <- max(align.LIR$TPM)
	      
	      dat.op$yval <- -1 * (1:nrow(dat.op)) * max(align.LIR$TPM)/100 - max.TPM/100
	      
	      p1 <- ggplot2::ggplot(align.LIR) + ggplot2::geom_point(ggplot2::aes(x=Position, y=TPM, color = factor(sRNA_size)),  
	                                                             size = input$srnaexp_point_size)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$start[1], y=-max.TPM/100, xend=y.df$end[1], yend=-max.TPM/100), 
	                                       lineend = "round", linejoin = "round", color = "red",
	                                       size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[2], y=-max.TPM/100, xend=y.df$start[2], yend=-max.TPM/100), 
	                                       lineend = "round", linejoin = "round", color = "red",
	                                       size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(ggplot2::aes(x=y.df$end[1]+1, y=-max.TPM/100, xend=y.df$start[2]-1, yend=-max.TPM/100), 
	                                       size = 0.6, color="grey60")
	      p1 <- p1 + ggplot2::geom_segment(data=dat.op, ggplot2::aes(x=Left_start, y=yval, xend=Left_end, yend=yval), 
	                                       lineend = "round", linejoin = "round", color = "blue",
	                                       size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(data=dat.op, ggplot2::aes(x=Right_end, y=yval, xend=Right_start, yend=yval), 
	                                       lineend = "round", linejoin = "round", color = "blue",
	                                       size = 1.1, arrow = ggplot2::arrow(length = ggplot2::unit(0.1, "inches")), alpha=0.5)
	      p1 <- p1 + ggplot2::geom_segment(data=dat.op, ggplot2::aes(x=Left_end+1, y=yval, xend=Right_start-1, yend=yval), 
	                                       size = 0.6, color="grey60")
	      p1 <- p1 + ggplot2::scale_colour_hue(name = "sRNA size (nt)")
	      p1 <- p1 + ggplot2::scale_y_continuous(breaks = round(seq(0, max(align.LIR$TPM)*1.1, length.out = 5)))
	      p1 <- p1 + ggplot2::ylab("Expression level of sRNAs (TPM)") + ggplot2::xlab("Position")
	      p1 <- p1 + ggplot2::theme_classic()
	      p1 <- p1 + ggplot2::theme(axis.text=ggplot2::element_text(size=input$srnaexp_axis_tick_size),
	                                axis.title=ggplot2::element_text(size=input$srnaexp_axis_label_size, face="bold"), 
	                                legend.title=ggplot2::element_text(size=input$srnaexp_legend_title_size), 
	                                legend.text=ggplot2::element_text(size=input$srnaexp_legend_text_size)
	      )
	    }
	    grid::grid.draw(p1)
	    dev.off()
	  }, contentType = 'application/pdf')
	
	## Overlap between LIR and genes
	output$Quantify_LIR_gene_op_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Overlaps between the selected LIR and genes:</b></font>')
	  }
	})
	
	output$Quantify_LIR_gene_op <- DT::renderDT({
	  if ( is.null(input$LIRreadCount_rows_selected) ) {
	    LIR.gene.op <- NULL
	  } else {
	    if ( file.exists(alignedLIRResults()[[4]]) ) {
	      LIR.gene.op <- data.table::fread(alignedLIRResults()[[4]], data.table = F)
	      LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	      LIR.gene.op <- LIR.gene.op[LIR.gene.op$ID %in% LIR.ID, ]
	      LIR.gene.op <- LIR.gene.op[, !colnames(LIR.gene.op) %in% c("Match_per", "Indel_per", "Score", "gene.chr")]
	    } else {
	      LIR.gene.op <- data.frame("V1"="No data available!")
	      colnames(LIR.gene.op) <- ""
	    }
	  }
	  
	  DT::datatable(
	    LIR.gene.op,
	    options = list(paging = FALSE, searching = FALSE, autoWidth = FALSE, bSort=FALSE, scrollX = TRUE,
	                   buttons = list('copy', 
	                               list(extend = 'csv',   filename = "genes_overlap_with_LIRs_in_quantify_result"),
	                               list(extend = 'excel', filename = "genes_overlap_with_LIRs_in_quantify_result")
	                               ),
	                   dom = 'Bfrtip',
	                   columnDefs=list(list(targets="_all")),
	                   initComplete = DT::JS(
	                     "function(settings, json) {",
	                     "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
	                     "}")
	    ), escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons"
	  )
	}, server = FALSE)
	
	## Display LIR sequence
	output$LIR_detail_align_fasta_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    HTML('<i class="fa fa-circle" aria-hidden="true"></i> <b>Sequence of the selected LIR (<font size="4" color="blue">left flanking sequence in lower case</font> - <font size="4" color="darkcyan">left arm sequence in upper case</font> - <font size="4" color="lightcoral">loop sequence in lower case</font> - <font size="4" color="darkcyan">right arm sequence in upper case</font> - <font size="4" color="blue">right flanking sequence in lower case</font>):</b>')
	  }
	})
	
	output$LIR_detail_align_fasta <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    # tmp.fl <- file.path(tempdir(), "t4.fa")
	    # Biostrings::writeXStringSet(alignedLIRResults()[[2]][LIR.ID], file = tmp.fl, width=20000)
	    # readLines(tmp.fl)
	    
	    fa <- alignedLIRResults()[[2]][LIR.ID]
	    fa.len <- Biostrings::width(fa)
	    names(fa.len) <- names(fa)
	    
	    fa.L <- stringr::str_locate_all(as.character(fa), "[ACGT]+")
	    fa.L.nrow <- sapply(fa.L, nrow)
	    fa.arm <- do.call(rbind, fa.L)
	    fa.arm <- data.frame(fa.arm, stringsAsFactors = FALSE)
	    fa.arm$LIR <- rep(names(fa), fa.L.nrow)
	    fa.arm$length <- fa.len[fa.arm$LIR]
	    fa.arm <- fa.arm[, c("LIR", "start", "end", "length")]
	    names(fa.arm) <- c("LIR", "arm_start", "arm_end", "length")
	    
	    fa.flank <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(flank_start = c(1, max(arm_end) + 1), flank_end = c(min(arm_start) - 1, max(length)))
	    
	    fa.loop <- fa.arm %>% dplyr::group_by(LIR) %>% dplyr::summarise(loop_start = min(arm_end)+1, loop_end = max(arm_start)-1)
	    fa.loop <- fa.loop[fa.loop$loop_start < fa.loop$loop_end, ]
	    
	    fa.arm.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.arm))], fa.arm$arm_start, fa.arm$arm_end)
	    fa.flank.fa <- Biostrings::subseq(fa[rep(1, nrow(fa.flank))], fa.flank$flank_start, fa.flank$flank_end)
	    fa.loop.fa <- Biostrings::subseq(fa, fa.loop$loop_start, fa.loop$loop_end)
	    
	    paste0(">", LIR.ID, "<br>",
		       '<p style = "word-wrap: break-word;"><font color="blue"><b>', as.character(fa.flank.fa[1]), "</b></font>",
	           '<font color="darkcyan"><b>', as.character(fa.arm.fa[1]), "</b></font>",
	           '<font color="lightcoral"><b>', as.character(fa.loop.fa), "</b></font>",
	           '<font color="darkcyan"><b>', as.character(fa.arm.fa[2]), "</b></font>",
	           '<font color="blue"><b>', as.character(fa.flank.fa[2]), "</b></font></p>"
	    )
	  }
	}, sep = "\n")
	
	## Display LIR alignment
	output$LIR_detail_align_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Alignment of the left and right arms of the selected LIR (* indicates complementary match):</b></font>')
	  }
	})
	
	output$LIR_detail_align <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    alignedLIRResults()[[3]][[LIR.ID]]
	  }
	}, sep = "\n")
	
	## Display small RNAs derived from the LIR
	output$LIR_derived_sRNA_title <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Small RNAs derived from the selected LIR:</b></font>')
	  }
	})
	
	output$LIR_derived_sRNA <- renderText({
	  if (is.null(input$LIRreadCount_rows_selected)) {
	    
	  } else {
	    LIR.ID <- alignedResults()[[4]]$LIR[input$LIRreadCount_rows_selected]
	    sRNA.align.detail <- alignedResults()[[1]]
	    sRNA.align.detail <- sRNA.align.detail[, -1]
	    sRNA.align.detail <- sRNA.align.detail[sRNA.align.detail$LIR == LIR.ID, ]
	    
	    unique(sRNA.align.detail$sRNA)
	  }
	}, sep = "\n")
	
	observe({
	  if (input$clearAlign>0) {
	    isolate({
	      updateSelectInput(session, "In_align", selected = "paste")
	      updateTextInput(session, "AlignInPaste", value="")
	      shinyWidgets::updatePickerInput(session, "Aligndb", selected = character(0))
	    })
	  } else {NULL}
	})
	
	observe({
	  if (input$alignExam >0) {
	    isolate({
	      updateSelectInput(session, "In_align", selected = "paste")
	      updateTextAreaInput(session, "AlignInPaste", value = paste(readLines("quantify.exam.sRNA.read.count.txt"), collapse = "\n"))
	      shinyWidgets::updatePickerInput(session, "Aligndb", selected = "Oryza_sativa.MH63")
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
	        
	        if (count.matrix.text == "") {
	          shinyWidgets::sendSweetAlert(
	            session = session,
	            title = "No input data received!", type = "error",
	            text = NULL
	          )
	          NULL
	        } else {
	          count.matrix <- data.table::fread(text=count.matrix.text, data.table=F)
	        }
	      } else if (input$In_deseq == "upload") {
	        if (is.null(input$DeseqUpload)) {
	          shinyWidgets::sendSweetAlert(
	            session = session,
	            title = "No input data received!", type = "error",
	            text = NULL
	          )
	          NULL
	        } else {
	          count.matrix <- data.table::fread(input$DeseqUpload$datapath, data.table=F)
	        }
	      }
	      
	      sample.info <- ""
	      if (input$In_deseq_table == "paste") {
	        sample.info.text <- input$DeseqTablePaste
	        sample.info.text <- gsub("^\\s+", "", sample.info.text)
	        sample.info.text <- gsub("\\s+$", "", sample.info.text)
	        
	        if (sample.info.text == "") {
	          shinyWidgets::sendSweetAlert(
	            session = session,
	            title = "No input data received!", type = "error",
	            text = NULL
	          )
	          NULL
	        } else {
	          sample.info <- data.table::fread(text=sample.info.text, data.table=F)
	        }
	      } else if (input$In_deseq_table == "upload") {
	        if (is.null(input$DeseqTableUpload)) {
	          shinyWidgets::sendSweetAlert(
	            session = session,
	            title = "No input data received!", type = "error",
	            text = NULL
	          )
	          NULL
	        } else {
	          sample.info <- data.table::fread(input$DeseqTableUpload$datapath, data.table=F)
	        }
	      }
	      
	      if (count.matrix == "" || sample.info == "") {
	        shinyWidgets::sendSweetAlert(
	          session = session,
	          title = "No input data received!", type = "error",
	          text = NULL
	        )
	        NULL
	      } else {
	        rownames(count.matrix) <- count.matrix[, 1]
	        count.matrix.tag <- colnames(count.matrix)[1]
	        count.matrix[, 1] <- NULL
	        count.matrix <- as.matrix(count.matrix)
	        
	        rownames(sample.info) <- sample.info$sample
	        sample.info$sample <- NULL
	        
	        if (identical(sort(unique(colnames(count.matrix))), sort(unique(rownames(sample.info))))) {
	          sample.info$condition <- factor(sample.info$condition)
	          sample.info$type <- factor(sample.info$type)
	          
	          DESeq2.data <- DESeq2::DESeqDataSetFromMatrix(countData = count.matrix,
	                                                        colData = sample.info,
	                                                        design = ~ condition)
	          
	          keep <- rowSums(DESeq2::counts(DESeq2.data)) >= input$MinReadcount
	          DESeq2.data <- DESeq2.data[keep, ]
	          
	          DESeq2.res <- DESeq2::DESeq(DESeq2.data)
	          DESeq2.res.LFC <- DESeq2::lfcShrink(DESeq2.res, coef=DESeq2::resultsNames(DESeq2.res)[2], type="apeglm")
	          DESeq2.res.vsd <- DESeq2::vst(DESeq2.res, blind=FALSE)
	          DESeq2.res.table <- DESeq2::results(DESeq2.res)
	          
	          DESeq2.res.table.dt <- data.frame(DESeq2.res.table, stringsAsFactors = FALSE)
	          DESeq2.res.table.dt[, count.matrix.tag] <- rownames(DESeq2.res.table.dt)
	          DESeq2.res.table.dt <- DESeq2.res.table.dt[, c(7, 1:6)]
	          DESeq2.res.table.dt <- DESeq2.res.table.dt[order(DESeq2.res.table.dt$padj), ]
	          
	          output$DESeqResult <- DT::renderDT({
	            if (nrow(DESeq2.res.table) == 0) {
	              DESeqResult.table <- NULL
	            } else {
	              DESeqResult.table <- DESeq2.res.table.dt
	            }
	            
	            DT::datatable(
	              DESeqResult.table,
	              escape = FALSE, rownames= FALSE, selection="none", extensions = "Buttons",
	              options = list(pageLength = 5, autoWidth = FALSE, bSort=TRUE, scrollX = TRUE,
	                             buttons = list('pageLength', 'copy', 
	                                         list(extend = 'csv',   filename = "DESeq2_result"),
	                                         list(extend = 'excel', filename = "DESeq2_result")
	                                         ),
	                             dom = 'Bfrtip',
	                             columnDefs=list(list(targets="_all")),
	                             initComplete = DT::JS(
	                               "function(settings, json) {",
	                               "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
	                               "}")
	              )
	            )
	          }, server = TRUE)
	          
	          output$DESeq2_result_table.txt <- downloadHandler(
	            filename <- function() { paste('DESeq2_result.txt') },
	            content <- function(file) {
	              if (is.null(DESeq2.res.table) || nrow(DESeq2.res.table) == 0) {
	                NULL
	              } else {
	                data.table::fwrite(DESeq2.res.table.dt, file, sep="\t", quote=F)
	              }
	            }, contentType = 'text/plain'
	          )
	          
	          # MA plot
	          output$MA_plot <- renderPlot({
	            DESeq2::plotMA(DESeq2.res.LFC, ylim = c(input$MA_Y_axis[1], input$MA_Y_axis[2]), main = "MA-plot", cex = input$MA_point_size)
	          })
	          
	          output$MA_plot.pdf <- downloadHandler(
	            filename <- function() {
	              paste('MA_plot.pdf')
	            },
	            content <- function(file) {
	              pdf(file, width = input$MA_plot_width / 72, height = input$MA_plot_height / 72)
	              DESeq2::plotMA(DESeq2.res.LFC, ylim = c(input$MA_Y_axis[1], input$MA_Y_axis[2]), main = "MA-plot", cex = input$MA_point_size)
	              dev.off()
	            }, contentType = 'application/pdf')
	          
	          # Sample distance plot
	          output$sample_dist <- renderPlot({
	            sampleDists <- dist(t(SummarizedExperiment::assay(DESeq2.res.vsd)))
	            
	            sampleDistMatrix <- as.matrix(sampleDists)
	            rownames(sampleDistMatrix) <- paste(DESeq2.res.vsd$condition, DESeq2.res.vsd$type, sep="-")
	            colnames(sampleDistMatrix) <- NULL
	            colors <- colorRampPalette( rev(RColorBrewer::brewer.pal(9, "Blues")) )(255)
	            pheatmap::pheatmap(sampleDistMatrix,
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
	              sampleDists <- dist(t(SummarizedExperiment::assay(DESeq2.res.vsd)))
	              
	              sampleDistMatrix <- as.matrix(sampleDists)
	              rownames(sampleDistMatrix) <- paste(DESeq2.res.vsd$condition, DESeq2.res.vsd$type, sep="-")
	              colnames(sampleDistMatrix) <- NULL
	              colors <- colorRampPalette( rev(RColorBrewer::brewer.pal(9, "Blues")) )(255)
	              pheatmap::pheatmap(sampleDistMatrix,
	                                 clustering_distance_rows = sampleDists,
	                                 clustering_distance_cols = sampleDists,
	                                 col = colors, main = "Sample-to-sample distances")
	              dev.off()
	            }, contentType = 'application/pdf')
	          
	          # volcano plot
	          DESeq2.res.table.dt.vp <- DESeq2.res.table.dt
	          DESeq2.res.table.dt.vp$col <- "lightcoral"
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
	        } else {
	          shinyWidgets::sendSweetAlert(
	            session = session,
	            title = "Sample names in the count matrix does not match the sample names in the sample information table!", type = "error",
	            text = NULL
	          )
	          NULL
	        }
	      }
	    })
	  } else {
	    output$DESeq2_result_table.txt <- downloadHandler(
	      filename <- function() { paste('DESeq2_result.txt') },
	      content <- function(file) {
	        NULL
	      }, contentType = 'text/plain'
	    )
	  }
	})
	
	## Download example input data
	output$Count_matrix_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_count_matrix.txt') },
	  content <- function(file) {
	    dat <- data.table::fread("LIR_sRNA_read_count_matrix.txt", data.table = F)
	    data.table::fwrite(dat, file = file, sep="\t")
	  }, contentType = 'text/plain'
	)
	
	output$Sample_info_table_Input.txt <- downloadHandler(
	  filename <- function() { paste('Example_sample_information_table.txt') },
	  content <- function(file) {
	    dat <- data.table::fread("LIR_sRNA_sample_info.txt", data.table = F)
	    data.table::fwrite(dat, file = file, sep="\t")
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
	
	
	# Target
	observe({
	  if (input$submitTarget>0) {
	    isolate({
	      target.Seq <- input$TargetPaste
	      target.Seq <- gsub("^\\s+", "", target.Seq)
	      target.Seq <- gsub("\\s+$", "", target.Seq)
	      
	      if (target.Seq == "") {
	        shinyWidgets::sendSweetAlert(
	          session = session,
	          title = "No input data received!", type = "error",
	          text = NULL
	        )
	        NULL
	      } else {
	        srna.tin.name <- uuid::UUIDgenerate()
	        srna.tin.name <- paste0(srna.tin.name, ".fasta")
	        srna.tin.name.file <- file.path(tempdir(), srna.tin.name)

	        if (grepl(">", target.Seq)) {
	          writeLines(target.Seq, con = srna.tin.name.file)
	        } else {
	          target.Seq.fa <- Biostrings::DNAStringSet(gsub("\\s+", "", unlist(strsplit(target.Seq, split="\n"))))
	          names(target.Seq.fa) <- 1:length(target.Seq.fa)
	          Biostrings::writeXStringSet(target.Seq.fa, file = srna.tin.name.file)
	        }

	        bowtie.cDNA.db <- paste0("www/LIRBase_cDNA_bowtiedb/", gsub("\\s\\(.+", "", input$Targetdb))
	        srna.cDNA.bowtie <- paste0(srna.tin.name.file, ".bowtie")

	        bowtie.cDNA.cmd <- paste0("bowtie -x ", bowtie.cDNA.db, " -f ", srna.tin.name.file, " -v ", input$MaxTargetMismatch, " -p 5 -k ", input$MaxTargetHit, " > ", srna.cDNA.bowtie)
	        system(bowtie.cDNA.cmd, wait = TRUE, timeout = 0)

	        if (file.exists(srna.cDNA.bowtie) && file.size(srna.cDNA.bowtie) >0) {
	          bowtie.cDNA.out <- data.table::fread(srna.cDNA.bowtie, data.table=F, head=F, select=c(2, 3, 4, 5))
	          names(bowtie.cDNA.out) <- c("strand", "mRNA", "Position", "sRNA")
	          bowtie.cDNA.out <- bowtie.cDNA.out[bowtie.cDNA.out$strand == "-", ]
	          bowtie.cDNA.out.wp <- bowtie.cDNA.out
	          bowtie.cDNA.out$Position <- NULL
	          bowtie.cDNA.out <- unique(bowtie.cDNA.out)
	          bowtie.cDNA.out$size <- nchar(bowtie.cDNA.out$sRNA)
	          bowtie.cDNA.out.summ <- bowtie.cDNA.out %>% dplyr::group_by(mRNA) %>% dplyr::summarise(sRNA_num = dplyr::n(), sRNA_21_num = length(size[size==21]),
	                                                                                   sRNA_22_num = length(size[size==22]), sRNA_24_num = length(size[size==24])
	                                                                                   ) %>% dplyr::arrange(dplyr::desc(sRNA_num))
	          
	          cDNA.info <- data.table::fread(paste0("www/LIRBase_cDNA_bowtiedb/", gsub("\\s\\(.+", "", input$Targetdb), ".cDNA.info.gz"), data.table = F)
	          bowtie.cDNA.out.summ <- merge(bowtie.cDNA.out.summ, cDNA.info, by.x="mRNA", by.y="gene")
	          bowtie.cDNA.out.summ <- bowtie.cDNA.out.summ[order(-bowtie.cDNA.out.summ$sRNA_num), ]
	          names(bowtie.cDNA.out.summ)[6] <- "mRNA_annotation"
	        } else {
	          bowtie.cDNA.out.summ <- NULL
	        }

	        output$sRNATargetResult <- DT::renderDT({
	          if (is.null(bowtie.cDNA.out.summ)) {
	            bowtie.cDNA.out.summ <- data.frame("V1"="No targets found for the input small RNAs!")
	            colnames(bowtie.cDNA.out.summ) <- ""
	          }
	          
	          DT::datatable(
	            bowtie.cDNA.out.summ, extensions = 'Buttons',
	            escape = FALSE, rownames= FALSE, selection="none", filter = 'top',
	            options = list(pageLength = 5, lengthMenu = c(5, 10, 20, 30, 50), autoWidth = FALSE, bSort=TRUE, scrollX = TRUE,
	                           buttons = list('pageLength', 'copy',
	                                       list(extend = 'csv',   filename = "mRNA_target_of_sRNAs_derived_from_LIR"),
	                                       list(extend = 'excel', filename = "mRNA_target_of_sRNAs_derived_from_LIR")
	                                       ),
	                           dom = 'Bfrtip',
	                           columnDefs=list(list(targets="_all")),
	                           initComplete = DT::JS(
	                             "function(settings, json) {",
	                             "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
	                             "}")
	            )
	          )
	        }, server = FALSE)
	        
	        output$downloadTargetResult <- downloadHandler(
	          filename <- function() { paste('gene_targets_of_sRNAs_encoded_by_a_LIR.txt') },
	          content <- function(file) {
	            data.table::fwrite(bowtie.cDNA.out.summ, file, sep="\t", quote=F)
	          }, contentType = 'text/plain'
	        )
	        
	        output$downloadTargetAlignm <- downloadHandler(
	          filename <- function() { paste('Alignment_of_small_RNAs_against_their_targets.txt') },
	          content <- function(file) {
	            bowtie.cDNA.out.wp$sRNA <- as.character(Biostrings::reverseComplement(Biostrings::DNAStringSet(bowtie.cDNA.out.wp$sRNA)))
	            bowtie.cDNA.out.wp$size <- nchar(bowtie.cDNA.out.wp$sRNA)
	            data.table::fwrite(bowtie.cDNA.out.wp, file, sep="\t", quote=F)
	          }, contentType = 'text/plain'
	        )
	        
	      }
	    })
	  } else {
	    output$downloadTargetResult <- downloadHandler(
	      filename <- function() { paste('gene_targets_of_sRNAs_encoded_by_a_LIR.txt') },
	      content <- function(file) {
	        NULL
	      }, contentType = 'text/plain'
	    )
	    
	    output$downloadTargetAlignm <- downloadHandler(
	      filename <- function() { paste('Alignment_of_small_RNAs_against_their_targets.txt') },
	      content <- function(file) {
	        NULL
	      }, contentType = 'text/plain'
	    )
	  }
	})
	
	observe({
	  if (input$clearTarget>0) {
	    isolate({
	      updateTextAreaInput(session, "TargetPaste", value="")
	      shinyWidgets::updatePickerInput(session, "Targetdb", selected = character(0))
	    })
	  } else {NULL}
	})
	
	observe({
	  if (input$TargetExam >0) {
	    isolate({
	      updateTextAreaInput(session, "TargetPaste", value = paste(readLines("exam_sRNA_4_target.txt"), collapse = "\n"))
	      shinyWidgets::updatePickerInput(session, "Targetdb", selected = "Oryza_sativa.MH63 (CDS + UTR)")
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
	      
	      vis.Seq <- gsub(":+", "_", vis.Seq)
	      vis.Seq <- gsub(",+", "_", vis.Seq)
	      vis.Seq <- gsub("-+", "_", vis.Seq)
	      
	      if ((length(vis.Seq) == 1) && (vis.Seq == "")) {
	        shinyWidgets::sendSweetAlert(
	          session = session,
	          title = "No input data received!", type = "error",
	          text = NULL
	        )
	      } else if (substr(vis.Seq, 1, 1) != ">") {
	        shinyWidgets::sendSweetAlert(
	          session = session,
	          title = "'>' expected at beginning of line 1 to indicate the ID of the input sequence!", type = "error",
	          text = NULL
	        )
	      } else {
	        rnafold.in.file <- uuid::UUIDgenerate()
	        rnafold.in.file <- paste0(rnafold.in.file, ".fasta")
	        rnafold.in.file <- file.path(tempdir(), rnafold.in.file)
	        writeLines(vis.Seq, con=rnafold.in.file)
	        
	        ## test sequence ID
	        vis.Seq.test <- Biostrings::readDNAStringSet(rnafold.in.file)
	        names(vis.Seq.test) <- gsub("^\\s+", "", names(vis.Seq.test))
	        names(vis.Seq.test) <- gsub("\\s+$", "", names(vis.Seq.test))
	        if (any(names(vis.Seq.test) == "")) {
	          shinyWidgets::sendSweetAlert(
	            session = session,
	            title = "Wrong input data!", type = "error",
	            text = "Empty sequence ID is not allowed!"
	          )
	        } else {
	          vis.Seq.fa <- Biostrings::readDNAStringSet(rnafold.in.file)
	          if (length(vis.Seq.fa) > 1) {
	            shinyWidgets::sendSweetAlert(
	              session = session,
	              title = "Only one input sequence is allowed at one time!", type = "error",
	              text = NULL
	            )
	          } else {
	            if (names(vis.Seq.fa) == "") {
	              names(vis.Seq.fa) <- gsub(".fasta$", "", rnafold.in.file)
	              Biostrings::writeXStringSet(vis.Seq.fa, file=rnafold.in.file)
	              vis.Seq.fa <- Biostrings::readDNAStringSet(rnafold.in.file)
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
	            
	            # RNAfold result file
	            if (length(rnafold.out) < 3) {
	              shinyWidgets::sendSweetAlert(
	                session = session,
	                title = "Wrong input data!", type = "error",
	                text = "Please check the content and the format of your input data!"
	              )
	            } else {
	              ## Display RNAfold result in text
	              output$RNAfold_2nd_structure_text_title <- renderText({
	                HTML('<i class="fa fa-circle" aria-hidden="true"></i> <font size="4" color="red"><b>Predicted secondary structure of the potential RNA encoded by the LIR:</b></font>')
	              })
	              
	              output$RNAfold_textview <- renderUI({
	                verbatimTextOutput("RNAfold_2nd_structure_text")
	              })
	              
	              output$RNAfold_2nd_structure_text <- renderText({
	                tmp.fl <- file.path(tempdir(), "rnafold.out.fa")
	                rnafold.out.BS <- Biostrings::BStringSet(rnafold.out)
	                Biostrings::writeXStringSet(rnafold.out.BS, file = tmp.fl, width = 120)
	                rnafold.out.format <- readLines(tmp.fl)
	                rnafold.out.format <- rnafold.out.format[rnafold.out.format != ">"]
	                rnafold.out.format
	              }, sep = "\n")
	              
	              oopt = animation::ani.options(autobrowse = FALSE)
	              png.file <- gsub("pdf$", "png", pdf.file)
	              animation::im.convert(pdf.file, output = png.file, extra.opts="-density 5000")
	              file.copy(from=png.file, to="www", overwrite = TRUE)
	              file.remove(png.file)
	              
	              output$RNAfold_pngview <- renderUI({
	                tags$img(src = png.file)
	              })
	              
	              output$downloadLIRstrPDF <- downloadHandler(
	                filename <- function() { paste('LIR_hpRNA_2nd_structure.pdf') },
	                content <- function(file) {
	                  if (file.exists(pdf.file)) {
	                    file.copy(pdf.file, file)
	                    file.remove(pdf.file)
	                  } else {
	                    NULL
	                  }
	                }, contentType = NULL
	              )
	              
	            }
	          }
	        }
	      }
	    })
	  } else {
	    output$downloadLIRstrPDF <- downloadHandler(
	      filename <- function() { paste('LIR_hpRNA_2nd_structure.pdf') },
	      content <- function(file) {
	        NULL
	      }, contentType = NULL
	    )
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
	      updateTextAreaInput(session, "VisualizePaste", value = paste(readLines("exam3.fa"), collapse = "\n"))
	    })
	  } else {NULL}
	})
	
	
	# Annotated inverted repeats of 427 genomes
	output$downloadTable = DT::renderDataTable({
	  IRF_result <- read.csv("IRF_result.csv", head=T, as.is=T)
	  DT::datatable(
	    IRF_result,
	    options = list(lengthMenu = c(20, 30, 50), pageLength = 15, scrollX = TRUE,
	                   searching = TRUE, bSort=FALSE, autoWidth = FALSE,
	                   buttons = list('pageLength', 'copy', 
	                               list(extend = 'csv',   filename = "LIRs_identified_in_427_genomes_basic_info"),
	                               list(extend = 'excel', filename = "LIRs_identified_in_427_genomes_basic_info")
	                               ),
	                   dom = 'Bfrtip',
	                   columnDefs=list(list(targets="_all"))
	    ), escape = FALSE, selection="none", rownames= FALSE, extensions = "Buttons"
	  )
	  
	}, server = FALSE)
  
	output$BLASTdbdownloadTable = DT::renderDataTable({
	  BLAST_db_down <- read.table("BLASTdb_download.txt", head=T, as.is=T, sep="\t")
	  DT::datatable(
	    BLAST_db_down,
	    options = list(lengthMenu = c(20, 30, 50), pageLength = 15, scrollX = TRUE,
	                   searching = TRUE, autoWidth = FALSE, bSort=FALSE,
	                   buttons = list('pageLength', 'copy', 
	                               list(extend = 'csv',   filename = "BLAST_databasse"),
	                               list(extend = 'excel', filename = "BLAST_databasse")
	                               ), 
	                   dom = 'Bfrtip',
	                   columnDefs=list(list(targets="_all"))
	    ), escape = FALSE, selection="none", rownames= FALSE, extensions = "Buttons"
	  )
	   
	}, server = FALSE)
	
	output$BowtiedbdownloadTable = DT::renderDataTable({
	  Bowtie_db_down <- read.table("Bowtiedb_download.txt", head=T, as.is=T, sep="\t")
	  DT::datatable(
	    Bowtie_db_down,
	    options = list(lengthMenu = c(20, 30, 50), pageLength = 15, scrollX = TRUE,
	                   searching = TRUE, autoWidth = FALSE, bSort=FALSE,
	                   buttons = list('pageLength', 'copy',
	                               list(extend = 'csv',   filename = "Bowtie_databasse"),
	                               list(extend = 'excel', filename = "Bowtie_databasse")
	                               ), 
	                   dom = 'Bfrtip',
	                   columnDefs=list(list(targets="_all"))
	    ), escape = FALSE, selection="none", rownames= FALSE, extensions = "Buttons"
	  )
	}, server = FALSE)
	
	# Information of 427 genomes
	output$genomeTable = DT::renderDataTable({
	  genomes <- read.csv("All_genomes.csv", head=T, as.is=T)
	  genomes$Source <- paste0("<a href='", genomes$Source,"' target='_blank'>", genomes$Source,"</a>")
	  genomes$Publication <- paste0("<a href='https://doi.org/", genomes$Publication,"' target='_blank'>", genomes$Publication,"</a>")
	  DT::datatable(
	    genomes,
	    options = list(lengthMenu = c(20, 30, 50), pageLength = 15, scrollX = TRUE,
	                   searching = TRUE, autoWidth = TRUE, bSort=FALSE,
	                   buttons = list('pageLength', 'copy', 
	                               list(extend = 'csv',   filename = "427_genomes_info"),
	                               list(extend = 'excel', filename = "427_genomes_info")
	                               ), 
	                   dom = 'Bfrtip',
	                   columnDefs=list(list(targets="_all"))
	                   ), escape = FALSE, selection="none", rownames= FALSE, extensions = "Buttons"
	  )
	}, server = FALSE)

	
})

