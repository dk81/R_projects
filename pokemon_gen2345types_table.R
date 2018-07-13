# Pokemon (Gen 2 - 5) Types Chart In R

# Made on April 2, 2017 by David Ku

# Reference: http://pokemondb.net/type

# Gen 2 - 5 now has Dark and Steel added but Fairy not added until XY series (Gen 6):
# Chart Reference: https://img.pokemondb.net/images/typechart-gen2345.png

pokemonTypes <- c("Normal", "Fire", "Water", "Electric", "Grass", "Ice",
                 "Fighting", "Poison", "Ground", "Flying", "Psychic",
                 "Bug", "Rock", "Ghost", "Dragon", "Dark", "Steel")

# Length of Vector / Number of Types in Pokemon Gen 2-5:
length(pokemonTypes)


# Create Cartesian Product Type Table: 
# Attacker in Column 1 and Defender in Column 2

cartesianProd <- expand.grid(pokemonTypes, pokemonTypes)
cartesianProd <- as.data.frame(cartesianProd)

# Check dimensions (17 x 17 = 289 combinations):

dim(cartesianProd)

# Preview the table using head and tail functions:

head(cartesianProd, n = 10)

tail(cartesianProd, n = 10)

# Add third (empty) Column for Attack Damage Mutliplier:

cartesianProd[, 3] <- NA

# Rename column names:

colnames(cartesianProd) <- c("Attack_Type", "Defense_Type", "Attack Damage Multiplier")

# Check #2:

head(cartesianProd, n = 10)

tail(cartesianProd, n = 10)

##------------------------------------

# Fill in third column accordingly:

# 1: Normal Damage, 1/2 Not Very Effective, 0 No effect
# 2 Super Effective

# 17 Per Row/COlumn

# Normal as Defending Pokemon:

cartesianProd[1:17, 3] <- c(1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1)

# Fire as Defending Pokemon:

cartesianProd[18:34, 3] <- c(1, 1/2, 2, 1, 1/2, 1/2, 1, 1, 2, 1, 1, 1/2, 2, 1, 1, 1, 1/2)

# Water as Defending Pokemon:

cartesianProd[35:51, 3] <- c(1, 1/2, 1/2, 2, 2, 1/2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1/2)

# Electric as Defending Pokemon:

cartesianProd[52:68, 3] <- c(1, 1, 1, 1/2, 1, 1, 1, 1, 2, 1/2, 1, 1, 1, 1, 1, 1, 1/2)

# Grass as Defending Pokemon:

cartesianProd[69:85, 3] <- c(1, 2, 1/2, 1/2, 1/2, 2, 1, 2, 1/2, 2, 1, 2, 1, 1, 1, 1, 1)

# Ice as Defending Pokemon:

cartesianProd[86:102, 3] <- c(1, 2, 1, 1, 1, 1/2, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2)

# Fighting as Defending Pokemon:

cartesianProd[103:119, 3] <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1/2, 1/2, 1, 1, 1/2, 1)

# Poison as Defending Pokemon:

cartesianProd[120: 136, 3] <- c(1, 1, 1, 1, 1/2, 1, 1/2, 1/2, 2, 1, 2, 1/2, 1, 1, 1, 1, 1)

# Ground as Defending Pokemon:

cartesianProd[137: 153, 3] <- c(1, 1, 2, 0, 2, 2, 1, 1/2, 1, 1, 1, 1, 1/2, 1, 1, 1, 1)

# Flying as Defending Pokemon:

cartesianProd[154: 170, 3] <- c(1, 1, 1, 2, 1/2, 2, 1/2, 1, 0, 1, 1, 1/2, 2, 1, 1, 1, 1)

# Psychic as Defending Pokemon:

cartesianProd[171:187, 3] <- c(1, 1, 1, 1, 1, 1, 1/2, 1, 1, 1, 1/2, 2, 1, 2, 1, 2, 1)

# Bug as Defending Pokemon:

cartesianProd[188:204, 3] <- c(1, 2, 1, 1, 1/2, 1, 1/2, 1, 1/2, 2, 1, 1, 2, 1, 1, 1, 1)

# Rock as Defending Pokemon:

cartesianProd[205:221, 3] <- c(1/2, 1/2, 2, 1, 2, 1, 2, 1/2, 2, 1/2, 1, 1, 1, 1, 1, 1, 2)

# Ghost as Defending Pokemon:

cartesianProd[222:238, 3] <- c(0, 1, 1, 1, 1, 1, 0, 1/2, 1, 1, 1, 1/2, 1, 2, 1, 2, 1)

# Dragon as Defending Pokemon:

cartesianProd[239:255, 3] <- c(1, 1/2, 1/2, 1/2, 1/2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1)

# Dark as Defending Pokemon:

cartesianProd[256:272, 3] <- c(1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 0, 2, 1, 1/2, 1, 1/2, 1)

# Steel as Defending Pokemon:

cartesianProd[273:289, 3] <- c(1/2, 2, 1, 1, 1/2, 1/2, 2, 0, 2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2)

#---------------------------------

# Check again (optional):

# cartesianProd 

# Have the multipliers in column 3 as factors:

cartesianProd[, 3] <- as.factor(cartesianProd[, 3])

# Check structure:

str(cartesianProd)

# Check #3:

head(cartesianProd, n = 10)

tail(cartesianProd, n = 10)

## ------------------------------------------------------

# Creating the plot:

library(ggplot2)

# Making the plot - Version 1
# Defense on x-axis and Attack on y-axis (similar to website):

# Source for rotated x-axis text: 
# http://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
# \n for spacing: http://stackoverflow.com/questions/14487188/increase-distance-between-text-and-title-on-the-y-axis


# Making the plot:
# # Attack Type on x-axis and Defense Type on y-axis with x-axis labels on top:

# Attack Type on y-axis and Defense Type on x-axis:

ggplot(cartesianProd,aes(x = cartesianProd[, 2],y = cartesianProd[, 1], fill = cartesianProd[, 3])) + 
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