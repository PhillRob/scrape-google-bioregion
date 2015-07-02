# scrape-google-bioregion
This R code attempts to obtain scrape the first 10 google results for a key word, matching them to continents and bio regions. it uses the following packages and functions: 
    library(RCurl)
    library(stringr)
    library(XML)
    source("get_google_page_urls.R")
    source("readUrl.R")
    library(maps)
    library(sp)
    require(rworldmap)
  
