#Load and Read Data
library(tidyverse)
library(dplyr)
combine_data <- read_csv("NFL_Combine_Since_2000.csv")
str(combine_data)
#Data from just the last 15 years
combine_data2 <- combine_data %>%
  filter(Year >= 2010 & Year <= 2025)
#Select Needed Variables, drop others
clean_data1 <- combine_data2 %>%
  select(-Player, -School, -Team, -‘Career AV‘, -...18, -...19, -...20, -Round)
str(clean_data1)
clean_data1$Position <- as.factor(clean_data1$Position)
#Clean the variable names
names(clean_data1) <- make.names(names(clean_data1))
#Simplify name of data and get rid of undrafted players
data <- clean_data1
data <- data %>%
  filter(!is.na(Pick))

#Imputation
data$X40.yd.Dash[is.na(data$X40.yd.Dash)] <- mean(data$X40.yd.Dash, na.rm = TRUE)
data$Vertical.Jump[is.na(data$Vertical.Jump)] <- mean(data$Vertical.Jump, na.rm = TRUE)
data$Bench.Press[is.na(data$Bench.Press)] <- mean(data$Bench.Press, na.rm = TRUE)
data$Broad.Jump[is.na(data$Broad.Jump)] <- mean(data$Broad.Jump, na.rm = TRUE)
data$X3.Cone.Drill[is.na(data$X3.Cone.Drill)] <- mean(data$X3.Cone.Drill, na.rm = TRUE)
data$X20.yd.Shuttle[is.na(data$X20.yd.Shuttle)] <- mean(data$X20.yd.Shuttle, na.rm = TRUE)

#Linear Regression
#Split the data into training data and predict data
train_data <- data %>% #what model learns form
  filter(Year <= 2024)
predict_2025 <- data %>% #what model will generate predictions for
  filter(Year == 2025)

#Partition Data
train <- train_data %>% filter(Year <= 2020)
test <- train_data %>% filter(Year > 2020)
library(caret)
set.seed(123)

