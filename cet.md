Converting Ugly Matrix-like CET Temperature data set to Tabular format
======================================================================


The Centre Central England Temperature (CET) dataset is the longest instrumental record of temperature in the world. The mean, minimum and maximum datasets are updated monthly, with data for a month usually available by the 3rd of the next month. 

A provisional CET value for the current month is calculated on a daily basis. The mean daily data series begins in 1772 and the mean monthly data in 1659. Mean maximum and minimum daily and monthly data are also available, beginning in 1878.

The only downside in my opinion is the format chosen by the Met Office to present this data (matrix) is so unfriendly that people spend a lot of time creating complex macros in Excel (I've seen it) to convert this data to a tabular format to merge to other variables.

The data layout is as follow:

* Column 1: year
* Column 2: day
* Columns 3-14: daily CET values expressed in tenths of a degree. There are 12 columns; one for each of the 12 months.

My intention is to convert the above to a data frame with 2 columns: Date & Temperature.


Brief description of the data
-----------------------------

These daily and monthly temperatures are representative of a roughly triangular area of the United Kingdom enclosed by Lancashire, London and Bristol. The monthly series, which begins in 1659, is the longest available instrumental record of temperature in the world.

The daily series begins in 1772. Manley (1953,1974) compiled most of the monthly series, covering 1659 to 1973. These data were updated to 1991 by Parker et al (1992), when they calculated the daily series. Both series are now kept up to date by the Climate Data Monitoring section of the Hadley Centre, Met Office. Since 1974 the data have been adjusted to allow for urban warming.

My Approach
-----------

I always try to avoid re-inventing the wheel so for this task I rely on a very good 3rd parties packages instead of using pure Base R.

Also I am interested in the mean, max, min temperature which are provided in different files (luckily with the same format).

So step by step...

## 1. set up my working directory


```r
# Set up your working directory
setwd("/Users/albertonegron/projects/minis/CET")
```


## 2. Function to convert the data to a tabular format (DRY principle):


```r
transform.cet <- function(url) {
    # Libraries
    require(reshape2)
    require(lubridate)  # Excellent package for working with dates
    # Read file
    cet <- NULL  # reset object in case already exists
    cet <- read.table(url, quote = "\"")
    # Rename header
    var_names <- c("year", "day", "01", "02", "03", "04", "05", "06", "07", 
        "08", "09", "10", "11", "12")
    colnames(cet) <- var_names
    # Transpose data
    cet.melt <- melt(cet, c("year", "day"))
    cet.melt <- subset(cet.melt, value != -999)  # remove unvalid dates
    
    cet.melt$date <- dmy(paste(cet.melt$day, "-", cet.melt$variable, "-", cet.melt$year, 
        sep = ""))
    cet.melt$temperature <- cet.melt$value
    return(cet.melt[, c("date", "temperature")])
}
```


## 3. Processing CET files


```r
cet.mean <- transform.cet("http://www.metoffice.gov.uk/hadobs/hadcet/cetdl1772on.dat")
cet.min <- transform.cet("http://www.metoffice.gov.uk/hadobs/hadcet/cetmindly1878on_urbadj4.dat")
cet.max <- transform.cet("http://www.metoffice.gov.uk/hadobs/hadcet/cetmaxdly1878on_urbadj4.dat")
```


## 4. Rename Temperature to a more meaningful name


```r
names(cet.mean)[names(cet.mean) == "temperature"] <- "mean_temp"
names(cet.min)[names(cet.min) == "temperature"] <- "min_temp"
names(cet.max)[names(cet.max) == "temperature"] <- "max_temp"
```


## 5. Export to csv format


```r
write.csv(cet.mean, "cet_mean.csv", row.names = F)
write.csv(cet.min, "cet_min.csv", row.names = F)
write.csv(cet.max, "cet_max.csv", row.names = F)
```


## 6. (Optional)

Temperature is expressed in tenths of a degree so divide by 10 if you want centigrades.
