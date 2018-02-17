# Predicting Diabetes amongst Pima Indians

## Introduction
The increasing prevalence of diabetes is becoming a growing problem for the modern world, exposing people to its many long-term consequences. This project seeks to create a model that can identify diabetics and find the factors that most increase the risk of diabetes. Logistic regression was chosen as the model due to the only possible outcomes, having and not having signs of diabetes.

## Data Visualization and Preprocessing
The dataset can be found within the R faraway package. The dataset is composed of the health information of 768 females from the Pima Indian tribe, who have a high rate of diabetes. The dataset includes the following features:
  
  1. **pregnant**: number of pregnancies
  2. **glucose**: plasma glucose concentration at 2 hours in an oral glucose tolerance test
  3. **diastolic**: diastolic blood pressure (mm Hg)
  4. **triceps**: triceps skin fold thickness (mm)
  5. **insulin**: 2-Hour serum insulin (mu U/ml)
  6. **bmi**: body mass index (weight in kg/(height in meters squared))
  7. **diabetes**: diabetes pedigree function
  8. **age**: age (years) 
  9. **test**: test whether the patient shows signs of diabetes (coded 0 if negative, 1 if positive)

The original dataset had zeroes in many of the entries. In the context of the features, it is almost certain that they are missing data.
Thus, of the original 768 individuals, only the 392 individuals that had complete entries were used for the analysis.

The following plot shows the correlation between the various features to show how they interact with each other. Overall, glucose has the highest correlation with the test result. Other noteworthy correlations are triceps with bmi, age with pregnancies and inusulin with glucose.

![Heatmap](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/Heatmap.png)

## Fitting
We first performed logistic regression with all the features against the test result. Based on a significance threshold of 0.05, glucose (3.24e-11), bmi (0.00989), and diabetes pedigree (0.00760) were highly significant. Of the rest of the features, age (0.06474) was close to this threshold. 
```r
log1 = glm(test~.,data = clean.pima,family = binomial)
summary(log1)

##
## Call:
## glm(formula = test ~ ., family = binomial, data = clean.pima)
##
## Deviance Residuals: 
##    Min       1Q   Median       3Q      Max  
## -2.7823  -0.6603  -0.3642   0.6409   2.5612  
##
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.004e+01  1.218e+00  -8.246  < 2e-16 ***
## pregnant     8.216e-02  5.543e-02   1.482  0.13825    
## glucose      3.827e-02  5.768e-03   6.635 3.24e-11 ***
## diastolic   -1.420e-03  1.183e-02  -0.120  0.90446    
## triceps      1.122e-02  1.708e-02   0.657  0.51128    
## insulin     -8.253e-04  1.306e-03  -0.632  0.52757    
## bmi          7.054e-02  2.734e-02   2.580  0.00989 ** 
## diabetes     1.141e+00  4.274e-01   2.669  0.00760 ** 
## age          3.395e-02  1.838e-02   1.847  0.06474 .  
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
##
## (Dispersion parameter for binomial family taken to be 1)
##
##     Null deviance: 498.10  on 391  degrees of freedom
## Residual deviance: 344.02  on 383  degrees of freedom
## AIC: 362.02
##
## Number of Fisher Scoring iterations: 5
```
Based on the significant features, we create a reduced model that only includes glucose, bmi, and diabetes pedigree.
```r
log2 = glm(test~glucose+bmi+diabetes,data = clean.pima,family = binomial)
summary(log2)

##
## Call:
## glm(formula = test ~ glucose + bmi + diabetes, family = binomial, 
##     data = clean.pima)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.9885  -0.6873  -0.4256   0.6689   2.5516  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -8.791977   0.972850  -9.037  < 2e-16 ***
## glucose      0.040708   0.004891   8.324  < 2e-16 ***
## bmi          0.068073   0.019819   3.435 0.000593 ***
## diabetes     1.171465   0.414149   2.829 0.004675 ** 
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
##
## (Dispersion parameter for binomial family taken to be 1)
##
##     Null deviance: 498.1  on 391  degrees of freedom
## Residual deviance: 363.7  on 388  degrees of freedom
## AIC: 371.7
##
##Number of Fisher Scoring iterations: 5
```
We test the goodness of fit by comparing the deviance of the reduced model with that of the full model. Our null hypothesis shows that there is no difference between reduced model and the full model. In other words, if there is no significant increase in the deviance when we remove the features, then we can use the reduced model instead of the full model.

The result indicates that there is a significant increase in the residual sum of squares (Resid. Dev), indicating that the reduced model introduces a significant amount of deviance. Thus, we reject the null hypothesis.

