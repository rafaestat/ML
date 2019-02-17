##################################################
# XGBOOT tunado
# AUC: 0.8528
# acuracia valid: 0.77325 
#####################################################
library(tidyverse)
library(xgboost)
library(mlr)

load("base/files.RData")

dtrain <- xgb.DMatrix(data = as.matrix(caged_train[,-19]), label=caged_train$Sexo )
dvalid <- xgb.DMatrix(data = as.matrix(caged_valid[,-19]), label=caged_valid$Sexo )
dteste <- xgb.DMatrix(data = as.matrix(caged_teste[,-19]), label=caged_teste$Sexo )


#usando MLR
#CRIANDO A TAREFA
caged_train$Sexo = as.factor(caged_train$Sexo)
caged_teste$Sexo = as.factor(caged_teste$Sexo)
caged_valid$Sexo = as.factor(caged_valid$Sexo)

trainTask <- makeClassifTask(data = caged_train, target = "Sexo")
testeTask <- makeClassifTask(data = caged_teste, target = "Sexo")
validTask <- makeClassifTask(data = caged_valid, target = "Sexo")


#CRIANDO loarning
xgb_learner <- makeLearner("classif.xgboost",
                           predict.type = "prob",
                           par.vals = list(objective = "binary:logistic",
                                           eval_metric = "error",
                                           nrounds = 200))


#Rodando o modelo

xgb_model <- train(xgb_learner, task = trainTask)
result <- predict(xgb_model, testeTask)
result$data




#verifica todo os hiperparametro disponiveis
getParamSet("classif.xgboost")

xgb_params <- makeParamSet(
  # O número de steps (árvores no modelo, cada uma construída sequencialmente)
  makeIntegerParam("nrounds", lower = 50, upper = 150),
  # number of splits in each tree
  makeIntegerParam("max_depth", lower = 2, upper = 4),
  # número de divisões em cada árvore
  makeNumericParam("eta", lower = .4, upper = .6),
  # L2 regularization - prevents overfitting
  makeNumericParam("lambda", lower = -1, upper = 0, trafo = function(x) 10^x)
)


control <- makeTuneControlRandom(maxit = 50)

resample_desc <- makeResampleDesc("CV", iters = 4)

tuned_params <- tuneParams(
  learner = xgb_learner,
  task = trainTask,
  resampling = resample_desc,
  par.set = xgb_params,
  control = control
)

watchlist <- list(train=dtrain, test=dteste)
bst <- xgb.train(data=dtrain,
                 lambda=0.15 ,max.depth=3, eta=0.5, nthread = 1, nround=100, watchlist=watchlist, 
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
