library(R2WinBUGS)
library(R2jags)
seeds = read.table("~/Documents/sta290/datasets/seeds.txt", header=T)
#seeds = read.table("http://stat.duke.edu/courses/Fall08/sta290/datasets/seeds.txt", header=T)
summary(seeds)
par(mfrow=c(1,1))
plot(seeds)
seeds.glm0 = glm(SURV ~ 1, data=seeds, family=binomial)
seeds.glm1 = glm(SURV ~  CAGE + LIGHT, data=seeds, family=binomial)
seeds.glm2 = glm(SURV ~  CAGE + log(LIGHT), data=seeds, family=binomial)
par(mfrow=c(2,2))
plot(seeds.glm1, ask=F)
summary(seeds.glm1)
anova(seeds.glm1, test="Chi")
seeds.glm3 = glm(SURV ~  SPECIES + CAGE + log(LIGHT) + factor(LITTER), data=seeds, family=binomial)
summary(seeds.glm3)
anova(seeds.glm3, test="Chi")
seeds.glm4 = glm(SURV ~  SPECIES*CAGE*log(LIGHT)*factor(LITTER), data=seeds, family=binomial)
seeds.glm4 = glm(SURV ~  SPECIES*CAGE*log(LIGHT)*factor(LITTER), data=seeds, family=binomial)

anova(seeds.glm4, test="Chi")
# reduce to binomial from bernoulli

attach(seeds)
seeds.bin = aggregate(seeds[,c("SURV", "GERM","ESTAB")], by=list(PLOT, SUBPLT, SPECIES, LIGHT, LITTER, CAGE, GAP), FUN=sum)
names(seeds.bin)[1:7] = names(seeds)[c(1:3,8:11)]

detach(seeds)
attach(seeds.bin)
seeds.bin$COTY = "H"
seeds.bin$COTY[SPECIES == "Gouania" | SPECIES == "Maclura" | SPECIES == "Strychnos"] = "E"
seeds.bin$COTY = factor(seeds.bin$COTY)
data = list(Y = SURV, N=nrow(seeds.bin), S = 8, C = 2, L = 4, reps=6,
#  Gap = GAP+1,
  Species = as.numeric(SPECIES), meanlight=mean(log(LIGHT)), Cage = CAGE+1,
  Litter = as.numeric(factor(LITTER)), light=log(LIGHT),
  Leaves=c(1,1,2,1,1,2,1,2))


seedsmodel <- function(){
    for (n in 1:N) {
        logit(pi[n]) <- alpha[Species[n], Cage[n], Litter[n]] + 
            beta[Species[n], Cage[n], Litter[n]]*(light[n] - meanlight)
        Y[n] ~ dbin(pi[n], reps)
#        light[n] ~ dnorm(mu.light[Gap[n]], prec.light[Gap[n]])
      }
#    prec.light[1] ~ dgamma(.001, .001)
#    prec.light[2] ~ dgamma(.001, .001)
#    mu.light[1] ~ dnorm(0, .00001)
#    mu.light[2] ~ denorm(0,.00001)
    for (c in 1:C) {
        for (l in 1:L) {
            for (s in 1:S) {
                alpha[s, c, l] ~ dnorm(alpha.mu[Leaves[s],c,l], alpha.phi)
                beta[s, c, l] ~ dnorm(beta.mu[Leaves[s],c,l],   beta.phi)
            }
            for (leaves in 1:2) {
                alpha.mu[leaves, c, l] <- alpha.pop +
                                          alpha.coty*(leaves-1) +
                                          alpha.cage*(c - 1) +
                                          alpha.litter*l
                beta.mu[leaves, c, l] ~ dnorm(0.00000E+00, 1)
            }
        }
    }
    alpha.pop ~ dnorm(0, 1)
    alpha.coty ~ dnorm(0., 1)
    alpha.cage ~ dnorm(0.0, 1)
    alpha.litter ~ dnorm(0.0, 1)
    alpha.sigma ~ dunif(0.0, 10)
    alpha.phi <- 1/(alpha.sigma * alpha.sigma)
    beta.phi <- pow(beta.sigma, -2)
    beta.sigma ~ dunif(0.0, 10)
  }


# write the model code out to a file
model.file = paste(getwd(),"seedsmodel.txt", sep="/")
write.model(seedsmodel, model.file)


inits = function() {
list(#beta=matrix(rnorm(2*8,0, 1),2,8),
     #alpha=matrix(rnorm(2*8,0, 1),2,8),
     alpha.sigma=.1,
     beta.sigma=.1
#     alpha.mu= 0,
#     beta.mu = 0)
     )
}
parameters.to.save = c("alpha", "beta", "alpha.sigma", "beta.sigma","alpha.mu", "beta.mu", "alpha.coty", "alpha.pop", "alpha.cage", "alpha.litter") 

# needed to run under WINE on MAC OSX/Linux

sim = jags(data, inits=inits, parameters.to.save, model.file=model.file, n.chains=2, n.iter=5000)

