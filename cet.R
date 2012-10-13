# Central England Temperature Data (CET)
# Author: Alberto Negron
# date: 13/10/2012
# Description: Convert matrix-like data into Tabular data and export as csv

setwd('/Users/albertonegron/projects/minis/CET')

# Function to convert data to tabular format
transform.cet <- function(url){
  #Libraries
  require(reshape2)
  require(lubridate)
  # Read file
  cet <- NULL # reset object in case already exists
  cet <- read.table(url, quote="\"")
  # Rename header
  var_names <- c('year','day','01','02','03','04','05','06','07','08','09','10','11','12')
  colnames(cet) <- var_names
  # Transpose data
  cet.melt <- melt(cet,c('year','day'))
  cet.melt  <- subset(cet.melt,value!=-999) # remove unvalid dates
  cet.melt$date <- dmy(paste(cet.melt$day,'-',cet.melt$variable,'-',cet.melt$year,sep=''))
  cet.melt$temperature <- cet.melt$value
  return(cet.melt[,c('date','temperature')])
}

cet.mean <- transform.cet("http://www.metoffice.gov.uk/hadobs/hadcet/cetdl1772on.dat")
cet.min  <- transform.cet("http://www.metoffice.gov.uk/hadobs/hadcet/cetmindly1878on_urbadj4.dat")
cet.max  <- transform.cet("http://www.metoffice.gov.uk/hadobs/hadcet/cetmaxdly1878on_urbadj4.dat")

names(cet.mean)[names(cet.mean)=="temperature"] <- "mean_temp"
names(cet.min)[names(cet.min)=="temperature"]   <-"min_temp"
names(cet.max)[names(cet.max)=="temperature"]   <- "max_temp"

write.csv(cet.mean,"cet_mean.csv",row.names=F)
write.csv(cet.min,"cet_min.csv",row.names=F)
write.csv(cet.max,"cet_max.csv",row.names=F)

