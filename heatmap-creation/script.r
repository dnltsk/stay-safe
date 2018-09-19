install.packages("RcppCCTZ") #for parseDatetime
install.packages("ggplot2") 
install.packages("spatstat")
install.packages("RColorBrewer")
library(RcppCCTZ)
library(ggplot2)
library(spatstat)
library(RColorBrewer)

setwd("~/projects/stay-safe/heatmap-creation/")

data <- read.csv('../data/objectstream.csv', header = T)
data$timestamp2 <- parseDatetime(data$timestamp, "%Y-%m-%dT%H:%M:%SZ");
min_x <- min(data$x)
max_x <- max(data$x)
min_y <- min(data$y)
max_y <- max(data$y)
head(data)

filter_from <- parseDatetime("2018-06-21T17:00:00Z", "%Y-%m-%dT%H:%M:%SZ");
filter_to <- parseDatetime("2018-06-21T17:05:00Z", "%Y-%m-%dT%H:%M:%SZ");
data_subset <- subset(data, timestamp2 >= filter_from & timestamp2 <= filter_to)
head(data_subset)

str(data_subset)

#
# ggplot approach
#
g <- ggplot(data_subset,aes(x=x, y=y)) +
  stat_density2d(aes(alpha=..level..), geom="polygon") +
  #scale_alpha_continuous(limits=c(0,0.2),breaks=seq(0,0.2,by=0.025))+
  #scale_fill_gradient(low="blue", high="green")+
  geom_point(colour="red", size=0.1)+
  theme_bw()
g

ggplot(data_subset, aes(x = x, y = y)) +
  stat_density2d(aes(fill = ..level..), alpha=0.5, geom="polygon") +
  scale_fill_gradientn(colours=rev(brewer.pal(7,"Spectral"))) +
  geom_point(alpha = .5, size = .1)

#
# spatstat approach
#
foo <- data.frame(x=data_subset$x, y=data_subset$y)
foo_ppp <- as.ppp(foo[!duplicated(foo), ], c(min_x,max_x,min_y,max_y))
par(mar=c(1,1,1,1))
plot(density(foo_ppp, 20), las=1,xlab="foo", ylab="bar")

