# Pokemon (Gen 1) Types Chart In R

# Made on April 2, 2017 

# Reference: http://pokemondb.net/type
# Gen 1 Pokemon had 150 Pokemon and Mew without the Dark, Steel and Fairy types.
# https://img.pokemondb.net/images/typechart-gen1.png

pokemonTypes <- c("Normal", "Fire", "Water", "Electric", "Grass", "Ice",
                 "Fighting", "Poison", "Ground", "Flying", "Psychic",
                 "Bug", "Rock", "Ghost", "Dragon")

# Length of Vector / Number of Types in Pokemon Gen 1:
length(pokemonTypes)


# Create Cartesian Product Type Table: 
# Attacker in Column 1 and Defender in Column 2

cartesianProd <- expand.grid(pokemonTypes, pokemonTypes)
cartesianProd <- as.data.frame(cartesianProd)

# Check (15 x 15 = 225 combinations):

cartesianProd 

# Add empty column:

cartesianProd[, 3] <- NA

# Rename column names:

colnames(cartesianProd) <- c("Attack_Type", "Defense_Type", "Attack Damage Multiplier")

# Check #2:

head(cartesianProd, n = 10)

##------------------------------------

# Fill in third column accordingly:

# 1: Normal Damage, 1/2 Not Very Effective, 0 No effect
# 2 Super Effective

# Normal as Defending Pokemon:

cartesianProd[1:15, 3] <- c(1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 0, 1)

# Fire as Defending Pokemon:

cartesianProd[16:30, 3] <- c(1, 1/2, 2, 1, 1/2, 1, 1, 1, 2, 1, 1, 1/2, 2, 1, 1)

# Water as Defending Pokemon:

cartesianProd[31:45, 3] <- c(1, 1/2, 1/2, 2, 2, 1/2, 1, 1, 1, 1, 1, 1, 1, 1, 1)

# Electric as Defending Pokemon:

cartesianProd[46:60, 3] <- c(1, 1, 1, 1/2, 1, 1, 1, 1, 2, 1/2, 1, 1, 1, 1, 1)

# Grass as Defending Pokemon:

cartesianProd[61:75, 3] <- c(1, 2, 1/2, 1/2, 1/2, 2, 1, 2, 1/2, 2, 1, 2, 1, 1, 1)

# Ice as Defending Pokemon:

cartesianProd[76:90, 3] <- c(1, 2, 1, 1, 1, 1/2, 2, 1, 1, 1, 1, 1, 2, 1, 1)

# Fighting as Defending Pokemon:

cartesianProd[91:105, 3] <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1/2, 1/2, 1, 1)

# Poison as Defending Pokemon:

cartesianProd[106: 120, 3] <- c(1, 1, 1, 1, 1/2, 1, 1/2, 1/2, 2, 1, 2, 2, 1, 1, 1)

# Ground as Defending Pokemon:

cartesianProd[121: 135, 3] <- c(1, 1, 2, 0, 2, 2, 1, 1/2, 1, 1, 1, 1, 1/2, 1, 1)

# Flying as Defending Pokemon:

cartesianProd[136: 150, 3] <- c(1, 1, 1, 2, 1/2, 2, 1/2, 1, 0, 1, 1, 1/2, 2, 1, 1)

# Psychic as Defending Pokemon:

cartesianProd[151:165, 3] <- c(1, 1, 1, 1, 1, 1, 1/2, 1, 1, 1, 1/2, 2, 1, 0, 1)

# Bug as Defending Pokemon:

cartesianProd[166:180, 3] <- c(1, 2, 1, 1, 1/2, 1, 1/2, 2, 1/2, 2, 1, 1, 2, 1, 1)

# Rock as Defending Pokemon:

cartesianProd[181:195, 3] <- c(1/2, 1/2, 2, 1, 2, 1, 2, 1/2, 2, 1/2, 1, 1, 1, 1, 1)

# Ghost as Defending Pokemon:

cartesianProd[196:210, 3] <- c(0, 1, 1, 1, 1, 1, 0, 1/2, 1, 1, 1, 1, 1, 2, 1)

# Dragon as Defending Pokemon:

cartesianProd[211:225, 3] <- c(1, 1/2, 1/2, 1/2, 1/2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2)

#---------------------------------

# Check again (optional):

#cartesianProd 

# Have the multipliers in column 3 as factors:

cartesianProd[, 3] <- as.factor(cartesianProd[, 3])

# Check structure:

str(cartesianProd)

## ------------------------------------------------------

# Creating the plot:

library(ggplot2)

# Making the plot - Version 1
# Defense on x-axis and Attack on y-axis (similar to website):

# Source for rotated x-axis text: 
# http://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
# \n for spacing: http://stackoverflow.com/questions/14487188/increase-distance-between-text-and-title-on-the-y-axis

ggplot(cartesianProd,aes(x = cartesianProd[, 2],y = cartesianProd[, 1],fill = cartesianProd[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('black', 'red','gray', "green")) +
  labs(x = "\n Defense Type", y = "Attack Type \n", 
       title = "Pokemon Type Chart", fill = "Attack Damage Multiplier \n") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90,vjust = 0.2, hjust = 1),
        legend.title = element_text(face="bold", size = 10)) 


# Making the plot - Version 2

# Attack Type on x-axis and Defense Type on y-axis:

ggplot(cartesianProd,aes(x = cartesianProd[, 1],y = cartesianProd[, 2],fill = cartesianProd[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('black', 'red','gray', "green")) +
  labs(x = "\n Attack Type", y = "Defense Type \n", 
       title = "Pokemon Type Chart", fill = "Attack Damage Multiplier \n") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90,vjust = 0.2, hjust = 1),
        legend.title = element_text(face="bold", size = 10)) 

# Making the plot - Version 3:

# Defense on x-axis and Attack on y-axis (similar to website) with x-axis on top:

# scale_x_discrete(position = "top") Source Link:
# http://stackoverflow.com/questions/26838005/putting-x-axis-at-top-of-ggplot2-chart

ggplot(cartesianProd,aes(x = cartesianProd[, 2],y = cartesianProd[, 1],fill = cartesianProd[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('black', 'red','gray', "green")) +
  labs(x = "Defense Type \n", y = "Attack Type \n", 
       title = "Pokemon Type Chart", fill = "Attack Damage Multiplier\n") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90,vjust = 0.2, hjust = 1),
        legend.title = element_text(face="bold", size = 10)) +
  scale_x_discrete(position = "top") 

# Making the plot - Version 4:
# # Attack Type on x-axis and Defense Type on y-axis with x-axis labels on top:

# Attack Type on x-axis and Defense Type on y-axis:

ggplot(cartesianProd,aes(x = cartesianProd[, 1],y = cartesianProd[, 2],fill = cartesianProd[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('black', 'red','gray', "green")) +
  labs(x = "Attack Type \n", y = "Defense Type \n", 
       title = "Pokemon Type Chart", fill = "Attack Damage Multiplier \n") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90,vjust = 0.2, hjust = 1),
        legend.title = element_text(face="bold", size = 10)) +
  scale_x_discrete(position = "top") 