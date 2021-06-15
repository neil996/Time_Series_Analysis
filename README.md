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

a) Simple Seasonal Exponential Model AIC: 370.7959
b) Holt’s Exponential Model AIC: 375.8386
c) Holt’s winter model AIC: 283.4927

Therefore from the AIC values obtained from the summary of different models, we can conclude that the model with least AIC observed i.e. 283 in Holt’s winter model is the
best fit model on the data.

* VIM (Visualization and Imputation of Missing Values) package helps to visualize the missing data in a deep way and thus can help to apply specific mechanisms which can be helpful in analyzing the missing values and deciding whether to impute/replace or remove it, while Fig Shows the implementation of VIM package.


  ![image](https://user-images.githubusercontent.com/78203289/120350915-4f6a2880-c2f7-11eb-9c7a-cfcab6a63ac6.png)

* Regression Techniques Implemented:


1.	XGBoost
2.	Random Forest
3.	Multiple Linear Regression
4.	Decision Tree

* Classification Models Implemented:

1.	KNN(K-Nearest Neighbor)
2.	SVC(Support Vector Classification)

#####

## Dataset 1. Conditions contributing to Covid deaths by age groups across different counties in United States


### Models Buildup


1. **XGBoost Model**:
   In our model buildup XGBoost Cross validation is done using xgboost in-built method such as xgb.cv, which tweeks certain parameters and thus is helpful to get the evaluation    log which contains the minimum and maximum tress which are built, using this data we can get the minimum number of trees which are required to predict the dependent variables    in the dataset.

2.	**Random Forest Model**:
    In our model we have used only 50 trees as increasing the number of trees is increasing computation to an indefinite time and thus is not able to give submissive results,       thus the trees has been pruned down to avoid computational error within the model.

## Dataset 2. United States COVID cases and deaths


### Models Buildup

1. **Multiple Regression Model**:
    Multiple regression model takes into account multiple factors affecting the dependent variable in the dataset. Also it generates dummy variables, as the data contains many       categorical variables which requires special needs as they cannot be entered into the regression model as it is, thus they are recoded into a series of variables.

2. **Decision Tree Model**:
    Decision Tree works on the model of nodes and constructing a tree with a certain length, in some cases maximum depth variable can be used to much extent. Decision Tree works     on the concept of splitting the nodes and thus we have to define the number of minimum splits while defining the decision tree model.We have used rpart library as part of       decision tree in R to build and execute the model, moreover the model is also pruned to get the best possible decision tree with minimum number of splits and complexity         parameter and as it is a regression model we have used method as anova.

## Dataset 3. United States Covid-19 cases and deaths over time


### Models Buildup

1. **KNN (K-Nearest Neighbor):**
   KNN or K nearest Neighbor is a classification as well as Regression model, which takes into the Euclidean distance. KNN application is rather simple as compared to other        Machine Learning methods, moreover the number of Hyper-parameters required in KNN is only defining the number of neighbors i.e. k.

   Implementing KNN required us to first get to know the optimal k value in KN, for this we used Grid search, in R we use caret library train method, which trains the model at      multiple parameters and by using bestTune parameter, we are able to retrieve the optimal k value which we can incorporate in the model.
   After this the KNN model is applied with the optimal parameters and accuracy is checked using different libraries such as confusionMtarix which gives a cumulative results on    the accuracy of the data along with Kappa value and many other.

2. **Support Vector Classification:**
   SVC or Support Vector Classification like KNN algorithm make use of Euclidean distance. The motive for using SVC is that it can generalize for a large set of data as SVC uses    epsilon hyperplane to get the model parameters in a high dimensional space. We made use of radial basis function while defining the kernel as with the help of kernel the        model is able to visualize the parameters in a high dimensional space and can give the values necessary for the model, to build support vectors.

####

## Evaluation of Regression Models:
