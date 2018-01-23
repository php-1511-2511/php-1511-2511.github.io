# See Lab in Chapter 8
library(tree)
library(ISLR)
data(Carseats)
High=ifelse (Carseats$Sales <=8,"No","Yes ")
Carseats = data.frame(Carseats, High)
tree.carseats = tree(High ~ Price + Income, data=Carseats)
pdf("simple-tree.pdf")
plot(tree.carseats)
text(tree.carseats)
dev.off()
pdf("simple-part.pdf", height=6,width=11)
partition.tree(tree.carseats, cex=1.5)
points(Income ~ Price, data=Carseats, col=2)
dev.off()

summary(tree.carseats)
tree.carseats =tree(High ~  . -Sales, data=Carseats )
pdf("carseats-tree.pdf", height=8,width=8)
plot(tree.carseats)
text(tree.carseats,pretty=0, cex=.75)
dev.off()

summary(tree.carseats)

set.seed (2)
train=sample (1: nrow(Carseats ), 200)
Carseats.test=Carseats [-train ,]
High.test=High[-train ]
tree.carseats =tree(High ~  . -Sales, data=Carseats,subset=train )
tree.pred=predict (tree.carseats ,Carseats.test ,type ="class")
table(tree.pred ,High.test)

set.seed (2)
cv.carseats =cv.tree(tree.carseats ,FUN=prune.misclass )
names(cv.carseats )
cv.carseats
pdf("carseats-cv.pdf", width=11,height=8)
par(mfrow =c(1,2))
plot(cv.carseats$size ,cv.carseats$dev ,type="b")
plot(cv.carseats$k ,cv.carseats$dev ,type="b")
dev.off()

prune.carseats =prune.misclass (tree.carseats ,best =9)
pdf("carseats-prune.pdf")
plot(prune.carseats )
text(prune.carseats ,pretty =0, cex=.75)
dev.off()


tree.pred=predict(prune.carseats , Carseats.test ,type="class")
table(tree.pred ,High.test)

library(randomForests)
# Bagging
bag.carseats = randomForest(High ~ . - Sales,data=Carseats,subset =train,
                            mtry=10, importance =TRUE)
yhat.bag = predict(bag.carseats ,newdata =Carseats.test)
table(yhat.bag,High.test)

# RandomForests
rf.carseats = randomForest(High ~ . - Sales,data=Carseats,
                           subset =train,
                          mtry=3, importance =TRUE)
yhat.rf= predict(rf.carseats ,newdata =Carseats.test)
table(yhat.rf,High.test)
pdf("RF.pdf", height=8, width=11)
varImpPlot(rf.carseats)
dev.off()

library(gbm)
boost.car =gbm(I(as.numeric(High)-1) ~ .-Sales,data=Carseats[train ,], 
               distribution="bernoulli", n.trees =5000, interaction.depth =4)
yhat.boost = ifelse(predict(boost.car, newdata=Carseats.test,n.trees=5000, type="response")> .5, 1, 0)
table(yhat.boost, High.test)
summary(boost.car)
plot(boost.car)
#BART
library(bartMachine)
bart.carseats = bartMachine(X=Carseats[train,-c(1,12)], y=Carseats$High[train])
yhat.bart = predict(bart.carseats, Carseats.test[, -c(1,12)], type="class")
table(yhat.bart, High.test)
investigate_var_importance(bart.carseats)

library(bark)
tmp.lm = lm(Sales ~ . - High, data=Carseats, x=T)
bark.car = bark(x.train=tmp.lm$x[train,-1],y=as.numeric(Carseats$High[train]) -1, x.test=tmp.lm$x[-train,-1], type="sd", class=T)
# yes 
yhat.bark = ifelse(bark.car$yhat.test.mean > 0, 1, 0 )
 
table(yhat.bark, High.test)
High.test
yhat.bark  No Yes 
0 109   21
1   7   63