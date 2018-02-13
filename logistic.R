pima = read.csv('pima.csv')
# original data sets has missing values denoted by the zero

clean.pima = pima[rowSums(pima[2:7] == 0) ==0,]
#exludes rows with zero in data frame excluding test variable

summary(clean.pima)

log1 = glm(test~.,data = clean.pima,family = binomial)
summary(log1)
# New reduced model with only significant features
log2 = glm(test~glucose+bmi+diabetes,data = clean.pima,family = binomial)
summary(log2)

anova(log1,log2,test = 'Chi')

fitvalues = log2$fitted.values
score.vec = seq(0, 1, by = 0.01)
tpr.vec = numeric(101)
fpr.vec = numeric(101)
for (i in 1:101){
  s <- score.vec[i]
  true.positive <- sum((fitvalues > s) * clean.pima$test)
  false.positive <- sum((fitvalues > s) * (1 - clean.pima$test))
  true.negative <- sum((fitvalues <= s) * (1 - clean.pima$test))
  false.negative <- sum((fitvalues <= s) * clean.pima$test)
  tpr.vec[i] <- true.positive/(true.positive + false.negative)
  fpr.vec[i] <- false.positive/(true.negative + false.positive)
  }
plot(score.vec,tpr.vec-fpr.vec,type = 'l',xlab = 'threshold', ylab = 'Sensitivty plus Specificity')
plot(fpr.vec,tpr.vec,xlab = 'false positive rate',ylab = 'true positive rate',type = 'l')
abline(0,1)
