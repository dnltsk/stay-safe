install.packages("devtools")
library(devtools)
devtools::use_rcpp()

install.packages("RcppCCTZ") #for parseDatetime
install.packages("ggplot2") 
install.packages("spatstat")
install.packages("RColorBrewer")
install.packages("rgdal") #for loading and plotting geotiff
install.packages("raster") #for loading and plotting geotiff
library(RcppCCTZ)
library(ggplot2)
library(spatstat)
library(RColorBrewer)
library(rgdal)
library(raster)


setwd("~/projects/stay-safe/heatmap-creation/")

data <- read.csv('../data/objectstream-subset.csv', header = T)
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

#
# filtering data
#
data_points <- data.frame(x=data_subset$x, y=data_subset$y)

#
# looping
#
P <- as.ppp(data_points[!duplicated(data_points), ], c(min_x,max_x,min_y,max_y))
Z <- density(P, 1)
Q <- quadratcount(P, nx= 6, ny=3)
plot(P, pch=20, cols="grey70", main=NULL)
plot(Q, add=TRUE)

Q.d <- intensity(Q)

norm_palette <- colorRampPalette(c("white", "yellow", "orange","red"))
pal_opaque <- norm_palette(5)
pal_trans <- norm_palette(5)
pal_trans[1] <- "#FFFFFF00" #was originally "#FFFFFF" 
pal_trans2 <- paste(pal_opaque,"50",sep = "")

plot(Z, col = pal_opaque, main = NULL)

plot(P, pch=20, cex=0.2, main=NULL)
plot(intensity(Q, image=TRUE), col = pal_trans2,add=T)
#plot(Q, add=T, col = "black", weight="bold")


par(mfrow = c(1,1), # cells
    mar=c(1,1,1,1)  # margins
)

pal_opaque <- norm_palette(5)
plot(density(foo_ppp, 20), las=2,xlab="foo", ylab="bar", main=NULL)

geotiff <- raster("../data/aerial-photo.geotiff")
plot(geotiff)
