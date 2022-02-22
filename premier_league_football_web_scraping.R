## English Premier Table Web Scraping
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)
library(stringr)
library(writexl)

## Extract English Premier League Soccer League tables page.

page <- read_html("https://www.premierleague.com/tables")

#------------------
# Rank:
rank <- page %>%
        html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[2]/span[1]') %>%
        html_text2() %>%
        readr::parse_integer()

# EPL Club Name:
name <- page %>%
        html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[3]/a/span[2]') %>%
        html_text2()

# Played Matches Amount, only take 20 as there are 20 teams
played <- page %>%
          html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[4]') %>%
          html_text2() %>%
          readr::parse_integer()
played <- played[1:20]

# Won
wins <- page %>%
        html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[5]') %>%
        html_text2() %>%
        readr::parse_integer()
wins <- wins[1:20]

# Draws
draws <- page %>%
         html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[6]') %>%
         html_text2() %>%
         readr::parse_integer()
draws <- draws[1:20]

# Losses
losses <- page %>%
  html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[7]') %>%
  html_text2() %>%
  readr::parse_integer()
losses <- losses[1:20]

# Goals For
goals_for <- page %>%
             html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[8]') %>%
             html_text2() %>%
             readr::parse_integer()
goals_for <- goals_for[1:20]

# Goals Against
goals_against <- page %>%
                 html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[9]') %>%
                 html_text2() %>%
                 readr::parse_integer()
goals_against <- goals_against[1:20]

# Goals Difference
goals_diff <- page %>%
              html_nodes(xpath='//*[@class="tableContainer"]/div/table/tbody/tr/td[10]') %>%
              html_text2() %>%
              readr::parse_integer()
goals_diff <- goals_diff[1:20]

# Points
points <- page %>%
          html_nodes("[class='points']") %>%
          html_text2() %>%
          readr::parse_integer()
points <- points[2:21]

#---------------------------------------
### Create Dataframe based on raw data:

epl_table <- data.frame(
  Rank = seq(1, 20),
  Club = name,
  Played = played,
  Wins = wins,
  Draws = draws,
  Losses = losses,
  Goals_For = goals_for,
  Goals_Against = goals_against,
  Goals_Difference = goals_diff,
  Points = points
)

## Preview table:

head(epl_table, 10)

### Save data Dataframe as Excel File:

library(writexl)

write_xlsx(epl_table, paste("EPL_Table", Sys.Date(), ".xlsx", sep = ""))

## Save dataframe as .csv File Option:

write.csv(epl_table, paste("EPL_Table", Sys.Date(), ".csv", sep = ""), row.names = FALSE)
