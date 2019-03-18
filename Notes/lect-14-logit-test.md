---
title       : Logistic Regression Model Fit
author      : Adam J Sullivan 
job         : Assistant Professor of Biostatistics
work        : Brown University
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js # {highlight.js, prettify, highlight}
hitheme     :  github     # 
widgets     : [mathjax, quiz, bootstrap, interactive] # {mathjax, quiz, bootstrap}
ext_widgets : {rCharts: [libraries/nvd3, libraries/leaflet, libraries/dygraphs]}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
logo        : publichealthlogo.png
biglogo     : publichealthlogo.png
assets      : {assets: ../../assets}
---  .segue bg:grey






# Logistic Regression: Testing Model Fit


--- .class #id

## Logistic Regression

- We will begin model building with an example. 
- We will look at a set of data which considers a self-assessed health exam. 
- There is a natural ordering in the health rating so we would assume that the probability of death to change with the categories. 
- Our data contains 1600 subjects and they are measured on 

--- .class #id


## Variables


| Variable  |     Description | 
| ---------- |   ---------------------------------------- | 
| id          Identification Number | 
| age         Age (years) | 
| male        Sex  | 
|    |         1 = Male | 
|   |             0 = Female | 
| sah  |        Self Assessed Health | 
|        |      1 = Excellent | 
|         |     2 = Good | 
|         |     3 = Fair | 
|         |     4= Poor | 



--- .class #id


## Variables

| Variable  |     Description | 
| ---------- |   ---------------------------------------- | 
| pperf   |    Physical Performance Scale (0-12) |
| pefr    |    Peak Expiratory Flow Rate (average of 3) |
| cogerr  |    Number of cognitive errors on SPMSQ |
| sbp     |    Systolic Blood Pressure (mmHg)  |
| mile    |    Ability to Walk 1 mile |
|         |    0 = No |
|         |  1 = Yes |
| digit   |    Use of digitalis |
|         |    0 = No |
|         |    1 = Yes |



--- .class #id


## Variables


| Variable  |     Description | 
| ---------- |   ---------------------------------------- | 
| loop  |      Use of Loop Diuretics |
|       |     0 = No |
|       |     1 = Yes |
| untrt |      Diagnosed but untreated diabetes |
|       |    0 = No |
|       |      1 = Yes  |



--- .class #id


## Variables


| Variable  |     Description | 
| ---------- |   ---------------------------------------- |
| trtdb  |     Treated Diabetes |
|       |      0 = No | 
|       |      1 = Yes |
| dead  |      Dead by 1991 | 
|       |      0 = No  |
|       |      1 = Yes  |
| time  |      Follow up (years)  |


--- .class #id

## Special Considerations

- For Self-Assessed Health Study we need to consider how we model certain variables
    * Age: this is critical since subjects were asked to compare their health to others
    * Count variables: `pperf` and `cogerr`
    * Measured Variables: `sbp` and `pefr`
    * Diabetes is in 2 variables `untrt` and `trtdb`
    * other binary variables: `male`, `mile`, `loop`, `digit` and `death`

--- .class #id

## Read in the Data


```r
library(haven)
sah <- read_dta("sah.dta") 
```



