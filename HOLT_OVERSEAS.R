#Reading the csv data
csv_Data<-read.csv("OverseasTrips.csv")

#Converting to timeseries
ts_csv_Data<-ts(csv_Data,start=c(2012,1),frequency = 4)
#Getting the data
extracted<-ts_csv_Data[,2]


#Getting training and test data

train<-window(extracted,start=c(2012,1),end=c(2017,4))
test<-window(extracted,start=c(2018,1),end=c(2019,4),frequency=4)

#Applying the holt model

holtoverseas<-holt(train,h=3)
autoplot(holtoverseas)
summary(holtoverseas)
forecast(holtoverseas,h=3)
#Getting optimal values of aplha and beta

holtoverseas$model#The optimal value i.e. beta =0.0001 is used to remove errors from the training set. We can tune our beta to this optimal value. 

accuracy(holtoverseas,test)

#Let us try to find the optimal value of beta through a loop ranging from 0.0001 to 0.5 that will minimize the RMSE test.

# identify optimal beta parameter
beta <- seq(.0001, .5, by = .001)
RMSE <- NA
for(i in seq_along(beta)) {
  fit <- holt(train,
              beta = beta[i], 
              h = 3)
  RMSE[i] <- accuracy(fit, 
                      test)[2,2]
}

# convert to a data frame and
# idenitify min beta value
beta.fit <- data_frame(beta, RMSE)
beta.min <- filter(beta.fit, 
                   RMSE == min(RMSE))
beta.fit
beta.min
# plot RMSE vs. beta
ggplot(beta.fit, aes(beta, RMSE)) +
  geom_line() +
  geom_point(data = beta.min, 
             aes(beta, RMSE), 
             size = 2, color = "red")

# new model with optimal beta
holt.overseas.opt <- holt(train,
                      h = 3,
                      beta = 0.0341)
summary(holt.overseas.opt)
forecast(holt.overseas.opt,h=3)
#Checking the residuals
checkresiduals(holt.overseas.opt$residuals)
# accuracy of first model
accuracy(holtoverseas,test)

# accuracy of new optimal model
accuracy(holt.overseas.opt, test)

#Plotting the Original Holt model along with Optimal Holt model:

p1 <- autoplot(holtoverseas) +
  ggtitle("Original Holt's Model") 

p2 <- autoplot(holt.overseas.opt) +
  ggtitle("Optimal Holt's Model") 
  

gridExtra::grid.arrange(p1, p2, 
                        nrow = 1)