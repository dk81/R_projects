# Forbes Billionaires 2021 Full Webscrape With RSelenium
# Made on Mar 3, 2022

# Load libraries:
library(RSelenium)
library(rvest)
library(tidyverse)
library(stringr)
library(dplyr)

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


### Loop through each page and webscrape:

# Initalize lists:

ranks_list <- c()
names_list <- c()
net_worths_list <- c()
age_list <- c()
country_list <- c()
source_list <- c()
industry_list <- c()

# There are 14 pages to scrape from, run for loop from 1 to 13.
# Parsing errors do occur but it does not affect output.
for (i in 1:14){

  # Get html for the page
  html <- remDr$getPageSource()[[1]]
  page <- read_html(html)
  
  # Scroll down gradually:
  webElem <- remDr$findElement("css", "body")
  for (i in 1:360){
    webElem$sendKeysToElement(list(key = "down_arrow"))
    Sys.sleep(0.03)
  }
  
  ###  Ranks & append to list. Append with the use of x <- c(x, new_stuff)
  ranks <- page %>% 
      html_nodes(xpath = '//*[@class="rank"]') %>%
      html_text2() 
  ranks_list <- c(ranks_list, ranks)
  
  ### Get Billionaires
  billionaires <- page %>% 
      html_nodes(xpath = '//*[@class="personName"]') %>%
      html_text2()
  names_list <- c(names_list, billionaires)
  
  ### Net Worth:
  net_worths <- page %>% 
      html_nodes(xpath = '//*[@class="netWorth"]/div[1]') %>%
      html_text2()
  net_worths_list <- c(net_worths_list, net_worths)
  
  ### Age
  age <- page %>% 
      html_nodes(xpath = '//*[@class="age"]/div[1]') %>%
      html_text2() %>%
      readr::parse_integer()
  age_list <- c(age_list, age)
  
  ### Country/Territory
  country <- page %>% 
      html_nodes(xpath = '//*[@class="countryOfCitizenship"]') %>%
      html_text2()
  country_list <- c(country_list, country)
  
  ### Source
  source <- page %>% 
      html_nodes(xpath = '//*[@class="source"]/div[1]') %>%
      html_text2()
  source_list <- c(source_list, source)
  
  ### Industry
  industry <- page %>% 
      html_nodes(xpath = '//*[@class="category"]/div') %>%
      html_text2()
  industry_list <- c(industry_list, industry)
  
  # If i = 13, break out of loop as no need to click next page:
  if (i == 14){
    break
  }
  
  # Click on next page to get next batch of billionaires:
  Sys.sleep(5)
  next_page <- remDr$findElements(using = "xpath", 
               value = "/html/body/div/div[1]/div/div/div[3]/div[2]/div[2]/div[2]/div[27]/div[7]/div[2]/button[2]")
  next_page[[1]]$clickElement()
}

# Create dataframe:

billionaires_df <- data.frame(
  Rank = ranks_list,
  Name = names_list,
  NWorth_Billions = net_worths_list,
  Age = age_list,
  Country = country_list,
  Source = source_list,
  Industry = industry_list
)

# Preview dataframe, top 10 billionaires acc. to Forbes
head(billionaires_df, 10)

# Last 10 rows in dataframe:
tail(billionaires_df, 10)

# # Save Raw Data Into .csv
write.csv(billionaires_df, paste0("Forbes_Billionaires_2021_full.csv"), row.names = FALSE)


## Close driver:
Sys.sleep(7)
remDr$close()

#### Data Analysis:
#------------------------------

## Load .csv file:
df <- read.csv("Forbes_Billionaires_2021_full.csv")

### Data Cleaning First

# Check data types:
summary(df)

# Preview data:
head(df, 10)

# Remove $ sign and B in net worth columns:
df$NWorth_Billions <- str_replace_all(df$NWorth_Billions, pattern = '[$B]', replacement = "") %>% 
                        trimws() %>%
                        as.numeric()

## Youngest Billionaires, Top 15
df %>% arrange(Age) %>% head(15)

## Oldest Known Billionaires
df %>% arrange(desc(Age)) %>% head(15)

## Billionaires & Their Families
df %>% filter(str_detect(Name, 'family$')) %>% head(15)

## USA Billionaires
df %>% filter(Country == 'United States') %>% head(15)

## Chinese Billionaires
df %>% filter(Country == 'China') %>% head(15)

## Canadian Billionaires
df %>% filter(Country == 'Canada') %>% head(15)

## Crypto Billionaires
df %>% filter(str_detect(Source, 'crypto')) %>% head(15)

## Technology Billionaires
df %>% filter(Industry == 'Technology') %>% head(15)

## Billionaires In Amazon, Microsoft, Facebook, Google
df %>% filter(Source %in% c('Amazon', 'Microsoft', 'Google', 'Facebook'))

#-------------------------------------------------------
### Number of Billionaires By Country With Plot (Top 15):

by_country <- df %>% 
               count(Country) %>% 
               arrange(desc(n)) %>% head(15)

# Sorting by counts for the Region
by_country$Country <- factor(by_country$Country, 
                           levels = by_country$Country[order(by_country$n)])

# ggplot Horizontal bar graph:

ggplot(by_country, aes(x = Country, y = n)) +
  geom_bar(stat = 'identity')+
  coord_flip() +
  geom_text(aes(label = n), hjust = 1.1, colour = "white", fontface = "bold") +
  labs(x = "\n Country \n", y = "\n Count \n", 
       title = paste0("\n Forbes - Number Of Billionaires By Country 2021 \n")) +
  theme(plot.title = element_text(hjust = 0.5, size = 15), 
        axis.title.x = element_text(face="bold", colour="#063970", size = 12),
        axis.title.y = element_text(face="bold", colour="#063970", size = 12))

#-------------------------------------------------------
### Number of Billionaires By Industry With Plot

by_industry <- df %>% 
                count(Industry) %>% 
                arrange(desc(n)) %>% head(15)

# Sorting by counts for the Region
by_industry$Industry <- factor(by_industry$Industry, 
                             levels = by_industry$Industry[order(by_industry$n)])

# ggplot Horizontal bar graph:

ggplot(by_industry, aes(x = Industry, y = n)) +
  geom_bar(stat = 'identity', fill = "#00cc99")+
  coord_flip() +
  geom_text(aes(label = n), hjust = 1.1, colour = "black", fontface = "bold") +
  labs(x = "\n Industry \n", y = "\n Count \n", 
       title = paste0("\n Forbes - Number Of Billionaires By Industry 2021 \n")) +
  theme(plot.title = element_text(hjust = 0.5, size = 15), 
        axis.title.x = element_text(face="bold", colour="#063970", size = 12),
        axis.title.y = element_text(face="bold", colour="#063970", size = 12))


