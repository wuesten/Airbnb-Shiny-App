# Load Libraries
library(tidyverse)
library(leaflet)
library(rgdal)
library(shiny)
library(shinydashboard)
library(markdown)
library(shinyWidgets)
library(htmltools)
library(shinythemes)
library(plotly)
library(devtools)
library(rsconnect)

# Enable book marking option
enableBookmarking(store = "server")

# Load Data
df_listings<- read_delim(file= "data/listings.csv", delim = ",", locale = readr::locale(encoding = "utf-8"))
df_geojson_bcn <- rgdal::readOGR("data/neighbourhoods.geojson")
df_calender <- read_delim(file= "data/calender_bcn.csv", delim = ",")

# Data preparation
df_listings <- df_listings %>% mutate(across(starts_with("price"), ~gsub("\\$", "", .) %>% as.numeric)) %>% filter(price != 999) %>% filter(price != 9999)
df_listings_neighborhoods <- df_listings %>% distinct(neighbourhood_cleansed)
#df_listings_price <- df_listings %>% distinct(price)
change_encoding <- data.frame(df_geojson_bcn)
Encoding(change_encoding[["neighbourhood"]]) <- "UTF-8"
df_geojson_bcn$cor_neighborhood <- change_encoding$neighbourhood
default_neighborhood <- df_listings_neighborhoods %>% filter(neighbourhood_cleansed == "la Sagrada Família")
max_price <-  df_listings %>% summarise(max(price))

# Join Calender data
df_listings_bcn_calender <- df_listings %>% left_join(df_calender, by = c("id" = "listing_id")) 
df_listings_bcn_calender <- df_listings_bcn_calender %>% filter(price.y != "$9,999.00") %>%
  mutate(across(starts_with("price"), ~gsub("\\$", "", .) %>% as.numeric))
#df_listings_bcn_calender$date <- as.Date(df_listings_bcn_calender$date, format = "%Y.%m.%d")