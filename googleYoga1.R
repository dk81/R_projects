# Google Data Practice 1:

# You can find data on the Google Trends Datastore:

# Annual Yoga Searches by State data (USA):

url <- url("https://raw.githubusercontent.com/googletrends/data/master/20160502_YogaByStateYear.csv")

yoga_data <- read.csv(url, header = TRUE, sep = ",")

# Take a look at the data:

dim(yoga_data)

head(yoga_data)

str(yoga_data)

# Fixing messy Data:

# Remove first row which says: "values show search interest per year in yoga... ":

yoga_data <- yoga_data[-1, ]

head(yoga_data)

# Check for any missing values:
sum(is.na(yoga_data))

# Notice how the column names other than the first column are states:
# Use gather() to turn columns into rows:

library(tidyr)

yoga_data <- gather(yoga_data, "State", "Yoga.Index.Search", -1)

head(yoga_data)

dim(yoga_data)

# Change first column X into Year:

colnames(yoga_data) <- c("Year", "State", "Yoga.Index.Search")

head(yoga_data)


# Get Rid of the "..us.xx" part at the end of each State observation
# http://www.endmemo.com/program/R/substr.php

yoga_data[,2] <- substr(yoga_data[,2], start = 1, stop = nchar(yoga_data[,2]) - 8)

head(yoga_data, n = 20)

## Replace dots in states such as North.Dakota, New.Jersey etc. using gsub:

yoga_data[,2] <- gsub(pattern = "\\.", replacement = " ", yoga_data[,2])


###---------------------------------------

# Save this "clean" data into a new variable for data analysis, data visualzation, etc.:

yoga_clean <- yoga_data



###---------------------------------------
library(dplyr)

# ------ 

# Top 5 States for Annual Yoga Searches Per Year:

yoga_topfive <- yoga_clean %>% 
                  group_by(Year) %>% 
                    arrange(Year, desc(Yoga.Index.Search)) %>% 
                       filter(row_number() <= 5)

# Source/Reference: https://groups.google.com/forum/#!topic/manipulatr/ZzohinbNsJc

#filter(row_number() <= 10)
# row_number is equivalent to rank:

yoga_topfive <- data.frame(yoga_topfive)

yoga_topfive

# ------ 

# Total Yoga Searches From 2004 to 2016:

# <- yoga_clean %>% 
                    group_by(State) %>% 
                      summarise_each(funs(sum), Yoga.Index.Search = Yoga.Index.Search) %>% 
                          arrange(desc(Yoga.Index.Search)) 

# Source: https://groups.google.com/forum/#!topic/manipulatr/ZzohinbNsJc

#filter(row_number() <= 10)
# row_number is equivalent to rank:

#alltime  <- data.frame(alltime)
#alltime

# Top Five States For Yoga Searches from 2004 to 2016:

#alltime_five <- filter(alltime, row_number() <= 5)
#alltime_five

# Vermont:

vermont <- yoga_clean %>% filter(State == "Vermont")

data.frame(vermont)

# ----- Index Over 50:

over_fifty <- yoga_clean %>% 
                 group_by(State) %>% 
                    filter(Yoga.Index.Search > 50)

over_fifty <- data.frame(over_fifty)
over_fifty

# ---------------------------

## Plotting

#ggplot(yoga_clean, aes(x = Year, y = Yoga.Index.Search, col = State)) + geom_point()

# Best I can do here:

ggplot(yoga_clean, aes(x = State, y = Yoga.Index.Search, col = Year)) +
   geom_point() +
     theme(axis.text.x = element_text(angle = 90, hjust = 1))


# 2016 data only:

only_2016 <- yoga_clean %>% filter(Year == 2016)

only_2016 <- data.frame(only_2016)
only_2016

ggplot(only_2016, aes(x = State, y = Yoga.Index.Search)) +
  geom_point(col = "blue") +
  ggtitle("Google's Yoga Search Data in 2016 \n") +
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="blue", size = 12),
        axis.title.y = element_text(face="bold", colour="blue", size = 12),
        axis.text.x = element_text(angle = 90))


