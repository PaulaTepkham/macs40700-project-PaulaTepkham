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

#icon list:
#https://fontawesome.com/icons


mytheme <- create_theme(
  adminlte_color(
    light_blue = "#2E3440"
  ),
  adminlte_sidebar(
    width = "400px",
    dark_bg = "lightgrey",
    dark_hover_bg = "darkblue",
    dark_color = "#2E3440",
    dark_submenu_bg = "lightgrey",
    dark_submenu_color = "#2E3440",
    dark_submenu_hover_color = "darkblue"
  ),
  adminlte_global(
    content_bg = "#FFF",
    box_bg = "#D8DEE9", 
    info_box_bg = "#D8DEE9"
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Monetary Policy Report: Text Analysis"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("globe")),
      
      menuItem("Analysis", icon = icon("chart-bar"), startExpanded = TRUE,
               menuSubItem("Common Words", tabName = "words", icon = icon("font")),
               menuSubItem("Common Bigrams", tabName = "bigrams", icon = icon("columns")),
               menuSubItem("Topic Modelings", tabName = "topics", icon = icon("layer-group"))
      )
    )
  ),
  
  ## Body content
  dashboardBody(
    use_theme(mytheme),  
    
    tabItems(
      ##### TAB OVERVIEW: INTERACTIVE PLOTLY PLOT #########
      tabItem(
        tabName = "overview",
        div(
          style = "display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;",
          
          div(
            style = "flex: 1; text-align: left; color: darkblue;",
            h2("Text Analysis on A More Robust Monetary Policy Shock: A Natural Language Processing Approach of Thailand’s Monetary Policy Reports"),
            h4(style = "text-align: left; color: gray;", 
               "This analysis is a part of a master's thesis that explores a new approach to measuring monetary policy shocks in Thailand's Monetary Policy Reports.")
          ),
          
          div(
            style = "flex: 1; text-align: right;",
            h3("Phornchanok (Paula) Tepkham"),
            p("MACSS-ECON, University of Chicago"),
            p("Last updated: March 12, 2025"),
            img(src = "img/paula_profile.png", height = "120px", style = "border-radius: 50%;")
          )
        ),
        
        h3(style = "text-align: left;", "Research Introduction"),
        p(style = "text-align: left;", 
          "In order to study the real effect of monetary policy on the economy, macroeconomists must distinguish changes in interest rates from anticipated responses to economic constraints.
     This research proposes an identification approach to monetary policy text shocks, leveraging both numerical and textual information from the Bank of Thailand's policy documents.
     The goal is to refine the original Romer & Romer (2004) approach by incorporating text-based data to improve monetary policy shock estimation."),
        
        tabsetPanel(
          
          #### Tab: Text Processing Steps
          tabPanel("Text Processing Steps",
                   h3("Text Processing Steps"),
                   p("Raw text from each document is processed using multiple steps. First, stop words are removed using",
                     a("Loughran-McDonald's Stop Word List", href="https://sraf.nd.edu/textual-analysis/stopwords/"),
                     "which includes general stop words, dates, numbers, and names. Then, each document is tokenized by breaking it into single words, Bigrams, and Trigrams."),
                   
                   h3("Types of MPC Documents Used in Analysis"),
                   tableOutput("mpc_table"),  # Table will be rendered in server.R
                   p(HTML("I will only use Monetary Policy Report in this analysis."))),
          
          #### Tab: Descriptives
          tabPanel("Descriptives",
                   h3("Descriptive Statistics of Monetary Policy Reports"),
                   p(HTML("The figure below illustrates the trends in the word count of the <b>Monetary Policy Reports</b> from 2013 to 2023.
                   Over the decade, the <b>average word count per quarterly document</b> was approximately <b>20,852 words</b> before Q2 2021.
                   However, a <b>significant reduction occurred after Q2 2021</b>, with word counts dropping to below <b>14,158 words</b> per document.
                   This shift may indicate <b>changes in reporting style or content emphasis</b> due to reporting policy changes after the beginning of COVID-19.")),
                   
                   br(),
                   h3("Word Count Trends in Monetary Policy Reports"),
                   plotlyOutput("plot_word_count"),
                   br()
          )
        ),
        
        h3("Code Repository"),
        tags$ul(
          tags$li(a("Github Repository",
                    href="https://github.com/PaulaTepkham/macs40700-project-PaulaTepkham.git", target="_blank"))
        )
      ),
      
      ##### TAB Words: INTERACTIVE PLOTLY PLOT #########
      tabItem(
        tabName = "words",
        h2("Common Words Analysis"),
        
        sliderInput("selected_year", "Select Year:",
                    min = min(top_words_q$year), 
                    max = max(top_words_q$year), 
                    value = 2020, step = 1, 
                    animate = TRUE),
        
        plotlyOutput("plot_common_words"),
    
        h2("Word Trend Analysis"),
        
        textInput("selected_words", "Enter Words (comma-separated):", 
                  value = "inflation, covid, exports"),
        
        plotlyOutput("plot_word_trends")
      ),
      
      ##### TAB Bigrams #########
      tabItem(
        tabName = "bigrams",
        h2("Most Common Bigrams in Monetary Policy Reports"),
        plotlyOutput("plot_common_bigrams"),
        br(),
        h2("Bigram Network in Monetary Policy Reports"),
        plotlyOutput("plot_bigram_network")
      ),
      
      ##### TAB Topic Modeling #########
      tabItem(
        tabName = "topics",
        h2("Intertopic Distance Map (t-SNE Projection)"),
        plotlyOutput("plot_topic_map"),
        br(),
        h2("Comparison of Term Frequencies Across Topics"),
        selectInput("selected_topic", "Select Topic:",
                    choices = unique(comparison_data$topic_name),  
                    selected = unique(comparison_data$topic_name)[1]),  
        plotlyOutput("plot_term_frequencies")
      )
    )
  )
)