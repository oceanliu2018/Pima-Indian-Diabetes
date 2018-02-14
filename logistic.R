# Load packages
library(ROCR)
library(caret)

pima = read.csv('pima.csv')

# original data sets has missing values denoted by the zero
# exlude rows with zero in data frame excluding test variable
clean.pima = pima[rowSums(pima[2:7] == 0) ==0,]

summary(clean.pima)




log1 = glm(test~.,data = clean.pima,family = binomial)
summary(log1)
# New reduced model with only significant features
log2 = glm(test~glucose+bmi+diabetes,data = clean.pima,family = binomial)
summary(log2)

# Compare the deviance of the two models
anova(log1,log2,test = 'Chi')

# Add age to the reduced model
log3 = glm(test~glucose+bmi+diabetes+age,data = clean.pima,family = binomial)
summary(log3)

# COmpare deviance of new reduced model
anova(log1,log3,test = "Chi")


# Compute Specificty and Sensitity
fitvalues = log3$fitted.values
score.vec = seq(0, 1, by = 0.001)
tpr.vec = numeric(1001)
fpr.vec = numeric(1001)
for (i in 1:1001){
  s <- score.vec[i]
  true.positive <- sum((fitvalues > s) * clean.pima$test)
  false.positive <- sum((fitvalues > s) * (1 - clean.pima$test))
  true.negative <- sum((fitvalues <= s) * (1 - clean.pima$test))
  false.negative <- sum((fitvalues <= s) * clean.pima$test)
  tpr.vec[i] <- true.positive/(true.positive + false.negative)
  fpr.vec[i] <- false.positive/(true.negative + false.positive)
}

# Output Plot of Sensitivity and Selectivity vs varuous thresholds to png
png('Threshold.png')
plot(score.vec,tpr.vec-fpr.vec,type = 'l',xlab = 'threshold', ylab = 'Sensitivty plus Specificity',main = 'Accuracy at Various Thresholds')
dev.off()

# Output ROC plot to png
png('ROC.png')
plot(fpr.vec,tpr.vec,xlab = 'false positive rate',ylab = 'true positive rate',type = 'l',col='red',main = 'ROC Plot')
abline(0,1)
dev.off()
# Compute AUC
pred = prediction(predict(log3,type = 'response'),clean.pima$test)
perf = performance(pred,'auc')
as.numeric(perf@y.values)

# Make confusion matrix
confusionMatrix(as.integer(predict(log3,type='response')>0.3),clean.pima$test)

# Compute odds
exp(coef(log3))
