---
title       : Parametric Survival Analysis 
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




# Non Parametric Statistics

--- .class #id

## What are they?

- Non parametrics means that you do not need to specify a specific distribution for the data. 
- Many of the methods you have learned up to this point require data dealing with the normal distribution. 
- This is due partially to the fact that the t-distribution, $\chi^2$ distribution, and the $F$ distribution can all be derived from the normal distribution. 
- Traditionally you are just taught to use normallity and made to either transform the data or just go ahead knowing it is incorrect. 


--- .class #id

## Normal vs Skewed Data 

- Data that is normally distributed has:
    - the mean and the median the same.
    - The data is centered about the mean.
    - Very specific probability values.
- Data that is skewed has: 
    - Mean less than median for left skewed data.
    - Mean greater than median for right skewed data. 


--- .class #id





## Why is this an issue?

- In 1998 a survey was given to Harvard students who entered in 1973:
  - The mean salary was $750,000
  - The median salary was $175,000
- What could be a problem with this?
- What happened here? 

--- .class #id



## Why do we use Parametric Models?

1. Parametric Models have more power so can more easily detect significant differences. 
2. Given large sample size Parametric models perform well even in non-normal data. 
3. Central limit theorem states that in research that can be perfromed over and over again, that the means are normally distributed. 
4. There are methods to deal with incorrect variances. 

--- .class #id



## Why do we use Non Parametric Models?

1. Your data is better represented by the median. 
2. You have small sample sizes. 
3. You cannot see the ability to replicate this work. 
4. You have ordinal data, ranked data, or outliers that you can’t remove.

--- .class #id



## What Non Parametric Tests will we cover? 

- Sign Test
- Wilcoxon Signed-Rank Test
- Wilcoxon Rank-Sum Test (Mann-Whitney U Test, ...)
- Kruskal Wallis test
- Spearman Rank Correlation Coefficient
- Bootstrapping


--- .segue bg:grey


# The sign Test

--- .class #id

## The Sign Test

- The sign test can be used when comparing 2 samples of observarions when there is not independence of samples. 
- It actually does compares matches together in order to accomplish its task. 
- This is similar to the paired t-test
- No need for the assumption of normality. 
- Uses the Binomial Distribution


--- .class #id

## Steps of the Sign Test

- We first match the data 
- Then we subtract the 2nd value from the 1st value. 
- You then look at the sign of each subtraction. 
- If there is no difference between the two groups you shoul have roughly 50% positives and 50% negatives. 
- Compare the proportion of positives you have to a binomial with p=0.5. 

--- .class #id


## Example: Binomial Test Function

- Consider the scenario where you have patients with Cystic Fibrosis and health individuals. 
- Each subject with CF has been matched to a healthy individual on age, sex, height and weight. 
- We will compare the Resting Energy Expenditure (kcal/day)

--- .class #id


## Reading in the Data


```r
library(readr)
ree <- read_csv("ree.csv")
ree
```

```
## # A tibble: 13 x 2
##       CF Healthy
##    <dbl>   <dbl>
##  1  1153     996
##  2  1132    1080
##  3  1165    1182
##  4  1460    1452
##  5  1634    1162
##  6  1493    1619
##  7  1358    1140
##  8  1453    1123
##  9  1185    1113
## 10  1824    1463
## 11  1793    1632
## 12  1930    1614
## 13  2075    1836
```


--- .class #id



## Function in R

- Comes from the `BDSA` Package

```
SIGN.test(x ,y, md=0, alternative = "two.sidesd",
conf.level=0.95)
```

- Where 
  - `x` is a vector of values
  - `y` is an optional vector of values.
  - `md` is median and defaults to 0. 
  - `alternative` is way to specific type of test.
  - `conf.level` specifies $1-\alpha$.

--- .class #id

## Getting Package


```r
# install.packages("devtools")
# devtools::install_github('alanarnholt/BSDA')
```

--- .class #id


## Our Data


```r
library(BSDA)
attach(ree)
SIGN.test(CF, Healthy)
detach()
```

--- .class #id


## Our Data


```
## 
## 	Dependent-samples Sign-Test
## 
## data:  CF and Healthy
## S = 10, p-value = 0.02
## alternative hypothesis: true median difference is not equal to 0
## 95 percent confidence interval:
##   25.4 324.5
## sample estimates:
## median of x-y 
##           161 
## 
## Achieved and Interpolated Confidence Intervals: 
## 
##                   Conf.Level L.E.pt U.E.pt
## Lower Achieved CI      0.908   52.0    316
## Interpolated CI        0.950   25.4    324
## Upper Achieved CI      0.978    8.0    330
```

--- .class #id

## By "Hand"

- Subtract Values


```r
library(tidyverse)
ree <- ree %>%
mutate(diff = CF - Healthy)
ree
```

--- .class #id


## By "Hand"


- count negatives


```
## # A tibble: 13 x 3
##       CF Healthy  diff
##    <dbl>   <dbl> <dbl>
##  1  1153     996   157
##  2  1132    1080    52
##  3  1165    1182   -17
##  4  1460    1452     8
##  5  1634    1162   472
##  6  1493    1619  -126
##  7  1358    1140   218
##  8  1453    1123   330
##  9  1185    1113    72
## 10  1824    1463   361
## 11  1793    1632   161
## 12  1930    1614   316
## 13  2075    1836   239
```

--- .class #id

## By "Hand"


```r
binom.test(2,13)
```

```
## 
## 	Exact binomial test
## 
## data:  2 and 13
## number of successes = 2, number of trials = 10, p-value = 0.02
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.0192 0.4545
## sample estimates:
## probability of success 
##                  0.154
```

--- .segue bg:grey

# Wilcoxon Signed-Rank Test

--- .class #id

## Wilcoxon Signed-Rank Test

