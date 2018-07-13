
# Analyzing A Baby Names Dataset In R With dplyr
# With Sideways Bar Graphs
# Ref: https://stackoverflow.com/questions/27141565/how-to-sum-up-the-duplicated-value-while-keep-the-other-columns


library(babynames) # Baby Names dataset:
library(ggplot2) # For Data visualization & Graphs
library(dplyr) # For data wrangling and manipulation
library(stringr) # For strings and regex

# Save the babynames data into baby_data:

baby_data <- data.frame(babynames)

# Preview the data:

head(baby_data); tail(baby_data)

# Structure of data:

str(baby_data)

# Change column names:

colnames(baby_data) <- c("Year", "Sex", "Name", "Count", "Proportion")

head(baby_data); tail(baby_data)

### --------------------------------------

## 1) Finding The Top 20 Baby Names:

sorted_names <- baby_data %>% group_by(Name, Sex) %>% summarise(Total = sum(Count)) %>%
                      arrange(desc(Total))
sorted_names <- data.frame(sorted_names)

head(sorted_names, n = 20)

top_twenty_baby <- sorted_names[1:20, ]

top_twenty_baby

top_twenty_baby$Name <- factor(top_twenty_baby$Name, 
                       levels = top_twenty_baby$Name[order(top_twenty_baby$Total)]) 

top_twenty_baby$Sex <- as.factor(top_twenty_baby$Sex)


# Ggplot Sideways Bar Graph:

ggplot(top_twenty_baby, aes(x = Name, y = Total/1000000, fill = Sex)) + 
  geom_bar(stat = "identity") + coord_flip() +
  scale_y_continuous(breaks = seq(0, 6, 1)) + 
  geom_text(aes(label = round(Total/1000000, 2)), hjust = 1.2, colour = "black", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", title = "Top 20 Baby Names (1880 - 2015) \n") + 
  theme(plot.title = element_text(hjust = 0.5, colour = "darkblue"), 
        axis.title.x = element_text(face ="bold", colour ="darkred", size = 12, vjust = 1),
        axis.title.y = element_text(face ="bold", colour ="darkred", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face ="bold", size = 10))


## 2) Finding The Top 20 Female Baby Names:

female_names <- baby_data %>% filter(Sex == "F") %>% group_by(Name) %>% 
                 summarise(Total = sum(Count)) %>% arrange(desc(Total))
female_names <- data.frame(female_names)

head(female_names, n = 20)

top_twenty_female <- female_names[1:20, ]

top_twenty_female$Name <- factor(top_twenty_female$Name, 
                               levels = top_twenty_female$Name[order(top_twenty_female$Total)]) 


# Ggplot Sideways Bar Graph:

ggplot(top_twenty_female, aes(x = Name, y = Total/1000000)) + 
  geom_bar(stat = "identity", fill = "maroon") + coord_flip() +
  scale_y_continuous(breaks = seq(0, 6, 1)) + 
  geom_text(aes(label = round(Total/1000000, 2)), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", title = "Top 20 Female Baby Names (1880 - 2015) \n") + 
  theme(plot.title = element_text(hjust = 0.5, colour = "darkblue"), 
        axis.title.x = element_text(face="bold", colour="darkgreen", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="darkgreen", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))



## 3) Finding The Top 20 Male Baby Names:

male_names <- baby_data %>% filter(Sex == "M") %>% group_by(Name) %>% 
  summarise(Total = sum(Count)) %>% arrange(desc(Total))
male_names <- data.frame(male_names)

head(male_names, n = 20)

top_twenty_male <- male_names[1:20, ]

top_twenty_male$Name <- factor(top_twenty_male$Name, 
                        levels = top_twenty_male$Name[order(top_twenty_male$Total)]) 


# Ggplot Sideways Bar Graph:

ggplot(top_twenty_male, aes(x = Name, y = Total/1000000)) + 
  geom_bar(stat = "identity", fill = "blue", alpha = 0.6) + coord_flip() +
  scale_y_continuous(breaks = seq(0, 6, 1)) + 
  geom_text(aes(label = round(Total/1000000, 2)), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", title = "Top 20 Male Baby Names (1880 - 2015) \n") + 
  theme(plot.title = element_text(hjust = 0.5, colour = "darkblue"), 
        axis.title.x = element_text(face="bold", colour="darkgreen", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="darkgreen", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))


## 4) Popular Baby Names By Letter

# grepl Function:

grepl("^[Z]", "Zorro") # Is first letter a Z? True or False?

letterM <- baby_data %>% filter(grepl("^[M]", Name)) 

sum(letterM$Count)

letterA <- baby_data %>% filter(grepl("^[A]", Name)) 

sum(letterA$Count)

letterZ <- baby_data %>% filter(grepl("^[Z]", Name)) 

sum(letterZ$Count)

## Getting the counts by first letter in baby names with a for loop.

letterCounts <- c() #Empty vector

for (char in LETTERS) {
  total <- baby_data %>% filter(grepl(paste0("^[", noquote(char), "]"), Name))
  letterCounts <- append(letterCounts, sum(total$Count)) 
}

str(letterCounts)

letterCounts_tbl <- data.frame("First_Letter" = LETTERS, "Count" = letterCounts)


letterCounts_tbl$First_Letter <- factor(letterCounts_tbl$First_Letter, 
                               levels = letterCounts_tbl$First_Letter[order(letterCounts_tbl$Count)]) 

top_fifteen_firstLetter <- letterCounts_tbl[1:15, ]

# Ggplot Sideways Bar Graph (With removed x axes):
# Ref: https://stackoverflow.com/questions/35090883/remove-all-of-x-axis-labels-in-ggplot
# http://felixfan.github.io/ggplot2-remove-grid-background-margin/

ggplot(top_fifteen_firstLetter , aes(x = First_Letter, y = Count/1000000)) + 
  geom_bar(stat = "identity") + coord_flip() +
  scale_y_continuous(breaks = seq(0, 6, 1)) + 
  geom_text(aes(label = round(Count/1000000, 1)), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", title = "Top 15 Baby Names By First Letter (1880 - 2015) \n") + 
  theme(plot.title = element_text(hjust = 0.5, colour = "darkblue"), 
        axis.title.x = element_text(face="bold", colour="darkgreen", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="darkgreen", size = 12),
        axis.text.x = element_blank(),
        axis.ticks.x=element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        legend.title = element_text(face="bold", size = 10)) 


