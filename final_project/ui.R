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
library(shinythemes) 

word_count_per_period <- readRDS("rds/word_count_per_period.RDS")
top_words_q <- readRDS("rds/top_words_q.RDS")
bigram_network <- readRDS("rds/bigrams_united.RDS")
bigram_network <- readRDS("rds/bigram_network.RDS")
trigrams_united <- readRDS("rds/trigrams_united.RDS")
trigram_network <- readRDS("rds/trigram_network.RDS")
topic_coords <- readRDS("rds/topic_coords.RDS")
comparison_data <- readRDS("rds/comparison_data.RDS")
# usa <- st_as_sf(maps::map("state", fill=TRUE, plot =FALSE))

#icon list:
#https://fontawesome.com/icons



# Define custom theme
mytheme <- create_theme(
  adminlte_color(
    light_blue = "darkblue"
  ),
  adminlte_sidebar(
    width = "400px",
    dark_bg = "lightgrey",
    dark_hover_bg = "lightblue",
    dark_color = "#2E3440"
  ),
  adminlte_global(
    content_bg = "#FFF",
    box_bg = "#D8DEE9", 
    info_box_bg = "#D8DEE9"
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Monetary Policy Report: Text Analysis"),
  
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview Data", tabName = "overview", icon = icon("globe")),
      
      menuItem("Analysis", icon = icon("chart-bar"), startExpanded = TRUE,
               menuSubItem("Common Words", tabName = "words", icon = icon("font")),
               menuSubItem("Common Bigrams", tabName = "bigrams", icon = icon("columns")),
               menuSubItem("Topic Modelings", tabName = "topics", icon = icon("layer-group"))
      )
    )
  ),
  
  ## Body content
  dashboardBody(
    use_theme(mytheme),  # Apply custom fresh theme
    
    tabItems(  # Wrap all tabItem() inside tabItems()
      
      # Overview Tab
      tabItem(
        tabName = "overview",
        h2("Word Count Trend Over Time"),
        plotlyOutput("plot_word_count"),
        width = 11
      ),
      
      # Common Words Tab
      tabItem(
        tabName = "words",
        h2("Common Words Analysis"),
        plotOutput("plot_common_words")  # Placeholder for visualization
      ),
      
      # Common Bigrams Tab
      tabItem(
        tabName = "bigrams",
        h2("Common Bigrams Analysis"),
        plotOutput("plot_common_bigrams")  # Placeholder for visualization
      ),
      
      # Topic Modelings Tab
      tabItem(
        tabName = "topics",
        h2("Topic Modelings"),
        plotOutput("plot_topic_modeling")  # Placeholder for visualization
      )
    )
  )
)