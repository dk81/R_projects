## Trading View Crypto Web Scraping
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag
# https://www.statology.org/remove-dollar-sign-in-r/

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)
library(stringr)

## Extract top cryptos from Tradingview site.

page <- read_html("https://www.tradingview.com/markets/cryptocurrencies/prices-all/")

table <- page %>% html_element('tbody')

crypto_data <- table %>% html_nodes('td') %>% html_text2()

# Get Crypto Name:
crypto_name <- table %>% html_nodes("[class='tv-screener__symbol']") %>% html_text2()

# Crypto Market Cap:
mcap <- crypto_data[seq(2, length(crypto_data), 8)] 

# Fully Diluted Market Cap
fd_mcap <- crypto_data[seq(3, length(crypto_data), 8)] 

# Price (listed as LAST):
price <- crypto_data[seq(4, length(crypto_data), 8)] 

# Available Coins
avail_coins <- crypto_data[seq(5, length(crypto_data), 8)] 

# Total Coins
total_coins <- crypto_data[seq(6, length(crypto_data), 8)] 

# Traded Volume
traded_vol <- crypto_data[seq(7, length(crypto_data), 8)]

# Change (%)
change_pct <- crypto_data[seq(8, length(crypto_data), 8)]

### Create Dataframe based on raw data:

tview_cryptos <- data.frame(
  Name = crypto_name,
  Market_Cap = mcap,
  Fully_Diluted_MCap = fd_mcap,
  Price = price,
  Avail_Coins = avail_coins,
  Total_Coins = total_coins,
  Traded_Vol = traded_vol,
  Change_Pct = change_pct
)

### Save Dataframe as Excel File:

library(writexl)

write_xlsx(tview_cryptos, paste("TradingView_Cryptos_", Sys.Date(), ".xlsx", sep = ""))

## Save dataframe as .csv File Option:

write.csv(tview_cryptos, paste("TradingView_Cryptos_", Sys.Date(), ".csv", sep = ""), row.names = FALSE)
  