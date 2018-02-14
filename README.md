# Pima-Indian-Diabetes

## Introduction
The increase in the prevalence of diabetes is becoming a growing problem for the modern world and has many long-term consequences on human health. Logistic regression was performed on the data to create a model to identify those that are diabetic as well as find the factors that most increase the risk of diabetes. Logistic regression was chosen due to only being two possible outcomes, having and not having signs of diabetes.

## Data Preprocessing
The dataset is composed of the health information of Pima Indians who have a high rate of diabetes. The dataset includes the following features
  1. **pregnant**: number of pregnancies
  2. **glucose**: plasma glucose concentration at 2 hours in an oral glucose tolerance test
  3. **diastolic**: diastolic blood pressure (mm Hg)
  4. **triceps**: triceps skin fold thickness (mm)
  5. **insulin**: 2-Hour serum insulin (mu U/ml)
  6. **bmi**: body mass index (weight in kg/(height in meters squared))
  7. **diabetes**: diabetes pedigree function
  8. **age**: age (years) 
  9. **test**: test whether the patient shows signs of diabetes (coded 0 if negative, 1 if positive)
Due to missing data (zeroes in the data frame), of the original 768 entries, only the 392 that had complete entries were used.

## Results
A logistic regression with all features was first performed. Based on the probabilities in the final column, we see that glucose levels, bmi, and diabetes pedigree are highly significant. Of the rest of the features, age also has a relatively low p-value.
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
Based on the significant features, we create a model that only include the three features that are highly significant 

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
We can test the goodness of fit by comparing the reduced model with the full model. The null hypothesis being that the reduced model fits well and the alternate hypothesis being that the reduced model does not.

The result show that there is a significant increase in the Residual sum of squares (Resid. Dev), indicating that the reduced model introduces a significant amount of deviance. We reject the null hypothesis.

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

We re-add the age variables as it has a p-value which had the smallest p-value in the full model. We see that in this new model, age becomes significant, suggesting that age's interactions with the other variables in the full model decreases its impact.
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
We can repeat the goodness of fit test with the new reduced model. This time we see that that the difference in residual sum of squares is no longer significant, indicating that the reduced model performs about as well as the full model.
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
To evaluate the effectiveness of the model, we can create the ROC plot an compute the area under the curve.  The area under the curve for the ROC plot is 0.86, which indicates that the model is relatively accurate. 
![ROC curve](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/ROC.png)
```
pred = prediction(predict(log3,type = 'response'),clean.pima$test)
perf = performance(pred,'auc')
as.numeric(perf@y.values)

[1] 0.8604521
```
From the specificity (true negative rate) + sensitivity (true positive rate) vs threshold plot, it seems that a threshold of 0.3 yields the best combined specificity and sensitivity.
![Threshold](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/Threshold.png)


At a threshold of 0.3, we compute the following confusion matrix. The model has an accuracy of 0.7755 with a 95% confidence interval of (0.7309, 0.8159) 
```
          Reference
Prediction   0   1
         0 201  27
         1  61 103

Accuracy : 0.7755          
                95% CI : (0.7309, 0.8159)
```
## Discussion
Using only bmi, diabetes pedigree, age, and glucose we were able to create a relatively accurate model. These features seem appropriate. High glucose level is one of the symptoms for diabetes. Diabetic people tend to be more overweight. Family history is also considered a major risk factor. Older adults are most prevalent group for diabetes.

Using the coefficients from that model we can compute the odds ratios of the features. A one unit increase in glucose, bmi, diabetes, age, will increase the odds of testing positive for diabetes by 3.7%, 7.8%, 197%, and 5.4 percent respectively. 
```
exp(coef(log3))

## (Intercept)      glucose          bmi     diabetes          age 
## 4.140876e-05 1.036852e+00 1.077290e+00 2.965746e+00 1.054442e+00 
```
The most surprising finding was how little impact diastolic blood pressure had on the diabetes test. This may be due to the size of dataset
Future analyses should include different ethnicities as well as both genders.
