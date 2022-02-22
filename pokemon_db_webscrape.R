# Pokemon Table from Pokemondb Webscraping In R

# Load libraries:
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)


poke_url <- "https://pokemondb.net/pokedex/all"

page <- read_html(poke_url)

pokemon <- page %>% html_element("table") %>% html_elements("tr")

# Remove first element in pokemon:

pokemon <- pokemon[-1]

# Testing with extracting elements

pokemon %>% html_elements('td') %>% .[c(1, 5)] %>% html_text2()

pokemon[1046] %>% html_elements('td')

### Extract items:

## Extract Pokemon Number:

poke_num <- pokemon %>% 
            html_elements('span.infocard-cell-data') %>% 
            html_text2() %>%
            readr::parse_integer()

## Extract Pokemon Name & Remove \n tag:
name <- pokemon %>% html_elements('td.cell-name')  %>% html_text2()
name <- gsub('[\n]', ' ', name)

## Pokemon Type & Remove \n tag and trim whitespace on the right.
type <- pokemon %>% html_elements('td.cell-icon')  %>% html_text2()
type <- gsub('[\n]', ' ', type) 
type <- trimws(type, which = "right")

## Total Stats:
total_stats <- pokemon %>% 
               html_elements('td.cell-total') %>% 
               html_text2() %>%
               readr::parse_integer()

## HP found in tbody/tr/td[5], I use xpath here.
hp <- pokemon %>% 
      html_nodes(xpath='//*[@id="pokedex"]/tbody/tr/td[5]') %>%
      html_text2() %>%
      readr::parse_integer()

## Attack:
attack <- pokemon %>% 
          html_nodes(xpath='//*[@id="pokedex"]/tbody/tr/td[6]') %>%
          html_text2() %>%
          readr::parse_integer()

## Defense:
defense <- pokemon %>% 
          html_nodes(xpath='//*[@id="pokedex"]/tbody/tr/td[7]') %>%
          html_text2() %>%
          readr::parse_integer()

## Special Attack:
sp_atk <- pokemon %>% 
          html_nodes(xpath='//*[@id="pokedex"]/tbody/tr/td[8]') %>%
          html_text2() %>%
          readr::parse_integer()

## Special Defense:
sp_atk <- pokemon %>% 
          html_nodes(xpath='//*[@id="pokedex"]/tbody/tr/td[9]') %>%
          html_text2() %>%
          readr::parse_integer()

## Speed
speed <- pokemon %>% 
         html_nodes(xpath='//*[@id="pokedex"]/tbody/tr/td[10]') %>%
         html_text2() %>%
         readr::parse_integer()

#---------

# Create Pokemon table from Pokemon.db:

# Put together as dataframe:

pokemon_df <- data.frame(
  Number = poke_num,
  Pokemon = name,
  Type = type,
  Total_Stats = total_stats,
  HP = hp,
  Attack = attack,
  Defense = defense,
  Sp_Atk = sp_atk,
  Sp_Def = sp_def,
  Speed = speed
)

# Convert into numeric columns for number, total_stats, hp, attack, defense, sp_atk, sp_def & speed
# Reference: https://stackoverflow.com/questions/22772279/converting-multiple-columns-from-character-to-numeric-format-in-r

columns <- c("Number", "Total_Stats", "HP", "Attack", "Defense", "Sp_Atk", "Sp_Def", "Speed")

pokemon_df[columns] <- sapply(pokemon_df[columns], as.numeric)

# Save into .csv file:

write.csv(pokemon_df, paste("pokemon_db_table", '.csv', sep = ""), row.names = FALSE)
