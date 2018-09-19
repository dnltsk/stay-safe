install.packages("RcppCCTZ") #for parseDatetime
library(RcppCCTZ)

setwd("~/projects/stay-safe/heatmap-creation/")

data <- read.csv('../data/objectstream.csv', header = T)
data$timestamp2 <- parseDatetime(data$timestamp, "%Y-%m-%dT%H:%M:%SZ");
head(data)

filter_from <- parseDatetime("2018-06-21T17:00:00Z", "%Y-%m-%dT%H:%M:%SZ");
filter_to <- parseDatetime("2018-06-21T17:00:00Z", "%Y-%m-%dT%H:%M:%SZ");
data_subset <- subset(data, timestamp2 >= filter_from & timestamp2 <= filter_to)
head(data_subset)
