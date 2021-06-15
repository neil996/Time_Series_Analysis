# Time_Series_Analysis
Analysis of different time series models on OverseasTrips and NewHouseRegistrations in Ireland

# OverseasTrips Dataset

* The Overseas Trips dataset is obtained from Central Statistics Office in Ireland and is a quarterly time series data indicating travel by non-residents to Ireland from Q1. 2012 to
Q4, 2019.
In this section, we will analyze the raw time series of the dataset which is also the required step in every time series modeling process. As the raw time series helps to identify the
Trends or Seasonality patterns within the data, which we can take into consideration during the execution of the models.

* Firstly the dataset extracted, is converted to a time series model using the function ts(), where the start and end is given along with the frequency and as this is a quarterly dataset, we given the frequency as 4. Moving on we plot the data using 
the function plot for which the output obtained is shown below in Fig. 1. ,which shows that there is increasing trend in the data as we move along from 2012 to 2020 moreover the plot also
indicates the presence of seasonality which although remains constant for most time but also show spikes as the years progresses.:

 ![image](https://github.com/neil996/Time_Series_Analysis/blob/main/Images/quarterly.PNG)
 ![image](https://github.com/neil996/Time_Series_Analysis/blob/main/Images/seasonal_decom.PNG)

# MODEL BUILDUP PHASE

* In the model construction phase, we apply 3 different types of time series model to access the overseas trips dataset using various strategies such as smoothing models which we made
use on this dataset. The different time series methods opted are Simple Exponential Smoothing, Holt’s model and lastly Holt winter seasonal method. The advantage of using exponential is that weights are given to observations with
respect to recent and past data, with past data getting lower weights and new data getting higher weights.

1. **Simple Exponential Smoothing**

Step 1: Analysis of Raw Data and creating train and test: 

The first step involves converting the raw data to time series data and as we have a quarterly time series data, we
assign the frequency as 4 along with start and end parameters to convert the raw data to quarterly time series data. Then the data is extracted for the first 2 columns and then using the
window (time series object, start, end) command in R, we subset the data into training and test sub-sets.

Step 2: Applying the model using alpha parameters best suited for SES:

SES gives best results by using the smoothing parameter i.e. alpha between the range 0.1 and 0.2, thus we apply the first initial model with alpha as 0.2 and number of forecasts i.e.
‘h’ as 3, on the train time series data. On plotting the modelled data using the function autoplot(), as shown in Fig. 5.,it is observed that we get a flat line showing
that present trend is not captured properly, thus we need to remove the trend and seasonality from the data to make it
stationary.

Step 3: Removing Trend and Seasonality from data:

To remove trend and seasonality from the time series data, differencing is used which make the non-stationary data with trend and seasonality as stationary data without trends and
seasonality. As there is no reasonable variance observed therefore Logarithmic transformation is not used. To get the number of differencing required ndiffs(time series object) is used which gives the output as 1
Therefore we make use of command diff() command, to make the train and test data stationary.

Step 4: Detecting the optimal values for alpha: To get the optimal value of the smoothing parameter to achieve the minimum RMSE is an essential task in the model
buildup process. Therefore to get the optimal value of the alpha parameter, we implemented a function which creates a sequence from 0.01 to 0.99, with an increment by 0.1 and
calculating the RMSE on each value consequently.

2. **Holt’s Exponential Smoothing Model Buildup**

Step 1: Analysis and Creating train and test: As the process to convert the raw data to a quarterly time series data, is already achieved in the Simple Exponential
Smoothing phase. Thus we move ahead with extracting data for the first 2 columns from the time series dataframe to a spate data frame and then using the window (time series object).

Step 2: Applying the model to get optimal beta values: Holt model is applied by using the function holt() passing the time series object along with alpha and beta parameters.
For the initial model we don’t give any beta value as holt will assign a beta value which after doing the summary of the applied model we get the optimal value of beta as 0.0001, on
which we can perform tuning by creating a sequence function which will increment till 0.5 and fitting each model with that specific beta value and obtaining the resulting RMSE, with the
goal to achieve minimum RMSE, which comes out to be 0.0341 with RMSE as 547.

Step3: Applying the Holt’s model with appropriate beta values: The optimal gamma value obtained is 0.0341 with minimum RMSE, thus applying minimum beta value obtained in the model with number of forecasting periods as 3, gives an
AIC of 375.

3. **Holt’s Winter Exponential Smoothing Model Buildup**

Step 1: Decomposition of different time series moreover analyzing the model parameters required: On converting the data to a time series data, we can decompose the time series into seasonal and trend obtained by
making use of decompose() method and passing the time series object which disintegrates the model to seasonal ,trend thus indicating the parameters that should be passed in model
attribute as shown in Fig. 15., indicating it as an additive time series mode for trend parameter while the seasonal variations observed indicate a Multiplicative time series approach, thus
giving the final models as (M,Ad,M).

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/Holt_Images/decomposition.png)

Step 2: Detecting optimal gamma values: The initial model applied gave the value of gamma as 0.0001.To detect the optimal gamma value, we again make use of the sequence function which increments till 0.85 and
checks the RMSE obtained at each gamma value so as to obtain the minimum gamma showing the minimum RMSE. Thus the minimum gamma value is 0.63 for which minimum RMSE is obtained 8.77.

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/Holt_Images/gamma.PNG)

