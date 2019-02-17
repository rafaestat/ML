##################################################
# naive bayes
# AUC: 0.6861
# acuracia valid: 0.65685 
#####################################################

library(mlr)

#####################################
# load das bases

load("base/files.RData")
summarizeColumns(caged_train)
caged_train$Sexo = as.integer(caged_train$Sexo )
caged_teste$Sexo = as.integer(caged_teste$Sexo )
caged_valid$Sexo = as.integer(caged_valid$Sexo )

trainTask <- makeClassifTask(data = caged_train, target = "Sexo")
testeTask <- makeClassifTask(data = caged_teste, target = "Sexo")
validTask <- makeClassifTask(data = caged_valid, target = "Sexo")

#####################################
# cria os learns
nb_learner = makeLearner("classif.naiveBayes" 
                         ,predict.type = "prob")


#verifica todo os hiperparametro disponiveis
getParamSet("classif.naiveBayes")


nb_model = train(nb_learner, trainTask)

result <- predict(nb_model, validTask)
result$data
                
pred <- result$data$prob.1  
library(pROC)
roc_obj <- roc(caged_valid$Sexo, pred)
auc(roc_obj)
prop.table(table(caged_valid$Sexo , pred>0.5 ))
prop.table(table((caged_valid$Sexo==1) == (pred>0.5) ))     


result <- predict(nb_model, trainTask)
result$data

pred <- result$data$prob.1  
library(pROC)
roc_obj <- roc(caged_train$Sexo, pred)
auc(roc_obj)
prop.table(table(caged_train$Sexo , pred>0.5 ))
prop.table(table((caged_train$Sexo==1) == (pred>0.5) ))  


###############################################
# tunando 

#verifica todo os hiperparametro disponiveis
getParamSet("classif.naiveBayes")


