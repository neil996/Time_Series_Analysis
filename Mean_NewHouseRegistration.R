#Reading the csv data
csv_Data<-read.csv("NewHouseRegistrations_Ireland.csv")

#Converting to timeseries
ts_csv_Data<-ts(csv_Data,start=1978,frequency = 1)

#Getting the data
extracted<-ts_csv_Data[,2]

#Getting training and test data

train<-window(extracted,start=1978,end=2008,frequency=1)
test<-window(extracted,start=2009,end=2019,frequency=1)

##Applying the simple mean average model as this model considers trend data:

meanf_fit<-sma(train,h=3,slient=none)
meanf_fit
plot(meanf_fit)
summary(meanf_fit)

#Forecasting:
forecast_mean<-forecast(meanf_fit,h=3)
print(forecast_mean)
checkresiduals(meanf_fit)
summary(forecast_mean)

