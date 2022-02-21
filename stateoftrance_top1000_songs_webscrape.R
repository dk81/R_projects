# A State of Trance Top 1000 Of All Time
# List Released on January 11, 2021

# Load libraries:
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)

# Link:
url <- "https://www.astateoftrance.com/news/armin-van-buuren-reveals-all-time-a-state-of-trance-top-1000-list/"

# ASOT Top 1000:
url_page <- read_html(url)

# Obtain div tag with class columns:

songs <- url_page %>%
  html_nodes("[class='columns']") 

# Tracks are found in the p tags of songs. More specifically in index 6 and 7.

tracks <- songs %>% html_elements('p') 
tracks <- tracks[c(6, 7)] %>% html_text2()

# Obtain top 50, extract from nested list
top_50 <-  str_split(tracks[1], pattern = "\n") 
top_50 <- top_50[[1]]

# Ranked 51-1000
other_tracks <- str_split(tracks[2], pattern = "\n")
other_tracks <- other_tracks[[1]]

# Combine all:
combined <- c(top_50, other_tracks)

# Dataframe:
df <- data.frame(Rank = seq(1, 1000),
                 Track = combined)

#-----------------------------
### Extension:

# Separate by hyphen. That is the hyphen from the site (-) not my keyboard hyphen (-):
asot_top_1000_df <- df %>% 
                  separate(col = Track, into = c("Artist", "Song"), sep = '-')  

# Remove number in artist column:
# Reference: https://stackoverflow.com/questions/32767164/use-gsub-remove-all-string-before-first-white-space-in-r
asot_top_1000_df$Artist <- str_replace(asot_top_1000_df$Artist, "^[\\S]+", "") %>% trimws()

# Preview table:
head(asot_top_1000_df)

tail(asot_top_1000_df)

# Top 20 Most Frequent Artists in ASOT Top 1000
# Armin van Buuren, Above & Beyond, GAIA, Giuesppe Ottaviani, Ørjan Nilsen, Aly & Fila, Gareth Emery
asot_top_1000_df %>% 
  count(Artist) %>% 
  arrange(desc(n)) %>%
  head(20)

# Save table as .csv file:
write.csv(asot_top_1000_df, file = 'ASOT_Top1000_Tracks.csv', row.names = FALSE)
