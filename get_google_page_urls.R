### code to get 
get_google_page_urls <- function(u) {
    # read in page contents
    html <- getURL(u)
    
    # parse HTML into tree structure
    doc <- htmlParse(html)
    
    # extract url nodes using XPath. Originally I had used "//a[@href][@class='l']" until the google code change.
    attrs <- xpathApply(doc, "//h3//a[@href]", xmlAttrs)
    #links <- xpathApply(doc, "//h3//a[@href]", function(x) xmlAttrs(x)[[1]])
    # extract urls
    links <- sapply(attrs, function(x) x[[1]])
    
    # free doc from memory
    free(doc)
    
    # ensure urls start with "http" to avoid google references to the search page
    links <- grep("http://", links, fixed = TRUE, value=TRUE)
    
    #links <-grep("/url?q=", links, fixed = TRUE, value=TRUE)
    #links<-sub("/url?q=", "", links)
    return(links)
}