#####################################
############ SERVER #################
#####################################
library(ggnewscale)
library(viridis) 
library(sf)
library(tidyverse)
library(ggrepel)
library(fresh)
library(shiny)
library(shinydashboard)
library(usmap)
library(plotly)
library(dplyr)


word_count_per_period <- readRDS("rds/word_count_per_period.RDS")
top_words_q <- readRDS("rds/top_words_q.RDS")
bigram_network <- readRDS("rds/bigrams_united.RDS")
bigram_network <- readRDS("rds/bigram_network.RDS")
trigrams_united <- readRDS("rds/trigrams_united.RDS")
trigram_network <- readRDS("rds/trigram_network.RDS")
topic_coords <- readRDS("rds/topic_coords.RDS")
comparison_data <- readRDS("rds/comparison_data.RDS")
# usa <- st_as_sf(maps::map("state", fill=TRUE, plot =FALSE))



server <- function(input, output) { 
  
  # Render table for MPC Documents
  output$mpc_table <- renderTable({
    data.frame(
      "Released after each meeting" = c("MPC Decision Announcement", "MPC Minutes"),
      "Released on a quarterly basis" = c("Monetary Policy Report", "Analyst Meeting Slides")
    )
  }, align = "c", bordered = TRUE, striped = TRUE)
  
  
  ##### TAB OVERVIEW: INTERACTIVE PLOTLY PLOT #########
  output$plot_word_count <- renderPlotly({
    
    avg_early <- word_count_per_period %>%
      filter(year_quarter >= "2013-Q1" & year_quarter <= "2021-Q2") %>%
      summarise(avg = mean(n)) %>%
      pull(avg)
    
    avg_late <- word_count_per_period %>%
      filter(year_quarter >= "2021-Q3" & year_quarter <= "2023-Q4") %>%
      summarise(avg = mean(n)) %>%
      pull(avg)
    
    fig <- plot_ly(word_count_per_period, 
                   x = ~year_quarter, 
                   y = ~n, 
                   type = 'scatter', 
                   mode = 'lines+markers',
                   line = list(color = 'navy', width = 2),
                   marker = list(color = 'lightgrey', size = 2),
                   name = "Word Count")
    
    fig <- fig %>%
      add_trace(y = rep(avg_early, nrow(word_count_per_period)), 
                x = ~year_quarter, 
                type = 'scatter', 
                mode = 'lines',
                line = list(dash = "dash", color = "lightgrey", width = 1),
                name = "Avg: 2013-2021") %>%
      add_trace(y = rep(avg_late, nrow(word_count_per_period)), 
                x = ~year_quarter, 
                type = 'scatter', 
                mode = 'lines',
                line = list(dash = "dash", color = "lightgrey", width = 1),
                name = "Avg: 2021-2023")
    
    fig <- fig %>%
      layout(
        title = list(
          text = "<b>Word Count Trend Over Time</b>",
          x = 0.5  # Center title
        ),
        xaxis = list(title = "Year-Quarter", tickangle = 60),  # Rotate x-axis labels
        yaxis = list(title = "Word Count"),
        annotations = list(
          list(x = "2016-Q4", y = avg_early, text = paste0(format(round(avg_early, 0), big.mark = ","), " words"),
               showarrow = FALSE, font = list(color = "grey", size = 12)),
          list(x = "2022-Q3", y = avg_late, text = paste0(format(round(avg_late, 0), big.mark = ","), " words"),
               showarrow = FALSE, font = list(color = "grey", size = 12))
        )
      )
    
    fig
  })
  
  ##### TAB Words: INTERACTIVE PLOTLY PLOT #########
  filtered_words_year <- reactive({
    req(input$selected_year)
    
    top_words_q %>%
      filter(year == input$selected_year) %>%
      slice_head(n = 10)  # select 10 words
  })
  
  filtered_words_trends <- reactive({
    req(input$selected_words)  
    
    selected_words <- strsplit(input$selected_words, ",\\s*")[[1]]
    
    top_words_q %>%
      filter(word %in% selected_words) %>%
      mutate(year = as.numeric(year)) %>% 
      arrange(year)  
  })
  
  output$plot_common_words <- renderPlotly({
    data <- filtered_words_year()
    
    plot_ly(data, 
            x = ~n, 
            y = ~reorder(word, n), 
            type = 'bar', 
            orientation = 'h',
            marker = list(color = 'lightblue')) %>%
      layout(
        title = list(text = paste0("<b>Most Common Words in Monetary Policy Report: ", input$selected_year, "</b>"),
                     x = 0.5, font = list(size = 16)),
        xaxis = list(title = "Count"),
        yaxis = list(title = ""),
        margin = list(l = 100),
        plot_bgcolor = "white"
      )
  })
  
  # Render Plotly Line Chart for Word Trends Over Time
  output$plot_word_trends <- renderPlotly({
    data <- filtered_words_trends()
    
    plot_ly(data, 
            x = ~year, 
            y = ~ngram_percentage, 
            color = ~word, 
            text = ~paste("Year:", year, "<br>Percentage:", round(ngram_percentage, 2)), 
            type = 'scatter', 
            mode = 'lines+markers',  
            line = list(shape = "linear")) %>%
      layout(
        title = list(text = paste0("<b>Word Trends: ", input$selected_words, "</b>"),
                     x = 0.5, font = list(size = 16)),
        xaxis = list(title = "Year", tickmode = "array", tickvals = unique(data$year), tickangle = 45),
        yaxis = list(title = "Percentage"),
        margin = list(l = 100),
        plot_bgcolor = "white"
      )
  })
  
}