#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# BYS 3.28.18
# The UI for the SP500 Index Annualized Rolling Returns Shiny app.
# 2-tab construct in the main panel.


library(shiny)

shinyUI(fluidPage(
   
   # Application title
   titlePanel("S&P 500 Index - Annualized Rolling Returns"),
   
   # the following code makes the selected tab title render in black font
   
   tags$style(HTML("
                   .tabs-above > .nav > li[class=active] > a {
                   background-color: #FFF;
                   color: #000;
                   }")),
  
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         
         p("Since February 2018, volatility observed in the stock market makes average 
investors concerned. While the mean of SP500's calendar year returns  
since 1928 is 13.87%, it took 13 years to recover the 1999's peak from the two crashes.  
This application visualizes annualized rolling returns (ARRs) to help you better understand volatilities 
which the calendar year based return averages may hide."),
         br(),
         hr(),
         
         h4("Please choose a start year in the slider below"),
         sliderInput("syear",
                     "Start Year:",
                     min = 1968,
                     max = 2018,
                     value = 1968,
                     step = 1,
                     sep=""),
         
         br(),
         hr(),
         br(),   
         
         a(href="http://www.multpl.com/inflation-adjusted-s-p-500/table/by-month","Data Source"),
         br(),
         a(href="https://www.thebalance.com/rolling-returns-versus-average-annual-returns-2388654",
           "More info on ARR")
         
         ),  # sidebarPanel
      
      # Show a plot of the generated distribution
      mainPanel(
         tabsetPanel(type="tabs",
                     
                     tabPanel("S&P500 ARR 10-Year Average",
                              br(),
                              tags$h4("Hover for details"),
                             
                              hr(),
                              plotly::plotlyOutput("sp500TenYR")
                              
                     ), # tabPanel - SP500 vs RF
                     
                     tabPanel("S&P500 ARR 20-Year Average",
                              br(),
                              tags$h4("Hover for details"),
                              
                              hr(),
                              plotly::plotlyOutput("sp500TwentyYR")
                              
                     ) # tabPanel - SP500 index perf
                    
         ) # tabsetPanel
      ) # mainPanel
   ) #sidebarLayer
   )) #shinyUI
