# Rock Paper Scissors Lizard Spock Matrix Table In R

# You Versus Opponent
# You can choose Rock, Paper, Scissors, Lizard, Spock
# Rock Beats Scissors, Scissors Beats Paper and Paper Beats Rock

# Full charts can be found at: http://www.samkass.com/theories/RPSSL.gif
# or http://www.momsminivan.com/rock-paper-spock.jpg

# Create empty table:

dataTable <- matrix(data = NA, nrow = 25, ncol = 3, byrow = TRUE)

dataTable <- as.data.frame(dataTable)

colnames(dataTable) <- c("You", "Opponent", "Outcome")

# Fill in columns

dataTable[, 1] <- c(rep("Rock", 5), rep("Paper", 5), rep("Scissors", 5), 
                    rep("Lizard", 5), rep("Spock", 5))

dataTable[, 2] <- c(rep(c("Rock", "Paper", "Scissors", "Lizard", "Spock"), 5))

# Check:

dataTable

# Filling In The Outcome Column:

outcome_col <- c("Draw", "Lose", "Win", "Win", "Lose",
                 "Win", "Draw", "Lose", "Lose", "Win",
                 "Lose", "Win", "Draw", "Win", "Lose",
                 "Lose", "Win", "Lose", "Draw", "Win",
                 "Win", "Lose", "Win", "Lose", "Draw")


# Place outcome_col as third column and convert as factors:

dataTable[, 3] <- outcome_col
dataTable[, 3] <- as.factor(dataTable[, 3])

# Check again:

dataTable

str(dataTable)

#----------------------

# Load ggplot2 library:

library(ggplot2)

# Matrix Plot:
# Source: http://stackoverflow.com/questions/10232525/geom-tile-heatmap-with-different-high-fill-colours-based-on-factor
# http://stackoverflow.com/questions/16074440/r-ggplot2-center-align-a-multi-line-title
# http://docs.ggplot2.org/dev/vignettes/themes.html

# Creating the Rock, Paper, Scissors Matrix Plot:

ggplot(dataTable,aes(x = dataTable[, 1],y = dataTable[, 2],fill = dataTable[, 3])) + 
  geom_tile() + 
  scale_fill_manual(values = c('blue','red', "green")) +
  labs(x = "Your Choice", y = "Opponent's Choice", 
       title = "Rock, Paper, Scissors, Lizard, Spock Chart", fill = "Your Outcome") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#3355FF", size = 12),
        axis.title.y = element_text(face="bold", colour="#3355FF", size = 12),
        legend.title = element_text(face="bold", size = 10))
  

#-----------------------------------------

## Alternate/Faster Way:

library(ggplot2)

choices <- c("Rock", "Paper", "Scissors", "Lizard", "Spock")

dataTable <- expand.grid(choices, choices)

dataTable <- as.data.frame(dataTable)

dataTable

# Add third column:

dataTable[ , 3] <- NA

# Add column names:

colnames(dataTable) <- c("You", "Opponent", "Outcome")

# Check:

dataTable

# Input third column (outcome) data accordingly:

dataTable[, 3] <- c("Draw", "Win", "Lose", "Lose", "Win",
                    "Lose", "Draw", "Win", "Win", "Lose",
                    "Win", "Lose", "Draw", "Lose", "Win",
                    "Win", "Lose", "Win", "Draw", "Lose",
                    "Lose", "Win", "Lose", "Win", "Draw") 

# Place outcome_col as third column and convert as factors:

dataTable[, 3] <- as.factor(dataTable[, 3])

# Check structure:

str(dataTable)

# Check #2:

dataTable

# Creating the Rock, Paper, Scissors Matrix Plot:

ggplot(dataTable,aes(x = You,y = Opponent, fill = Outcome)) + 
  geom_tile() + 
  scale_fill_manual(values = c('blue','red', "green")) +
  labs(x = "\n Your Choice", y = "Opponent's Choice \n", 
       title = "Rock, Paper, Scissors, Lizard, Spock Chart \n", 
       fill = "Your Outcome \n ") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="maroon", size = 12),
        axis.title.y = element_text(face="bold", colour="maroon", size = 12),
        legend.title = element_text(face="bold", size = 10))