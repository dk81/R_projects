# Rock Paper Scissors Matrix Table In R

# You Versus Opponent
# You can choose Rock, Paper or Scissors
# Rock Beats Scissors, Scissors Beats Paper and Paper Beats Rock

# Create empty table:

dataTable <- matrix(data = NA, nrow = 9, ncol = 3, byrow = TRUE)

dataTable <- as.data.frame(dataTable)

colnames(dataTable) <- c("You", "Opponent", "Outcome")

# Fill in columns

dataTable[, 1] <- c(rep("Rock", 3), rep("Paper", 3), rep("Scissors", 3))

dataTable[, 2] <- c(rep(c("Rock", "Paper", "Scissors"), 3))

dataTable[, 3] <- c(c("Draw", "Lose", "Win"), c("Win", "Draw", "Lose"), c("Lose", "Win", "Draw"))

# Check:

dataTable

# Convert Outcome as Factors:

#dataTable[, 3] <- as.factor(dataTable[, 3])

str(dataTable)

library(ggplot2)

# Matrix Plot:
# Source: http://stackoverflow.com/questions/10232525/geom-tile-heatmap-with-different-high-fill-colours-based-on-factor
# http://stackoverflow.com/questions/16074440/r-ggplot2-center-align-a-multi-line-title
# http://docs.ggplot2.org/dev/vignettes/themes.html
# http://docs.ggplot2.org/current/theme.html

# Creating the Rock, Paper, Scissors Matrix Plot:

ggplot(dataTable,aes(x = dataTable[, 1],y = dataTable[, 2],fill = dataTable[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('blue','red', "green")) +
  labs(x = "\n Your Choice", y = "Opponent's Choice \n", 
       title = "Rock, Paper, Scissors Chart \n", fill = "Your Outcome") + 
  theme(plot.title = element_text(hjust = 0.5), 
       axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
       axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
       legend.title = element_text(face="bold", size = 10)) 


#### Alternate Table Creation:

# can use expand.grid to make the Cartesian product table.
# Source: http://stackoverflow.com/questions/4309217/cartesian-product-data-frame-in-r

choices <- c("Rock", "Paper", "Scissors")

cartesianProd <- expand.grid(choices, choices)
cartesianProd <- as.data.frame(cartesianProd)

# Check:

cartesianProd 

# Add empty column:

cartesianProd[, 3] <- NA

# Check again:

cartesianProd 

# Rename column names:

colnames(cartesianProd) <- c("You", "Opponent", "Outcome")

# Check #3:

cartesianProd 

# Fill in third column accordingly:

cartesianProd[, 3] <- c(c("Draw", "Win", "Lose"), c("Lose", "Draw", "Win"), c("Win", "Lose", "Draw"))

# Check #4:

cartesianProd 

# Check structure:

#str(cartesianProd)

# Reformat third column:

#cartesianProd[, 3] <- as.factor(cartesianProd[, 3])

# Creating the plot:

ggplot(dataTable,aes(x = cartesianProd[, 1],y = cartesianProd[, 2],fill = cartesianProd[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('blue','red', "green")) +
  labs(x = "\n Your Choice", y = "Opponent's Choice \n", 
       title = "Rock, Paper, Scissors Chart \n", fill = "Your Outcome") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        legend.title = element_text(face="bold", size = 10)) 