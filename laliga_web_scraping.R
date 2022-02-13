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

# Obtain table rows data, just need 20 out of 60.
table <- page %>% html_nodes("[class='styled__StandingTabBody-e89col-0 fVocLp']")
table_rows <- table[1:20]

# Rank:
rank <- table_rows %>%
  html_nodes("[class='styled__TextRegularStyled-sc-1raci4c-0 fciXFy']") %>% 
  html_text2() %>%
  readr::parse_integer()

# Club Names & Abbreviations
club_names <- table_rows %>%
  html_nodes("[class='styled__TextRegularStyled-sc-1raci4c-0 glrfl']") %>%
  html_text2()

names <- club_names[seq(2, 40, 2)]
club_symbol <- club_names[seq(1, 40, 2)]

## Table Data where each row has Points, Played, W, D, L, GF, GA and GD for each Laliga team:
table_data <- table_rows %>%
  html_nodes("[class='styled__TextRegularStyled-sc-1raci4c-0 cIcTog']") %>%
  html_text2() %>% 
  readr::parse_integer()

# Points:
points <- table_data[seq(1, length(table_data), by = 8)]

# Played Matches Amount:
played <- table_data[seq(2, length(table_data), by = 8)]

# Won
wins <- table_data[seq(3, length(table_data), by = 8)]

# Draws
draws <- table_data[seq(4, length(table_data), by = 8)]

# Lost
losses <- table_data[seq(5, length(table_data), by = 8)]

# Goals For
goals_for <- table_data[seq(6, length(table_data), by = 8)]

# Goals Against
goals_against <- table_data[seq(7, length(table_data), by = 8)]

# Goals Difference
goal_diff <- table_data[seq(8, length(table_data), by = 8)]

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