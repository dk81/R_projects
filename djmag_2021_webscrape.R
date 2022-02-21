# DJ Magazine Top 100 2021 Webscraping

# Load libraries:
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)

# Link:
url <- "https://djmag.com/top100djs/"

# DJ Mag 2021 Page:
dj_mag2021_page <- read_html(url)

# Rank can be obtained without webscraping, I can use seq(1, 100) for Rank column

# DJ/Artist Name:
names <- dj_mag2021_page %>%
         html_nodes("[class='top100dj-name']") %>%
         html_text2()

# Movement:
rank_movement <- dj_mag2021_page %>%
                 html_nodes("[class='top100dj-movement']") %>%
                 html_text2()

# 2021 DJMag Interview URL Links:
dj_interview_urls <- dj_mag2021_page %>%
                     html_nodes("[class='top100dj-name']") %>%
                     html_element('a') %>%
                     html_attr('href')

dj_interview_urls <- paste0("https://djmag.com/", dj_interview_urls)

### ----------
# Create Dataframe:

dj_mag_2021_df <- data.frame(Rank = seq(1, 100),
                             DJ = names,
                             Rank_Change = rank_movement,
                             Interview_URL = dj_interview_urls)

## Filter for New Entries:
new_entries <- dj_mag_2021_df %>% filter(Rank_Change == 'New Entry')

## DJs with Re-Entry (Fell out of top 100 and are back in top 100 in 2021)
re_entries <- dj_mag_2021_df %>% filter(Rank_Change == 'Re-entry')

## DJs who moved up:
up_movers <- dj_mag_2021_df %>% filter(grepl('Up', Rank_Change))

## DJs who moved down:
down_movers <- dj_mag_2021_df %>% filter(grepl('Down', Rank_Change))

## Non-Movers 
non_movers <- dj_mag_2021_df %>% filter(Rank_Change == 'Non Mover')

# Save DJ Mag 2021 list as .csv file:
write.csv(dj_mag_2021_df, file = 'DJMag_Top100_2021.csv', row.names = FALSE)
