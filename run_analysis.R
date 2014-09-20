##
## 
##

## Set working dir to point at the data
setwd("c:\\projects\\rwork\\cleanse_data\\project")


## Load train and test sets and make one dataframe to contain all the data (outData)
## X_* the data
## Y_* training label
## subject_* the test subject

##
## 1. Load the data
##
trainSetX <- read.csv("train/X_train.txt", header=FALSE, sep="" )
trainSetY <- read.csv("train/Y_train.txt", header=FALSE, sep="" )
trainSetSubj <- read.csv("train/subject_train.txt", header=FALSE, sep="" )
testSetX <- read.csv("test/X_test.txt", header=FALSE, sep="" )
testSetY <- read.csv("test/Y_test.txt", header=FALSE, sep="" )
testSetSubj <- read.csv("test/subject_test.txt", header=FALSE, sep="" )

activities <- read.csv("activity_labels.txt", header=FALSE, sep="")
features <- read.csv("features.txt", header=FALSE, sep="", colClasses="character")


##
## 2. Combine data sets and rename column. Replace activity codes with descriptibe names
##

## Combine training labels and subjects to the set as columns
trainingSet <- cbind( trainSetX, trainSetY, trainSetSubj )
testSet <- cbind( testSetX, testSetY, testSetSubj )

## Combine data sets
outData <- rbind( testSet, trainingSet )

## Rename columns with feature names
names( outData ) <- c( features$V2, "Activity", "Subject")

## substitute activies with descriptive terms
outData$Activity <- factor( outData$Activity, levels=activities$V1, labels=activities$V2)


##
## 3. Drop all columns that are not std() or mean()
##

## make column indexes for the mean and std measuremements
features <- rbind( features, c(562, "Activity"), c(563, "Subject"))
colIndexes <- grep(".*-mean|.*-std|.*Activity|.*Subject", features[,2] )
measurements <- features[as.numeric(colIndexes),]

## remove meanFreq columuns as they are not needed
remCols <- grep(".*meanFreq", measurements[,2])
measurements <- measurements[ -remCols, ]

## Drop excess columns
outData <- outData[ , measurements$V2 ]

tidySet <- data.table( outData )
out<-tidySet[,lapply(.SD,mean),by="Activity,Subject"]
write.table(out,file="tidyOutputSet.txt",sep=",",row.names = FALSE)

