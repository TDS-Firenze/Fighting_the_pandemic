library(openxlsx)
library(TTR)
library(tidyverse)
library(tidyquant)
library("PerformanceAnalytics")
library(ggplot2)

set.seed(1)
#setwd('C:/Users/martapaz/Desktop/MW')

df_bt = read.xlsx(xlsxFile = "Blood_test.xlsx", sheet = 1, skipEmptyRows = FALSE)

df_bt$X1 = NULL

summary(df_bt)
str(df_bt)

######################## Decision trees #####################
library(party)
df_bt$SARS_Cov_2_exam_result = as.factor(df_bt$SARS_Cov_2_exam_result)
str(df_bt)
mtry = round(ncol(df_bt)/3)
airct <- ctree(SARS_Cov_2_exam_result ~ ., data = df_bt)
plot(airct)

bt_rf <- cforest(SARS_Cov_2_exam_result ~ ., data = df_bt, control = cforest_unbiased(mtry = mtry))
vi = varimp(bt_rf)
barplot(vi)
via = abs(varimp(bt_rf))
barplot(via)
vi_mod <- 100*(via/(sum(via)))
######################## Decision trees #####################

########################     LDA     #######################
library(MASS)
set.seed(1)
ind = sample(2, nrow(df_bt), replace = TRUE, prob = c(0.7, 0.3))
training = df_bt[ind==1,]
testing = df_bt[ind==2,]
table(testing$SARS_Cov_2_exam_result)
plot(df_bt[,c(9,12)], col=df_bt[,1])

linear_lda = lda(SARS_Cov_2_exam_result ~ ., training)
lda_prediction = predict(linear_lda, newdata = testing[,2:ncol(testing)])

createConfusionMatrix=function(actual, preds, cutoff_value){
  predClass=ifelse(preds<cutoff_value, 0, 1)
  message("Cutoff is : ", cutoff_value)
  return(table(actual,predClass))
}

## Confusion matrix for cutoff=0.5
cutoff=0.5
createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], cutoff)

tpr_x = c()
fpr_x = c()
for (i in seq(0.01,0.8,0.01)){
  CM = createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], i)
  TPR = CM[2,2]/(CM[2,2] + CM[2,1])
  tpr_x = c(tpr_x,TPR)
  FPR = CM[1,2]/(CM[1,2] + CM[1,1])
  fpr_x = c(fpr_x,FPR)
}

cof = seq(0.01,0.8,0.01)

plot(cof, tpr_x, type="l", col="red")
par(new=TRUE)
plot(cof, fpr_x, type="l", col="blue" )
title('LDA')
legend("topright",  legend = c("TPR", "FPR"), col=c("red","blue"), lty = 1:2, cex = 0.8)



CM = createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], cutoff)
TPR = CM[2,2]/(CM[2,2] + CM[2,1])
FPR = CM[1,2]/(CM[1,2] + CM[1,1])


library(ROCR)
pred=prediction(lda_prediction$posterior[,2], testing$SARS_Cov_2_exam_result)
perf=performance(pred,"tpr","fpr")

TPRfromROCR=unlist(perf@y.values)
FPRfromROCR=unlist(perf@x.values)

plot(TPRfromROCR~FPRfromROCR, col="deepskyblue", 
     main="ROC plot",type="o", pch=16);abline(0,1);grid()

print(performance(pred,"auc")@y.values[[1]])

diff_TPRFPR=TPRfromROCR-FPRfromROCR
KS=max(diff_TPRFPR)
cutoffAtKS=unlist(perf@alpha.values)[which.max(diff_TPRFPR)]
print(c(KS, cutoffAtKS))

CM = createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], cutoffAtKS)
CM

TPR = CM[2,2]/(CM[2,2] + CM[2,1])
FPR = CM[1,2]/(CM[1,2] + CM[1,1])
FNR = CM[2,1]/(CM[2,2] + CM[2,1])

########################     LDA-PCA   #######################


df_bt = read.xlsx(xlsxFile = "Blood_test.xlsx", sheet = 1, skipEmptyRows = FALSE)

df_bt$X1 = NULL

summary(df_bt)
str(df_bt)


X_PCA = df_bt[,2:ncol(df_bt)]
PC_PCA = prcomp(X_PCA, scale. = TRUE)
summary(PC_PCA)
p1_8 = as.matrix(PC_PCA$x[,1:8])
df_bt$SARS_Cov_2_exam_result = as.factor(df_bt$SARS_Cov_2_exam_result)

df_pca = data.frame(df_bt$SARS_Cov_2_exam_result, p1_8)
colnames(df_pca)[1] <- "SARS_Cov_2_exam_result"

table(df_pca$SARS_Cov_2_exam_result)

df_bt = df_pca

library(MASS)
set.seed(1)
ind = sample(2, nrow(df_bt), replace = TRUE, prob = c(0.7, 0.3))
training = df_bt[ind==1,]
testing = df_bt[ind==2,]


linear_lda = lda(SARS_Cov_2_exam_result ~ ., training) # LDA algortm
lda_prediction = predict(linear_lda, newdata = testing[,2:ncol(testing)]) # Predict with testing observaion

createConfusionMatrix=function(actual, preds, cutoff_value){
  predClass=ifelse(preds<cutoff_value, 0, 1)
  message("Cutoff is : ", cutoff_value)
  return(table(actual,predClass))
}

## Confusion matrix for cutoff=0.5
cutoff=0.5
createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], cutoff)

tpr_x = c()
fpr_x = c()
for (i in seq(0.01,0.8,0.01)){
  CM = createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], i)
  TPR = CM[2,2]/(CM[2,2] + CM[2,1])
  tpr_x = c(tpr_x,TPR)
  FPR = CM[1,2]/(CM[1,2] + CM[1,1])
  fpr_x = c(fpr_x,FPR)
}

cof = seq(0.01,0.8,0.01)

plot(cof, tpr_x, type="l", col="black")
par(new=TRUE)
plot(cof, fpr_x, type="l", col="yellow" )
title('PCA LDA')
legend("topright",  legend = c("TPR", "FPR"), col=c("black","yellow"), lty = 1:2, cex = 0.8)



library(ROCR)
pred=prediction(lda_prediction$posterior[,2], testing$SARS_Cov_2_exam_result)
perf=performance(pred,"tpr","fpr")

TPRfromROCR=unlist(perf@y.values)
FPRfromROCR=unlist(perf@x.values)

plot(TPRfromROCR~FPRfromROCR, col="deepskyblue", 
     main="ROC plot",type="o", pch=16);abline(0,1);grid()

print(performance(pred,"auc")@y.values[[1]])

diff_TPRFPR=TPRfromROCR-FPRfromROCR
KS=max(diff_TPRFPR)
cutoffAtKS=unlist(perf@alpha.values)[which.max(diff_TPRFPR)]
print(c(KS, cutoffAtKS))

CM_PCA = createConfusionMatrix(testing$SARS_Cov_2_exam_result,lda_prediction$posterior[,2], cutoffAtKS)

TPR_PCA = CM_PCA[2,2]/(CM_PCA[2,2] + CM_PCA[2,1])
FPR_PCA = CM_PCA[1,2]/(CM_PCA[1,2] + CM_PCA[1,1])

#Delay
index = which.min(FNrate)
min_FN_rate = min(FNrate)
best_test_TPR = TPrate[index]
best_test_FPR = FPrate[index]

hour = c(1,2,3,4,5,6)
chan__not_detec_infect_per = min_FN_rate**hour
plot(hour,chan__not_detec_infect_per)
lines(hour,chan__not_detec_infect_per)