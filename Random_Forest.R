##################################################
# Random forest Tunada
# AUC: 0.849
# acuracia valid: 0.77215
#####################################################

library(randomForest)

load("base/files.RData")

#usando MLR
#CRIANDO A TAREFA
caged_train$Sexo = as.factor(caged_train$Sexo)
caged_teste$Sexo = as.factor(caged_teste$Sexo)
caged_valid$Sexo = as.factor(caged_valid$Sexo)

trainTask <- makeClassifTask(data = caged_train, target = "Sexo")
testeTask <- makeClassifTask(data = caged_teste, target = "Sexo")
validTask <- makeClassifTask(data = caged_valid, target = "Sexo")

rfLRN <- makeLearner("classif.randomForest" 
                     ,predict.type = "prob")

#Tune!

#verifica todo os hiperparametro disponiveis
getParamSet( rfLRN )

#Defining the Hyperparameter Space
ps = makeParamSet(
  makeDiscreteParam("mtry"  , values = c(10,20,30,50)),
  makeDiscreteParam("ntree" , values = c(50,150,200,250))
)

#Defining Resampling
cvTask <- makeResampleDesc("CV", iters=4L)

#Defining Search
search <-  makeTuneControlGrid()

tune <- tuneParams(learner = rfLRN
                   ,task = trainTask
                   ,resampling = cvTask
                   ,measures = list(acc)
                   ,par.set = ps
                   ,control = search
                   ,show.info = TRUE)

#[Tune] Result: mtry=20; ntree=250 : acc.test.mean=0.7734000


# Create a new model using tuned hyperparameters
rf_tuned_learner <- setHyperPars(
  learner = rfLRN,
  par.vals = tune$x
)
rf_model <- train(rf_tuned_learner, trainTask)

result <- predict( rf_model, validTask)


pred <- result$data$prob.1  
library(pROC)
roc_obj <- roc(caged_valid$Sexo, pred)
auc(roc_obj)
prop.table(table(caged_valid$Sexo , pred>0.5 ))
prop.table(table((caged_valid$Sexo==1) == (pred>0.5) ))
