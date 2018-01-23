library(lars)
#install.packages("monomvn")

library(monomvn)
data(diabetes)  


yf = diabetes$y
Xf = diabetes$x2  # 64 variables from all 10 main effects,
                  # two-way interactions and quadradics
Xf = scale(Xf)    # rescale so that all variables have mean 0 and sd 1
n = length(yf)
n.test = 100

nsim= 25
mse.ols = rep(NA, nsim)
mse.lasso = rep(NA, nsim)
mse.bhs = rep(NA, nsim)
for (i in 1:nsim) {
  in.test = sample(1:n, n.test)  # random test cases
  in.train = (1:n)[-in.test]  # remaining training data
  y = yf[in.train]
  x = Xf[in.train,]
  db.lars = lars(x,y, type="lasso")
  Cp = summary(db.lars)$Cp
  best = (1:length(Cp))[Cp == min(Cp)]     # step with smallest Cp
  y.pred = predict(db.lars, s=best, newx=Xf[in.test,])
  mse.lasso[i] =  sum((yf[in.test] - y.pred$fit)^2)/n.test

  y.pred = predict(lm(y ~ x), Xf[in.test,]) # old predictions    
  mse.ols[i] = sum((yf[in.test] - y.pred)^2)/n.test

  bhs = blasso(x, y, case="hs", RJ=FALSE, normalize=F) #already normalized
  y.pred = mean(bhs$mu) + Xf[in.test,] %*% apply(bhs$beta, 2, mean)
  mse.bhs[i] = sum((yf[in.test] - y.pred)^2)/n.test
  print(c(i, mse.ols[i], mse.lasso[i], mse.bhs[i]))
}

boxplot(mse.ols, mse.lasso, mse.bhs)

ols = lm(y ~ x)
plot(coef(ols)[-1], apply(bhs$beta, 2, mean))
plot(coef(ols)[-1],db.lars$beta[best,])
plot(db.lars$beta[best,],apply(bhs$beta, 2, mean) )
abline(0,1)
pairs(data.frame(coef(ols)[-1],db.lars$beta[best,],  apply(bhs$beta, 2, mean)))


