scrape.native <- function (x,keyword=" native ") {
    # x is a vector of lower case species names with out sup species and stuff
    
    # only scrapes http site not https, thats usually why there are warnings
    x<-as.vector(x); x<-gsub(" ","+",x)
    if (is.null(keyword)) {keyword<-c("native")}
    
    keyword<-gsub(" ","_",keyword) #google keyword 
    key_filter<-gsub("_","\\b", keyword,fixed=T) #regexpres keyword
    key<-gsub("_","",keyword) # plain text keyword
    output<-matrix(nrow=length(x)); output_all<-matrix(nrow=length(x))
    
    # load packages and functions
    library(RCurl)
    library(stringr)
    library(XML)
    source("get_google_page_urls.R")
    source("readUrl.R")
    library(maps)
    library(sp)
    require(rworldmap)
    require(devtools)
    
    ###get country data and bioregions (countryExData[ , 2]<-this are the countrie)
    data(countryExData); 
    country<-unique(c(countryExData[ , 2])); country_match<-paste(country, collapse="|")
    geo <- unique(c(countryExData[ , 3],countryExData[ , 4]))
    continent<-c("Asia", "Africa", "North America", "South America", "Europe", "Australia", "Antarctica")
    geo<-unique(c(geo,continent))
    # old all_match <- append(geo,"native"); all_match_1 <- (paste(all_match, collapse="|"))
    all_ma <- (paste(geo, collapse="|")); all_ma<-gsub("  ", "", all_ma, fixed = TRUE)
    
    # this is for test only:    
    # x<-read.csv("species.csv"); x<-x[,2] ; x<-as.vector(tail(x));x<-as.vector(x); x<-gsub(" ","+",x)
    
    # get url (sample url: u <- "http://www.google.com.au/search?aq=f&gcx=w&sourceid=chrome&ie=UTF-8&q=juncus+tenuis+native")
    url.frame <-"http://www.google.com.au/search?aq=f&gcx=w&sourceid=chrome&ie=UTF-8&q="
    for (p in 1:length(x)) { print(x[p])
        u <- tolower(paste0(url.frame, x[p],"+",keyword)) ###compose search term to be send to google
        url <- get_google_page_urls(u) }# obtain url list
        url <- as.list(url)
        white<-"\\bkeyserver.lucidcentral.org\\b"  
        # check if our favorite sources are amongst and if so exclusivly use them and omit all others
        if ( grepl(white, url[p], perl=TRUE, ignore.case=TRUE) ) {
        url<-url[p][grep(white, url[p], perl=TRUE, ignore.case=T)]
        key_filter<-keyword<-gsub(" ","",keyword)}
    
        #     if (grepl("keyserver.lucidcentral.org", url[p], ignore.case=T)) {}else{url1<-url[grep("keyserver.lucidcentral.org",url, ignore.case=T)]}
        url <- gsub("/url?q=","", url, fixed = TRUE)
        url <- gsub("%3F","?", url, fixed = TRUE) 
        url <- gsub("%3D","=", url, fixed = TRUE)
        url <- unlist(strsplit(url, "&..=.&..="))
        url <- url[grep("^http://", url, ignore.case=T)]
        
        # Get the systems locale
        # Sys.setlocale("LC_ALL","English")
    
        # extract lines that contain 'native' and georegions
        for (i in 1:length(url)) {
            web_page <- vector("list",length (url))
            web_page[[i]] <- readUrl(url[i])
            web_page[[i]] <- gsub("<.*?>", "", web_page[[i]]) # clean html code
            web_page[[i]] <- gsub("/t|  ","",web_page[[i]]) # remove unneccessary spacing
            if (grepl(paste("not",key), web_page[i], perl = TRUE, ignore.case=T)) {
                print(paste("negation found for term:", key))}else{
                neg_lines<-vector("list",length (url)) # new empty vector
                for (p in 1:length(url)) {neg_lines[p]<-toString(web_page[p])}
                loc <- gregexpr(key_filter, neg_lines[[i]], ignore.case=T, perl = TRUE)
                loc <- unlist(loc)
                geo_lines<-vector("list",length (url))
                for (k in 1:length(loc)) {geo_lines[k]<-unique(substr(neg_lines[[i]], loc[k], loc[k]+200))}
                geo_lines<-geo_lines[grep('introduced|invaded|naturalised|naturalized|estabished',geo_lines, ignore.case=T, invert=T)]
                result2<-unique(str_extract_all(unlist(geo_lines), all_ma, simplify = TRUE)   ) 
                result3<-unique(toString(result2))
                result3<-toString(unique(result2[result2 != ""] ))
                output_all<-cbind(x,result3)
            } # closing if without else
        } # closing for url
    } # closing  for species
return(output_all)
} # closing function