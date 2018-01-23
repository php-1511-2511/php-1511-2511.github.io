data(Boston)

library(BAS); library(lars)

rmse = function(truth, est) {  n=length(truth); sqrt(sum((truth - est)^2)/n)}

boston.bms = bms(Boston[,c(14, 1:13)], g="hyper=3")
boston.bas = bas.lm(medv ~ ., prior="hyper-g-laplace", alpha=3, n.models=2^13, method="BAS", data=Boston)
image(boston.bas, top=25)


par(mfrow=c(2,2))
plot(app.bas, ask=F)

plot(app.bas$logmarg)
set.seed(42)
n = nrow(college)
n.train=round(.80*n); n.test = n - n.train
nsim=25
rmse.ZS=rep(NA,nsim); rmse.HG=rep(NA,nsim); rmse.ols=rep(NA, nsim); rmse.lasso=rep(NA, nsim)

for ( i in 1:nsim) {
  
  train = sample(1:n, n.train)
  Y.train = lcollege$Apps[train]
  Y.test =  lcollege$Apps[-train]
  X.train = X[train,]
  X.test= X[-train,]
  
  app.bas = bas.lm(Apps ~ ., prior="ZS-null", alpha=n.train, n.models=2^18, method="BAS",data=lcollege[train,], modelprior=beta.binomial(1,1))
  Yhat = predict(app.bas, model.matrix(Apps ~ . , data= lcollege[-train,]), top=100)
  rmse.ZS[i]= rmse(Yhat$Ybma, Y.test)
  
  app.bas = bas.lm(Apps ~ ., prior="hyper-g-laplace", alpha=3, n.models=2^18, method="BAS",data=lcollege[train,], modelprior=beta.binomial(1,1))
  Yhat = predict(app.bas, model.matrix(Apps ~ . , data= lcollege[-train,]), top=100)
  rmse.HG[i]= rmse(Yhat$Ybma, Y.test)
  
  
  y.pred.ols = predict(lm(Apps ~ ., data=lcollege, subset=train), newdata=lcollege[-train,]) # old predictions    
  rmse.ols[i] = rmse(Y.test, y.pred.ols)
  
  
  db.lars = lars(X.train,Y.train, type="lasso")
  Cp = summary(db.lars)$Cp
  best = (1:length(Cp))[Cp == min(Cp)]     # step with smallest Cp
  y.pred = predict(db.lars, s=best, newx=X.test)
  rmse.lasso[i] =  rmse(Y.test,y.pred$fit)
  print(c(i, rmse.ols[i], rmse.lasso[i], rmse.ZS[i], rmse.HG[i]))
}

mean(rmse.ols); mean(rmse.lasso); mean(rmse.ZS)
boxplot(rmse.ols, rmse.lasso, rmse.ZS, names=c("OLS", "LASSO", "BMA-Cauchy"))

