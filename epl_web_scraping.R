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

table <- page %>% html_element('tbody')

# Obtain table rows, exclude expandable rows:
table_rows <- table %>% html_elements('tr')
table_rows <- table_rows[seq(1, 40, 2)]

# Table Data
table_data <- table %>% html_elements('td')

#------------------
# EPL Club Name:
name <- table_rows %>% html_nodes("[class='long']") %>% html_text2()

# Played Matches Amount:
played <- table_data[seq(4, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

# Won
wins <- table_data[seq(5, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

# Draws
draws <- table_data[seq(6, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

# Lost
losses <- table_data[seq(7, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

# Goals For
goals_for <- table_data[seq(8, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

# Goals Against
goals_against <- table_data[seq(9, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

# Goals Difference
goals_diff <- table_data[seq(10, length(table_data), 14)] %>% html_text2() 

# Points
points <- table_data[seq(11, length(table_data), 14)] %>% html_text2() %>% readr::parse_integer()

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