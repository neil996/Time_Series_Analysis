#Reading the csv data
csv_Data<-read.csv("NewHouseRegistrations_Ireland.csv")

#Converting to timeseries
ts_csv_Data<-ts(csv_Data,start=1978,frequency = 1)

#Getting the data
extracted<-ts_csv_Data[,2]

autoplot(extracted)

#Getting training and test data

train<-window(extracted,start=1978,end=2008,frequency=1)
test<-window(extracted,start=2009,end=2019,frequency=1)

##Applying Naive Model:

naive_model<-naive(train,h=3)
summary(naive_model)
checkresiduals(naive_model$residuals)
#Forecasting using naive model:
forecast_naive<-forecast(naive_model,3)

#Finding accuracy of the model
accuracy(naive_model,test)
autoplot(naive_model)
