#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("S&P 500 Index Performance"),
  
  # the following code makes the selected tab title render in black font
  
  tags$style(HTML("
        .tabs-above > .nav > li[class=active] > a {
                  background-color: #FFF;
                  color: #000;
                  }")),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       
       h3("This application lets you interactively see the S&P 500 Index 
          historical performance."),
       br(),
       hr(),
       
       h4("Please enter a start year"),
       sliderInput("syear",
                   "Start Year:",
                   min = 1928,
                   max = 2017,
                   value = 2000,
                   step = 1,
                   sep=""),
      
       br(),
       hr(),
       
       # br(),
       br(),   
       
       a("Data Source:",
            href="http://www.stern.nyu.edu/~adamodar/pc/datasets/histretSP.xls",
            "histretSP.xls"),
       br(),
       a("contributed by Prof. Damodaran", 
         href="http://pages.stern.nyu.edu/~adamodar/")
       
    ),  # sidebarPanel
    
    # Show a plot of the generated distribution
    mainPanel(
       tabsetPanel(type="tabs",
                   
                   tabPanel("S&P500 vs Risk-free",
                            br(),
                           # htmlOutput("html1"),
                           # hr(),
                            plotly::plotlyOutput("sp500Rtn")
                   ), # tabPanel - SP500 vs RF
                   
                   tabPanel("S&P500 Index Performance",
                            br(),
                           # htmlOutput("html2"),
                           # hr(),
                            plotly::plotlyOutput("sp500Idx")
                            
                   ), # tabPanel - SP500 index perf
                   
                   tabPanel("S&P 500 Index vs Risk-free Boxplot",
                            br(),
                           # htmlOutput("html3"),
                           # hr(),
                            plotly::plotlyOutput("sp500Box")   
                           
                            
                   ), # tablPanel - SP500 vs RF boxplot
                   
                   tabPanel("$100 invested in 1928",
                            br(),
                            htmlOutput("sp500_100USD"),
                            hr(),
                            plotly::plotlyOutput("sp500_100dollars")   
                            
                            
                   ) # tablPanel - SP500 vs RF boxplot
       ) # tabsetPanel
    ) # mainPanel
  ) #sidebarLayer
)) #shinyUI
