
eps = .01
J = rpois(1,2/eps)
x = runif(J)
beta = .5*eps/(runif(J, eps, 1)
plot(x,cumsum(beta))
