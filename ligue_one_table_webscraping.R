# Ligue 1 Football Webscraping
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)
library(stringr)

# URL from Ligue 1 website
ligue_one_url <- read_html("https://www.ligue1.com/ranking")

# Table, class as classement-table-body:
ligue_one_table <- ligue_one_url %>% 
              html_nodes("[class='classement-table-body']") 


# Class names for ranks, teams, points, won, drawn, lost, gf, ga, diff are not really unique.
# Have to do this approach where I use filtering and sequencing based on the div tags data.
table_data <- ligue_one_table %>% 
              html_elements('li') %>% 
              html_elements('div') %>% 
              html_text2()

# Table data is a large list that has the sequence of Position, Team, Points, Played, Won, 
# Drawn, Lost, Goals For, Goals Against, Diff, Form (not needed):
# I extract the team name using the corresponding class name, 
# the rest of the table data do not really have class names so I filter from table_data

# Create dataframe:

ligue_one_df <- data.frame(
                Rank = table_data[seq(1, length(table_data), 11)],
                Team = ligue_one_table %>% 
                       html_nodes("[class='GeneralStats-clubName desktop-item']") %>%
                       html_text2(),
                Points = ligue_one_table %>% 
                         html_nodes("[class='GeneralStats-item GeneralStats-item--points']") %>%
                         html_text2() %>% 
                         readr::parse_integer(),
                Played = table_data[seq(4, length(table_data), 11)],
                Wins = table_data[seq(5, length(table_data), 11)],
                Draws = table_data[seq(6, length(table_data), 11)],
                Losses = table_data[seq(7, length(table_data), 11)],
                Goals_For = table_data[seq(8, length(table_data), 11)],
                Goals_Against = table_data[seq(9, length(table_data), 11)],
                Goal_Diff = table_data[seq(10, length(table_data), 11)]
)

# Current Top 10 teams in Ligue One
head(ligue_one_df, 10)

## Save Serie A raw data Table Into A .csv file.
write.csv(ligue_one_df, paste("LigueOne_Football_Table_", Sys.Date(), sep = ""))