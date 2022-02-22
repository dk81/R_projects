# Amazon.ca Webscraping in R
# Started on Feb 20, 2022

# Load libraries:
library(rvest)
library(dplyr)
library(tidyr)


# Url page:
url <- "https://www.amazon.ca/gp/bestsellers/electronics/?ie=UTF8&ref_=sv_ce_2"

# Amazon.ca Best Sellers in Electronics
amazon_page <- read_html(url)


# Extract Items - Obtain Item, Stars, Number of Reviews, Price
# It gives best 30 items, not the 50 max for the page

items <- amazon_page %>%
         html_nodes("[class='_p13n-zg-list-grid-desktop_truncationStyles_p13n-sc-css-line-clamp-3__g3dy1']") %>%
         html_text2()

stars <- amazon_page %>%
         html_nodes("[class='a-icon-alt']") %>%
         html_text2()

num_reviews <- amazon_page %>%
               html_nodes("[class='a-size-small']") %>%
               html_text2()

prices <- amazon_page %>%
          html_nodes("[class='a-size-base a-color-price']") %>%
          html_text2()

## Make Dataframe:
amazon_electronics_df <- data.frame(
  Items = items,
  Review_Stars = stars,
  Number_Reviews = num_reviews,
  Price = prices
)

# Dataframe sample:
head(amazon_electronics_df)

# Save to .csv:
write.csv(amazon_electronics_df, paste("Amazon_Electronics_BestSellers_", Sys.Date(), '.csv', sep = ""))