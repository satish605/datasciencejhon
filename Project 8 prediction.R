library(caret)
library(rpart)
library(rpart.plot)
library(randomForest)
library(corrplot)

#Download the Data

trainingURL <-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testingURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
trainingFile <- "./data/pml-training.csv"
testingFile <- "./data/pml-testing.csv"
if (!file.exists("./data")) {
  dir.create("./data")
}
if (!file.exists(trainingFile)) {
  download.file(trainingURL, destfile=trainingFile, method="curl")
}
if (!file.exists(testingFile)) {
  download.file(testingURL, destfile=testingFile, method="curl")
}

#Read the Data
#After downloading the data from the data source, we can read the two csv files into two data frames.
trainRaw <- read.csv("./data/pml-training.csv")
testRaw <- read.csv("./data/pml-testing.csv")

dim(testRaw)

#Clean the Data
#In this step, we will clean the data and get rid of observations with missing values as well as some meaningless
variables.
sum(complete.cases(trainRaw))
dim(trainRaw)



#First, we remove columns that contain NA missing values.
trainRaw <- trainRaw[, colSums(is.na(trainRaw)) == 0]
testRaw <- testRaw[, colSums(is.na(testRaw)) == 0]

#Next, we get rid of some columns that do not contribute much to the accelerometer measurements.

classe <- trainRaw$classe
trainRemove <- grepl("^X|timestamp|window", names(trainRaw))
trainRaw <- trainRaw[, !trainRemove]
trainCleaned <- trainRaw[, sapply(trainRaw, is.numeric)]
trainCleaned$classe <- classe
testRemove <- grepl("^X|timestamp|window", names(testRaw))
testRaw <- testRaw[, !testRemove]
testCleaned <- testRaw[, sapply(testRaw, is.numeric)]


#Slice the Data

set.seed(2108) # For reproducibile purpose
inTrain <- createDataPartition(trainCleaned$classe, p=0.70, list=F)
trainData <- trainCleaned[inTrain, ]
testData <- trainCleaned[-inTrain, ]



#Data Modeling

controlRf <- trainControl(method="cv", 5)
modelRf <- train(classe ~ ., data=trainData, method="rf", trControl=controlRf, ntree=250)
modelRf

predictRf <- predict(modelRf, testData)
confusionMatrix(testData$classe, predictRf)

accuracy <- postResample(predictRf, testData$classe)
accuracy

oose <- 1 - as.numeric(confusionMatrix(testData$classe, predictRf)$overall[1])
oose

#Predicting for Test data-set
result <- predict(modelRf, testCleaned[, -length(names(testCleaned))])
result

corrPlot <- cor(trainData[, -length(names(trainData))])
corrplot(corrPlot, method="color")

treeModel <- rpart(classe ~ ., data=trainData, method="class")
prp(treeModel) # fast plot