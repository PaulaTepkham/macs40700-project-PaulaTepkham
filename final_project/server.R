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
library(igraph)


word_count_per_period <- readRDS("rds/word_count_per_period.RDS")
top_words_q <- readRDS("rds/top_words_q.RDS")
bigram_network <- readRDS("rds/bigrams_united.RDS")
bigram_network <- readRDS("rds/bigram_network.RDS")
trigrams_united <- readRDS("rds/trigrams_united.RDS")
trigram_network <- readRDS("rds/trigram_network.RDS")
topic_coords <- readRDS("rds/topic_coords.RDS")
comparison_data <- readRDS("rds/comparison_data.RDS")
# usa <- st_as_sf(maps::map("state", fill=TRUE, plot =FALSE))

bigrams_overall <- bigrams_united %>%
  count(bigram, sort = TRUE) %>%
  slice_max(n, n = 10) 

edges_df <- as_data_frame(bigram_network, what = "edges")  
colnames(edges_df) <- c("from", "to", "weight")  # Ensure proper column names
nodes_df <- data.frame(id = V(bigram_network)$name)
layout <- layout_with_fr(bigram_network)  # Generates node positions
nodes_df <- nodes_df %>%
  mutate(x = layout[, 1], y = layout[, 2])  # Assign x, y positions

edges_df <- edges_df %>%
  left_join(nodes_df, by = c("from" = "id")) %>%
  rename(x_start = x, y_start = y) %>%
  left_join(nodes_df, by = c("to" = "id")) %>%
  rename(x_end = x, y_end = y)

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
  
  ##### TAB bigrams #########
  
  
  
  output$plot_common_bigrams <- renderPlotly({
    plot_ly(bigrams_overall, 
            x = ~n, 
            y = ~reorder(bigram, n), 
            type = 'bar', 
            orientation = 'h',
            marker = list(color = 'lightblue')) %>%
      layout(
        title = list(text = "<b>Most Common Bigrams in Monetary Policy Reports</b>",
                     x = 0.5, font = list(size = 16)),
        xaxis = list(title = "Count"),
        yaxis = list(title = ""),
        margin = list(l = 100),
        plot_bgcolor = "white"
      )
  })
  
  
  output$plot_bigram_network <- renderPlotly({
    
    plot_ly() %>%
      # Add edges (connections between words)
      add_segments(
        x = ~edges_df$x_start, y = ~edges_df$y_start,
        xend = ~edges_df$x_end, yend = ~edges_df$y_end,
        line = list(color = 'gray', width = 1, opacity = 0.5),
        hoverinfo = "none"
      ) %>%
      
      # Add nodes (words)
      add_trace(
        data = nodes_df,
        x = ~x, y = ~y, 
        text = ~id, 
        type = "scatter", mode = "markers+text",
        textposition = "top center",
        marker = list(size = 10, color = "lightblue", opacity = 0.8)
      ) %>%
      
      layout(
        title = list(text = "<b>Bigram Network in Monetary Policy Reports</b>", x = 0.5),
        xaxis = list(title = "", showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(title = "", showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        plot_bgcolor = "white"
      )
  })
  
  ##### TAB LDA #########
  output$plot_topic_map <- renderPlotly({
    
    plot_ly(topic_coords, 
            x = ~X, 
            y = ~Y, 
            text = ~paste("", Topic), 
            type = "scatter", 
            mode = "markers+text",
            textposition = "top center",
            color = ~Topic, 
            marker = list(size = 10, opacity = 0.7)) %>%
      layout(
        title = list(text = "<b>Intertopic Distance Map (t-SNE Projection)</b>", x = 0.5),
        xaxis = list(title = "t-SNE Dimension 1"),
        yaxis = list(title = "t-SNE Dimension 2"),
        legend = list(title = list(text = "Topic")),
        plot_bgcolor = "white"
      )
  })
  
  filtered_terms <- reactive({
    req(input$selected_topic)  # Ensure input is available
    
    comparison_data %>%
      filter(topic_name == input$selected_topic)  # Filter data for the selected topic
  })
  
  output$plot_term_frequencies <- renderPlotly({
    data <- filtered_terms()
    
    plot_ly(data, 
            x = ~beta, 
            y = ~reorder(term, beta), 
            type = 'bar', 
            orientation = 'h',
            name = "Selected Topic",
            marker = list(color = '#000080', opacity = 0.8)) %>%
      
      add_trace(x = ~overall_beta, 
                y = ~reorder(term, beta), 
                type = 'bar', 
                name = "Overall Frequency",
                marker = list(color = 'grey', opacity = 0.5)) %>%
      
      layout(
        title = list(text = paste0("<b>Term Frequencies for Topic: ", input$selected_topic, "</b>"),
                     x = 0.5, font = list(size = 16)),
        xaxis = list(title = "Beta Value (Topic Probability)"),
        yaxis = list(title = "Term"),
        barmode = "overlay",  # Overlay bars for comparison
        margin = list(l = 150),  # Adjust left margin for readability
        plot_bgcolor = "white",
        legend = list(title = list(text = "Frequency Type"))
      )
  })
}