# SUMMARIZING TO IDENTIFY OPTIMAL MODEL

On Overseas trips we applied three different time series models, starting with Simple Exponential Smoothing, followed by Holt’s Smoothing and finally Holt’s winter
smoothing model. All the three models are thoroughly using loop execution to ensure we get the smoothing parameters which show the minimum RMSE obtained. Therefore after executing 3 different exponential smoothing models, we need
to identify which time series model performed well on our data, thus we will run the below tests to evaluate the same:

1.) Checking Residuals:
Checking the residuals can be achieved with the help of R command checkresiduals$model. As observed from Fig.19. , it is evident that only Holt’s winter model has ACF plot in
which no autocorrelation is observed as no spike is above the dotted line, while on the other hand in Simple seasoning model and Holt’s model ,the ACF plot shows high auto-correlation
as the spikes are above the dotted lines.

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/Holt_Images/comparison.PNG)

2.) Validating using AIC (Akaike Information Criteria):
The AIC obtained from all the three different exponential smoothing models is as follows:

a. Simple Seasonal Exponential Model AIC: 370.7959
b. Holt’s Exponential Model AIC: 375.8386
c. Holt’s winter model AIC: 283.4927

Therefore from the AIC values obtained from the summary of different models, we can conclude that the model with least AIC observed i.e. 283 in Holt’s winter model is the
best fit model on the data.


# New House Registration Dataset

* TThe dataset contains annual time series data of new house registrations of the past 42 years i.e. from 1978 to 2019. We will implement 3 different times series models i.e. ARIMA(Auto Regression Integrated Moving Average), mean model and naïve model. Before starting to implement the above models, we will plot the raw time series data to find out and analyze any trends or seasonality. Below graph in Fig. 20 shows increasing trend from 1978 to around 2005 or 2006 and then it starts decreasing and again seems to be increasing. Thus we can conclude from the analysis that we have trend in our raw time series data.

Before starting to implement the above models, we will plot the raw time series data to find out and analyze any trends or seasonality. Below graph in Fig. 20 shows increasing trend from 1978 to around 2005 or 2006 and then it starts decreasing and again seems to be increasing. Thus we can conclude from the analysis that we have trend in our raw time series data.

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/New_House_Images/raaw.PNG)

# ARIMA Modelling:
In the process of execution of ARIMA modelling technique[3], it is important to remove trend or seasonality from the time series data, and as in analysis f raw time series
data, only trend pattern is detected we will apply aim to remove trend pattern. Below steps will explain the same:

Step 1: Analyzing the data for patterns:
The first step is to remove any trend or seasonality pattern from the time series dataset, as in ARIMA model any trend or seasonal pattern is not preferred. As the data had trend present, we use ndiffs() command to get the number of differencing required to make the data stationary.

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/New_House_Images/differenced.PNG)

Step 2: Implementing Augmented Dickey Fuller test:
To ensure that the data is stationary, we perform Augmented Dickey Fuller test, which on analyzing should give the p-value less than 0.5 thus confirming the null hypothesis, that the data is stationary.

Step 3: Examining the ACF and PACF Plots to identify models and values of p and q:
ACF(Autocorrelation function) and PACF(Partial autocorrelation function) helps to identify the type of ARIMA model which should be implemented.
The ACF plot shows a single spike and then slowly decay as shown in Fig.23. , while the PACF plot does not show any spikes as shown in Fig. 23. Therefore we can confirm that this a Moving average model i.e. MA(1) model with p value observed as 0 and q value observed as 1.

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/New_House_Images/acf_pacf.PNG)

