# Pokemon Table from Pokemondb Webscarping In R

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

poke_num <- pokemon %>% html_elements('span.infocard-cell-data') %>% html_text2()

## Extract Pokemon Name:
name <- pokemon %>% html_elements('td.cell-name')  %>% html_text2()

# Remove \n tag:
name <- gsub('[\n]', ' ', name)

## Pokemon Type:
type <- pokemon %>% html_elements('td.cell-icon')  %>% html_text2()

# Remove \n tag and trim whitespace on the right.
type <- gsub('[\n]', ' ', type) 
type <- trimws(type, which = "right")

## Total Stats:
total_stats <- pokemon %>% html_elements('td.cell-total')  %>% html_text2()

## HP, Seq filtering needed as Attack, Def, Sp Attk, Sp Def and Speed all share the class cell-num in td tag.
hp <- pokemon %>% html_elements('td.cell-num')  %>% .[seq(2, length(pokemon) * 7, 7)] %>% html_text2()

## Attack:
attack <- pokemon %>% html_elements('td.cell-num')  %>% .[seq(3, length(pokemon) * 7 , 7)] %>% html_text2()

## Defense:
defense <- pokemon %>% html_elements('td.cell-num')  %>% .[seq(4, length(pokemon) * 7 , 7)] %>% html_text2()

## Special Attack:
sp_atk <- pokemon %>% html_elements('td.cell-num')  %>% .[seq(5, length(pokemon) * 7 , 7)] %>% html_text2()

## Special Defense:
sp_def <- pokemon %>% html_elements('td.cell-num')  %>% .[seq(6, length(pokemon) * 7 , 7)] %>% html_text2()

## Speed
speed <- pokemon %>% html_elements('td.cell-num')  %>% .[seq(7, length(pokemon) * 7 , 7)] %>% html_text2()

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
