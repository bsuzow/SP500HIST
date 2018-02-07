#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
   #library(xlsx)
   
   # Ran into problems with installing the xlsx package. 2-6-18
   # trying the readxl package.
   
   library(readxl)  #http://readxl.tidyverse.org/
   library(dplyr)
   library(data.table)
   library(ggplot2)
   library(plotly)
   
   # Load the data
   
   download.file("http://www.stern.nyu.edu/~adamodar/pc/datasets/histretSP.xls","histretSP.xls", mode="wb")
   
   sp500sum = read_excel("histretSP.xls",sheet="Returns by year", range="A18:J108")
   sp500raw = read_excel("histretSP.xls",sheet="S&P 500 & Raw Data", range="A2:F93")
   
   #sp500sum= read.xlsx("histretSP.xls", header=FALSE, startRow=19, endRow=108, 
   #                    sheetName="Returns by year")
   #sp500raw= read.xlsx("histretSP.xls", header=TRUE, startRow=2, endRow=93, 
   #                    sheetName="S&P 500 & Raw Data")
   
   names(sp500sum)= c("Year","sp500Rtn","TblRtn","TbnRtn","StkBal","TblBal",
                      "TbnBal","diff.S-Tbl","diff.S-Tbn","HRP")
   
   #sp500raw$Jan.1.notes=NULL  # remove Jan.1.notes column
   setnames(sp500raw,"S&P 500","sp500" )  # change the sp500 col name
   
   # merge the two DFs
   
   sp500 = merge(sp500raw, sp500sum, by="Year")
   
   sp500 = sp500 %>% mutate(Year = ts(Year))
   sp500 = sp500 %>% mutate(sp500Rtn.pct = round(sp500Rtn*100,2))
   sp500 = sp500 %>% mutate(TblRtn.pct   = round(TblRtn*100,2))
   sp500 = sp500 %>% mutate(TbnRtn.pct   = round(TbnRtn*100,2))
   
   # input$ variables must be referenced within a reactive()
   
   sp500net = reactive({
      
      sp500.df = sp500 %>% filter(Year>= input$syear)
      
   })
   
   # compose the note on tab4
   
   max.df = reactive({
      
      df = data.frame(sp500net()$StkBal,sp500net()$TblBal,sp500net()$TbnBal)
      names(df) = c("SP500","TBills","TBonds")
      
      SP500=paste0("$", formatC(max(df$SP500), format="f", digits=2, big.mark=","))
      TBL  =paste0("$", formatC(max(df$TBills), format="f", digits=2, big.mark=","))
      TBN  =paste0("$", formatC(max(df$TBonds), format="f", digits=2, big.mark=","))
      data.frame("SP500"=SP500,"TBL"=TBL,"TBN"=TBN)
   })
      
      
   #  
   output$sp500_100USD  = renderUI({
      
      HTML(
         paste0("<B>The $100 invested in 1928 in:</B>","<br>",
             " S&P 500 would grow to ",max.df()$SP500," in 2017.<br>",
             " 3-month T-bills to ", max.df()$TBL,"in 2017.<br>",
             " 10-year T-bonds to ", max.df()$TBN,"in 2017.", sep="") 
      )
   }) #sp500_100USD

   # Assign the stats text to the output variable defined in UI
   # ref on renderUI : https://stackoverflow.com/questions/23233497/outputting-multiple-lines-of-text-with-rendertext-in-r-shiny   
  
   # SP500 vs Risk-free
   
   output$sp500Rtn <- renderPlotly({
      
      
      sp500Rtn = sp500net() %>% select(Year,sp500Rtn, TblRtn, TbnRtn)
      
      pal = c("blue","red","purple")  # does not have an effect
      
      p1 = plot_ly(sp500Rtn,x=~Year, y=~sp500Rtn, name="S&P500",type="scatter",
                   mode="lines", colors=pal) %>%
         add_trace(y=~TblRtn, name="3-mth T-Bill", mode="lines") %>%
         add_trace(y=~TbnRtn, name="10-yr T-Bond", mode="lines")
      p1
      
      
   }) # sp500Rtn
   
   # SP500 Index historical returns
   
   output$sp500Idx <- renderPlotly({
      
      ylabel = list(title="S&P 500 Index")
      
      p2 = plot_ly(sp500net(),x=~Year, y=~sp500,
                   text= ~paste("Year: ",as.character(Year),"<br>Index: ",
                                sp500,"<br>Return: ",sp500Rtn.pct,"%", sep=""),
                   type="scatter",mode="lines") %>%
         
         plotly::layout(yaxis = ylabel)
      p2 
      
   })  # sp500Idx
   
   # SP500 vs Risk-free Box plots
   
   output$sp500Box <- renderPlotly({
      
      ylabel = list(title="Percentage")
      p3 = plot_ly(sp500net(), y=~sp500Rtn.pct,
                   name="S&P500",type="box") %>%
         add_trace(y=~TblRtn.pct,name="T-Bill") %>%
         add_trace(y=~TbnRtn.pct,name="T-Bond") %>%
         plotly::layout(yaxis = ylabel)
      
      p3
      
   })  # SP500Box
 
   output$sp500_100dollars <- renderPlotly({
      
      sp500Rtn = sp500net() %>% select(Year,sp500Rtn, TblRtn, TbnRtn)
      
      ylabel = list(title="Log2($$)")
      
      p4 = plot_ly(sp500net(),x=~Year, y=~log2(StkBal),
                   name="S&P500",
                   text= ~paste("Year: ",as.character(Year),
                                "<br><br>SP500: $", round(StkBal,2),
                                "<br><br>T-Bill: $",round(TblBal,2),
                                "<br><br>T-Bond: $",round(TbnBal,2), sep=""),
                   type="scatter",mode="line")  %>%
         
         add_trace(y=~log2(TblBal), name="T-Bill", mode="lines") %>%  
         add_trace(y=~log2(TbnBal), name="T-Bond", mode="lines") %>%
         plotly::layout(yaxis = ylabel)
      p4
      
   })  # SP500Box
   
  
}) #shinyServer
