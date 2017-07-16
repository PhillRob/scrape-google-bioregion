# scrape-google-bioregion
This R code attempts to obtain scrape the first 10 google results for a key word, matching them to continents and bio regions. It requires the following packages and functions:
```r
    library(RCurl)
    library(stringr)
    library(XML)
    library(maps)
    library(sp)
    require(rworldmap)
    source("get_google_page_urls.R")
    source("readUrl.R")
```
