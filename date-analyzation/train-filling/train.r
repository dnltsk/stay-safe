install.packages("RcppCCTZ") #for parseDatetime
install.packages("ggplot2") 
install.packages("spatstat")
install.packages("RColorBrewer")
library(RcppCCTZ)
library(ggplot2)
library(spatstat)
library(RColorBrewer)

setwd("~/Schreibtisch/hacktrain/git/stay-safe/train-filling/")

timeTable <- NULL
totalTrains <- 0
data <- read.csv('../data/2018-06-21istdaten.csv', header = T, sep=";")

stationBoolean <- grepl("Hardbr", paste(data$HALTESTELLEN_NAME), fixed = TRUE)
trainBoolean <- grepl("S", paste(data$LINIEN_TEXT), fixed=TRUE)
timeTag <- data$ABFAHRTSZEIT

for (i in 1:length(timeTag)) {
  if (nchar(paste(timeTag[i])) > 1) {
    if (stationBoolean[i] == TRUE) {
      if (trainBoolean[i] == TRUE) {
      #print(i)
      #print(data$HALTESTELLEN_NAME[i])
      #print(data$LINIEN_TEXT[i])
      trainData <- NULL
      
      trainData$timeTag <- timeTag[i]
      trainData$trainType <- data$LINIEN_TEXT[i]
      
      write.table(trainData, file = "trainData.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)
      }
    }
  }
}

data2 <- read.csv("trainData.csv", header=F, skip = 5, nrows = 630)
length(data2$V1)
index <- order(data2$V2)
length(index)

platforms = list(4, 2, 3, 2, 2, 3, 1, 4, 3, 1, 2, 3, 3, 2, 1, 4, 2, 3, 2, 2, 3, 1, 4, 4, 3, 1, 2, 3, 3, 2, 1, 4, 2, 3, 2, 2, 3, 1, 4, 3, 1)
destinations = list("Aarau", "ZH–Rapperswil", "Baden", "Rapperswil", "Feldmeilen", "Schaffhausen", "Seuzach", "Baden–Brugg AG", "Flughafen", "Pfäffikon SZ", "Uster", "Winterthur", "Niederweningen", "Uetikon", "Wetzikon", "Dietikon", "ZH–Rapperswil", "Baden", "Rapperswil", "Feldmeilen", "Rafz", "Seen", "Affoltern",
                    "Baden–Brugg AG", "Flughafen", "Pfäffikon SZ", "Uster", "Winterthur", "Niederweningen", "Uetikon", "Wetzikon", "Aarau", "ZH–Rapperswil", "Baden", "Rapperswil", "Feldmeilen", "Schaffhausen", "Seuzach", "Baden–Brugg AG", "Uster", "Winterthur")

length(platforms)
length(destinations)

counter <- 1
for (i in 1:length(index)) {
  data3 <- NULL
  print(data2$V2[index[i]])
  data3$timeTag <- data2$V2[index[i]]
  data3$trainType <- data2$V3[index[i]]

  data3$A <- round(60.0 + runif(1, -50.0, 50))
  data3$B <- round(60.0 + runif(1, -50.0, 50))
  data3$C <- round(60.0 + runif(1, -50.0, 50))
  data3$D <- round(60.0 + runif(1, -50.0, 50))
  data3$E <- round(60.0 + runif(1, -50.0, 50))
  data3$f <- round(60.0 + runif(1, -50.0, 50))
  
  data3$platform <- 0
  data3$destination <- ""
  
  if (grepl("08:", paste(data3$timeTag), fixed=TRUE)){
    data3$platform <- platforms[counter]
    data3$destination <- destinations[counter]
    counter <- counter + 1
  }

  write.table(data3, file = "timeTable.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)
}


