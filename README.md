# S&P 500 Index Fund Historic Data Analysis

This repo is created for exploratory data analyses of the S&P 500 (SP500) Index Fund performance.  The stock market has been volatile since Febrary 2018.  While the SP500's mean of calendar year returns since 1928 is over 13%, it took 13 years to return to the 1999's peak from the two crashes.  Is the index fund a good investment tool in comparison with risk-free Treasuries in a long term?  What does its historic data tell us how long "a long term" should be? 

Datasets in the tabular form are more efficiently communicated to the audience via visualization tools. I chose [Shiny](https://shiny.rstudio.com/) for unpack the datasets and answer the questions.  R Shiny allows developers to present multiple plots with relative ease.  The user of an Shiny product can play with data interactively using buttons and/or sliders.  

In this repo, two Shiny apps are featured:
- [S&P 500 Performance](http://www.suzow.us/SP500_Performance) -- comparison with short-term and long-term bond funds
- [S&P 500 Annualized Rolling Returns](http://www.suzow.us/SP500ARR)

[Data source:](http://www.stern.nyu.edu/~adamodar/pc/datasets/histretSP.xls) courtesy of [Prof. Damodaran](http://www.stern.nyu.edu/~adamodar)

