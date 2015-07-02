##run scraping
#source ("scrape.r")
source ("scrape.native.r")
x<-read.csv("species_au_lag.csv"); x<-x[,2]
a<-scrape.native (x,keyword=" native ")


x1<-x[1:50]; x2<-x1[grepl("alopecurus pratensis",x1)]; x<-x2
