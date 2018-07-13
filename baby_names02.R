# Sideways Bar Graph
# Analyzing Baby Names Part 2:
# A Bar Graph Approach


library(babynames) # Baby Names dataset:
library(ggplot2) # Data visualization
library(data.table) # For data wrangling and manipulation

# Save the babynames data into baby_data:

baby_data <- data.table(babynames)

# Preview the data:

head(baby_data); tail(baby_data)

# Structure of data:

str(baby_data)

# Change column names:

colnames(baby_data) <- c("Year", "Sex", "Name", "Count", "Proportion")

### --------------------------------------

## Finding The Top 20 Baby Names:

# Sort names from most popular to least popular (adds duplicates too):

sorted_names <- baby_data[ , .(Name.Count = sum(Count)), by = Name]
sorted_names <- sorted_names[order(-Name.Count)]

# Preview: 
head(sorted_names, n = 20)

top_twenty_babynames <- sorted_names[1:20, ]

# Preview: 
top_twenty_babynames

# Ggplot Bar Graph:

ggplot(top_twenty_babynames, aes(x = Name, y = Name.Count)) + 
  geom_bar(stat = "identity") +
  labs(x = "Name \n", y = "\n Count \n", title = "Top 20 Baby Names") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90, vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))

# Ggplot Sideways Bar Graph:

ggplot(top_twenty_babynames, aes(x = Name, y = Name.Count)) + 
  geom_bar(stat = "identity") + coord_flip() +
  labs(x = "Name \n", y = "\n Count \n", title = "Top 20 Baby Names") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(angle = 90, vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))

# Ggplot Sideways Bar Graph (Scaled):

ggplot(top_twenty_babynames, aes(x = Name, y = Name.Count/1000000)) + 
  geom_bar(stat = "identity") + coord_flip() +
  scale_y_continuous(breaks=seq(0, 6, 1)) +
  labs(x = "Name \n", y = "\n Count (Millions) \n", title = "Top 20 Baby Names") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))

# Getting The Sorted Bar Graph In ggplot2:

# We have the sorted top 20 baby names but ggplot would not recognize this 
# ordering.
# To have ggplot recognize this ordering, we have these 20 names
# as factors in the order of the most popular female
# name to the 20th most popular female name
# http://rstudio-pubs-static.s3.amazonaws.com/7433_4537ea5073dc4162950abb715f513469.html

top_twenty_babynames$Name <- factor(top_twenty_babynames$Name, 
                           levels = top_twenty_babynames$Name[order(top_twenty_babynames$Name.Count)]) 

# Ggplot Sideways Bar Graph (Fixed & Sorted):

ggplot(top_twenty_babynames, aes(x = Name, y = Name.Count/1000000)) + 
  geom_bar(stat = "identity") + coord_flip() +
  scale_y_continuous(breaks=seq(0, 6, 1)) + 
  geom_text(aes(label = round(Name.Count/1000000, 3)), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", title = "The Twenty Most Popular Baby Names") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))



#-------------------------

### Male Baby Names:

male_babynames <- baby_data[Sex == "M" , .(Name.Count = sum(Count)), by = Name][order(-Name.Count)]

head(male_babynames , n = 20)

# Order male baby names in descending order by Count:
# Reference: http://www.statmethods.net/management/sorting.html

male_babynames <- male_babynames[order(-Name.Count), ]

head(male_babynames, n = 20)

# Eliminate weird row numbers:
#rownames(male_babynames) <- NULL

# Top 20 Male Baby Names:

toptwenty_m <- male_babynames[1:20, ]

toptwenty_m

toptwenty_m$Name <- factor(toptwenty_m$Name, 
                    levels = toptwenty_m$Name[order(toptwenty_m$Name.Count)])


# Ggplot Sideways Bar Graph (Fixed & Sorted):

ggplot(toptwenty_m, aes(x = Name, y = Name.Count/1000000)) + 
  geom_bar(stat = "identity") + coord_flip() +
  scale_y_continuous(breaks=seq(0, 6, 1)) + 
  geom_text(aes(label = round(Name.Count/1000000, 3)), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", 
       title = "The Twenty Most Popular \n Male Baby Names \n") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))



#-----------------------------------------

# Getting the Top 20 Female Baby Names:

female_babynames <- baby_data[Sex == "F" , .(Name.Count = sum(Count)), by = Name][order(-Name.Count)]

head(female_babynames , n = 20)

# Order female baby names in descending order by Count:
# Reference: http://www.statmethods.net/management/sorting.html

female_babynames <- female_babynames[order(-Name.Count), ]

head(female_babynames, n = 20)

# Eliminate weird row numbers:
#rownames(male_babynames) <- NULL

# Top 20 Female Baby Names:

toptwenty_f <- female_babynames[1:20, ]

toptwenty_f

toptwenty_f$Name <- factor(toptwenty_f$Name, 
                  levels = toptwenty_f$Name[order(toptwenty_f$Name.Count)])


# Ggplot Sideways Bar Graph (Fixed & Sorted):

ggplot(toptwenty_f, aes(x = Name, y = Name.Count/1000000)) + 
  geom_bar(stat = "identity") + coord_flip() +
  scale_y_continuous(breaks=seq(0, 6, 1)) + 
  geom_text(aes(label = round(Name.Count/1000000, 3)), hjust = 1.2, colour = "white", fontface = "bold") +
  labs(x = "Name \n", y = "\n Count (Millions) \n", 
       title = "The Twenty Most Popular \n Female Baby Names") + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="#FF7A33", size = 12, vjust = 1),
        axis.title.y = element_text(face="bold", colour="#FF7A33", size = 12),
        axis.text.x = element_text(vjust = 0.1, hjust = 0.1),
        legend.title = element_text(face="bold", size = 10))


