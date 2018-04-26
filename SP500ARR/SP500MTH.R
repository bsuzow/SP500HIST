# SP500MTH.R
# BYS 3.18.18

# Collection of R functions needed for the SP500HIST project

#--------------------
# function: annualRtn
#--------------------

annualRtn = function(index,mth){
   # Purpose:
   #     Calculate the mean of every 12 rows in rolling
   #        (i.e. means of [1:12],[2:13],[3,14], etc.)
   #
   # Output: A data frame with annualized returns, 10-yr ARR avgs, and 12th month of each period as columns
   #
   # Arguments:
   #     index: a numeric vector
   #     s.mth: a POSIXct vector for dates associated with the index argument
   
   AR = numeric()  # annualized rolling returns vector
   AR10 = numeric() # ARR average over 10 years
   AR20 = numeric() # ARR average over 20 years
   
   s.mth = as.Date(vector())       # start months vector
   s.mth.10yr = as.Date(vector())  # start months for 10-yr ARRs
   s.mth.20yr = as.Date(vector())
   
   length = length(index)
   
   for (i in 12:(length)) {
      AR[i]   = (index[i]-index[i-11])/index[i-11]*100
      s.mth[i] = as.Date(mth[i-11],origin="1970-01-01")
   } # for-loop
   
   AR[1:11]=NA
   s.mth[1:11] = NA
   
   AR.df = data.frame(AR=AR, s.mth=s.mth)
   
   startIndex= 12*10
   offset10yr=119   # 12 * 10 - 1
  
   for (k in (12+offset10yr):(length)){    # The first month ARR is available is Dec 1928. 
                                       # The first month 10yr ARR avg is available is row 131 (Nov 1938 as the last month of the first 10 yr pd)
      AR10[k] = mean(AR[(k-offset10yr):k])
      s.mth.10yr[k] = as.Date(mth[k-offset10yr])
   }
   AR10[1:(12+offset10yr-1)] = NA
   s.mth.10yr[1:(12+offset10yr-1)] = NA
   
   AR.df = AR.df %>% mutate(AR10 = AR10) %>% mutate(s.mth.10yr = s.mth.10yr)
   
   offset20yr = 239 # 12 * 20 -1
   
   for (k in (12+offset20yr):(length)){    # 
      
      AR20[k] = mean(AR[(k-offset20yr):k])
      s.mth.20yr[k] = as.Date(mth[k-offset20yr])
   }
   AR10[1:(12+offset10yr-1)] = NA
   s.mth.10yr[1:(12+offset10yr-1)] = NA
   
   AR20[1:(12+offset20yr-1)] = NA
   s.mth.20yr[1:(12+offset20yr-1)] = NA
   
   AR.df = AR.df %>% mutate(AR10 = AR10, s.mth.10yr = s.mth.10yr,
                            AR20 = AR20, s.mth.20yr = s.mth.20yr)
   
   
} # annualRtn()


PlotARR = function(df,startMonthForPlot="1998-01-01",year=20){
   
   # Purpose: Data plot of the df dataframe x: endinging month (df$e.mth) & y: ARR Avgs of 1 or 10, 20 yrs
   # Output:  Scatter Plot
   # Arguments:
   #  df: The dataframe of SP500 ARRs
      # columns: AR, s.mth, e.mth, class
   #  startMonthForPlot: The cutoff month in which the plotting starts
   #  year: the # of years over which ARRs would be averaged.
   
   
   if(year != 1 && year!= 10 && year != 20) {
      stop("The year parameter should be set to 1, 10 or 20")
   }
   df.net = df %>% filter(!is.na(ARR)) %>%
      filter(e.mth>=as.Date(startMonthForPlot,"%Y-%m-%d"))
   
   
   max <- df.net[which.max(df.net$ARR), ]   
   
   # For annotating the maxing value. 
   max.annotate <- list(   
      x = max$e.mth,
      y = max$ARR,
      #text = rownames(max),  # to be changed
      text = paste0(max$s.mth," thru ",max$e.mth,"<br>Avg of Annualized Rolling Returns (%): ",round(max$ARR,2)),
      xref = "x",
      yref = "y",
      showarrow = TRUE,
      arrowhead = 7,
      ax = 70,
      ay = -40
      
   )
   
   f <- list(
      family = "Arial",
      size = 18,
      color = "black"
   )
   
   x <- list(
      title = "Ending Month of Annualized Rolling Returns (ARR) Period",
      titlefont = f
   )
   
   y <- list(
      title = "Annualized Rolling Returns (ARR) Average",
      ticksuffix="%",
      titlefont = f
   )
   
   if (year == 20){
      p.title = "20-year Annualized Rolling Returns Average"
   } else if (year == 10) {
      p.title = "10-year Annualized Rolling Returns Average"
   } else {
      p.title = "Annualized Rolling Returns Average"
   }
   
   if (sum(as.character(df.net$class)=="neg")==0) { # no negative y values
      markerParamValue =list(color="#145A32",opacity=.5) # plot all points in green
   } else {
      markerParamValue =list(color=factor(df.net$class,labels=c("red","green")),opacity=.5)
   }
  
   p.ARR = plot_ly(df.net,x=~e.mth, y=~ARR, 
                     hoverinfo = 'text',
                     text = ~paste0("Starting Month: ",s.mth,"<br>Ending Month: ",e.mth,
                                   "<br>ARR Avg: ",round(ARR,2), "%"),
                     type="scatter",
                     mode="markers",
                     
                     marker=markerParamValue) %>%
                     add_markers() %>% 
      
                     #plotly::layout(title = p.title,
                     plotly::layout(
                     xaxis = x, 
                     yaxis = y,
                    # annotations = max.annotate,   # max ARR annotation
                     showlegend=FALSE) %>%
   
                     add_annotations(
                        x= .5,
                        y= 1,
                        xref = "paper",
                        yref = "paper",
                        text = paste0("<b>",p.title,"</b>"),
                        showarrow = F
                     ) 
   p.ARR  
   
}  # PlotARR
