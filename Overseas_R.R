#Reading the csv data
csv_Data<-read.csv("OverseasTrips.csv")

#Converting to timeseries
ts_csv_Data<-ts(csv_Data,start=c(2012,1),frequency = 4)
#Getting the data
extracted<-ts_csv_Data[,2]

#Getting training and test data

train<-window(extracted,start=c(2012,1),end=c(2017,4))
test<-window(extracted,start=c(2018,1),end=c(2019,4),frequency=4)

###########################################################################
##Exploring Data

plot(extracted,main="Cumulative Trips", xlab="year", ylab="Trips", lwd=3)
lines(ma(extracted,9),col="orange",lwd=4)

#Seasonal Plot
seasonplot(extracted,main="Seasonal plot: Overseas Quarterly",
           year.labels = TRUE, year.labels.left = TRUE,
           col=1:20, pch=19,lwd=2)

#Circular seasonal plot
ggseasonplot(extracted, polar=TRUE) +
  ylab("$ million") +
  ggtitle("Polar seasonal plot: antidiabetic drug sales")

#Monthly plot
monthplot(extracted, main="Seasonal plot: Overseas Quarterly", 
          xlab="quarter", ylab = "Number Of Trips")

#####################################################################
# removing the trend
ndiffs(train)  ##Gives output as 1
overseas_diff <- diff(train)
autoplot(overseas_diff)

# reapplying SES on the differenced data
ses.overseas.dif <- ses(train,
                    alpha = .2, 
                    h = 3)
forecastd_ses<-forecast(ses.overseas.dif,h=3)
summary(ses.overseas.dif)
autoplot(ses.overseas.dif)

# removing trend from test set
ndiffs(test)
overseas.dif.test <- diff(test)

#Checking the accuracy between test and fitted model forecasted values
accuracy(ses.overseas.dif, overseas.dif.test)

# checking with different alpha values:
alpha <- seq(.01, .99, by = .01)
RMSE <- NA
for(i in seq_along(alpha)) {
  fit <- ses(overseas_diff, alpha = alpha[i],
             h = 3)
  RMSE[i] <- accuracy(fit, 
                      overseas.dif.test)[2,2]
}

# convert to a data frame and 
# idenitify min alpha value
alpha.fit <- data_frame(alpha, RMSE)
alpha.min <- filter(alpha.fit, 
                    RMSE == min(RMSE))

# plot RMSE vs. alpha
ggplot(alpha.fit, aes(alpha, RMSE)) +
  geom_line() +
  geom_point(data = alpha.min,
             aes(alpha, RMSE), 
             size = 2, color = "red")

# Performing SES on  the optimal model.
# Overseas data
ses_diff_overseas_opt <- ses(overseas_diff, alpha=0.01,
                    h = 3)
forecastd_ses_opt<-forecast(ses_diff_overseas_opt,h=3)
forecastd_ses_opt
autoplot(ses_diff_overseas_opt)
accuracy(ses_diff_overseas_opt,overseas.dif.test)
summary(ses_diff_overseas_opt)
#Checking the residuals
checkresiduals(forecastd_ses_opt$residuals)
# plotting results
p1 <- autoplot(ses_diff_overseas_opt) +
  theme(legend.position = "bottom")
p2 <- autoplot(overseas.dif.test) +
  autolayer(ses_diff_overseas_opt, alpha = .01) +
  ggtitle("Predicted vs. Actuals for 
                 the test data set")

gridExtra::grid.arrange(p1, p2, 
                        nrow = 1)

######################################################################################
######################################################################################

