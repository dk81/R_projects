# Coingecko Web Scrape In R
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag
# https://www.statology.org/remove-dollar-sign-in-r/

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)
library(stringr)

## Extract top 100 cryptos on Coingecko.com

page <- read_html("https://www.coingecko.com/")

table <- page %>% html_element('tbody')

# Get Rank:
rank <- table %>%
  html_nodes(
    "[class='table-number tw-text-left text-xs cg-sticky-col cg-sticky-second-col tw-max-w-14 lg:tw-w-14']"
  ) %>%
  html_text2() %>%
  readr::parse_integer()

# Name
crypto_name <- table %>%
  html_nodes("[class='tw-hidden lg:tw-flex font-bold tw-items-center tw-justify-between']") %>%
  html_text2()

# Ticker
ticker <- table %>%
  html_nodes("[class='d-lg-none font-bold tw-w-12']") %>%
  html_text2()

# Extract price:
price <- table %>%
  html_nodes('[class="td-price price text-right pl-0"]') %>%
  html_text2()

# 1 Hour Change
change_1h <- table %>%
  html_nodes("[class='td-change1h change1h stat-percent text-right col-market']") %>%
  html_text2()

# 24 Hour Change
change_24h <- table %>%
  html_nodes("[class='td-change24h change24h stat-percent text-right col-market']") %>%
  html_text2()

# 7 Day Change
change_7d <- table %>%
  html_nodes("[class='td-change7d change7d stat-percent text-right col-market']") %>%
  html_text2()

# 24 Hour Volume
volume_24h <- table %>%
  html_nodes("[class='td-liquidity_score lit text-right %> col-market']") %>%
  html_text2()

# Market Cap
market_cap <- table %>%
  html_nodes("[class='td-market_cap cap col-market cap-price text-right']") %>%
  html_text2()

#------

# Put together as dataframe:

df <- data.frame(
  Rank = rank,
  Crypto = crypto_name,
  Ticker = ticker,
  Price = price,
  Change_1h = change_1h,
  Change_24h = change_24h,
  Change_7d = change_7d,
  Volume_24h = volume_24h,
  Market_Cap = market_cap
)


#------
### Multiples Coingecko pages case:

# Sample Link: https://www.coingecko.com/?locale=en&page=2
i <- 2

test <- paste0("https://www.coingecko.com/?locale=en&page=", i)


