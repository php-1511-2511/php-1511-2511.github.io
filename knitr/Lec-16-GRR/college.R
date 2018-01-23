college = read.csv("../../Data/college.csv", header=T, row.names=1)
Elite = rep(0, nrow(college))
Elite[college$Top10perc > 50] = 1
college$Elite = Elite

plot(Apps ~ ., log="xy", data=college)

lcollege= college
attach(college)
lcollege$Apps = log(Apps)
lcollege$Accept = log(Accept)
lcollege$Enroll = log(Enroll)
lcollege$F.Undergrad = log(F.Undergrad)
lcollege$P.Undergrad = log(P.Undergrad)
lcollege$Outstate = log(Outstate)
lcollege$Room.Board = log(Room.Board)
lcollege$Books = log(Books)
lcollege$Personal = log(Personal)
lcollege$Expend = log(Expend)

X = as.matrix(lcollege[, -(1:2)]) # remove Private factor and Apps = Y
X = cbind(as.numeric(lcollege$Private),X)
colnames(X)[1] = "Private"

plot(lm(Apps ~ ., data=lcollege))


library(BAS); library(lars)

rmse = function(truth, est) {  n=length(truth); sqrt(sum((truth - est)^2)/n)}

app.bas = bas.lm(Apps ~ ., prior="ZS-null", alpha=777, n.models=2^18, method="MCMC+BAS", 
                 MCMC.iterations=50000,data=lcollege)
app.bas = bas.lm(sqrt(Apps) ~ ., prior="ZS-null", alpha=777, n.models=2^17, method="MCMC", 
                 MCMC.iterations=50000000,data=college)
image(app.bas, top=25)

par(mfrow=c(2,2))
plot(app.bas, ask=F)

plot(app.bas$logmarg)
set.seed(42)
n = nrow(college)
n.train=round(.90*n); n.test = n - n.train
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
  
  app.bas = bas.lm(Apps ~ ., prior="BIC", alpha=n.train, n.models=2^18, method="BAS",data=lcollege[train,], modelprior=beta.binomial(1,1))
  Yhat = predict(app.bas, model.matrix(Apps ~ . , data= lcollege[-train,]), top=1)
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
rmse.mat = cbind(rmse.ols, rmse.lasso, rmse.ZS, rmse.HG)
boxplot(sweep(rmse.mat, 1, apply(rmse.mat,1, min), FUN="/"))

boxplot(rmse.ols, rmse.lasso, rmse.ZS, names=c("OLS", "LASSO", "BMA-Cauchy"))
