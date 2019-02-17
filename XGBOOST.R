##################################################
# XGBOOT 
# AUC: 0.8491
# acuracia valid: 0.76955 
#####################################################


library(tidyverse)
library(xgboost)

load("base/files.RData")




dtrain <- xgb.DMatrix(data = as.matrix(caged_train[,-19]), label=caged_train$Sexo )
dvalid <- xgb.DMatrix(data = as.matrix(caged_valid[,-19]), label=caged_valid$Sexo )
dteste <- xgb.DMatrix(data = as.matrix(caged_teste[,-19]), label=caged_teste$Sexo )

watchlist <- list(train=dtrain, test=dteste)
bst <- xgb.train(data=dtrain, 
                 max.depth=4, eta=0.05, nthread = 1, nround=250, watchlist=watchlist, 
                 objective = "binary:logistic")


plot(bst$evaluation_log$iter,bst$evaluation_log$train_error)
lines(bst$evaluation_log$train_error)
lines(bst$evaluation_log$test_error,col='red')


pred <- predict(bst, dvalid)
library(pROC)
roc_obj <- roc(caged_valid$Sexo, pred)
auc(roc_obj)
prop.table(table(caged_valid$Sexo , pred>0.5 ))
prop.table(table((caged_valid$Sexo==1) == (pred>0.5) ))



importance_matrix <- xgb.importance(model = bst)
print(importance_matrix)
xgb.plot.importance(importance_matrix = importance_matrix)
xgb.dump(bst, with.stats = T)