Index <-createDataPartition(train$Weighted.AV,p=0.8,list=FALSE)
trdata <- train[Index,] #Creates training data set
tsdata <- train[-Index,] #Creates testing data set
#Create Model
model_lm <- lm(Weighted.AV ~ .-Broad.Jump, data = trdata)
summary(model_lm)
#Take out Vertical Jump
model_lm2 <- lm(Weighted.AV ~ .-Broad.Jump -Vertical.Jump, data = trdata)
summary(model_lm2)
#Take out Height
model_lm3 <- lm(Weighted.AV ~ .-Broad.Jump -Vertical.Jump -Height, data = trdata)
summary(model_lm3)
#Take out Weight
model_lm4 <- lm(Weighted.AV ~ .-Broad.Jump -Vertical.Jump -Height -Weight, data = trdata)
summary(model_lm4)
#Take out 20-yard Shuttle
model_lm5 <- lm(Weighted.AV ~ .-Broad.Jump -Vertical.Jump -Height -Weight -X20.yd.Shuttle, data = trdata
                summary(model_lm5)
                #Take out Bench Press
                model_lm6 <- lm(Weighted.AV ~ .-Broad.Jump -Vertical.Jump -Height -Weight -X20.yd.Shuttle -Bench.Press,
                                summary(model_lm6)
                                #Take out Year
                                model_lm7 <- lm(Weighted.AV ~ .-Broad.Jump -Vertical.Jump -Height -Weight -X20.yd.Shuttle -Bench.Press -
                                                  summary(model_lm7)
                                                #Predict
                                                preds <- predict(model_lm6, newdata = tsdata)
                                                cntrl <- trainControl(method="repeatedcv",number = 10, repeats = 5)
                                                lambda_grid <- 10^seq(-3,3,length=100)
                                                alpha <- seq(0,1, length=50)
                                                #Evaluate with Cross Validation
                                                model_ols <- train(Weighted.AV~. -Broad.Jump -Vertical.Jump -Height -Weight -X20.yd.Shuttle -Bench.Press
                                                                   data=trdata,
                                                                   method="lm",
                                                                   trControl=cntrl)
                                                model_ols
                                                library(glmnet)
                                                #Lasso Model
                                                model_lasso <- train(Weighted.AV ~ .,
                                                                     data = trdata,
                                                                     method = "glmnet",
                                                                     tuneGrid = expand.grid(alpha = 1, lambda = lambda_grid),
                                                                     trControl = cntrl)
                                                model_lasso
                                                #Best Tuning Parameter
                                                model_lasso$bestTune # Gives best tuning parameter
                                                #Lambda is 10.002656088
                                                
                                                #Top 3 Important Variables
                                                plot(model_lasso$finalModel,xvar="lambda", label=TRUE,main="LASSO REGRESSION")
                                                varImp(model_lasso)
                                                plot(varImp(model_lasso,Scale=T),main="LASSO REGRESSION")
                                                #####Visualization of varImp using ggplot2
                                                library(ggplot2)
                                                ggplot(varImp(model_lasso))
                                                #The top 3 important variable are position,40 yard dash, and 3 cone drill.
                                                model_lassopred_ts <- predict(model_lasso,newdata=tsdata)
                                                ## ### Lasso Regression model performance /accuracy test data
                                                model_lassoperformance_ts <- data.frame(RMSE=RMSE(model_lassopred_ts,tsdata$Weighted.AV),
                                                                                        Rsquare=R2(model_lassopred_ts,tsdata$Weighted.AV))
                                                model_lassoperformance_ts
                                                #Ridge Model
                                                model_rdg <- train(Weighted.AV~.,
                                                                   data=trdata,
                                                                   method="glmnet",
                                                                   tuneGrid=expand.grid(alpha=0,lambda=lambda_grid),
                                                                   trControl=cntrl)
                                                #Best Tuning Parameter
                                                model_rdg$bestTune # Gives best tuning parameter
                                                #Lambda is
                                                ##Visual inspection of RIDGE Regularization Parameter and RMSE
                                                plot(model_rdg)
                                                ##OR Visual inspection of RIDGE log(lambda) and RMSE
                                                plot(log(model_rdg$result$lambda),model_rdg$result$RMSE,xlab="log(lambda)",ylab="RMSE",xlim=c(6,-6),main
                                                     log(model_rdg$bestTune$lambda)
                                                     ## OR Visual inspection of RIDGE log(lambda) and Rsquared
                                                     plot(log(model_rdg$result$lambda),model_rdg$result$Rsquared,xlab="log(lambda)",ylab="Rsquared",xlim=c(6
                                                                                                                                                           #Top 3 Important Variables
                                                                                                                                                           varImp(model_rdg)
                                                                                                                                                           plot(varImp(model_rdg, Scale = T),main=" Ridge Regression")
                                                                                                                                                           plot(model_rdg$finalModel,xvar="lambda", label=TRUE)
                                                                                                                                                           #The most important variables are holiday season, product quality score, and price
                                                                                                                                                           model_rdgpred_ts <- predict(model_rdg,newdata=tsdata)
                                                                                                                                                           ## Ridge Regression Model performance /accuracy test data
                                                                                                                                                           model_rdgperformance_ts <- data.frame(RMSE=RMSE(model_rdgpred_ts,tsdata$Weighted.AV),
                                                                                                                                                                                                 Rsquare=R2(model_rdgpred_ts,tsdata$Weighted.AV))
                                                                                                                                                           model_rdgperformance_ts
                                                                                                                                                           #Random Forest
                                                                                                                                                           library(randomForest)
                                                                                                                                                           model_rf <- train(Weighted.AV ~ .,
                                                                                                                                                                             data = trdata,
                                                                                                                                                                             method = "rf",
                                                                                                                                                                             trControl = cntrl,
                                                                                                                                                                             tuneLength = 5)
                                                                                                                                                           model_rf
                                                                                                                                                           model_rf$results
                                                                                                                                                           model_rf$bestTune
                                                                                                                                                           varImp(model_rf)
                                                                                                                                                           plot(varImp(model_rf))
                                                                                                                                                           model_ols$results
                                                                                                                                                           3
                                                                                                                                                           model_rdg$results
                                                                                                                                                           model_lasso$results
                                                                                                                                                           model_rf$results
                                                                                                                                                           Including Plots
                                                                                                                                                           You can also embed plots, for example:
                                                                                                                                                             varImp(model_lasso)
                                                                                                                                                           plot(varImp(model_lasso,Scale=T),main="LASSO REGRESSION")
                                                                                                                                                           plot(log(model_rdg$result$lambda),model_rdg$result$RMSE,xlab="log(lambda)",ylab="RMSE",xlim=c(6,-6),main
                                                                                                                                                                plot(model_rdg)
                                                                                                                                                                plot(varImp(model_rdg, Scale = T),main=" Ridge Regression")
                                                                                                                                                                plot(model_rdg$finalModel,xvar="lambda", label=TRUE)