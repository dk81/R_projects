# Pokemon Gen 6+ Types Chart In R

# Made on April 2, 2017 

# Reference: http://pokemondb.net/type

# Fairy type now included in Gen 6+:
# Chart Reference: https://img.pokemondb.net/images/typechart.png

pokemonTypes<- c("Normal", "Fire", "Water", "Electric", "Grass", "Ice",
                 "Fighting", "Poison", "Ground", "Flying", "Psychic",
                 "Bug", "Rock", "Ghost", "Dragon", "Dark", "Steel", "Fairy")

# Length of Vector / Number of Types in Pokemon Gen 6+:
length(pokemonTypes)


# Create Cartesian Product Type Table: 
# Attacker in Column 1 and Defender in Column 2

pokeTable <- expand.grid(pokemonTypes, pokemonTypes)
pokeTable <- as.data.frame(pokeTable)

# Check dimensions (18 x 18 = 324 combinations):

dim(pokeTable)

# Preview the table using head and tail functions:

head(pokeTable, n = 10)

tail(pokeTable, n = 10)

# Add third (empty) Column for Attack Damage Mutliplier:

pokeTable[, 3] <- NA

# Rename column names:

colnames(pokeTable) <- c("Attack_Type", "Defense_Type", "Attack Damage Multiplier")

# Check #2:

head(pokeTable, n = 10)

##------------------------------------

# Fill in third column accordingly:

# 1: Normal Damage, 1/2 Not Very Effective, 0 No effect
# 2 Super Effective

# 18 Per Row/COlumn

# Normal as Defending Pokemon:

pokeTable[1:18, 3] <- c(1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1)

# Fire as Defending Pokemon:

pokeTable[19:36, 3] <- c(1, 1/2, 2, 1, 1/2, 1/2, 1, 1, 2, 1, 1, 1/2, 2, 1, 1, 1, 1/2, 1/2)

# Water as Defending Pokemon:

pokeTable[37:54, 3] <- c(1, 1/2, 1/2, 2, 2, 1/2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1/2, 1)

# Electric as Defending Pokemon:

pokeTable[55:72, 3] <- c(1, 1, 1, 1/2, 1, 1, 1, 1, 2, 1/2, 1, 1, 1, 1, 1, 1, 1/2, 1)

# Grass as Defending Pokemon:

pokeTable[73:90, 3] <- c(1, 2, 1/2, 1/2, 1/2, 2, 1, 2, 1/2, 2, 1, 2, 1, 1, 1, 1, 1, 1)

# Ice as Defending Pokemon:

pokeTable[91:108, 3] <- c(1, 2, 1, 1, 1, 1/2, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1)

# Fighting as Defending Pokemon:

pokeTable[109:126, 3] <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1/2, 1/2, 1, 1, 1/2, 1, 2)

# Poison as Defending Pokemon:

pokeTable[127:144, 3] <- c(1, 1, 1, 1, 1/2, 1, 1/2, 1/2, 2, 1, 2, 1/2, 1, 1, 1, 1, 1, 1/2)

# Ground as Defending Pokemon:

pokeTable[145:162, 3] <- c(1, 1, 2, 0, 2, 2, 1, 1/2, 1, 1, 1, 1, 1/2, 1, 1, 1, 1, 1)

# Flying as Defending Pokemon:

pokeTable[163:180, 3] <- c(1, 1, 1, 2, 1/2, 2, 1/2, 1, 0, 1, 1, 1/2, 2, 1, 1, 1, 1, 1)

# Psychic as Defending Pokemon:

pokeTable[181:198, 3] <- c(1, 1, 1, 1, 1, 1, 1/2, 1, 1, 1, 1/2, 2, 1, 2, 1, 2, 1, 1)

# Bug as Defending Pokemon:

pokeTable[199:216, 3] <- c(1, 2, 1, 1, 1/2, 1, 1/2, 1, 1/2, 2, 1, 1, 2, 1, 1, 1, 1, 1)

# Rock as Defending Pokemon:

pokeTable[217:234, 3] <- c(1/2, 1/2, 2, 1, 2, 1, 2, 1/2, 2, 1/2, 1, 1, 1, 1, 1, 1, 2, 1)

# Ghost as Defending Pokemon:

pokeTable[235:252, 3] <- c(0, 1, 1, 1, 1, 1, 0, 1/2, 1, 1, 1, 1/2, 1, 2, 1, 2, 1, 1)

# Dragon as Defending Pokemon:

pokeTable[253:270, 3] <- c(1, 1/2, 1/2, 1/2, 1/2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2)

# Dark as Defending Pokemon:

pokeTable[271:288, 3] <- c(1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 0, 2, 1, 1/2, 1, 1/2, 1, 2)

# Steel as Defending Pokemon:

pokeTable[289:306, 3] <- c(1/2, 2, 1, 1, 1/2, 1/2, 2, 0, 2, 1/2, 1/2, 1/2, 1/2, 1, 1/2, 1, 1/2, 1/2)

# Fairy as Defending Pokemon:

pokeTable[307:324, 3] <- c(1, 1, 1, 1, 1, 1, 1/2, 2, 1, 1, 1, 1/2, 1, 1, 0, 1/2, 2, 1)


#---------------------------------

# Check again (optional):

# cartesianProd 

# Have the multipliers in column 3 as factors:

pokeTable[, 3] <- as.factor(pokeTable[, 3])

# Check structure:

str(pokeTable)

# Check #3:

head(pokeTable, n = 10)

tail(pokeTable, n = 10)

## ------------------------------------------------------

# Creating the plot:

library(ggplot2)

# Making the plot
# Defense on x-axis and Attack on y-axis (similar to website):

# Source for rotated x-axis text: 
# http://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
# \n for spacing: http://stackoverflow.com/questions/14487188/increase-distance-between-text-and-title-on-the-y-axis

# # Attack Type on x-axis and Defense Type on y-axis with x-axis labels on top:

ggplot(pokeTable,aes(x = pokeTable[, 2],y = pokeTable[, 1], fill = pokeTable[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('black', 'red','gray', "green")) +
  labs(x = "Defense Type \n", y = "Attack Type \n", 
       title = "Pokemon Type Chart", fill = "Attack Damage Multiplier \n") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90,vjust = 0.2, hjust = 1),
        legend.title = element_text(face="bold", size = 10)) +
  scale_x_discrete(position = "top") 