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
  
  ##### INTERACTIVE PLOTLY PLOT #########
  output$plot_word_count <- renderPlotly({
    
    avg_early <- word_count_per_period %>%
      filter(year_quarter >= "2013-Q1" & year_quarter <= "2021-Q2") %>%
      summarise(avg = mean(n)) %>%
      pull(avg)
    
    avg_late <- word_count_per_period %>%
      filter(year_quarter >= "2021-Q3" & year_quarter <= "2023-Q4") %>%
      summarise(avg = mean(n)) %>%
      pull(avg)
    
    # Create the Plotly visualization
    fig <- plot_ly(word_count_per_period, 
                   x = ~year_quarter, 
                   y = ~n, 
                   type = 'scatter', 
                   mode = 'lines+markers',
                   line = list(color = 'navyblue', width = 2),
                   marker = list(color = 'navyblue', size = 6),
                   name = "Word Count")
    
    # Add average lines
    fig <- fig %>%
      add_trace(y = rep(avg_early, nrow(word_count_per_period)), 
                x = ~year_quarter, 
                type = 'scatter', 
                mode = 'lines',
                line = list(dash = "dash", color = "lightgrey", width = 1),
                name = "Early Avg") %>%
      add_trace(y = rep(avg_late, nrow(word_count_per_period)), 
                x = ~year_quarter, 
                type = 'scatter', 
                mode = 'lines',
                line = list(dash = "dash", color = "lightgrey", width = 1),
                name = "Late Avg")
    
    # Add text annotations for averages
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
  
}