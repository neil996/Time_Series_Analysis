#Reading the csv data
csv_Data<-read.csv("OverseasTrips.csv")

#Converting to timeseries
ts_csv_Data<-ts(csv_Data,start=c(2012,1),frequency = 4)
#Getting the data
extracted<-ts_csv_Data[,2]


#Getting training and test data

train<-window(extracted,start=c(2012,1),end=c(2017,4))
test<-window(extracted,start=c(2018,1),end=c(2019,4),frequency=4)

#applying holt winter
autoplot(decompose(extracted))

# applying ets
ets.overseas <- ets(train,
                  model = "MAM")
autoplot(ets.overseas)

ets.auto.overseas <- ets(train,
                    model = "ZZZ")
summary(ets.auto.overseas)
autoplot(ets.auto.overseas)
qcement.f2 <- forecast(ets.auto.overseas,
                       h = 3)
accuracy(qcement.f2,test)
##assessing our model

summary(ets.overseas)
checkresiduals(ets.overseas)

# forecast the next 3 quarters
qcement.f1 <- forecast(ets.overseas,
                       h = 3)
qcement.f1
# check accuracy
accuracy(qcement.f1, test)

#Getting optimum value of gamma
gamma <- seq(0.01, 0.85, 0.01)
RMSE <- NA

for(i in seq_along(gamma)) {
  hw.expo <- ets(train, 
                 "MAM", 
                 gamma = gamma[i])
  future <- forecast(hw.expo, 
                     h = 3)
  RMSE[i] = accuracy(future, 
                     test)[2,2]
}

error <- data_frame(gamma, RMSE)
minimum <- filter(error, 
                  RMSE == min(RMSE))

#Plotting the Gamma against the RMSE
ggplot(error, aes(gamma, RMSE)) +
  geom_line() +
  geom_point(data = minimum, 
             color = "blue", size = 2) +
  ggtitle("gamma's impact on 
            forecast errors",
          subtitle = "gamma = 0.63 minimizes RMSE")

# previous model with additive 
# error, trend and seasonality
accuracy(qcement.f1,test)

# new model with 
# optimal gamma parameter
qcement.hw6 <- ets(train,
                   model = "MAM", 
                   gamma = 0.63)
summary(qcement.hw6)
qcement.f6 <- forecast(qcement.hw6, 
                       h = 3)
accuracy(qcement.f6,test)
#Checking the residuals
checkresiduals(qcement.hw6$residuals)
# predicted values
qcement.f6
autoplot(qcement.f6)
