##################################################
# cart tunado
# AUC: 0.8262
# acuracia valid: 0.754
#####################################################
library(tidyverse)
library(xgboost)
library(mlr)



tree_learner <- makeLearner("classif.rpart",predict.type = "prob")

ps = makeParamSet(
  makeDiscreteParam("cp", values = c(0.0001 , 0.001, 0.002)),
  makeDiscreteParam("minsplit", values = c(100)),
  makeDiscreteParam("maxdepth", values = c(10,15,20,25,30))
                    )

kfold = makeResampleDesc("CV", iters = 4L)
control.grid = makeTuneControlGrid() 

tuned = tuneParams(tree_learner, task = trainTask, 
                   resampling = kfold,
                   control = control.grid,
                   par.set = ps)




# Create a new model using tuned hyperparameters
tree_tuned_learner <- setHyperPars(
  learner = tree_learner,
  par.vals = tuned$x
)
tree_model <- train(tree_tuned_learner, trainTask)

result <- predict(tree_model, validTask)

pred <- result$data$prob.1
library(pROC)
roc_obj <- roc(caged_valid$Sexo, pred)
auc(roc_obj)
prop.table(table(caged_valid$Sexo , pred>0.5 ))
prop.table(table((caged_valid$Sexo==1) == (pred>0.5) ))