get_coingecko_data <- function(numPages = 2) {
  # Each page in Coingecko contains 100 cryptos
  # Initialize empty lists:
  rank_list <- c()
  crypto_list <- c()
  ticker_list <- c()
  price_list <- c()
  
  change_1h_list <- c()
  change_24h_list <- c()
  change_7d_list <- c()
  
  volume_24h_list <- c()
  mcap_list <- c()
  
  for (i in 1:numPages) {
    link <- paste0("https://www.coingecko.com/?page=", i)
    page <- read_html(link)
    table <- page %>% html_element('tbody')
    
    # Get Rank:
    rank <- table %>%
      html_nodes(
        "[class='table-number tw-text-left text-xs cg-sticky-col cg-sticky-second-col tw-max-w-14 lg:tw-w-14']"
      ) %>%
      html_text2() %>%
      readr::parse_integer()
    
    rank_list <- append(rank_list, rank)
    
    # Crypto Names
    crypto_name <- table %>%
      html_nodes("[class='tw-hidden lg:tw-flex font-bold tw-items-center tw-justify-between']") %>%
      html_text2()
    
    crypto_list <- append(crypto_list, crypto_name)
    
    # Obtain crypto tickers:
    ticker <- table %>%
      html_nodes("[class='d-lg-none font-bold tw-w-12']") %>%
      html_text2()
    
    ticker_list <- append(ticker_list, ticker)
    
    
    # Extract price:
    price <- table %>%
      html_nodes('[class="td-price price text-right pl-0"]') %>%
      html_text2()
    
    price_list <- append(price_list, price)
    
    # One hour % change:
    change_1h <- table %>%
      html_nodes("[class='td-change1h change1h stat-percent text-right col-market']") %>%
      html_text2()
    
    change_1h_list <- append(change_1h_list, change_1h)
    
    # 24 hour % change:
    change_24h <- table %>%
      html_nodes("[class='td-change24h change24h stat-percent text-right col-market']") %>%
      html_text2()
    
    change_24h_list <- append(change_24h_list, change_24h)
    
    # 7 Day % change
    change_7d <- table %>%
      html_nodes("[class='td-change7d change7d stat-percent text-right col-market']") %>%
      html_text2()
    
    change_7d_list <- append(change_7d_list, change_7d)
    
    # 24 Hour Volume:
    volume_24h <- table %>%
      html_nodes("[class='td-liquidity_score lit text-right %> col-market']") %>%
      html_text2()
    
    volume_24h_list <- append(volume_24h_list, volume_24h)
    
    # Market Cap:
    market_cap <- table %>%
      html_nodes("[class='td-market_cap cap col-market cap-price text-right']") %>%
      html_text2()
    
    mcap_list <- append(mcap_list, market_cap)
  }
  
  # Put as dataframe:
  
  df <- data.frame(
    Rank = rank_list,
    Crypto = crypto_list,
    Ticker = ticker_list,
    Price = price_list,
    Change_1h = change_1h_list,
    Change_24h = change_24h_list,
    Change_7d = change_7d_list,
    Volume_24h = volume_24h_list,
    Mkt_Cap = mcap_list
  )
  
  return(df)
}

# Function call:

cg_data <- get_coingecko_data(numPages = 3)

head(cg_data)

tail(cg_data)

# Save into .csv file:

write.csv(cg_data, paste("Coingecko_Prices_", Sys.Date(), sep = ""))

#### Data Cleaning & Data Analysis

## Data Cleaning Part

# Convert some columns from characters to numeric for sorting purposes

# Rank column to numeric:
cg_data$Rank <- as.numeric(cg_data$Rank)

# Remove $ and comma signs in price column:
cg_data$Price <- as.numeric(gsub("[$,]", "", cg_data$Price))

# Remove $ and comma signs in Volume 24h column:
cg_data$Volume_24h <- as.numeric(gsub("[$,]", "", cg_data$Volume_24h))

# Remove $ and comma signs in Mkt_Cap column:
cg_data$Mkt_Cap <- as.numeric(gsub("[$,]", "", cg_data$Mkt_Cap))

# Percentage sign removed in Change columns

cg_data$Change_1h <- as.numeric(gsub("[%]", "", cg_data$Change_1h))
cg_data$Change_24h <- as.numeric(gsub("[%]", "", cg_data$Change_24h))
cg_data$Change_7d <- as.numeric(gsub("[%]", "", cg_data$Change_7d))

## Data Analysis

# Highest Volume in 24 hours, top10
cg_data %>% arrange(desc(Volume_24h)) %>% head(10)

# Highest 7d change, top10:
cg_data %>% arrange(desc(Change_7d)) %>% head(10)

# Lowest 7d change, top10:
cg_data %>% arrange(Change_7d) %>% head(10)

# Highest 24h change, top10:
cg_data %>% arrange(desc(Change_24h)) %>% head(10)

# Lowest 24h change, top10:
cg_data %>% arrange(Change_24h) %>% head(10)

# Highest 1h change, top10:
cg_data %>% arrange(desc(Change_1h)) %>% head(10)

# Lowest 1h change, top10:
cg_data %>% arrange(Change_1h) %>% head(10)

# Search for coins with Bitcoin in their name:
cg_data %>% filter(str_detect(Crypto, "Bitcoin"))

# Ethereum Related coins
cg_data %>% filter(str_detect(Crypto, "Ethereum"))