```r
anova(log1,log2,test = 'Chi')

## Analysis of Deviance Table
##
## Model 1: test ~ pregnant + glucose + diastolic + triceps + insulin + bmi + 
##     diabetes + age
## Model 2: test ~ glucose + bmi + diabetes
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)   
## 1       383     344.02                        
## 2       388     363.70 -5   -19.68 0.001435 **
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

From the rest of the features, we re-add the age variables as it has a p-value that was very close to our threshold for significance. We found that in this new model, age becomes highly significant (8.00e-05), suggesting that the interaction of age with the other features decreases the impact of age.
```r
log3 = glm(test~glucose+bmi+diabetes+age,data = clean.pima,family = binomial)
summary(log3)

##
## Call:
## glm(formula = test ~ glucose + bmi + diabetes + age, family = binomial, 
##     data = clean.pima)
##
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.8228  -0.6617  -0.3759   0.6702   2.5881  
##
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -10.092018   1.080251  -9.342  < 2e-16 ***
## glucose       0.036189   0.004982   7.264 3.76e-13 ***
## bmi           0.074449   0.020267   3.673 0.000239 ***
## diabetes      1.087129   0.419408   2.592 0.009541 ** 
## age           0.053012   0.013439   3.945 8.00e-05 ***
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
##
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 498.10  on 391  degrees of freedom
## Residual deviance: 347.23  on 387  degrees of freedom
## AIC: 357.23
##
## Number of Fisher Scoring iterations: 5

```
We repeat the deviance test with the new reduced model. This time we found that that the difference in residual sum of squares is no longer significant, indicating that the reduced model performs about as well as the full model.
```r
anova(log1,log3,test = "Chi")
## Analysis of Deviance Table
##
## Model 1: test ~ pregnant + glucose + diastolic + triceps + insulin + bmi + 
##     diabetes + age
## Model 2: test ~ glucose + bmi + diabetes + age
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       383     344.02                     
## 2       387     347.23 -4  -3.2138   0.5227
```
To evaluate the effectiveness of the model, we draw the ROC plot and compute the area under the curve. The area under the curve (AUC) for the ROC plot is 0.86, indicating that the model is relatively accurate. 
![ROC curve](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/ROC.png)
```
pred = prediction(predict(log3,type = 'response'),clean.pima$test)
perf = performance(pred,'auc')
as.numeric(perf@y.values)

[1] 0.8604521
```
We plot the true positive rate + true negative rate vs threshold to see how the model performs at various thresholds. Based on the plot,  a threshold of about 0.3 yields the highest rate of true positives and negatives.

![Threshold](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/Threshold.png)

At a threshold of 0.3, we compute the following confusion matrix. The model has an accuracy of 0.7755 with a 95% confidence interval of (0.7309, 0.8159).
```
          Reference
Prediction   0   1
         0 201  27
         1  61 103

Accuracy : 0.7755          
                95% CI : (0.7309, 0.8159)
```
## Discussion
Using only bmi, diabetes pedigree, age, and glucose we created a relatively accurate model to identify those who had diabetes. In context, these features seem appropriate. High glucose level is one of the major symptoms for diabetes. Diabetic people tend to be more overweight and have high bmi. Family history has also been considered a major risk factor. Finally, older adults are far more likely to be diabetic that young adults.

Using the coefficients from that model we can compute the odds ratios of the features. A one unit increase in glucose, bmi, diabetes, age, will increase the odds of testing positive for diabetes by 3.7%, 7.8%, 197%, and 5.4% respectively. 
```
exp(coef(log3))

## (Intercept)      glucose          bmi     diabetes          age 
## 4.140876e-05 1.036852e+00 1.077290e+00 2.965746e+00 1.054442e+00 
```
The features that were not strong predictors can also be accounted for. Diastolic results were not a good indicator of diabetes, which is to be expected given the lack of correlation with the test results. This suggests that though high blood pressure is a major symptom of diabetes, those who have hypertension may not necessarily be more prone to diabetes. Tricep skin thickness is an estimator of body fat like bmi. Insulin also fails to outperform glucose, suggesting that directly measuring glucose levels is more effective. Though number of pregnancies was not significant in our model, it had the next lowest p-value and should be considered for future analyses. 

One issue is the lack of documentation on the diabetes pedigree function. Since we do not know how it is calculated nor its units, it is impossible to assess how much it increases the odds of diabetes. Conversely, it is easy to gather patient information on bmi, age, and glucose level. 

Since the model was created from data only including female Pima Indians, further study is required to determine if the model can be applied to other groups. Thus, future analyses should expand on the sample to include people of different ethnicities and both genders. Most importantly, the size of the dataset is not very large, so the model may not be very robust. 