- The sign test works well but it truly ignores the magntiude of the differences. 
- Sign test often not used due to this problem. 
- Wilcoxon Signed Rank takes into account both the sign and the rank


--- .class #id

## How does it work? 

- Pairs the data based on study design. 
- Subtracts data just like the sign test.
- Ranks the magnitude of the difference:

```
8
-17
52
-76
```

--- .class #id


## What happens with these ranks?

| Subtraction | Positive Ranks | Negative Ranks |
| ----------- | -------------- | -------------- | 
| 8  | 1 |  | 
| -17 |  | -2 | 
| 52 | 3 |  | 
| -76 |  | -4 | 
**Sum** | **4** | **-6** |


--- .class #id


## What about after the sum?

- $W_{+}= 1 + 3 = 4$
- $W_{-} + -2 + -4 = -6$
- Mean: $\dfrac{n(n+1)}{4}$
- Variance: $\dfrac{n(n+1)(2n+1)}{24}$

--- .class #id

## What about after the sum?

- Any ties, $t$: decrease variance by $t^3-\dfrac{t}{48}$
- z test:

$$ z =\dfrac{W_{smaller}- \dfrac{n(n+1)}{4}}{\sqrt{\dfrac{n(n+1)(2n+1)}{24}-t^3-\dfrac{t}{48}}}$$

--- .class #id


## Wilcoxon Signed Rank in R


```r
attach(ree)
wilcox.test(CF, Healthy, paired=T)
detach(ree)
```

```
## 
## 	Wilcoxon signed rank test
## 
## data:  CF and Healthy
## V = 80, p-value = 0.005
## alternative hypothesis: true location shift is not equal to 0
```



--- .segue bg:grey

# Wilcoxon Rank-Sum Test

--- .class #id

## Wilcoxon Rank-Sum Test

- This test is used on indepdent data. 
- It is the non-parametric version of the 2-sample $t$-test.
- Does not requre normality or equal variance. 

--- .class #id


## How do we do it?

- Order each sample from least to greatest
- Rank them. 
- Sum the ranks of each sample

--- .class #id


## What do we do with summed ranks?

- $W_s$ smaller of 2 sums.
- Mean: $\dfrac{n_s(n_s+n_L + 1)}{2}$
- Variance: $\dfrac{n_sn_L(n_s+n_L+1)}{12}$
- z-test

$$ z = \dfrac{W_s-\dfrac{n_s(n_s+n_L + 1)}{2}}{\sqrt{\dfrac{n_sn_L(n_s+n_L+1)}{12}}}$$


--- .class #id



## Wilcoxon Rank-Sum in R

- Consider built in data `mtcars`


```r
library(tidyverse)
cars <- as_data_frame(mtcars)
cars
```

```
## # A tibble: 32 x 11
##      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
##    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
##  2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
##  3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
##  4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
##  5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
##  6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
##  7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
##  8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
##  9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
## 10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
## # ... with 22 more rows
```

--- .class #id


## Wilcoxon Rank-Sum in R

- We will Consider `mpg` and `am`
- `mpg`: Miles Per Gallon on Average
- `am`
    - 0: automatic transmission
    - 1: manual transmission


--- .class #id


## Wilcoxon Rank-Sum in R


```r
attach(cars)
wilcox.test(mpg, am)
detach(cars)
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  mpg and am
## W = 1000, p-value = 3e-12
## alternative hypothesis: true location shift is not equal to 0
```


--- .segue bg:grey


# Kruskal Wallis Test

--- .class #id

## Kruskal Wallis Test

- If we have multiple groups of independent data that are not normally distributed or have variance issues, you can use the Kruskal Wallis Test.
- It tests significant differences in medians of the groups. 
- This is a non-parametric method for One-Way ANOVA.
- Harder to try and calculate by hand, so we will just use R.

--- .class #id

## Kruskal Wallis Test in R

```
kruskal.test(formula, data, subset, ...)
```

- Where
    - `formula` is `y~x` or can enter `outcome,group` instead.
    - `data` is the dataframe of interest.
    - `subset` if you wish to test subset of data. 

--- .class #id


## Arthritis Data

- comes from the `BSDA` package. 
- `Arthriti`

| Variable | Description | 
| -------- | ----------- | 
| `time` | Time in Days until patient felt relief | 
| `treatment` | Factor with three levels `A`, `B`, and `C` |


--- .class #id

## Arthritis Data


```r
library(BSDA)
Arthriti
```

```
## # A tibble: 51 x 2
##     time treatment
##    <int> <fct>    
##  1    40 A        
##  2    35 A        
##  3    47 A        
##  4    52 A        
##  5    31 A        
##  6    61 A        
##  7    92 A        
##  8    46 A        
##  9    50 A        
## 10    49 A        
## # ... with 41 more rows
```

--- .class #id



## Kruskal-Wallis Test in R


```r
kruskal.test(time~treatment, data=Arthriti)
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  time by treatment
## Kruskal-Wallis chi-squared = 2, df = 2, p-value = 0.4
```




--- .segue bg:grey



#  Spearman Rank Correlation Coefficient

--- .class #id


##  Spearman Rank Correlation Coefficient


- Correlation is a measurement of the strength of a linear relationship between variables. 
- This means it does not necessarily get the actual magnitude of relationship. 
- Spearman Rank Correlation seeks to fix this. 
- It works with Montonic Data.

--- .class #id

## Monotonic Data

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png)

--- .class #id


## Spearman Rank Correlation in R

- We can do this the the `cor()` function. 


```r
#Pearson from Monotonic Decreasing
cor(x2,y2, method="pearson")

#Spearman from Monotonic Decreasing
cor(x2,y2, method="spearman")
```

```
## [1] -0.888
## [1] -0.996
```

