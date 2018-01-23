africa = read.table("africa.dat", header = T)
africa.glm = glm(MILTCOUP ~ ., family=poisson, data=africa)
africa.glm = glm(MILTCOUP ~ MILITARY + POLLIB + PARTY93+PCTVOTE+PCTTURN+ 
                 SIZE*POP + NUMREGIM*NUMELEC, family=poisson, data=africa)
africa.glm2 = glm(MILTCOUP ~ MILITARY + POLLIB + PARTY93+PCTVOTE+PCTTURN+ 
                 log(SIZE) + log(POP) + NUMREGIM*NUMELEC, family=poisson, data=africa)

summary(africa.glm)
pdf("diagnostics.pdf")
par(mfrow=c(2,2))
plot(africa.glm)
dev.off()

africa.glm1 = glm(MILTCOUP ~ MILITARY  + PARTY93+PCTVOTE+PCTTURN+ 
                 SIZE*POP + NUMREGIM*NUMELEC  + factor(POLLIB), family=poisson, x=T, y=T, data=africa)
anova(africa.glm, africa.glm1)


library(R2WinBUGS)
library(R2jags)

scale.X = scale(africa.glm1$x[, -1])
africa.dat = list(Y=africa.glm1$y, X =  cbind(1,scale.X),
                  n = length(africa.glm1$y), p=ncol(africa.glm1$x),
                  sd = c(1, attr(scale.X, "scaled:scale")),
                  Xbar = attr(scale.X, "scaled:center")
)

africa.model = function() {
  for (i in 1:n) {
    Y[i] ~ dpois(mu[i])
    log(mu[i]) <-  inprod(X[i,], coef[])
  }

  coef[1] ~ dnorm(0.0, 1.0E-6)
  beta[1] <- coef[1]- inprod(beta[2:p], Xbar)
  for (j in 2:p) {
    coef[j] ~ dnorm(0.0, 1.0E-6)
#   coef[j] ~ dnorm(0.0, lambda[j])
#    lambda[j] ~ dgamma(.5, .5)
    beta[j] <- coef[j]/sd[j]
  }
}

model.file = paste(getwd(),"poismodel.txt", sep="/")
write.model(africa.model, model.file)


inits = function() {
  coefs = coef(glm(africa.dat$Y ~ africa.dat$X -1), family=poisson)
  return(list(coef = coefs))
}
#parameters.to.save = c("beta", "lambda")
parameters.to.save = c("beta", "coef")

sim = jags(africa.dat, inits, parameters.to.save=parameters.to.save, model.file=model.file, n.chains=2,n.iter=10000)


plot(sim)

plot(apply(sim$BUGSoutput$sims.matrix[,1:13], 2, mean), coef(africa.glm1))
abline(0,1)

summary(sim$BUGSoutput$sims.matrix[,1:12])
colnames(sim$BUGSoutput$sims.matrix)
HPDinterval(as.mcmc(sim$BUGSoutput$sims.matrix[,2]))
