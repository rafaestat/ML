library(tidyverse)



CAGEDEST_052018 <- read.csv2("~/Projetos_R/XGBoost_CAGED/Dados/CAGEDEST_052018.txt", 
                             row.names=NULL)
n = dim(CAGEDEST_052018)[1]
amostra = sample( n )

CAGEDEST_052018 <- CAGEDEST_052018[amostra,1:24]
CAGEDEST_052018$Sexo = CAGEDEST_052018$Sexo-1

tra = 1:30000
val = 30001:50000
tes = 50001:150000


caged_train = CAGEDEST_052018[ amostra[tra] , ]
caged_valid = CAGEDEST_052018[ amostra[val] , ]
caged_teste = CAGEDEST_052018[ amostra[tes] , ]

dir.create("base")
save(caged_train , caged_valid , caged_teste , file = "base/files.RData")






