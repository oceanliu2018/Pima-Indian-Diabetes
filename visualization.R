# Creates a correlation heatmap
pima = read.csv('pima.csv')

# original data sets has missing values denoted by the zero
# exlude rows with zero in data frame excluding test variable
clean.pima = pima[rowSums(pima[2:7] == 0) ==0,]
library(ggplot2)
library(ggcorrplot)

corr = cor(clean.pima)

# Create heatmap
png('Heatmap.png')
ggcorrplot(corr,lab = TRUE)
dev.off()