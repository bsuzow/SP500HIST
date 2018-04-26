#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# BYS 3.26.18
# The server.R for the SP500 Index ARR multi-year averages Shiny app.


library(shiny)
source('SP500MTH.R')

shinyServer(function(input, output) {
   
   library(readxl)  #http://readxl.tidyverse.org/
   library(dplyr)
   library(data.table)
   library(ggplot2)
   library(plotly)
   
   # Load the data
   # SP500MTH.xls has been created with the SP500 index monthly prices available at:
   # http://www.multpl.com/inflation-adjusted-s-p-500/table/by-month.
   #
   
   sp500mth = read_excel("SP500mth.xls",sheet="sp500", range="A1:B1085")
   sp500mth = sp500mth[-1,]  # remove the first row (which represents the index price of March 16.)
   names(sp500mth) = c("mth","index")
   sp500mth = as.data.frame(sp500mth[order(sp500mth$mth),])  # re-sort to make it ascending
   
   # Refine the data frame, sp500mth
   
   AR.df = annualRtn(sp500mth$index,sp500mth$mth)
   
   sp500mth = sp500mth %>% 
      mutate(s.mth=AR.df$s.mth,AR = AR.df$AR) %>%
      
      mutate(class = as.factor(ifelse(AR>0,"pos","neg"))) %>%
      mutate(s.mth.10yr = AR.df$s.mth.10yr,
             AR10=AR.df$AR10) %>% # adding the rolling annualized rtns
      mutate(class10yr = as.factor(ifelse(AR10>0,"pos","neg"))) %>%
      
      mutate(s.mth.20yr = AR.df$s.mth.20yr,
             AR20=AR.df$AR20) %>% # adding the rolling annualized rtns
      mutate(class20yr = as.factor(ifelse(AR20>0,"pos","neg"))) %>%
      
      mutate(e.mth = as.Date(mth,origin="1970-01-01")) # change the mth column to the Data class
   
   
   # input$ variables must be referenced within a reactive()
   
   startYR = reactive({
      paste(input$syear,"01","01",sep="-")
   })
   
   # SP500 10-yr ARR
   
   output$sp500TenYR <- renderPlotly({
      
      sp500ARR = sp500mth %>% select(s.mth.10yr,e.mth,AR10,class10yr)
      names(sp500ARR) = c("s.mth","e.mth","ARR","class")
      PlotARR(sp500ARR,startMonthForPlot= startYR(),year=10)
      
   }) # sp500TenYR
   
   
   # SP500 20-yr ARR
   
   output$sp500TwentyYR <- renderPlotly({
      
      sp500ARR = sp500mth %>% select(s.mth.20yr,e.mth,AR20,class20yr)
      names(sp500ARR) = c("s.mth","e.mth","ARR","class")
      PlotARR(sp500ARR,startMonthForPlot= startYR())
      
   })  # sp500TwentyYR
  
}) #shinyServer
