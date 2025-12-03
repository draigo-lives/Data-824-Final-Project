library(shiny)
library(tidyverse)
library(bslib)
library(ggExtra)
library(rlang)
library(plotly)
library(scales)

df <- read.csv("final.csv")
month_levels <- month.name

ui <- page_sidebar(
  title = h2("Find my Phone!", style="font-weight:bold; text-align:center;"),
  sidebar = sidebar(
    varSelectInput("xvar", "X Variable", df, selected = "brand"),
    varSelectInput("yvar", "Y Variable", df, selected = "price_usd"),
    checkboxGroupInput(
      "brand", "Brand",
      choices  = sort(unique(df$brand)),
      selected = unique(df$brand)
    ),
    hr(),
    checkboxInput("by_brand", "Show Brand", TRUE),
  ),
  plotlyOutput("scatter")
)

server <- function(input, output) {
  
  subsetted <- reactive({
    req(input$brand)
    df |>
      filter(brand %in% input$brand) |>
      mutate(
        release_month = factor(release_month, levels = month_levels, ordered = TRUE)
      )
  })
  
  output$scatter <- renderPlotly({
    
    data <- subsetted()
    
    req(input$xvar, input$yvar)
    
    x_name <- as_name(input$xvar)
    y_name <- as_name(input$yvar)
    req(nzchar(x_name), nzchar(y_name))
    
    x_is_num <- is.numeric(data[[x_name]])
    y_is_num <- is.numeric(data[[y_name]])
    

    if (x_is_num && y_is_num) {
      
      p <- ggplot(
        data,
        aes(
          x    = .data[[x_name]],
          y    = .data[[y_name]],
          text = paste("Model:", model)
        )
      ) +
        theme_minimal() +
        theme(legend.position = "bottom") +
        labs(x = x_name, y = y_name)
      
      if (input$by_brand) {
        p <- p + aes(color = brand)
      }
      
      p <- p + geom_point(alpha = 0.6)
      
      

    } else if (xor(x_is_num, y_is_num)) {
      
      if (!x_is_num && y_is_num) {
        cat_name <- x_name
        num_name <- y_name
        flip <- FALSE
      } else {
        cat_name <- y_name
        num_name <- x_name
        flip <- TRUE
      }
      
      p <- ggplot(
        data,
        aes(x = .data[[cat_name]], y = .data[[num_name]])
      ) +
        theme_minimal() +
        theme(legend.position = "bottom") +
        labs(x = cat_name, y = num_name)
      
      if (input$by_brand) {
        p <- p + aes(fill = brand, color = brand)
      }
      
      p <- p +
        geom_violin(alpha = 0.4, trim = FALSE) +
        geom_jitter(
          aes(text = paste("Model:", model)),
          width = 0.15,
          alpha = 0.7,
          size  = 1.5
        )
      
      if (flip) {
        p <- p + coord_flip()
      }
      

    } else {
      
      p <- ggplot(
        data,
        aes(
          x    = .data[[x_name]],
          fill = .data[[y_name]]
        )
      ) +
        geom_bar(position = position_dodge()) +
        theme_minimal() +
        theme(legend.position = "bottom") +
        labs(
          x    = x_name,
          y    = "Count",
          fill = y_name
        )
      
      if (input$by_brand) {
        p <- p + facet_wrap(~ brand)
      }
    }
    

    if (x_is_num && x_name == "price_usd") {
      p <- p + scale_x_continuous(labels = label_dollar())
    }
    if (y_is_num && y_name == "price_usd") {
      p <- p + scale_y_continuous(labels = label_dollar())
    }

    if (!x_is_num) {
      p <- p + theme(
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
      )
    }
    
    ggplotly(p, tooltip = "text")
  })
}

shinyApp(ui = ui, server = server)