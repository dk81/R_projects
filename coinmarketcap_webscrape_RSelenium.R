# Coinmarketcap Crypto Prices Webscraping With RSelenium
# Started on Feb 28, 2022

# Reference: http://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
# Reference 2: https://www.youtube.com/watch?v=U1BrIPmhx10
# Reference 3: https://stackoverflow.com/questions/31901072/scrolling-page-in-rselenium

# Goal is to obtain top 500 cryptos according to Coinmarketcap:

# Load libraries:
library(RSelenium)
library(rvest)
library(tidyverse)

# Restart R (CTRL + SHIFT + F10) before running code below again if code does not work.
# Open Firefox browser:
rD <- rsDriver(browser = "firefox", port = 4545L, verbose = F)

remDr <- rD$client

# Coinmarketcap View Alls page not the home page:

url <- "https://coinmarketcap.com/all/views/all/"

remDr$navigate(url)

# Scroll down to bottom gradually, doing it all the way to end is too fast
Sys.sleep(2)
webElem <- remDr$findElement("css", "body")

for (i in 1:180){
  webElem$sendKeysToElement(list(key = "down_arrow"))
  Sys.sleep(0.015)
}

# Click on Load more to get next 200 cryptos, rank 201-400

Sys.sleep(1)
load_more <- remDr$findElements(using = "xpath", value = "/html/body/div/div[1]/div[2]/div/div[1]/div/div[3]/button")
load_more[[1]]$clickElement()

# Scroll down more to load rank 201-400 cryptos:

for (i in 1:180){
  webElem$sendKeysToElement(list(key = "down_arrow"))
  Sys.sleep(0.015)
}

# Click load more again:
Sys.sleep(1)
load_more[[1]]$clickElement()

# Scroll down more to load rank 201-400 cryptos:

for (i in 1:90){
  webElem$sendKeysToElement(list(key = "down_arrow"))
  Sys.sleep(0.02)
}

#------------------------
### Get page & data:
html <- remDr$getPageSource()[[1]]

# Coinmarketcap Page:
page <- read_html(html)

# Get crypto Rank by Market cap:
rank <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[1]/div') %>%
  html_text2()

# Crypto Name:
name <- page %>% 
        html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[2]/div/a[2]') %>%
        html_text2()
  
# Crypto Ticker/Symbol:
tickers <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[3]/div') %>%
  html_text2()

# Market Cap = Price * Circulating Supply:
market_cap <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[4]/p/span[2]') %>%
  html_text2()
  
# Price
price <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[5]/div/a/span') %>%
  html_text2()

# Circulating Supply
circ_supply <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[6]/div') %>%
  html_text2() 

# Volume (24h)
volume_24h <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[7]/a') %>%
  html_text2() 

# % Change 1h:
pct_change_1h <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[8]/div') %>%
  html_text2() 

# % Change 24h:
pct_change_24h <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[9]/div') %>%
  html_text2() 

# % Change 7d:
pct_change_7d <- page %>% 
  html_nodes(xpath = '//*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td[10]') %>%
  html_text2() 

#---------------------
### Create Dataframe

df <- data.frame(
  Rank = rank,
  Name = name,
  Symbol = tickers,
  Market_Cap = market_cap,
  Price = price,
  Circ_Supply = circ_supply,
  Volume_24h = volume_24h,
  Pct_Change_1h = pct_change_1h,
  Pct_Change_24h = pct_change_24h,
  Pct_Change_7d = pct_change_7d
)

# Take top 500 only:
cmc_top500_df <- df[1:500, ]

# String for file name:
paste0("Coinmarketcap_Top500_", Sys.Date(), '.csv')

# Save raw data:
write.csv(cmc_top500_df, paste0("Coinmarketcap_Top500_", Sys.Date(), '.csv'), row.names = FALSE)

## Close driver:
Sys.sleep(10)
remDr$close()