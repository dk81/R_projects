# Newegg.ca Webscraping Project
# Started on February 16, 2022

# Load libraries:
library(rvest)
library(dplyr)
library(tidyr)

# Laptops URL on Newegg
url <- "https://www.newegg.ca/p/pl?Submit=StoreIM&Category=223&Depa=3"

# Newegg laptops
newegg_laptops <- read_html(url)

# Laptops Information, each tile for a laptop is in the class of item-cell
laptops <- newegg_laptops  %>%
           html_nodes("[class='item-cell']") 

# I want Product Name, Brand, Price, Shipping Cost, Product URL Link
# No review data to be extracted

# Products in class: item-title:
products <- laptops %>%
            html_nodes("[class='item-title']") %>%
            html_text2()

# Brand is class item brand in <a> tag then get <img> tag then get title:
brand <- laptops %>% 
         html_nodes("[class='item-brand']") %>%
         html_element('img') %>%
         html_attr('title')

# Current price of laptop, string concatenation is used
# In class = price-current, strong tag is for dollar amounts, sup tag is for cents:
price <- paste0(laptops %>% html_nodes("[class='price-current']") %>% html_element('strong') %>% html_text2(), 
               laptops %>% html_nodes("[class='price-current']") %>% html_element('sup') %>% html_text2()) 

# Shipping Costs:
ship_costs <- laptops %>% 
              html_nodes("[class='price-ship']") %>%
              html_text2()

# Product URL Link, class is item container 
product_url <- laptops %>% 
               html_nodes("[class='item-container']") %>%
               html_element('a') %>%
               html_attr('href')

## Create dataframe on one page of laptop results on Newegg.ca:
df <- data.frame(
        Laptop = products,
        Brand = brand,
        Price = price,
        Shipping_Costs = ship_costs,
        Product_URL = product_url
)

### ----------------------------
#   Multiple Pages Case
### ----------------------------

# Initialize vectors (lists):

products_list <- c()
price_list <- c()
brand_list <- c()
ship_costs_list <- c()
product_url_list <- c()

# Scrape 5 pages of laptops:
for (i in 1:5){
   # Read URL with page number (i)
   url <- paste0("https://www.newegg.ca/p/pl?Submit=StoreIM&Category=223&Depa=3&page=", i)
   
   #Laptops page
   page <- read_html(url)
   
   # Laptops Information, each tile for a laptop is in the class of item-cell
   laptops <- page  %>%
     html_nodes("[class='item-cell']") 
   
   # Add products
   products <- laptops %>%
               html_nodes("[class='item-title']") %>%
               html_text2()
   products_list <- c(products_list, products)
   
   # Add brands:
   brand <- laptops %>% 
            html_nodes("[class='item-brand']") %>%
            html_element('img') %>%
            html_attr('title')
   brand_list <- c(brand_list, brand)
   
   # Add prices:
   price <- paste0(laptops %>% html_nodes("[class='price-current']") %>% html_element('strong') %>% html_text2(), 
                   laptops %>% html_nodes("[class='price-current']") %>% html_element('sup') %>% html_text2()) 
   price_list <- c(price_list, price)
   
   # Add shipping costs:
   ship_costs <- laptops %>% 
                 html_nodes("[class='price-ship']") %>%
                 html_text2()
   ship_costs_list <- c(ship_costs_list, ship_costs)
   
   # Add Product URL lists:
   product_url <- laptops %>% 
                  html_nodes("[class='item-container']") %>%
                  html_element('a') %>%
                  html_attr('href')
   product_url_list <- c(product_url_list, product_url)
}

# Create dataframe based on multiple pages:

newegg_laptops_df <- data.frame(
  Laptop = products_list,
  Brand = brand_list,
  Price = price_list,
  Shipping_Costs = ship_costs_list,
  Product_URL = product_url_list
)

head(newegg_laptops_df)

# Optional: Save raw data into .csv 
write.csv(newegg_laptops_df, paste("Newegg.ca_Laptops_", Sys.Date(), '.csv', sep = ""))


#-----------------------------
### Data Analysis Portion
#-----------------------------

### Data Cleaning First
#------------

# Remove comma on price and convert to numeric & Change shipping costs column, Free Shipping to 0
newegg_laptops_df$Price <- as.numeric(gsub(pattern = ',', replacement = "", x = newegg_laptops_df$Price))

# Change Free Shipping to 0, remove dollar sign.
newegg_laptops_df$Shipping_Costs <- gsub(pattern = 'Free Shipping', replacement = "0", 
                                         x = newegg_laptops_df$Shipping_Costs)
# Remove dollar sign and word shipping
newegg_laptops_df$Shipping_Costs <- gsub(pattern = '[$|"Shipping"]', replacement = "", 
                                         x = newegg_laptops_df$Shipping_Costs)

newegg_laptops_df$Shipping_Costs <- as.numeric(newegg_laptops_df$Shipping_Costs)

### Basic data analysis on web scraped data on laptop prices.
#------------

# 10 Most expensive laptops
newegg_laptops_df %>% arrange(desc(Price)) %>% head(10)

# 10 Least Expensive laptops:
newegg_laptops_df %>% arrange(Price) %>% head(10)

# 10 Most Expensive ASUS & Acer America Laptops
newegg_laptops_df %>% 
   filter(Brand %in% c('Acer America', 'ASUS')) %>%
   arrange(desc(Price)) %>% head(10)


