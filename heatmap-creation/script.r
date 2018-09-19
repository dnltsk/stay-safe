install.packages("data.table")
install.packages("RcppCCTZ") #for parseDatetime
library(data.table)
library(RcppCCTZ)

setwd("~/projects/stay-safe/heatmap-creation/")

data <- system.time(fread('../data/objectstream.csv', header = T, sep = ',')) 
data <- read.csv('../data/objectstream.csv', header = T)

head(data)

data_subset <- subset(data, timestamp >= "2018-06-21T17:00:00Z" & timestamp <= "2018-06-21T17:05:00Z")

parseDatetime("2018-06-21T17:00:00Z", "%Y-%m-%d'T'%H:%M:%S'Z'");

data_subset$timestamp2 <- parseDatetime(data_subset$timestamp, "%Y-%m-%d'T'%H:%M:%S'Z'");

data_subset
