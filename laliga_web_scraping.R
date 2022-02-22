## La Liga Spanish Soccer Table Web Scraping
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag
  
# Load libraries:
  
library(dplyr)
library(tidyr)
library(rvest)
library(stringr)
library(writexl)

## Extract La Liga Football League tables page.

page <- read_html("https://www.laliga.com/en-GB/laliga-santander/standing")

# Extract the first 20 elements when I extract each part. There are 20 La Liga teams
# Rank:
rank <- page %>% 
        html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[1]') %>%
        html_text2() %>%
        readr::parse_integer()
rank <- rank[1:20]

# Club Names 
club_names <- page %>% 
              html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[2]/div[2]/p') %>%
              html_text2()
club_names <- club_names[1:20]

# Club Abbreviations:
# Club Names 
club_tickers <- page %>% 
                html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[2]/div[1]/p') %>%
                html_text2()
club_tickers <- club_tickers[1:20]

# Points:
points <- page %>% 
          html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[3]') %>%
          html_text2() %>%
          readr::parse_integer()
points <- points[1:20]

# Played Matches Amount:
played <- page %>% 
          html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[4]') %>%
          html_text2() %>%
          readr::parse_integer()
played <- played[1:20]

# Won
wins <- page %>% 
        html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[5]') %>%
        html_text2() %>%
        readr::parse_integer()
wins <- wins[1:20]

# Draws
draws <- page %>% 
         html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[6]') %>%
         html_text2() %>%
         readr::parse_integer()
draws <- draws[1:20]

# Losses
losses <- page %>% 
          html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[7]') %>%
          html_text2() %>%
          readr::parse_integer()
losses <- losses[1:20]

# Goals For
goals_for <- page %>% 
             html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[8]') %>%
             html_text2() %>%
             readr::parse_integer()
goals_for <- goals_for[1:20]

# Goals Against
goals_against <- page %>% 
                 html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[9]') %>%
                 html_text2() %>%
                 readr::parse_integer()
goals_against <- goals_against[1:20]

# Goals Difference
goal_diff <- page %>% 
             html_nodes(xpath = '//*[@class="styled__StandingTableBody-e89col-5 cDiDQb"]/div/div[1]/div/div[1]/div[10]') %>%
             html_text2() %>%
             readr::parse_integer()
goal_diff <- goal_diff[1:20]

#---------------------------------------
### Create Dataframe based on raw data:

laliga_table <- data.frame(
  Rank = rank,
  Club = names,
  Club_Abbrev = club_symbol,
  Points = points,
  Played = played,
  Wins = wins,
  Draws = draws,
  Losses = losses,
  Goals_For = goals_for,
  Goals_Against = goals_against,
  Goal_Diff = goal_diff
)

## Preview table:

head(laliga_table, 10)

### Save Raw data Dataframe as Excel File:

library(writexl)

write_xlsx(laliga_table, paste("LaLiga_Table", Sys.Date(), ".xlsx", sep = ""))

## Save dataframe as .csv File Option:

write.csv(laliga_table, paste("LaLiga_Table", Sys.Date(), ".csv", sep = ""), row.names = FALSE)  