Step 4: Fitting the ARIMA model with values of p, d and q and also using auto ARIMA:
The values to be put in our model are 0 for p, differencing is 1 and q as 1 which concludes to ARIMA(0,1,1). Therefore the equation to fir the model is arima(object,order=c(0,1,1)).
Thus we get the value of ma1 as 0.3736 with AIC (Akaike Information Criteria) as 627.86.
Now we make use of auto.arima(time series object, stepwise=FALSE) function to get the optimal model by automating the arima process, here the stepwise is given as FALSE so that we can detect all the possible combinations. Thus the model obtained from auto.arima came to be ARIMA(1,1,0), thus contradicting the fact that the model is MA(1) model and not an AR(1) model.

Step 5: Checking the residuals to ensure white noise observed:
On plotting the residuals on QQ plot as shown in Fig. 24., we observe that for both the models i.e. ARIMA(0,1,1) and ARIMA(1,1,0) ,the residuals are normally distributed and moreover performing the checkresiduals(model$residual) test which is an automated version of Ljung Box test as shown in Fig. 25., we do not get the significant p-values for both the ARIMA models but the better value is obtained for ARIMA(1,1,0) model and thus we can conclude that the residuals are independently distributed thus showing the models have white noise.

![image](https://github.com/neil996/Time_Series_Analysis/blob/main/New_House_Images/residuals.PNG)

# Naive Modelling:
Naïve modelling technique assigns all the weight to the last observation and do not take into consideration the Trend and Seasonal patterns.

Step 1: The data is extracted from csv format and converted to a data frame, then consequently converting the extracted data to a time series model by assigning the start and end along with frequency which would be 1 as this is a annual
time series data.

Step 2: The raw time series on conversion is then plotted, which shows an increasing trend.

Step 3: On extracting the data, we divide the data into training and test data respectively so as to better analyze the data.

Step4: Once the data is sub-divided into training and test data,then the naïve model is applied specifying the forecast period as 3.

Step 5: Forecasting and getting Accuracy: The forecasting is done using the R command forecast specifying the number of periods to forecast as 3, thus getting the Point Forecast values for term 2009 and beyond as 12676, while the High for 95% Confidence interval is 29378.26 for 2019, 36296for 2020 and 41605 for 2021.
Moreover on executing the accuracy command, we are able to obtain the accuracy with RMSE obtained in training set as 8521 and test set RMSE as 10660.

# Simple Moving Average Modelling:

Simple Moving Average performs well when the time series shows trend. In simple moving average mode, the data is averaged and then moved by removing the first value and
replacing it with new value and then again performing the average. The steps to pre-process the data and convert it into time series object will be same

i: sma()function in smooth library helps to perform this modelling technique by taking into account the time series object, which in our case we will pass “train” sub-set which
was obtained from Step3 ,and the number of forecasting i.e. “h” which will be 3.

ii: Plotting the Model: In this step we will plot the model which will give us plots such as Actual vs. Fitted, showing that the predicted values are close to the regression line thus indicating the model has good performance. The Residuals vs. Fitted graph shows residuals fit well with the data and non-linearity is not observed. Lastly the QQ plot shows that the residuals are normally distributed across the QQ line, indicating that the data is normally distributed.

iii: Forecasting and Observing Accuracy:
In this step we forecast the model 3 series ahead, thus we get the Pint Forecast as 12676 from 2009 to 2011, while the high at 95 % CI is 30402 for 2009, 37745 for 2010 and
4143379 for 2011. Thus showing that the model has performed well.

# SUMMARIZING TO IDENTIFY OPTIMAL MODEL

As both the naïve method and simple moving average belongs to the same class, we will compare these 2 models with each other first and then the resulting would be compared
with ARIMA model. Comparing Naïve and Simple Moving Average gives the standard deviation of the simple moving average as 8667.4, while in Naïve model gives a standard deviation 8521.7195, thus showing that Naïve model performed better than Simple Moving Average.

Comparing the ARIMA model with Naïve model, the former gives an RMSE of 8521.719 while for ARIMA gives an RMSE of 7736.531, while for MAE Naïve model gives
4681 while ARIMA again gives a lower value of 3863.819, thus showing that of all the three models observed ARIMA has scored better
