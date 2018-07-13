# If you need to install Quandl:

install.packages("Quandl")

# Loading Financial data With Quandl:

library(Quandl)
library(ggplot2)

# Helpful Youtube guide: https://www.youtube.com/watch?v=qg5alOoczNo

# Source: https://www.quandl.com/data/YAHOO/MSFT-MSFT-Microsoft-Corporation
# https://www.quandl.com/tools/r

# Authorization (Set your own API key):

Quandl.api_key("<api_key>")

microsoft <- Quandl("YAHOO/MSFT")

# A look at our dataset:
dim(microsoft); head(microsoft); tail(microsoft)

summary(microsoft)

ggplot(microsoft, aes(x = Date)) +
  geom_line(aes(y = Close), col = "black") +
  ylim(0, 200) +
  xlab("\n Year") +
  ylab("Closing Stock Price\n")

## Basic statistics and information:

# Mean closing stock price from March 13, 1986 to July 29, 2016 period:

mean_close <- mean(microsoft$Close); mean_close

# Average stock price 

# Extract row with lowest closing stock price:
microsoft[microsoft$Close == min(microsoft$Close), ]

# Extract row with highest closing stock price:
microsoft[microsoft$Close == max(microsoft$Close), ]

# Extract row with highest volume:
microsoft[microsoft$Volume == max(microsoft$Volume), ]

#------------------------------------------------

# Looking at microsoft from 2000 to July 29, 2016:

microsoft2000 <- Quandl("YAHOO/MSFT", start_date = "2000-01-01", end_date = "2016-07-29")

# A look at our dataset:
dim(microsoft2000); head(microsoft2000); tail(microsoft2000)

summary(microsoft2000)

# Plotting the closing stock prices from Jan 1, 2000 to July 29, 2016:

ggplot(microsoft2000, aes(x = Date)) +
  geom_line(aes(y = Close), col = "black") +
  ylim(0, 150) +
  xlab("\n Year") +
  ylab("Closing Stock Price\n")

# Mean closing stock price from March 13, 1986 to July 29, 2016 period:

mean_close2000 <- mean(microsoft2000$Close); mean_close2000

# Average stock price 

# Extract row with lowest closing stock price:
microsoft2000[microsoft2000$Close == min(microsoft2000$Close), ]

# Extract row with highest closing stock price:
microsoft2000[microsoft2000$Close == max(microsoft2000$Close), ]

# Extract row with highest volume:
microsoft2000[microsoft2000$Volume == max(microsoft2000$Volume), ]
