install.packages("RcppCCTZ") #for parseDatetime
install.packages("ggplot2") 
install.packages("spatstat")
install.packages("RColorBrewer")
library(RcppCCTZ)
library(ggplot2)
library(spatstat)
library(RColorBrewer)

setwd("~/Schreibtisch/hacktrain/git/stay-safe/timeTable/")

dataPlatform <- read.csv('../heatmap-creation/data.csv', header = F)
dataTrains <- read.csv('../train-filling/timeTable.csv', header = F)

timeTag <- dataPlatform$V2
length(timeTag)
limitCount <- 200

ACrowded <- FALSE
BCrowded <- (dataPlatform$V3 > limitCount)
CCrowded <- (dataPlatform$V4 > limitCount | dataPlatform$V5 > limitCount)
DCrowded <- (dataPlatform$V6 > limitCount | dataPlatform$V7 > limitCount)
ECrowded <- (dataPlatform$V8 > limitCount | dataPlatform$V8 == "NA")
FCrowded <- FALSE

ECrowded[21] <- FALSE
for (k in 1:length(BCrowded)) {
  if (is.na(BCrowded[k])) {
    BCrowded[k] <- FALSE
  }
}
BCrowded

timePoint <- 1
for (currentHour in 8:8) {
  for (currentMinute in 0:59) {
    currentTime <- paste(toString(currentHour), ":", toString(currentMinute), sep="")
    toString(currentHour)
    if (currentHour < 10) {
      currentTime <- paste("0", toString(currentHour), ":", toString(currentMinute), sep="")
      if (currentMinute < 10) {
        currentTime <- paste("0", toString(currentHour), ":0", toString(currentMinute), sep="")
      }
    }

S3 <- NULL
S3$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 3, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S3$waitingTime <- ttw[1]
S3$platform <- ttw[3]
S3$sector <- 0
if (as.integer(S3$platform) == 2 | as.integer(S3$platform) == 3) S3$sector <- ttw[2]
write.table(S3, file = "displayS3.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S5 <- NULL
S5$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 5, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S5$waitingTime <- ttw[1]
S5$platform <- ttw[3]
S5$sector <- 0
if (as.integer(S5$platform) == 2 | as.integer(S5$platform) == 3) S5$sector <- ttw[2]
write.table(S5, file = "displayS5.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)


S6 <- NULL
S6$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 6, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S6$waitingTime <- ttw[1]
S6$platform <- ttw[3]
S6$sector <- 0
if (as.integer(S6$platform) == 2 | as.integer(S6$platform) == 3) S6$sector <- ttw[2]
write.table(S6, file = "displayS6.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S7 <- NULL
S7$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 7, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S7$waitingTime <- ttw[1]
S7$platform <- ttw[3]
S7$sector <- 0
if (as.integer(S7$platform) == 2 | as.integer(S7$platform) == 3) S7$sector <- ttw[2]
write.table(S7, file = "displayS7.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S9 <- NULL
S9$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 9, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S9$waitingTime <- ttw[1]
S9$platform <- ttw[3]
S9$sector <- 0
if (as.integer(S9$platform) == 2 | as.integer(S9$platform) == 3) S9$sector <- ttw[2]
write.table(S9, file = "displayS9.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S11 <- NULL
S11$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 11, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S11$waitingTime <- ttw[1]
S11$platform <- ttw[3]
S11$sector <- 0
if (as.integer(S11$platform) == 2 | as.integer(S11$platform) == 3) S11$sector <- ttw[2]
write.table(S11, file = "displayS11.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S12 <- NULL
S12$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 12, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S12$waitingTime <- ttw[1]
S12$platform <- ttw[3]
S12$sector <- 0
if (as.integer(S12$platform) == 2 | as.integer(S12$platform) == 3) S12$sector <- ttw[2]
write.table(S12, file = "displayS12.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S15 <- NULL
S15$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 15, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S15$waitingTime <- ttw[1]
S15$platform <- ttw[3]
S15$sector <- 0
if (as.integer(S15$platform) == 2 | as.integer(S15$platform) == 3) S15$sector <- ttw[2]
write.table(S15, file = "displayS15.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S16 <- NULL
S16$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 16, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S16$waitingTime <- ttw[1]
S16$platform <- ttw[3]
S16$sector <- 0
if (as.integer(S16$platform) == 2 | as.integer(S16$platform) == 3) S16$sector <- ttw[2]
write.table(S16, file = "displayS16.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

S21 <- NULL
S21$timeStamp <- currentTime
ttw <- timeToWait(currentHour, currentMinute, 21, ACrowded, BCrowded[timePoint], CCrowded[timePoint], DCrowded[timePoint], ECrowded[timePoint], FCrowded)
S21$waitingTime <- ttw[1]
S21$platform <- ttw[3]
S21$sector <- 0
if (as.integer(S21$platform) == 2 | as.integer(S21$platform) == 3) S21$sector <- ttw[2]
write.table(S21, file = "displayS21.csv", sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

timePoint <- timePoint + 1
}
}

timeToWait <- function(hour, minute, line, aC, bC, cC, dC, eC, fC) {
  stringLine <- toString(line)
  depTime <- 0
  hoursToWait <- 0
  minutesToWait <- 0
  #print(length(dataTrains$V1))
    for (i in 1:length(dataTrains$V1)) {
      #print(i)
      #print(dataTrains$V3)
      if (grepl(stringLine, dataTrains$V3[i], fixed=TRUE) == TRUE) {
        depTime <- substring(dataTrains$V2[i], 12, 16)
        #print(i)
        if (hour < as.integer(substr(dataTrains$V2[i], 12, 13))) {
          hoursToWait <- as.integer(substr(dataTrains$V2[i], 12, 13)) - hour
          minutesToWait <- as.integer(substr(dataTrains$V2[i], 15, 16)) - minute + hoursToWait*60
          break
        }
        if (hour == as.integer(substr(dataTrains$V2[i], 12, 13))) {
          if (minute < as.integer(substr(dataTrains$V2[i], 15, 16))) {
            minutesToWait <- as.integer(substr(dataTrains$V2[i], 15, 16)) - minute
            break
          }
        }
        if (as.integer(substr(dataTrains$V2[i], 12, 13)) == 0) {
          minutesToWait <- 60 - minute + as.integer(substr(dataTrains$V2[i], 15, 16))
          break
        }
    }
    }
  minVal <- 10000
  minInd <- 0
    if (dataTrains$V4[i] < minVal & !aC) {
      minInd <- 1
      minVal <- dataTrains$V4[i]
    }
    if (dataTrains$V5[i] < minVal & !bC) {
      minInd <- 2
      minVal <- dataTrains$V5[i]
    }
    if (dataTrains$V6[i] < minVal & !cC) {
      minInd <- 3
      minVal <- dataTrains$V6[i]
    }
    if (dataTrains$V7[i] < minVal & !dC) {
      minInd <- 4
      minVal <- dataTrains$V7[i]
    }
    if (dataTrains$V8[i] < minVal & !eC) {
      minInd <- 5
      minVal <- dataTrains$V8[i]
    }
    if (dataTrains$V9[i] < minVal & !fC) {
      minInd <- 6
      minVal <- dataTrains$V9[i]
    }
return(list(minutesToWait, minInd, dataTrains$V10[i]))
}

timeToWait(7, 59, 3, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
