## Forbes Top 200 Billionaires Webscraping With RSelenium
# Made on Mar 1, 2022

# Load libraries:
library(RSelenium)
library(rvest)
library(tidyverse)
library(stringi)
library(tidyr)

# Restart R (CTRL + SHIFT + F10) before running code below again if code does not work.
# Open Firefox browser:
rD <- rsDriver(browser = "firefox", port = 4545L, verbose = F)

remDr <- rD$client

# Bloomberg Billionaires Page, it updates each day.

url <- "https://www.forbes.com/billionaires/"

remDr$navigate(url)

# Scroll down after more ranks appear (About 2 down arrows for each rank)
webElem <- remDr$findElement("css", "body")

#for (i in 1:250){
#  webElem$sendKeysToElement(list(key = "down_arrow"))
#  Sys.sleep(0.03)
#}
Sys.sleep(5)

## Extract Billionaires Data from Forbes
# Format: Rank, Billionaire, Net Worth, Age, Country/Territory, Source, Industry

# Get html:
html <- remDr$getPageSource()[[1]]
page <- read_html(html)


###  Ranks:
ranks <- page %>% 
         html_nodes(xpath = '//*[@class="rank"]') %>%
         html_text2() 

# Remove dot in each string.
str_replace(ranks, pattern = ".", replacement = "")

### Get Billionaires
billionaires <- page %>% 
                html_nodes(xpath = '//*[@class="personName"]') %>%
                html_text2()

### Net Worth:
net_worths <- page %>% 
              html_nodes(xpath = '//*[@class="netWorth"]/div[1]') %>%
              html_text2()

### Age
age <- page %>% 
       html_nodes(xpath = '//*[@class="age"]/div[1]') %>%
       html_text2() %>%
       readr::parse_integer()

### Country/Territory
country <- page %>% 
           html_nodes(xpath = '//*[@class="countryOfCitizenship"]') %>%
           html_text2()

### Source
source <- page %>% 
          html_nodes(xpath = '//*[@class="source"]/div[1]') %>%
          html_text2()

### Industry
industry <- page %>% 
            html_nodes(xpath = '//*[@class="category"]/div') %>%
            html_text2()

#--------------------------

# Create dataframe:

forbes_top200_billionaires_df <- data.frame(
  Rank = ranks,
  Name = billionaires,
  Total_Net_Worth = net_worths,
  Age = age,
  Country = country,
  Source = source,
  Industry = industry
)

# Preview dataframe:
head(forbes_top200_billionaires_df, 10)

tail(forbes_top200_billionaires_df, 10)

# Save Dataframe:
write.csv(forbes_top200_billionaires_df, 
          paste0("Forbes_Top200_Billionaires_2021.csv"), 
          row.names = FALSE)

## Close driver:
Sys.sleep(10)
remDr$close()