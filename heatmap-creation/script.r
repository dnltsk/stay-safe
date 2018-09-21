install.packages("devtools")
install.packages("devtools", lib="~/R/lib")
library(devtools)
devtools::use_rcpp()
devtools::install_github("cran/rgdal")


install.packages("RcppCCTZ") #for parseDatetime
install.packages("ggplot2") 
install.packages("spatstat")
install.packages("RColorBrewer")
install.packages("raster") #for loading and plotting geotiff
install.packages("png")
install.packages("stringr") # for srt_pad

library(RcppCCTZ)
library(ggplot2)
library(spatstat)
library(RColorBrewer)
library(raster)
library(png)
library(stringr)


setwd("~/projects/stay-safe/heatmap-creation/")

data <- read.csv('../data/objectstream.csv', header = T)
data$timestamp2 <- parseDatetime(data$timestamp, "%Y-%m-%dT%H:%M:%SZ");
min_x <- min(data$x)
max_x <- max(data$x)
min_y <- min(data$y)
max_y <- max(data$y)

#
# constant colors
#
norm_palette <- colorRampPalette(c("white", "yellow", "orange","red"))
pal_opaque <- norm_palette(4)
pal_trans <- norm_palette(4)
pal_trans[1] <- "#FFFFFF00" #was originally "#FFFFFF" 
pal_trans2 <- paste(pal_opaque,"50",sep = "")

#
# find max quantiles
#
hour <- 5
minute <- 30
from_minute <- str_pad(minute, 2, pad = "0")
to_minute <- str_pad(minute+1, 2, pad = "0")
from_time<- paste(hour, ":", from_minute, sep="")
to_time<- paste(hour, ":", to_minute, sep="")
print(paste("from", from_time, "to", to_time))

from_timestamp <- paste("2018-06-21T",from_time,":00Z", sep="")
to_timestamp <- paste("2018-06-21T",to_time,":00Z", sep="")
filter_from <- parseDatetime(from_timestamp, "%Y-%m-%dT%H:%M:%SZ");
filter_to <- parseDatetime(to_timestamp, "%Y-%m-%dT%H:%M:%SZ");    

data_subset <- subset(data, timestamp2 >= filter_from & timestamp2 <= filter_to)
data_points <- data.frame(x=data_subset$x, y=data_subset$y)

P <- as.ppp(data_points, c(min_x,max_x,min_y,max_y), checkdup=F)
Z <- density(P, bw=.5)

col_breakes
col_breakes <- as.vector(quantile(Z, probs = (0:4)/4))

#
# filtering data
#
for (from_hour in 4:23){
  for (from_minute in 0:59){
    for (from_second in 0:5){
      
      from_hour <- 0
      from_minute <- 0
      from_second <- 5
      
      from_second <- from_second * 10
    
      to_hour <- from_hour
      to_minute <- from_minute
      to_second <- from_second + 10
      
      if(from_second == 50){
        to_second <- 0
        to_minute <- from_minute +1
        if(from_minute == 59){
          to_minute <- 0
          to_hour <- from_hour + 1
        }
      }
      
      from_hour <- str_pad(from_hour, 2, pad = "0")
      to_hour <- str_pad(to_hour, 2, pad = "0")
      from_minute <- str_pad(from_minute, 2, pad = "0")
      to_minute <- str_pad(to_minute, 2, pad = "0")
      from_second <- str_pad(from_second, 2, pad = "0")
      to_second <- str_pad(to_second, 2, pad = "0")
      
      from_time<- paste(from_hour, ":", from_minute, ":", from_second, sep="")
      to_time<- paste(to_hour, ":", to_minute, ":", to_second, sep="")
      
      print(paste("from", from_time, "to", to_time))
      
      from_timestamp <- paste("2018-06-21T",from_time,"Z", sep="")
      to_timestamp <- paste("2018-06-21T",to_time,"Z", sep="")
      filter_from <- parseDatetime(from_timestamp, "%Y-%m-%dT%H:%M:%SZ");
      filter_to <- parseDatetime(to_timestamp, "%Y-%m-%dT%H:%M:%SZ");    
      
      data_subset <- subset(data, timestamp2 >= filter_from & timestamp2 <= filter_to)
      data_points <- data.frame(x=data_subset$x, y=data_subset$y)
      
      #
      # plot
      #
      filename <- paste("plots/", from_time,".png", sep = "")
      png(filename=filename, width = 800, height = 180)
      
      P <- as.ppp(data_points, c(min_x,max_x,min_y,max_y), checkdup=F)
      Z <- density(P, bw=.5)
      
      par(mar=c(0,0,1.5,0))
      if(nrow(data_subset) == 0){
        plot(P, 
             #col = pal_opaque,
             breaks = col_breakes,
             legend = col_breakes,
             zlim=c(min(col_breakes), max(col_breakes))
        )
      }else{
        Q <- quadratcount(P, nx= 6, ny=3)  
        plot(intensity(Q, image=TRUE), main = from_timestamp,
             col = pal_opaque,
             #breaks = c(0.001,0.002,0.003,0.004,0.005) #col_breakes
             breaks = col_breakes,
             legend = col_breakes,
             zlim=c(min(col_breakes), max(col_breakes))
        )
        plot(P, pch=20, cex=0.3, add=T)
      }
      
      dev.off()
    
    }
  }
}



#
# geotiff -> skipped!
#
geotiff <- raster("../data/aerial-photo.geotiff")
aerial_photo <- readPNG("../data/aerial-photo.png")
plot(aerial_photo)
