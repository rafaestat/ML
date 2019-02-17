library(forcats)


load("base/files.RData")


f = factor(caged_train$UF)

fct_inorder(f)
fct_infreq(f)


f <- factor(c("b", "b", "a", "c", "c", "c"))
f
fct_inorder(f)
fct_infreq(f)

fct_inorder(f, ordered = TRUE)
  forcats::()
  f <- factor(c("a", "b"), levels = c("a", "b", "c"))
  f
  fct_drop(f)
  