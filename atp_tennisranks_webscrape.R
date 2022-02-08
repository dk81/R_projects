# Webscrape Tennis Rankings (ATP)
---
  
# Reference: https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag
  
# Load libraries:
  
library(dplyr)
library(tidyr)
library(rvest)
library(stringr)

#---------------------------------------
### ATP Men's Tennis:
# When extracting text, there is \r which appears. This is removed each time with gsub & trimws functions
#---------------------------------------

# Obtain singles rankings for men, just top 100:

atp_link <- read_html("https://www.atptour.com/en/rankings/singles")

page <- atp_link %>% html_elements('tbody')

# Ranks, remove \r and whitespace. Convert into numeric from string.

men_ranks <- page %>%
  html_nodes("[class='rank-cell']") %>%
  html_text2()

men_ranks <- gsub('[\r]', ' ', men_ranks) %>% trimws(which = "both")
men_ranks <- as.numeric(ranks)

# Obtain countries (Abbreviated), found in alt atttribute in image part.

men_country <- page %>%
  html_nodes("[class='country-item']") %>%
  html_element('img') %>%
  html_attr('alt')
 
# Players:

atp_players <- page %>%
  html_nodes("[class='player-cell']") %>%
  html_text2() 

atp_players <- gsub('[\r]', ' ', atp_players) %>% trimws(which = "both")

# Player Age:

atp_age <- page %>%
  html_nodes("[class='age-cell']") %>%
  html_text2() 

atp_age <- gsub('[\r]', ' ', atp_age) %>% trimws(which = "both")
atp_age <- as.numeric(atp_age)

# ATP points (Remove /r, white space, remove comma & convert into numeric)

atp_pts <- page %>%
  html_nodes("[class='points-cell']") %>%
  html_text2() 

atp_pts <- gsub('[\r]', ' ', atp_pts) %>% trimws(which = "both")
atp_pts <- gsub(',', '', atp_pts)
atp_pts <- as.numeric(atp_pts)

# Tournaments Played

atp_played <- page %>%
  html_nodes("[class='tourn-cell']") %>%
  html_text2() 

atp_played <- gsub('[\r]', ' ', atp_played ) %>% trimws(which = "both")
atp_played <- as.numeric(atp_played)

# Points Dropping

atp_drop_pts <- page %>%
  html_nodes("[class='pts-cell']") %>%
  html_text2() 

atp_drop_pts <- gsub('[\r]', ' ', atp_drop_pts) %>% trimws(which = "both")
atp_drop_pts <- as.numeric(atp_drop_pts)

# Next Best

atp_next_best <- page %>%
  html_nodes("[class='next-cell']") %>%
  html_text2() 

atp_next_best <- gsub('[\r]', ' ', atp_next_best) %>% trimws(which = "both")
atp_next_best <- as.numeric(atp_next_best)

### Create Men's Ranking Table Dataframe now:

atp_ranks_table <- data.frame(
  Rank = men_ranks,
  Player = atp_players,
  Country = men_country,
  Points = atp_pts,
  Tournaments_Played = atp_played,
  Pts_Drop = atp_drop_pts,
  Next_Best = atp_next_best
)

## Save Top 100 Male Tennis Players Table into a .csv File:

write.csv(atp_ranks_table, paste("ATP_Top100_", Sys.Date(), sep = ""), row.names = FALSE)

