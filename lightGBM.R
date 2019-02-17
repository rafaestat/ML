##################################################
# light GBM tunado
# AUC: 
# acuracia valid: 
#####################################################
library(lightgbm)
library(h2o)




params <- makeParamSet(
  makeNumericParam("bagging_fraction",lower = 0.5,upper = 1),
  makeNumericParam("learning_rate",lower=0.1,upper=10),
  makeIntegerParam("num_iterations",lower=80L,upper=120L),
  makeDiscreteParam("boosting",values = c("gbdt","dart")),
  makeIntegerParam("max_depth",lower = 1L,upper = 10L),
  makeNumericParam("min_data_in_leaf",lower = 10L,upper = 500L),
  makeNumericParam("bagging_freq",lower = 0,upper = 50))


ctrl = makeTuneControlIrace(maxExperiments = 10L)
resample_desc <- makeResampleDesc("CV", iters = 4)

res = tuneParams("classif.h2o.gbm", 
                 trainTask, 
                 rdesc, 
                 par.set = params, 
                 control =ctrl, 
                 show.info = FALSE)
