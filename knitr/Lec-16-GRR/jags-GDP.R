library(MASS)
library(lars)
### R interface to JAGS:
library(R2jags)
library(R2WinBUGS)

college=read.csv("../../Data/College.csv",header=T,row.names=1)
summary(college)
plot(lm(Apps ~ ., data=college))
# boxcox - sqrt ?
plot(lm(sqrt(Apps) ~ ., data=college))

n = nrow(college)
set.seed(42)
n.train=round(.80*n); n.test = n - n.train

select(lm.ridge(Apps ~ ., data=college, subset=train, lambda=seq(0, 1.5, length=50)))
plot(lm.ridge(Apps ~ ., data=college, lambda=seq(0, 1.5, length=50)))
college.ridge = lm.ridge(Apps ~ ., data=college, subset=train, lambda=0.489)



rr.model = function() {

  for (i in 1:n.train) {
      mu[i] <- inprod(X.train[i,], beta) + alpha
      Y.train[i] ~ dnorm(mu[i], phi)
  }
  for (i in 1:n.test) {
    mupred[i] <- inprod(X.test[i,], beta[1:p]) + alpha
#    Y.test[i] ~ dnorm(mupred[i], phi)  # drop or make sure that Y.test is NA
  }
  phi ~ dgamma(1.0E-6, 1.0E-6)
  alpha ~ dnorm(0, 1.0E-10)
  
  for (j in 1:p) {
      prec.beta[j] <- phi/tau2[j]
      tau2[j] ~ dexp(lambda.beta/2)
      beta[j] ~ dnorm(0, prec.beta[j])
  }
# GDP Prior on beta
  lambda.beta ~ dgamma(1, 1)

  for (j in 1:p) {
      beta.orig[j] <- beta[j]/scales[j]   # rescale
  }
  beta.0[1] <- alpha[1] - inprod(beta.orig[1:p], Xbar)

  sigma <- pow(phi, -.5)
}
rr.model.file = paste(getwd(),"rr-model.txt", sep="/")
write.model(rr.model, rr.model.file)


# create a function that provides intial values for WinBUGS
rr.inits = function() {
    bf.lm <- lm(sqrt(college$Apps) ~ scale(X))
    coefs = coef(bf.lm)
    alpha= coefs[1]
    beta = coefs[-1]
    phi = (1/summary(bf.lm)$sigma)^2
return(list(alpha=alpha, beta=beta,phi=phi))
  }

# a list of all the parameters to save

parameters = c("mupred","beta.0", "beta.orig","sigma","lambda.beta")


X = as.matrix(college[, -(1:2)]) # remove Private factor and Apps = Y
X = cbind(as.numeric(college$Private),X)
colnames(X)[1] = "Private"
# Create a data list with inputs for JagsBugs

nsim=25
rmse.ols=rep(NA,nsim); rmse.GDP=rep(NA,nsim); rmse.lasso=rep(NA,nsim)
for ( i in 1:nsim) {
train = sample(1:n, n.train)
X.train = X[train,]
X.test= X[-train,]
Y.train = sqrt(college$Apps[train])
Y.test = sqrt(college$Apps[-train])
scaled.X.train = scale(X.train)
data = list(Y.train = Y.train, X.train=scaled.X.train, p=ncol(X))
data$n.train = length(data$Y.train); data$n.test = n.test
data$scales = attr(scaled.X.train, "scaled:scale")
data$Xbar = attr(scaled.X.train, "scaled:center")
data$X.test = scale(X.test, center=data$Xbar, scale=data$scales)
data$Y.test = rep(NA, n.test)
# define a function that returns the Model 

bf.sim = jags(data, inits=NULL, parameters, model.file=rr.model.file,  n.iter=10000)

rmse.GDP[i] = rmse(bf.sim$BUGSoutput$mean$mupred, Y.test)

db.lars = lars(X.train,Y.train, type="lasso")
Cp = summary(db.lars)$Cp
best = (1:length(Cp))[Cp == min(Cp)]     # step with smallest Cp
y.pred = predict(db.lars, s=best, newx=X.test)
rmse.lasso[i] =  rmse(Y.test,y.pred$fit)

y.pred = predict(lm(sqrt(Apps) ~ ., data=college, subset=train), newdata=college[-train,]) # old predictions    
rmse.ols[i] = rmse(Y.test, y.pred)

print(c(i, rmse.ols[i], rmse.lasso[i], rmse.GDP[i]))

}

boxplot(rmse.ols, rmse.lasso, rmse.GDP)


rmse = function(truth, est) {  n=length(truth); sqrt(sum((truth - est)^2)/n)}
bf.bugs = as.mcmc(bf.sim$BUGSoutput$sims.matrix)  # create an MCMC object 
plot(bf.sim)
summary(bf.sim)  # names of objects in bf.sim
bf.sim  # print gives summary
par(mfrow=c(1,1))
quantile(bf.bugs[,"beta[1]"], c(.025, .5, .975))
HPDinterval(as.mcmc(bf.bugs[,"beta[1]"]))
HPDinterval(as.mcmc(bf.bugs[,"beta[2]"]))
HPDinterval(as.mcmc(bf.bugs[,"beta[3]"]))
HPDinterval(as.mcmc(bf.bugs[,"beta[4]"]))



hist(bf.bugs[,"beta[1]"], prob=T, xlab=expression(beta[1]),
     main="Posterior Distribution")
lines(density(bf.bugs[,"beta[1]"]))
densplot(bf.bugs[,"beta[1]"])
par(mfrow=c(1,2))
hist(bf.bugs[,"beta[2]"], prob=T, xlab=expression(beta[1]),
     main="Posterior Distribution")
lines(density(bf.bugs[,"beta[2]"]))
densplot(bf.bugs[,"beta[2]"])
hist(bf.bugs[,"beta[3]"], prob=T, xlab=expression(beta[1]),
     main="Posterior Distribution")
lines(density(bf.bugs[,"beta[3]"]))
densplot(bf.bugs[,"beta[3]"])
hist(bf.bugs[,"beta[4]"], prob=T, xlab=expression(beta[1]),
     main="Posterior Distribution")
lines(density(bf.bugs[,"beta[4]"]))
densplot(bf.bugs[,"beta[4]"])


