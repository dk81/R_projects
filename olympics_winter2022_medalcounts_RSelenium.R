# Winter Olympics 2022 Medals Count Web Scraping Using RSelenium
# First RSelenium project, started on Feb 27, 2022
# Reference: http://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
# Reference 2: https://www.youtube.com/watch?v=U1BrIPmhx10

# Installation of RSelenium: devtools::install_github("ropensci/RSelenium")
# Install Java JDK for RSelenium: https://www.youtube.com/watch?v=IJ-PJbvJBGs&t=0s

# Load libraries:
library(RSelenium)
library(rvest)
library(tidyverse)

# Restart R to run all code below again if code does not work.
# Open Firefox browser:
rD <- rsDriver(browser = "firefox", port = 4545L, verbose = F)

remDr <- rD[["client"]]

# Go to Olympics Winter 2022 medal counts:
url <- "https://olympics.com/beijing-2022/olympic-games/en/results/all-sports/medal-standings.htm"
remDr$navigate(url)

# Click to accept cookies.
# xpath is //*[@id="onetrust-accept-btn-handler"]
remDr$findElements(using = "id", value = "onetrust-accept-btn-handler")[[1]]$clickElement()

# Load page:
html <- remDr$getPageSource()[[1]]

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))

# Parse page:
medals_page <- read_html(html)

# Obtain table:
medals_table <- medals_page %>% html_nodes(xpath = '//*[@id="medal-standing-table"]')

### Extract data:
# Each country has its own row. (tr tag)

## Obtain Rank:
rank <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[1]/strong') %>%
  html_text2() %>%
  readr::parse_integer()

## NOC/Country/Association:
country <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[2]/div/a/abbr') %>%
  html_text2()

## Number of Gold Medals:
gold_medals <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[3]') %>%
  html_text2() %>%
  readr::parse_integer()

## Silver Medals Count:
silver_medals <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[4]') %>%
  html_text2() %>%
  readr::parse_integer()

## Bronze Medals Count:
bronze_medals <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[5]') %>%
  html_text2() %>%
  readr::parse_integer()

# Total Medals Count for Country:
total_medals <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[6]/a/strong') %>%
  html_text2() %>%
  readr::parse_integer()

# Rank by Total Medals Count:
rank_total_medals <- medals_page %>%
  html_nodes(xpath = '//*[@id="medal-standing-table"]/tbody/tr/td[7]') %>%
  html_text2() %>%
  readr::parse_integer()

#### Create Dataframe:

olympics_medals_w2022_df <- data.frame(
  Rank = rank,
  NOC = country,
  Gold_Medals = gold_medals,
  Silver_Medals = silver_medals,
  Bronze_Medals = bronze_medals,
  Total_Medals = total_medals,
  Rank_By_Total_Medals = rank_total_medals
)

#----------------------
## Save file into .csv
write.csv(olympics_medals_w2022_df, "Beijing_W2022_Olympics_MedalsCount.csv", row.names = FALSE)

## Close driver:
Sys.sleep(3)
remDr$close()