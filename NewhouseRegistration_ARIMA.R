#Reading the csv data
csv_Data<-read.csv("NewHouseRegistrations_Ireland.csv")

#Converting to timeseries
ts_csv_Data<-ts(csv_Data,start=1978,frequency = 1)

#Getting the data
extracted<-ts_csv_Data[,2]

autoplot(extracted,ylab="New House Registrations",xlab="Years")

#Getting training and test data

train<-window(extracted,start=1978,end=2008,frequency=1)
test<-window(extracted,start=2009,end=2019,frequency=1)

###########################################################################
##Exploring Data

plot(extracted,main="Years", xlab="Year", ylab="New house Registrations", lwd=3)

#####################################################################

#Checking the number of differencing required to remove the trend
ndiffs(train)
differenced<-diff(train)

#Augmented Dickey Fuller test
library(aTSA)
adf.test(differenced)

#Checking variance:
autoplot(diff(train),ylab="New House Registrations",xlab="Years")

autoplot(diff(log10(train)),ylab="New House Registrations",xlab="Years")

#Checking with ACF Plot
acf(differenced)
pacf(differenced)

#Applying ARIMA Model interpreted from acf and pacf plots:

arima_fit<-arima(train,order = c(0,1,1))
arima_fit

#Forecasting ARIMA(0,1,1)

arima_forecast<-forecast::forecast(arima_fit, h=3)
arima_forecast
plot(arima_forecast)
accuracy(arima_forecast,test)

#Validating the above model:

qqnorm(arima_fit$residuals)
qqline(arima_fit$residuals)
checkresiduals(arima_fit)
Box.test(arima_fit$residuals,type = "Ljung-Box")

######################################################################################################################
###################################################AUTO-ARIMA#########################################################

#Applying Auto-ARIMA model

auto_arima_fit<-auto.arima(train,stepwise = FALSE)
auto_arima_fit

#Applying the model obtained from auto arima:

auto_arima_params_fit<-arima(train,order=c(1,1,0))
auto_arima_params_fit

#Forecasting ARIMA(1,1,0)

auto_arima_forecast<-forecast::forecast(auto_arima_params_fit, h=3)
auto_arima_forecast
plot(auto_arima_forecast)
accuracy(auto_arima_forecast,test)
summary(auto_arima_forecast)
#Validating the above model:

qqnorm(auto_arima_params_fit$residuals)
qqline(auto_arima_params_fit$residuals)
checkresiduals(auto_arima_params_fit)
Box.test(auto_arima_params_fit$residuals,type = "Ljung-Box")

