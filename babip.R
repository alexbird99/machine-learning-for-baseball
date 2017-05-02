#setwd("C:\\workspace\\R")

batterData <- read.csv('2016bat.csv', fileEncoding = "UTF-8-BOM")

str(batterData)


batterData$LD. <- as.numeric(sub("%", "", batterData$LD., fixed=TRUE))/100
batterData$GB. <- as.numeric(sub("%", "", batterData$GB., fixed=TRUE))/100
batterData$FB. <- as.numeric(sub("%", "", batterData$FB., fixed=TRUE))/100
batterData$IFFB. <- as.numeric(sub("%", "", batterData$IFFB., fixed=TRUE))/100
batterData$HR.FB <- as.numeric(sub("%", "", batterData$HR.FB, fixed=TRUE))/100
batterData$IFH. <- as.numeric(sub("%", "", batterData$IFH., fixed=TRUE))/100
batterData$BUH. <- as.numeric(sub("%", "", batterData$BUH., fixed=TRUE))/100
batterData$Pull. <- as.numeric(sub("%", "", batterData$Pull., fixed=TRUE))/100
batterData$Cent. <- as.numeric(sub("%", "", batterData$Cent., fixed=TRUE))/100
batterData$Oppo. <- as.numeric(sub("%", "", batterData$Oppo., fixed=TRUE))/100
batterData$Soft. <- as.numeric(sub("%", "", batterData$Soft., fixed=TRUE))/100
batterData$Med. <- as.numeric(sub("%", "", batterData$Med., fixed=TRUE))/100
batterData$Hard. <- as.numeric(sub("%", "", batterData$Hard., fixed=TRUE))/100

str(batterData)

cor(subset(batterData,select=-c(Name,Team,playerid)))

goodColumns <- c('GB.','FB.', 'IFFB.','IFH.','Pull.','Oppo.', 'BABIP')
library(caret)
inTrain <- createDataPartition(batterData$BABIP, p=0.7, list=FALSE)
training <- batterData[inTrain, goodColumns]
testing <- batterData[-inTrain, goodColumns]

method = 'lm' # linear regression
#method = 'glm' # logistic regression (not great here because we are not doing classification)
#method = 'rpart' # decision trees (ditto)
#method = 'gbm' # boosting
#method = 'rf' # random forest

ctrl <- trainControl(method='repeatedcv', number=10, repeats=10)
modelFit <- train(BABIP ~ ., method=method, data=training, trControl=ctrl)

summary(modelFit)

model2 <- train(BABIP ~ GB. + FB. + IFH., method=method, data=training, trControl=ctrl)

summary(model2)

predicted2 <- predict(model2,newdata=testing)

cor(testing$BABIP,predicted2)^2 # 0.4182863

plot(testing$BABIP,predicted2)
