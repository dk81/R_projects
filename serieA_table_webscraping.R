# Serie A Football Web Scraping in R
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)
library(stringr)

# URL from Serie A website
serie_a <- read_html("https://www.legaseriea.it/en/serie-a/league-table")

# Team Rows:
rows <- serie_a  %>% 
  html_elements('tr') 

# Table Data (16 x 20 teams = 320 entries in table)
table_data <- rows %>% 
  html_elements('td') %>%
  html_text2()

# Extract Team Names & remove numbers. This extracts stuff like 1 Milan when I want just Milan
# Reference: https://stackoverflow.com/questions/13590139/remove-numbers-from-alphanumeric-characters
team_names <- table_data[seq(1, 320, 16)]
team_names <- gsub('[0-9]+', '', team_names) %>% str_replace_all(" ", "")

# Points column would require seq(2, 320, 16) for filtering), Matches played would be seq(3, 320, 16) and so on.
# Not the most elegant way but it gets the data.
# Create dataframe:
serieA_df <- data.frame(Rank = seq(1, 20),
                        Team_Name = team_names,
                        Points = table_data[seq(2, 320, 16)],
                        Matches_Played = table_data[seq(3, 320, 16)],
                        Match_Wins = table_data[seq(4, 320, 16)],
                        Match_Draws = table_data[seq(5, 320, 16)],
                        Match_Losses = table_data[seq(6, 320, 16)],
                        Home_Played = table_data[seq(7, 320, 16)],
                        Home_Wins = table_data[seq(8, 320, 16)],
                        Home_Draws = table_data[seq(9, 320, 16)],
                        Home_Losses = table_data[seq(10, 320, 16)],
                        Away_Played = table_data[seq(11, 320, 16)],
                        Away_Wins = table_data[seq(12, 320, 16)],
                        Away_Draws = table_data[seq(13, 320, 16)],
                        Away_Losses = table_data[seq(14, 320, 16)],
                        Goals_For = table_data[seq(15, 320, 16)],
                        Goals_Against = table_data[seq(16, 320, 16)]
                        )

# See table:
head(serieA_df, 8)

## Save Serie A raw data Table Into A .csv file.
write.csv(serieA_df, paste("SerieA_Football_Table_", Sys.Date(), '.csv', sep = ""))
