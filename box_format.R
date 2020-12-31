titleBox <- function(title) {
  fluidRow(
    box(
      width = 12, background = "navy",
      span(strong(title),
        style = "font-size:24px"
      )
    )
  )
}

sectionBox <- function(..., title) {
  fluidRow(
    box(...,
      width = 12,
      title = span(strong(title), style = "font-size:24px"), 
      solidHeader = TRUE, status = "warning", collapsible = FALSE
    )
  )
}

textBox <- function(...) {
  box(span(...,
        style = "font-size:18px"
      ), status = "success", width = 12)
}

messageBox <- function(...) {
  box(..., status = "danger", background = "green")
}

module_Box <- function(..., title, imgSrc, text) {
  box(
    ..., 
    title = span(title, style = "font-size:20px"),
    solidHeader = TRUE, status = "primary",
    fluidRow(
      column(
        width = 5,
        div(style = "margin-left:5px;margin-right:0px;margin-top:0px;",shiny::img(src = imgSrc, width = "100%", height = "100%"))
      ),
      column(
        width = 7,
        span(text, style = "font-size:18px"),
      )
    )
  )
}