```
## Start:  AIC=1162
## dead ~ sah2 + age + male + pperf + perf + cogerr + sbp + mile + 
##     digit + loop + untrt + trtdp
## 
##          Df Deviance  AIC
## - age     1     1137 1161
## - digit   1     1137 1161
## - sbp     1     1138 1162
## <none>          1136 1162
## - sah2    1     1139 1163
## - pperf   1     1139 1163
## - perf    1     1140 1164
## - untrt   1     1141 1165
## - mile    1     1144 1168
## - cogerr  1     1145 1169
## - trtdp   1     1146 1170
## - loop    1     1149 1173
## - male    1     1177 1201
## 
## Step:  AIC=1161
## dead ~ sah2 + male + pperf + perf + cogerr + sbp + mile + digit + 
##     loop + untrt + trtdp
## 
##          Df Deviance  AIC
## - digit   1     1138 1160
## <none>          1137 1161
## - sbp     1     1139 1161
## - sah2    1     1140 1162
## - pperf   1     1142 1164
## - untrt   1     1142 1164
## - perf    1     1142 1164
## - mile    1     1145 1167
## - trtdp   1     1147 1169
## - cogerr  1     1148 1170
## - loop    1     1150 1172
## - male    1     1179 1201
## 
## Step:  AIC=1160
## dead ~ sah2 + male + pperf + perf + cogerr + sbp + mile + loop + 
##     untrt + trtdp
## 
##          Df Deviance  AIC
## <none>          1138 1160
## - sbp     1     1140 1160
## - sah2    1     1142 1162
## - untrt   1     1143 1163
## - pperf   1     1143 1163
## - perf    1     1144 1164
## - mile    1     1147 1167
## - cogerr  1     1149 1169
## - trtdp   1     1149 1169
## - loop    1     1155 1175
## - male    1     1181 1201
## 
## Call:
## glm(formula = dead ~ sah2 + male + pperf + perf + cogerr + sbp + 
##     mile + loop + untrt + trtdp, family = binomial(link = "logit"), 
##     data = sah)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -1.632  -0.557  -0.401  -0.281   2.559  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -2.831126   0.681306   -4.16  3.2e-05 ***
## sah2         0.197495   0.107006    1.85  0.06494 .  
## male         1.145512   0.175180    6.54  6.2e-11 ***
## pperf       -0.064669   0.028456   -2.27  0.02305 *  
## perf        -0.001945   0.000807   -2.41  0.01592 *  
## cogerr       0.148237   0.044780    3.31  0.00093 ***
## sbp          0.005590   0.003897    1.43  0.15144    
## mile        -0.569343   0.192364   -2.96  0.00308 ** 
## loop         0.884837   0.209041    4.23  2.3e-05 ***
## untrt        0.527456   0.225157    2.34  0.01915 *  
## trtdp        0.750717   0.219219    3.42  0.00062 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1306.7  on 1599  degrees of freedom
## Residual deviance: 1138.2  on 1589  degrees of freedom
## AIC: 1160
## 
## Number of Fisher Scoring iterations: 5
```

--- .class #id

## Self-Assessed Health

- With our data we are mainly interested in how well self-assessed health predicts death.
- There are 11 other variables that are possible confounders for this relationship. This means that if we consider all of this we have the possibility of 12 main effects and 11 possible 2 way interactions with self assessed health. 
- This could be a very large model and we are only thinking of 2-way interactions here. 


--- .class #id


## Assessing Model Fit

- Once we begin building models we need to know how to assess model fit.  
- We have previously covered the likelihood ratio test where we can compare one model versus another. 
- Now we move to assessing the fit of one model.
- What affects model fit?
    * Omitted covariates (Main effects, interactions, polynomial terms)
    * Poor choice of link function
    * Unusual subjects 


--- .class #id


## Assessing Model Fit


- We usually determine the goodness of fit for logistic regression based on 

1. ***Calibration:*** A model is well *calibrated* if the observed and predicted probabilities based on the model are reasonably close. 

2. ***Discrimination:***  A model has good *discrimination* if the distribution of risk scores for cases and controls separate out. 
    - This means Cases tend to have higher scores. 
    - This means Controls tend to have lower scores.
    - There is little overlap.

--- .class #id


## Calibration

- We will use the Hosmer-Lemeshow Goodness of Fit test to assess calibration in logistic regression models:
- With this test we have:

$$\hat{p}_i = \dfrac{\exp\left( \hat{\beta}_0 + \hat{\beta}_1 x_{i1} + \hat{\beta}_2 x_{i2} + \cdots + \hat{\beta}_K x_{iK} \right)}{1 + \exp\left( \hat{\beta}_0 + \hat{\beta}_1 x_{i1} + \hat{\beta}_2 x_{i2} + \cdots + \hat{\beta}_K x_{iK} \right)}$$
- where $i=1,\ldots,n$ and $K$ is the number of covariates in the model. 


--- .class #id


## How Do We Perform it?

