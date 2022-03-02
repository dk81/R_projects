## Bloomberg Billionaires Index Webscraping With RSelenium
# Made on Feb 28, 2022

# Load libraries:
library(RSelenium)
library(rvest)
library(tidyverse)
library(stringi)
library(tidyr)
library(ggplot2)

# Restart R (CTRL + SHIFT + F10) before running code below again if code does not work.
# Open Firefox browser:
rD <- rsDriver(browser = "firefox", port = 4545L, verbose = F)

remDr <- rD$client

# Bloomberg Billionaires Page, it updates each day.

url <- "https://www.bloomberg.com/billionaires/"

remDr$navigate(url)

# No need to click to accept cookies actually.
# Scroll down after more ranks appear (About 2 down arrows for each rank)
webElem <- remDr$findElement("css", "body")

#for (i in 1:250){
#  webElem$sendKeysToElement(list(key = "down_arrow"))
#  Sys.sleep(0.03)
#}
Sys.sleep(5)

## Extract Billionaires Data:
# Format: Rank, Billionaire, Last Change in $, YTD $ Change, Country/Region, Industry

# Get html:
html <- remDr$getPageSource()[[1]]
page <- read_html(html)

### Get Rank
rank <- page %>% 
        html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[1]') %>%
        html_text2()

# Remove Rank (index 1) and blanks (stringi pkg):
rank <- rank[seq(2, length(rank))]
rank <- as.numeric(stri_remove_empty(rank))
  
### Billionaires Name
billionaires <- page %>% 
                html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[2]') %>%
                html_text2() 
billionaires <- billionaires[seq(2, length(billionaires))] %>% stri_remove_empty()

### Total Net Worth:
total_net_worth <- page %>% 
                   html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[3]') %>%
                   html_text2() %>%
                   stri_remove_empty()
total_net_worth <- total_net_worth[seq(2, length(total_net_worth))] %>% stri_remove_empty()
  
### Last Change in $
last_change <- page %>% 
               html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[4]') %>%
               html_text2() %>%
               stri_remove_empty()
last_change <- last_change[seq(2, length(last_change))] %>% stri_remove_empty()
  
### YTD Change $
ytd_change <- page %>% 
              html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[5]') %>%
              html_text2() %>%
              stri_remove_empty()
ytd_change <- ytd_change[seq(2, length(ytd_change))] %>% stri_remove_empty()

### Country/Region
region <- page %>% 
          html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[6]') %>%
          html_text2()  
region <- region[seq(2, length(region))] %>% stri_remove_empty()

### Industry
industry <- page %>% 
            html_nodes(xpath = '/html/body/div[6]/section[2]/div/div/div[7]') %>%
            html_text2()  
industry <- industry[seq(2, length(industry))] %>% stri_remove_empty()

#--------------------------

# Create dataframe:

bloomberg_billionaires_df <- data.frame(
  Rank = rank,
  Name = billionaires,
  Total_Net_Worth = total_net_worth,
  Last_Change = last_change,
  YTD_Change = ytd_change,
  Region = region,
  Industry = industry
)

# Preview dataframe:
head(bloomberg_billionaires_df, 10)

tail(bloomberg_billionaires_df, 10)

# String for file name:
paste0("Bloomberg_Billionaires_", Sys.Date(), '.csv')

# Save Dataframe:
write.csv(bloomberg_billionaires_df, paste0("Bloomberg_Billionaires_", Sys.Date(), '.csv'), row.names = FALSE)

## Close driver:
Sys.sleep(10)
remDr$close()

#-----------------------------
### Data Analysis Portion:


## Billionaires Count by Region:
by_region <- bloomberg_billionaires_df %>%
             group_by(Region) %>%
             summarise(Count = n()) %>%
             arrange(desc(Count)) %>%
             data.frame()

## Create bar graph in ggplot2, Billionaires Count by Region:

# Sorting by counts for the Region
by_region$Region <- factor(by_region$Region, 
                           levels = by_region$Region[order(by_region$Count)])

# Billionaires Count by Region (Top 10 Regions):
ggplot(head(by_region, 10), aes(x = Region, y = Count)) +
  geom_bar(stat = "identity", fill = "#238c6d") + 
  coord_flip() +
  geom_text(aes(label = Count), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "\n Region \n", y = "\n Count \n", 
       title = paste0("\n Bloomberg_Billionaires_", Sys.Date(), "\n")) +
  theme(plot.title = element_text(hjust = 0.5, size = 15), 
        axis.title.x = element_text(face="bold", colour="#063970", size = 12),
        axis.title.y = element_text(face="bold", colour="#063970", size = 12))

## Canadian Billionaires (CZ from Binance highest for Canada):
bloomberg_billionaires_df %>% filter(Region == 'Canada')

## American Billionaires (Top 10):
bloomberg_billionaires_df %>% 
  filter(Region == 'United States') %>%
  head(10)

## Billionaires Count by Category
by_category <- bloomberg_billionaires_df %>%
               group_by(Industry) %>%
               summarise(Count = n()) %>%
               arrange(desc(Count)) %>%
               data.frame()

## Bar Graph Of Billionaires By Category:

# Sorting by counts for the Category
by_category$Industry <- factor(by_category$Industry, 
                               levels = by_category$Industry[order(by_category$Count)])

# Top 10 Billionaires Count by Industry, labels added, blue bars
ggplot(head(by_category, 10), aes(x = Industry, y = Count)) +
  geom_bar(stat = "identity", fill = "#555387") + 
  coord_flip() +
  geom_text(aes(label = Count), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "\n Industry \n", y = "\n Count \n", 
       title = paste0("\n Bloomberg_Billionaires_", Sys.Date(), "\n")) +
  theme(plot.title = element_text(hjust = 0.5, size = 15), 
        axis.title.x = element_text(face="bold", colour="#063970", size = 12),
        axis.title.y = element_text(face="bold", colour="#063970", size = 12))

## Technology Billionaires (Top 10):
bloomberg_billionaires_df %>% filter(Industry == 'Technology') %>% head(10)

## Finance Billionaires (Top 10):
bloomberg_billionaires_df %>% filter(Industry == 'Finance') %>% head(10)

## Retail Billonaires (Top 10):
bloomberg_billionaires_df %>% filter(Industry == 'Retail') %>% head(10)
