# Ligue 1 Football Webscraping
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)
library(stringr)

# URL from Ligue 1 website
ligue_one_url <- read_html("https://www.ligue1.com/ranking")

# Ranks:
ranks <- ligue_one_url %>% 
         html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[1]') %>%
         html_text2() %>%
         readr::parse_integer()

# Teams:
teams <- ligue_one_url %>% 
         html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[2]/span[1]') %>%
         html_text2()

# Points:
points <- ligue_one_url %>% 
          html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[3]') %>%
          html_text2() %>%
          readr::parse_integer()

# Played
played <- ligue_one_url %>% 
          html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[4]') %>%
          html_text2() %>%
          readr::parse_integer()

# Wins
wins <- ligue_one_url %>% 
          html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[5]') %>%
          html_text2() %>%
          readr::parse_integer()

# Draws
draws <- ligue_one_url %>% 
         html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[6]') %>%
         html_text2() %>%
         readr::parse_integer()

# Losses
losses <- ligue_one_url %>% 
          html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[7]') %>%
          html_text2() %>%
          readr::parse_integer()

# Goals For
goals_for <- ligue_one_url %>% 
             html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[8]') %>%
             html_text2() %>%
             readr::parse_integer()

# Goals Against
goals_against <- ligue_one_url %>% 
                 html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[9]') %>%
                 html_text2() %>%
                 readr::parse_integer()


# Goal Difference
goals_diff <- ligue_one_url %>% 
              html_nodes(xpath='//*[@class="classement-table-body"]/ul/li/a/div[10]') %>%
              html_text2() %>%
              readr::parse_integer()

### Create dataframe:

ligue_one_df <- data.frame(
  Rank = ranks,
  Team = teams,
  Points = points,
  Played = played,
  Wins = wins,
  Draws = draws,
  Losses = losses,
  Goals_For = goals_for,
  Goals_Against = goals_against,
  Goal_Diff = goals_diff
)

# Current Top 10 teams in Ligue One
head(ligue_one_df, 10)

## Save Serie A raw data Table Into A .csv file.
write.csv(ligue_one_df, paste("LigueOne_Football_Table_", Sys.Date(), '.csv', sep = ""))