- We then reorder the subjects in the order of the fitted probabilities so that
$$\hat{p}_1<\hat{p}_2< \cdots < \hat{p}_n$$
- We then group this data in `G` approximately equal sized groups based on the ordered $\hat{p}$. 
- The default is typically `G=10` to create deciles of increasing risk. 


--- .class #id


##  With G Groups we have:

$$
\begin{aligned}
O_j &= \sum_{i\in group_j} y_i = \text{ Observed number of events in group }j\\
E_j &= \sum_{i\in group_j} \hat{p}_i = \text{ Expected number of events in group }j\\
\bar{p}_j &= \dfrac{E_j}{n_j} \;\;\;\; n_j=\text{ number of subjects in group} j=1,\ldots,G\\
\end{aligned}
$$
- We then compute the test statistic:
$$ X^2_{HL} = \sum_{j=1}^G \dfrac{\left(O_j - E_J\right)^2}{n_j\bar{p}_j\left(1-\bar{p}_j\right)}\sim \chi^2_{G-2}$$


--- .class #id


##  Our Test Statistic

- This test statistic is for the following hypothesis
$$H_0: \text{ The fitted Model is Correct}$$
$$\text{vs}$$
$$H_1: \text{ The fitted Model is Not Correct}$$
- In order for this to work well $G\ge6$ and $n_j$ should be large.


--- .class #id

## Testing in R



|term   | estimate| p.value| conf.low| conf.high|
|:------|--------:|-------:|--------:|---------:|
|sah2   |    1.218|   0.065|    0.988|     1.504|
|male   |    3.144|   0.000|    2.233|     4.442|
|pperf  |    0.937|   0.023|    0.886|     0.991|
|perf   |    0.998|   0.016|    0.996|     1.000|
|cogerr |    1.160|   0.001|    1.062|     1.266|
|sbp    |    1.006|   0.151|    0.998|     1.013|
|mile   |    0.566|   0.003|    0.388|     0.826|
|loop   |    2.423|   0.000|    1.600|     3.635|
|untrt  |    1.695|   0.019|    1.079|     2.612|
|trtdp  |    2.119|   0.001|    1.367|     3.234|


--- .class #id


##  Testing in R

We can test the calibration of this below:


```r
library(ResourceSelection)
hoslem.test(sah$dead, fitted(mod.back.auto), g=10)
```


--- .class #id


## What about the warning?

- We get a warning message about factors. 
- When this happens we need to check out data:

```r
class(sah$dead)
table(sah$dead)
```

```
## [1] "haven_labelled"
## 
##    0    1 
## 1373  227
```

--- .class #id


## Fixing Factors

We can see that `dead` is a factor without the 0 and 1 that we wanted to have for it. Basically this Stata dataset had labels and those labels are what R imported. 



```r
sah$dead <- as.numeric(sah$dead)
table(sah$dead)
```

```
## 
##    0    1 
## 1373  227
```


--- .class #id

## Our Test Again



```r
library(ResourceSelection)
hoslem.test(sah$dead, fitted(mod.back.auto), g=10)
```

```
## 
## 	Hosmer and Lemeshow goodness of fit (GOF) test
## 
## data:  sah$dead, fitted(mod.back.auto)
## X-squared = 10, df = 8, p-value = 0.2
```

--- .class #id


## The test Results

- This time we get get a p-value of 0.243. 
- This means our model is a good fit and it is calibrated well.
-  We could try other values of $G$ to make sure:


```
## 
## 	Hosmer and Lemeshow goodness of fit (GOF) test
## 
## data:  sah$dead, fitted(mod.back.auto)
## X-squared = 3, df = 4, p-value = 0.5
```

--- .class #id


## The test Results



```r
library(ResourceSelection)
hoslem.test(sah$dead, fitted(mod.back.auto), g=6)
```



--- .class #id


## The test Results



```r
library(ResourceSelection)
hoslem.test(sah$dead, fitted(mod.back.auto), g=8)
```

```
## 
## 	Hosmer and Lemeshow goodness of fit (GOF) test
## 
## data:  sah$dead, fitted(mod.back.auto)
## X-squared = 5, df = 6, p-value = 0.6
```

--- .class #id


## The test Results


```r
library(ResourceSelection)
hoslem.test(sah$dead, fitted(mod.back.auto), g=12)
```

