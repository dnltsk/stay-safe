install.packages("RcppCCTZ") #for parseDatetime
install.packages("ggplot2") 
install.packages("spatstat")
install.packages("RColorBrewer")
library(RcppCCTZ)
library(ggplot2)
library(spatstat)
library(RColorBrewer)

setwd("~/Schreibtisch/hacktrain/git/stay-safe/heatmap-creation/")

data <- read.csv('../data/objectstream.csv', header = T)
data$timestamp2 <- parseDatetime(data$timestamp, "%Y-%m-%dT%H:%M:%SZ");
min_x <- min(data$x)
max_x <- max(data$x)
min_y <- min(data$y)
max_y <- max(data$y)
head(data)

startTimeList = NULL
for(hour in 8:8) {
  for(minute in 0:59) {
    for(second in 0:59) {
startTimeHour <- toString(hour)
if (hour < 10) startTimeHour <- paste("0", startTimeHour, sep="")
startTimeMinute <- toString(minute)
if (minute < 10) startTimeMinute <- paste("0", startTimeMinute, sep="")
startTimeSecond <- toString(second)
if (second < 10) startTimeSecond <- paste("0", startTimeSecond, sep="")
startTime <- paste("2018-06-21T", startTimeHour, ":", startTimeMinute, ":", startTimeSecond, "Z", sep="")
startTimeList <- append(startTimeList, startTime)
#append(timeStamp, startTime)
#print(startTime)
  }
  }
}
print(startTimeList)

for (i in 1:length(startTimeList)){
intervalData <- NULL
startTime <- startTimeList[i]
endTime <- startTimeList[i+1]
print(startTime)
print(endTime)

filter_from <- parseDatetime(startTime, "%Y-%m-%dT%H:%M:%SZ");
filter_to <- parseDatetime(endTime, "%Y-%m-%dT%H:%M:%SZ");
data_subset <- subset(data, timestamp2 >= filter_from & timestamp2 <= filter_to)
#head(data_subset)

str(data_subset)
fileName <- paste("subdata/", startTime, "subset.csv", sep="")
write.csv(data_subset, file = fileName)

hist2 <- hist(data_subset$x, breaks = 6, main = "")
intervalCounts <- hist2$counts
print(intervalCounts)

intervalData$timestamp <- startTime
intervalData$countsB1 <- intervalCounts[1]
intervalData$countsC1 <- intervalCounts[2]
intervalData$countsC2 <- intervalCounts[3]
intervalData$countsD1 <- intervalCounts[4]
intervalData$countsD2 <- intervalCounts[5]
intervalData$countsE1 <- intervalCounts[6]
print(intervalData)

heatFile <- paste("heatmaps/heat", startTime, ".jpg", sep="")
heatMapPlot <- FALSE

intervalData$heatMapFile <- heatFile
print(intervalData)
write.table(intervalData, file = "data.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)
#finalData <- frame(finalData, intervalData)

if (heatMapPlot == TRUE){
  foo <- data.frame(x=data_subset$x, y=data_subset$y)
  foo_ppp <- as.ppp(foo[!duplicated(foo), ], c(min_x,max_x,min_y,max_y))
  par(mar=c(1,1,1,1))
  
  jpeg(file = heatFile)
  plot(density(foo_ppp, 20), las=1,xlab="foo", ylab="bar")
  dev.off()
}
}

#
# ggplot approach
#
#g <- ggplot(data_subset,aes(x=x, y=y)) +
#  stat_density2d(aes(alpha=..level..), geom="polygon") +
#  #scale_alpha_continuous(limits=c(0,0.2),breaks=seq(0,0.2,by=0.025))+
#  #scale_fill_gradient(low="blue", high="green")+
#  geom_point(colour="red", size=0.1)+
#  theme_bw()
#g

#ggplot(data_subset, aes(x = x, y = y)) +
#  stat_density2d(aes(fill = ..level..), alpha=0.5, geom="polygon") +
#  scale_fill_gradientn(colours=rev(brewer.pal(7,"Spectral"))) +
#  geom_point(alpha = .5, size = .1)



