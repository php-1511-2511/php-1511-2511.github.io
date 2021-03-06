---
title       : Logistic Regression Model Building
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







# Logistic Model Building

--- .class #id

## Confounding and Effect Modification(Interaction)

- We can also address confounding and effect modification in R. 
- To explore this more we will consider a new data example with a subset of data from the [Physicians Health Study](http://phs.bwh.harvard.edu/). 

--- .class #id

## Physician Health Study Variables



| Name | Description | 
| ----- | ------------- | 
| age  |       Age in years at time of Randomization |
| asa   |      0 - placebo, 1 - aspirin | 
| bmi    |     Body Mass Index (kg/$m^2$) | 
| hypert  |    1 - Hypertensive at baseline, 0 - Not | 
| alcohol  |   0 - less than monthly, 1 - monthly to less than daily, 2 - daily consumption |
| dm      |    0 = No diabetes Mellitus, 1 - diabetes Mellitus |
| sbp      |   Systolic BP (mmHg) | 

--- .class #id


## Physician Health Study Variables

| Name | Description | 
| ----- | ------------- | 
| exer    |    0 - No regular, 1 - Sweat at least once per week | 
| csmoke  |    0 - Not currently, 1 - < 1 pack per day, 2 - $\ge$ 1 pack per day | 
| psmoke  |    0 - never smoked, 1 - former < 1 pack per day, 2 - former $\ge$ 1 pack per day |
| pkyrs   |    Total lifetime packs of cigarettes smoked | 
| crc     |    0 - No colorectal Cancer, 1 - Colorectal cancer | 
| cayrs   |    Years to colorectal cancer, or death, or end of follow-up. | 

--- .class #id



## Loading Data

We can load this data into R.

```r
library(tidyverse)
library(haven)
phscrc <- read_dta("phscrc.dta")
phscrc <- phscrc %>%
            mutate(age.cat = cut(age, c(40,50,60,70, 90), right=FALSE)) %>%
            mutate(alcohol.use = factor(phscrc$alcohol>0, labels=c("no", "yes")))
```


--- .class #id


## The Data



```r
 mytable <- xtabs(~age.cat+alcohol.use+ crc, phscrc)
library(pander)
pandoc.table(mytable)
```


--- .class #id

## The Data



|         |             |     |      |    |
|:-------:|:-----------:|:---:|:----:|:--:|
|         |             | crc |  0   | 1  |
| age.cat | alcohol.use |     |      |    |
| [40,50) |     no      |     | 1762 | 3  |
|         |     yes     |     | 4764 | 36 |
| [50,60) |     no      |     | 1385 | 19 |
|         |     yes     |     | 3969 | 61 |
| [60,70) |     no      |     | 749  | 21 |
|         |     yes     |     | 2167 | 73 |
| [70,90) |     no      |     | 278  | 9  |
|         |     yes     |     | 690  | 32 |


--- .class #id

## Confounding

- The above chart explores the relationship between Alcohol Use, age and Colorectal Cancer. 
- We may be interested in evaluating the exposure of Alcohol use on the outcome of Colorectal Cancer adjusting for age. 
- We could run the following model:
$$CRC = \beta_0 + \beta_1 E + \beta_2 X$$

- Where $E=1$ is the group with people who drink more than monthly and $X$ is age in years.


--- .class #id


## Interpretation of $\beta_1$

- The odds ratio between disease and exposure for a fixed age is
$$\dfrac{\dfrac{p_{1,x}}{1-p_{1,x}}}{\dfrac{p_{0,x}}{1-p_{0,x}}}$$
- Thus the log odds ratio is
$$
\begin{aligned}
&log\left(\dfrac{p_{1,x}}{1-p_{1,x}}\right) - \log\left(\dfrac{p_{0,x}}{1-p_{0,x}}\right)\\
&= (\beta_0 + \beta_1(1)+ \beta_2x) - (\beta_0 + \beta_1(0)+\beta_2x)\\
&= \beta_1\\
\end{aligned}
$$


--- .class #id

## What does this mean?

- This means
    * For any logistic regression model with a main effect of Exposure, $E$, and confounder ,$X$, for any given value of $X=x$, the log odds ratio between disease and exposure is $\beta_1$
    * Including both $X$ and $E$ in the model, controls for the possible confounding of $X$ on the relationship between the disease and exposure.
    * If the variable $X$ were omitted, the estimated relationship between disease and exposure could possibly be biased because of confounding by $X$. 



--- .class #id


## Interpretation of $\beta_2$

- For two subjects who have the same exposure $E$, regardless of which it is, but who differ by 1 year of age, the log(OR) of Colorectal Cancer for a unit change in $X$ is:

$$
\begin{aligned}
log&\left(\dfrac{p_{e,x+1}}{1-p_{e,x+1}}\right) - \log\left(\dfrac{p_{e,x}}{1-p_{e,x}}\right)\\
&= (\beta_0 + \beta_1e+ \beta_2(x+1)) - (\beta_0 + \beta_1e+\beta_2x)\\
&= \beta_2\\
\end{aligned}
$$


--- .class #id

## Effect Modification / Interaction

- Consider the following logistic regression model
$$\log\left(\dfrac{p_{e,x}}{1-p_{e,x}}\right) = \beta_0 + \beta_1e + \beta_2x + \beta_3\cdot e \cdot x$$
- This gives us a similar model to previously with an added effect modification term. 
- This more complex model allows for the odds ratio between outcome and exposure vary across levels of $X$.  


--- .class #id


## What Happens with Effect Modification?

- For Unexposed (Drink Less than Once a Month):
$$
\begin{aligned}
\log\left(\dfrac{p_{0,x}}{1-p_{0,x}}\right) &= \beta_0 + \beta_1\cdot0 + \beta_2x + \beta_3\cdot0\cdot x\\
&= \beta_0 + \beta_2x\\
\end{aligned}
$$
- For Exposed (Drink More than Once a Month):
$$
\begin{aligned}
\log\left(\dfrac{p_{1,x}}{1-p_{1,x}}\right) &= \beta_0 + \beta_1\cdot1 + \beta_2x + \beta_3\cdot1\cdot x\\
&= (\beta_0+\beta_1) + (\beta_2 + \beta_3)x\\
\end{aligned}
$$


--- .class #id


## What does this mean?

- This implies that the log odds ratio measuring the association between outcome and exposure given $X=x$ is
$$
\begin{aligned}
log&\left(\dfrac{p_{1,x}}{1-p_{1,x}}\right) - \log\left(\dfrac{p_{0,x}}{1-p_{0,x}}\right)\\
&= \beta_1 + \beta_3x
\end{aligned}
$$
- Notice how this varies with different ages now. 


--- .class #id


## Interpretation of the Main effects 

- When we have effect modification terms in the model we refer to the $E$ and $X$ as the main effects and $E\cdot X$ as the effect modification term. 
    * Main effects do not have their usual interpretation when they are in a model with an effect modification term. 
    * $\beta_1 = \beta_1 + \beta_3\cdot0$, this represents the log odds ratio of having colorectal cancer comparing this who drink often to those who don't drink often in people whose age is 0. 
    * $\beta_2$ represents the log odds ratio comparing people who differ in age by 1 year but both drink less than once a month. 



--- .class #id


## Centering Covariates

- One way to make the effect modification terms more meaningful is to center continuous covariates:
$$Z= X- \bar{X}$$
- Then we can fit the model:
$$\log\left(\dfrac{p_{e,z}}{1-p_{e,z}}\right) = \beta^*_0 + \beta_1^*e + \beta_2^*z + \beta_3^*\cdot e \cdot z$$


--- .class #id

## New Interpretation

- This means that now 
$$\beta_1^* = \beta_1^* + \beta_3^*\cdot0$$
- is the relative odds of having colorectal cancer comparing men who drink more than once a month to those who drink less at the mean age. 



--- .class #id


## Is Effect Modification Significant? 

- If there is no effect modification between Age and Alcohol Use pressure than we would find that $\beta_3=0$ we can test for this
$$H_0:\beta_3=0 \text{ vs }H_1:\beta_3\ne0$$


--- .class #id


## The models in R

- We can run these models now:

```r
library(tidyverse)
mod1 <- glm(crc ~ alcohol.use+ age, phscrc, family=binomial(link="logit"))
mod2 <- glm(crc ~ alcohol.use*age, phscrc, family=binomial(link="logit"))
phscrc <- phscrc %>%
  mutate(age.cent = age - mean(age,na.rm=TRUE))
mod3 <- glm(crc ~ alcohol.use*age.cent, phscrc, family=binomial(link="logit"))
```


--- .class #id

## Model 1

- If we look at the first model we find that we have:

|term           |   estimate|   p.value|   conf.low|  conf.high|
|:--------------|----------:|---------:|----------:|----------:|
|(Intercept)    | -8.3348992| 0.0000000| -9.1304585| -7.5591081|
|alcohol.useyes |  0.3560274| 0.0236256|  0.0560273|  0.6739932|
|age            |  0.0697425| 0.0000000|  0.0575685|  0.0819576|

- For 2 people the same age a person who drinks more than once a month has a 
42.7646629% increase in odds of colorectal cancer than someone who does not drink. 


--- .class #id

## Model 2

- Then if we consider our model with effect modification

|term               |   estimate|  p.value|    conf.low|  conf.high|
|:------------------|----------:|--------:|-----------:|----------:|
|(Intercept)        | -8.5800802| 0.000000| -10.2022552| -7.0380756|
|alcohol.useyes     |  0.6722965| 0.460657|  -1.0882345|  2.4909110|
|age                |  0.0737894| 0.000000|   0.0482466|  0.0995000|
|alcohol.useyes:age | -0.0052401| 0.723872|  -0.0344218|  0.0238241|

-  For those who drink less than monthly a one year increase in age leads to a 7.6580044% increase in odds of colorectal cancer. 


--- .class #id

## Model 3

- Finally our model with centered age and effect modification

|term                    |   estimate|  p.value|   conf.low|  conf.high|
|:-----------------------|----------:|--------:|----------:|----------:|
|(Intercept)             | -4.6573481| 0.000000| -5.0165614| -4.3396824|
|alcohol.useyes          |  0.3937278| 0.039862|  0.0325311|  0.7864981|
|age.cent                |  0.0737894| 0.000000|  0.0482466|  0.0995000|
|alcohol.useyes:age.cent | -0.0052401| 0.723872| -0.0344218|  0.0238241|

-  This time we can interpret the coefficient of alcohol use. For men at the average age in the study, 53.1611937, a man who drinks more than once a month will have 48.2496903% increase in odds compared to a man who drinks less than once a month. 


--- .class #id

## Nested Models

- We move from the base explanation of multiple logistic regression to discussing some tools for comparing models. The first models which we can compare are nested models. 
- Nested models can best be explained by the list below:

1.  $CRC = \beta_0 + \beta_1 Age$
2.  $CRC = \beta_0 + \beta_1 Alcohol + \beta_2 BMI$
3.  $CRC = \beta_0 + \beta_1 Age + \beta_2 Alcohol + \beta_3 BMI$


--- .class #id


## Nested Models

- With these models we have that Model 1 and 2 are nested in Model 3. 
- However Model 1 is not next in Model 2. 
- With these models the maximized value of the likelihood (and log-likelihood) for the larger model will always be at least as large as that for the smaller model. 



--- .class #id

## Nested Model: Our example

- In our example this means
$$L(3)\ge L(1)$$
$$L(3)\ge L(2)$$
- Where $L$ is the maximized likelihood.



--- .class #id

## Likelihood Ratio Test

- Like the $F$ test in linear regression we can compare nested models with what is called the Likelihood Ratio Test:

$$
\begin{aligned}
LR &= 2\log\left(\dfrac{L(\text{Larger Model})}{L(\text{smaller model})}\right)\\
&= 2\log\left(L(\text{Larger Model}\right)- 2\log\left(L(\text{smaller model})\right)\\
\end{aligned}
$$


--- .class #id

## The Likelihood Ratio Tes

- This test works with groups of coefficients.
- This means that
$$H_0: \text{ Extra Variables in Larger Model}=0$$
$$\text{ vs }$$
$$H_1: \text{ Extra Variables in Larger Model}\ne0$$
- Under, $H_0$ the LR statistic has a $\chi^2$ distribution with $d$ = Number of extra variables in larger model. 


--- .class #id

## Global Null Hypothesis

$$H_0: \beta_1 = \beta_2 = \cdots = \beta_p =0$$

--- .class #id



## Global Null Example

- We can test the global null hypothesis like in linear regression. 
- For example if we consider model 1 from our confounding section


| null.deviance| df.null|    logLik|     AIC|      BIC| deviance| df.residual|
|-------------:|-------:|---------:|-------:|--------:|--------:|-----------:|
|      2609.171|   16017| -1240.335| 2486.67| 2509.715|  2480.67|       16015|

- We can see that R gives us *Null deviance* and *Residual deviance*. Where
    - *Null Deviance* = 2(LL(Saturated Model) - LL(Null Model)) on $df = df_{Sat} - df_{Null}$
    - *Residual Deviance* = 2(LL(Saturated Model) - LL(Proposed Model)) on $df = df_{Sat} - df_{Proposed}$


--- .class #id

## Saturated Model

- The Saturated model means that each data point has its own probability. 
- The null model is a model with just an intercept term or essentially the probability of getting a disease is the same for everyone. 
- The proposed model is the model that we are fitting.


--- .class #id


## Likelihood Ratio Test

- We can then do a likelihood ratio test in R to test whether $\beta_1=\beta_2=0$. 
- We do this by comparing
$$\text{Null Deviance} - \text{Residual Deviance} \sim \chi^2_d$$
- Where $d=p$ or the number of covariates in the model. 


--- .class #id
## Manually in R



```r
LR <- summary(mod1)$null.deviance - summary(mod1)$deviance
df <-   summary(mod1)$df.null - summary(mod1)$df.residual
 1- pchisq(LR,df)
```

```
## [1] 0
```
- We find that this gives us a p-value < 0.0001 so that at least $\beta_1$ or $\beta_2$ is significant. 


--- .class #id


## Categorical Covariates

Many times we have categorical covariates and we need to be able to use them in model building. We can proceed two different ways depending on the data.

If we have covariate $X$ which is categorical than we treat $X$ differently depending on 

1. If the categories of $X$ are **nominal** or unordered (race, gender, eye color, ...)
2. If the categories of $X$ can be ordered. 


--- .class #id



## Nominal Categories. 

With $X$ which has $K\ge2$ categories, we created $K-1$ variables. For example:

* $x_1 = 1$ if $X=1$, $x_1 = 0$ otherwise
* $x_2 = 1$ if $X=2$, $x_2 = 0$ otherwise
* $x_{k-1} = 1$ if $X=2$, $x_{k-1} = 0$ otherwise


--- .class #id

## Nominal Categories

- This means that if a person was in category $K$ then $x_1,x_2,\ldots, x_{k-1}=0$. 
- We would then fit a logistic model:
$$logit(\Pr(Y=1|X)) = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_{k-1} x_{k-1}$$


--- .class #id

## Indicator Variables

- Many times we write this with *Indicator Variables* which is
    * I(Cat=1) is 1 if in category 1 and 0 otherwise
    * I(Cat=2) is 1 if in category 2 and 0 otherwise
    * I(Cat=K-1) is 1 if in category K-1 and 0 otherwise


--- .class #id


## What is the Saturated Model?

- This would be the same model as above. 
- With this model we have a saturated model because our model contains $K$ predictors which is the number of levels of $X$. 
- This would be the same model as for a $2\times K$ table in epidemiology. 


--- .class #id

##  We could then have:

Category | Log Odds | Probability
-------- | -------- | ------------
K | $\beta_0$ |  $p_0 = \dfrac{\exp(\beta_0)}{1+\exp(\beta_0)}$
1 | $\beta_0+\beta_1$ |  $p_0 = \dfrac{\exp(\beta_0+\beta_1)}{1+\exp(\beta_0+\beta_1)}$
2 | $\beta_0+\beta_2$ |  $p_0 = \dfrac{\exp(\beta_0+\beta_2)}{1+\exp(\beta_0+\beta_2)}$
$\vdots$ | $\vdots$ | $\vdots$ 
K-1 | $\beta_0+\beta_{k-1}$ |  $p_0 = \dfrac{\exp(\beta_0+\beta_{k-1})}{1+\exp(\beta_0+\beta_{k-1})}$


--- .class #id


## Ordered Categories

- For ordered categories we can treat them like before or we can treat them as a trend. 
- In order to do so let us consider what a trend looks like. 
- If we have a trend what we are saying is that if you consider the probabilities of disease in the $K$ categories than
$$p_1 \ge p_2 \ge \cdots \ge P_{K} \text{ or } p_1 \le p_2 \le \cdots \le P_{K}$$


--- .class #id

## Trend Variable

- Let us consider the original variable of `Alcohol` and its effect of Colorectal Cancer. 

|term        |   estimate|   p.value|   conf.low|  conf.high|
|:-----------|----------:|---------:|----------:|----------:|
|(Intercept) | -4.4182131| 0.0000000| -4.6563690| -4.1931173|
|alcohol     |  0.2776848| 0.0019606|  0.1023961|  0.4541972|

--- .class #id

## Alcohol Categories

$$
\text{Alcohol} = \begin{cases}
0 & \text{ Less than monthly}\\
1 & \text{ Monthly to less than Daily}\\
2 & \text{ Daily or more}
\end{cases}
$$

--- .class #id

## What Does the Trend mean?

- If we consider the above model what we have is 
$$logit(p_x) = \beta_0 + \beta_1 * Alcohol$$
- We then have
$$
\begin{aligned}
logit(p_0) &= \beta_0 \\
logit(p_1) &= \beta_0 + 1\beta_1 \\
logit(p_2) &= \beta_0 + 2\beta_2 \\
\end{aligned}
$$

--- .class #id

## What does this mean?

This means if 
$$
\begin{aligned}
\beta_1 = 0 \Rightarrow p_0=p_1=p_2\\
\beta_1 > 0 \Rightarrow p_0<p_1<p_2\\
\beta_1 < 0 \Rightarrow p_0>p_1>p_2\\
\end{aligned}
$$


--- .class #id


## What are we testing?

- So a test for $\beta_1=0$ will show us if the natural order of our categories is correct. 
- We can also test whether we should use the Linear Trend vs the Indicator Variable Model.
- To do this  we consider the Likelihood Ratio Test.
- with the following models:
    - $logit(p_x) = \beta_0 + \beta_1 Alcohol$ 
    - $logit(p_x) = \beta_0 + \beta_1 I(Alcohol = 1) + \beta_2 I(Alcohol=2)$ 

--- .class #id


## How do the Models compare?

-We will find that Model 1 is nested within Model 2. 
- How does this work?
    -  $\beta_1=\beta_1$
    - $\beta_2 = 2\beta_1$ in model 2. 


--- .class #id


## Results of Factor Model



|term             |   estimate|   p.value|   conf.low|  conf.high|
|:----------------|----------:|---------:|----------:|----------:|
|(Intercept)      | -4.3853864| 0.0000000| -4.6716150| -4.1235215|
|factor(alcohol)1 |  0.2173767| 0.1928240| -0.1035724|  0.5522374|
|factor(alcohol)2 |  0.5436799| 0.0024019|  0.1961081|  0.8999708|


--- .class #id

## Likelihood Ratio Test


```r
anova_mod <-anova(mod4, mod5, test="Chisq")
kable(tidy(anova_mod))
```



| Resid..Df| Resid..Dev| df|  Deviance|   p.value|
|---------:|----------:|--:|---------:|---------:|
|     16016|    2599.51| NA|        NA|        NA|
|     16015|    2599.33|  1| 0.1807433| 0.6707353|

- I find that with a p-value of 0.6707353. 
- I fail to reject the null hypothesis and find that I can stick with the linear trend rather than the indicator variable model. 