```
## 
## 	Hosmer and Lemeshow goodness of fit (GOF) test
## 
## data:  sah$dead, fitted(mod.back.auto)
## X-squared = 10, df = 10, p-value = 0.3
```

--- .class #id


## The test Results

In each case our p-values are still showing this is a good fit. 


--- .class #id


## Discrimination

- We then assess discrimination. To do this we use something called ***Concordance*** or ***C Statistic***
- To understand what this is consider 2 different subjects
    1. Subject 1 is dead
    2. Subject 2 is not dead.


--- .class #id

## Discrimination


If we consider our model from above it predicts:

1. $\hat{p}_1$ the probability that subject 1 is dead.
2. $\hat{p}_2$ the probability that subject 2 is dead.


--- .class #id

## The C-Statistic

- The ***C Statistic*** is given by
$$\Pr\left(\hat{p}_1 > \hat{p}_2\right)$$
    * If the risk prediction is worthless we find that $C=0.5$ or essentially the same as flipping a coin. 
    * If the risk is larger for all who are dead than all who are not dead than we have $C=1$. 

--- .class #id

## ROC Curves

- We typically find this value with a Receiver Operating Characteristic (ROC) curve. 
- This curve is:
    * For probability $p$ those with $\hat{p}>p$ are predicted to have the outcome 
    *  those with \(\hat{p} < p\) are predicted to not have the outcome. 
    


--- .class #id

## Sensitivity and Specificity

* ***Sensitivity*** 
    * True Positive
    * $\dfrac{ \text{Num. with Outcome and }\hat{p}>p}{\text{num. with Disease}}$
    * $\Pr(\hat{p}>p|\text{Has Disease})$

* ***Specificity***
    * True Negative
    * $\dfrac{ \text{Num. without Outcome and }1-\hat{p}>p}{\text{num. without disease}}$
    * \(\Pr(\hat{p} < p|\text{No Disease})\)

--- .class #id    
    
## ROC Curves

* $p$ is arbitrary. 
* If we increase $p$ we increase the Specificity but decrease the Sensitivity. 
* An ROC curve has the Sensitivity on the y-axis and 1-Specificity on the x-axis. 
* It graphs those points over all choices of $p$.


--- .class #id
 

## ROC Curves

* If the prediction rule is non-discriminatory then the ROC curve will be a straight line from the points (0,0) to (1,1)
* From the ROC curve, it can be shown that the Area under this Curve (AUC) is the same as the C-statistic or
$$AUC=C = \Pr\left(\text{Subject with Disease's Risk} > \text{Subject without Disease's Risk}\right)$$


--- .class #id


## R Code for ROC


```r
library(ggplot2)
library(ROCR)


prob <- predict(mod.back.auto)
pred <- prediction(prob, sah$dead)
perf <- performance(pred, "tpr", "fpr")
# I know, the following code is bizarre. Just go with it.
auc <- performance(pred, measure = "auc")
auc <- auc@y.values[[1]]

roc.data <- data.frame(fpr=unlist(perf@x.values),
                       tpr=unlist(perf@y.values),
                       model="GLM")
ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr)) +
    geom_ribbon(alpha=0.2) + geom_abline(intercept = 0, slope = 1, colour = "gray")+
    geom_line(aes(y=tpr)) +
    ggtitle(paste0("ROC Curve w/ AUC=", auc))
```


--- .class #id

## ROC Curve

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png)

--- .class #id

## Interpretation


- We can see with the plot above that we have an AUC of 0.756. This is a decent fit for the model.


| AUC | Model Fit | 
| ---- | -------- | 
| 0.5 | Random |
| 0.6 | Mediocre | 
| 0.7 | Decent | 
| 0.8 | Good | 
| 0.9 | Excellent | 

--- .class #id


## Calibration vs Discrimination

1. A logistic model with good agreement between observed and predicted outcomes may fail to sharply distinguish between those with a disease and those without. 
    * If the range of predicted risk across the deciles is narrow. 
2. A model that does a good job of distinguishing between those with and without the disease may get risks of events wrong if the calibration is poor. 


