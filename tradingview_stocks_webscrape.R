## Tradingview Webscrape Stocks
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag

# Load libraries:
  
library(dplyr)
library(tidyr)
library(rvest)
library(stringr)
library(writexl)

## Extract USA large cap stocks on Tradingview:

page <- read_html("https://www.tradingview.com/markets/stocks-usa/market-movers-large-cap/")

table <- page %>% html_element('tbody')

# Company Name:
name <- table %>% html_nodes(xpath = '//*[@class = "tv-screener__description"]') %>% html_text2()

# Stock Tickers:
tickers <- table %>% html_nodes(xpath = '//*[@class = "tv-screener__symbol"]') %>% html_text2() 
tickers <- tickers[seq(1, length(tickers), 2)]

# Company Sector:
sector <- table %>% html_nodes(xpath = '//*[@class = "tv-screener__symbol"]') %>% html_text2() 
sector <- sector[seq(2, length(sector), 2)]

## Table Data in 'td`` tags in HTML 
## For obtaining price, changes in % and amount, Tech Rating, Volume, Vol*Price & Market Cap:

table_data <- table %>% html_elements('td') %>% html_text2()

# Closing Price
price <- table_data[seq(2, length(table_data), 12)] 

# Change %
change_pct <- table_data[seq(3, length(table_data), 12)] 

# Change Amount in USD
change_amt <- table_data[seq(4, length(table_data), 12)] 

# Technical Rating
tech_rating <- table_data[seq(5, length(table_data), 12)]  

# Volume
volume <- table_data[seq(6, length(table_data), 12)] 

# Volume*Price
volume_price <- table_data[seq(7, length(table_data), 12)] 

# Market Cap
mcap <- table_data[seq(8, length(table_data), 12)] 

### Create Dataframe based on raw data:

tview_stocks <- data.frame(
  Ticker = tickers,
  Company = name,
  Sector = sector,
  Close_Price = price,
  Change_Pct = change_pct,
  Change_Amt = change_amt,
  Volume = volume,
  Volume_Times_Price = volume_price,
  Market_Cap = mcap
)

## Preview table:

head(tview_stocks, 10)

### Save Raw data Dataframe as Excel File:

library(writexl)

write_xlsx(tview_stocks, paste("TradingView_Stocks_", Sys.Date(), ".xlsx", sep = ""))

## Save dataframe as .csv File Option:

write.csv(tview_stocks, paste("TradingView_Stocks_", Sys.Date(), ".csv", sep = ""), row.names = FALSE)
