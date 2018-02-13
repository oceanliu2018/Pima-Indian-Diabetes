# Pima-Indian-Diabetes

## Introduction
The goal of this project is to create a model that will accurately predict diabetes. The dataset is composed of the health information of Pima Indians. The dataset includes the following features
  1. **pregnant**: number of pregnancies
  2. **glucose**: plasma glucose concentration at 2 hours in an oral glucose tolerance test
  3. **diastolic**: diastolic blood pressure (mm Hg)
  4. **triceps**: triceps skin fold thickness (mm)
  5. **insulin**: 2-Hour serum insulin (mu U/ml)
  6. **bmi**: body mass index (weight in kg/(height in metres squared))
  7. **diabetes**: diabetes pedigree function
  8. **age**: age (years) 
  9. **test**: test whether the patient shows signs of diabetes (coded 0 if negative, 1 if positive)
Due to missing data (0 in the dataframe), of the orignal 768 entries, 392 that had compelete entries were used.
Since we are attempting to predict the outcome of the binary "test" variable, logistic regression seemd to be a reasonable choice.
## Results


The most significant features are bmi, diabetes, glucose
Choosing the most significant features we get the following model
```
Call:
glm(formula = test ~ glucose + bmi + diabetes, family = binomial, 
    data = clean.pima)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.9885  -0.6873  -0.4256   0.6689   2.5516  

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -8.791977   0.972850  -9.037  < 2e-16 ***
glucose      0.040708   0.004891   8.324  < 2e-16 ***
bmi          0.068073   0.019819   3.435 0.000593 ***
diabetes     1.171465   0.414149   2.829 0.004675 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 498.1  on 391  degrees of freedom
Residual deviance: 363.7  on 388  degrees of freedom
AIC: 371.7

Number of Fisher Scoring iterations: 5
```
We test the goodness of fit by comparing the reduced model with the full model, the reduced model is sigficant.
```
Analysis of Deviance Table

Model 1: test ~ pregnant + glucose + diastolic + triceps + insulin + bmi + 
    diabetes + age
Model 2: test ~ glucose + bmi + diabetes
  Resid. Df Resid. Dev Df Deviance Pr(>Chi)   
1       383     344.02                        
2       388     363.70 -5   -19.68 0.001435 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```
The following ROC curve visualises the effectiveness of our model
![ROC curve](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/ROC%20curve.png)

The following plot compares Sensitivity + Specficity and various thesholds. Based on the plot, it appears that a threshold of around 0.3 will produce the best results
![Threshold](https://github.com/oceanliu2018/Pima-Indian-Diabetes/blob/master/ThresholdPlot.png)
