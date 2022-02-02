### Bundesliga Web Scraping In R
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag

# Load libraries:

library(dplyr)
library(tidyr)
library(rvest)

bundesliga <- read_html("https://www.bundesliga.com/en/bundesliga/table")

page <- bundesliga %>% html_elements('tbody')

# Teams are in the class 'd-none d-lg-inline':

teams <- page %>% 
         html_nodes("[class='d-none d-lg-inline']") %>%
         html_text2()

# Rank & convert into integer:

team_rank <- page %>% 
             html_nodes("[class='rank']") %>%
             html_text2() %>% 
             readr::parse_integer()

# Matches played

matches <- page %>% 
           html_nodes("[class='matches']") %>%
           html_text2() %>% 
           readr::parse_integer()

# Wins:

wins <- page %>% 
           html_nodes("[class='d-none d-lg-table-cell wins']") %>%
           html_text2() %>% 
           readr::parse_integer()

# Draws:

draws <- page %>% 
           html_nodes("[class='d-none d-lg-table-cell draws']") %>%
           html_text2() %>% 
           readr::parse_integer()


# Losses:

losses <- page %>% 
          html_nodes("[class='d-none d-lg-table-cell looses']") %>%
          html_text2() %>% 
          readr::parse_integer()

# Goals:

goals <- page %>% 
         html_nodes("[class='d-none d-md-table-cell goals']") %>%
         html_text2() 

# Goal Difference:

goal_diff <- page %>% 
             html_nodes("[class='difference']") %>%
             html_text2() %>% 
             readr::parse_integer()

### Create Bundesliga dataframe:

bundes_df <- data.frame(Rank = team_rank, Team = teams, 
                        Played = matches, Wins = wins, Draws = draws,
                        Losses = losses, Goals = goals, 
                        Goal_Difference = goal_diff)

## Goals Column Separate Into Goals For and Goals Against:

bundes_df <- bundes_df %>% separate(Goals, c("Goals For", "Goals Against"))

## Save Bundesliga Table Into A .csv file.

write.csv(bundes_df, paste("Bundesliga_", Sys.Date(), sep = ""))
