---
title       : Visualization with `ggplot2`
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










# `ggplot2`


--- .segue .quote bg:#C0C8CE


<q>  Appropriate graphical analysis may make the conclusions so clearcut that detailed specific analysis is unnecessary </q>

<q>-- David Cox (1978)</q>


--- .class #id

## `ggplot2`


- We will begin our journey into statistical graphics with the package `ggplot2`. 
- This is a package by Hadley Wickham and is part of the tidyverse. 
- It is a very comprehensive and easily adaptable language of graphics. 

--- .class #id

## What can't `ggplot2` do?


- A good place to start might be with what  `ggplot2` cannot do:
  - 3d graphs.
  - Interactive graphs, use `ggvis`
  - DAGs, see `igraph`
- We will now focus on all the things it can do.


--- .class #id


## `ggplot2` components


- `ggplot2` is built off the grammar of graphics with a very intuitive structure. 
- The base graphics built into R require the use of many different functions and each of them seem to have their own method for how to use them.   
- `ggplot2` will be more fluid and the more you learn about it the more amazing of graphics you can create. 

--- .class #id


## `ggplot2` components


- We will get started with the components of every `ggplot2` object:
  1. **data**
  2. **aesthetic mappings** between variables in the data and visual properties.
  3. At least one layer which describes how to render the data. 
    - Many of these are with the `geom_foo()` function. 


--- .class #id


## Our Data

- We will be working with data from [fivethirtyeight](https://fivethirtyeight.com/)
- We can access this by installing the package in R:
  

```r
install.packages("fivethiryeight")
library(fivethirtyeight)
```

--- .class #id

## Our Data

- We will work with data from the article: [Comic Books Are Still Made By Men, For Men And About Men](https://fivethirtyeight.com/features/women-in-comic-books/)
- We can access this data by calling the following:
  

```r
comic_characters
```


--- .class #id

## Comic Characters Data


```
## Error in eval(expr, envir, enclos): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Comic Characters Data

- We can see the names of the variables by using the `names()` function:


```r
names(comic_characters)
```

```
## Error in eval(expr, envir, enclos): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```



--- .class #id

## `ggplot()` Basics

- We will begin with a basic graph of appearances by alignment


```r
library(ggplot2)
ggplot(data=comic_characters, aes(x=align, y=appearances))
```


--- .class #id

## `ggplot()` Basics


```
## Error in ggplot(data = comic_characters, aes(x = align, y = appearances)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```

--- .class #id

## `ggplot()` Statement

- We can see that all we have is the basic layout of axis. 
- The data and aes gives us the basic layout. 
- We need `geom_foo()` to make a proper graph. 


--- .class #id

## `geom_point()` Statement

- We can add`geom_point()` to this:


```r
ggplot(data=comic_characters, aes(x=align, y=appearances)) + 
  geom_point()
```





--- .class #id

## `geom_point()` Statement




```
## Error in ggplot(data = comic_characters, aes(x = align, y = appearances)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Other graphs

- This graph is not the best use for out data. 
- We could try boxplots instead:
  


```r
ggplot(data=comic_characters, aes(x=align, y=appearances)) + 
  geom_boxplot()
```



--- .class #id

## Other graphs


  


```
## Error in ggplot(data = comic_characters, aes(x = align, y = appearances)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```

--- .class #id 


## Quick Transformation

- We may be having a hard time seeing this due to the outliers in the data. 
- We can try a log transform. 
- The code below will do this
- By the end of today you will understand this code


```r
comic_characters <- comic_characters %>%
  mutate(log_app = log(appearances))
```

```
## Error in eval(lhs, parent, parent): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```




--- .class #id 


## Boxplots Again





```
## Error in ggplot(data = comic_characters, aes(x = align, y = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Bar Graphs

- We could then consider simple bar graphs
- For example if we wanted to know how many characters of each type there were:
  

```r
ggplot(data=comic_characters, aes(x=align)) + 
  geom_bar()
```
- Note: With bar graphs we only need the x-axis. 

--- .class #id

## Bar Graphs


  

```
## Error in ggplot(data = comic_characters, aes(x = align)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```



--- .class #id

## Basic Template

```
ggplot(data= <DATA>, aes(x=<X-VARIABLE>, y=<Y-VARIABLE>)) + 
    <GEOM_FUNCTION>()
```

---  .segue bg:grey


# Aesthetics


--- .class #id

## Aesthetics

- The basic aesthetics are mapping the data to the x and y axis. 
- We can also add:
  - `alpha`: makes points transparent to see overlaps better
  - `fill`: Fills objects with color 
  - `color`: Changes color of points or lines.
  - `shape`: Changes spape of points



--- .class #id


## Aesthetics:  `alpha`


```r
ggplot(data=comic_characters, aes(x=align, y=log_app)) + 
  geom_point(aes(alpha=1/100))
```

--- .class #id

## Aesthetics:  `alpha`




```
## Error in ggplot(data = comic_characters, aes(x = align, y = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```

--- .class #id

## Aesthetics:  `alpha`

- It can be hard to see the transparency when they are so close.
- We can set the transparency to a variable


--- .class #id

## YOUR TURN

- Set `alpha=year`
- How does this change things?

--- .class #id

## Aesthetics:  `alpha`




```
## Error in ggplot(data = comic_characters, aes(x = align, y = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```

--- .class #id

## Aesthetics:  `color`

- We can easily change the color of points and lines using `color`


```r
ggplot(data=comic_characters, aes(x=align, y=log_app)) + 
  geom_point(aes(color=publisher))
```


--- .class #id

## Aesthetics:  `color`




```
## Error in ggplot(data = comic_characters, aes(x = align, y = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```

--- .class #id 

## YOUR TURN

- Set `color="blue"`
- How does this change things?


--- .class #id

## Aesthetics: `shapes`

- We can change the shape of points based on different variables.


```r
ggplot(data=comic_characters, aes(x=align, y=log_app)) + 
  geom_point(aes(shape=publisher))
```



--- .class #id

## Aesthetics: `shapes`




```
## Error in ggplot(data = comic_characters, aes(x = align, y = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Your Turn

- Try using both shape and color. 
- How does this add dimensionality to the graph?


--- .class #id

## Aesthetics: `fill`

- We can fill objects with color as well


```r
ggplot(data=comic_characters, aes(x=align)) + 
  geom_bar(aes(fill="blue"))
```


--- .class #id

## Aesthetics: `fill`

- This doesnt have the same effect as `color`


```
## Error in ggplot(data = comic_characters, aes(x = align)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Aesthetics: `fill`

- We can use other variables to add dimensionality


```r
ggplot(data=comic_characters, aes(x=align)) + 
  geom_bar(aes(fill=publisher))
```


--- .class #id

## Aesthetics: `fill`




```
## Error in ggplot(data = comic_characters, aes(x = align)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


---  .segue bg:grey

# Geoms

--- .class #id

## Geoms

- There are many `geom_foo()` functions we can use. 
- The Cheatsheet on   `ggplot()` is a good place to start for more. 

--- .class #id

## Other Plots: Density



```
## Error in ggplot(data = comic_characters, aes(x = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Other Plots: Density



```
## Error in ggplot(data = comic_characters, aes(x = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```


--- .class #id

## Other Plots: Histogram



```
## Error in ggplot(data = comic_characters, aes(x = log_app)): lazy-load database 'C:/Users/sullivanstats/Dropbox (Personal)/Brown/Teaching/Brown Courses/PHP2511/Spring 2019/website/php-1511-2511.github.io/Notes/.cache/unnamed-chunk-13_8ecaf0c2e00d6f774be6cefd4f037233.rdb' is corrupt
```




---  .segue bg:grey

# Piping or Chaining Data

--- .class #id

## Piping or Chaining

- We will discuss a concept that will help us greatly when it comes to working with our data. 
- The usual way to perform multiple operations in one line is by nesting. 

--- .class #id

## Piping or Chaining

To consider an example we will look at the data provided in the gapminder package:


```r
library(gapminder)
head(gapminder)
```

```
## # A tibble: 6 x 7
##   country     continent  year lifeExp      pop gdpPercap          gdp
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.  6567086330.
## 2 Afghanistan Asia       1957    30.3  9240934      821.  7585448670.
## 3 Afghanistan Asia       1962    32.0 10267083      853.  8758855797.
## 4 Afghanistan Asia       1967    34.0 11537966      836.  9648014150.
## 5 Afghanistan Asia       1972    36.1 13079460      740.  9678553274.
## 6 Afghanistan Asia       1977    38.4 14880372      786. 11697659231.
```

--- .class #id

## Nesting vs Chaining

- Let's say that we want to have the GDP per capita and life expectancy Kenya.
- Traditionally speaking we could do this in a nested manner:



```r
filter(select(gapminder, country, lifeExp, gdpPercap), country=="Kenya")
```

--- .class #id

## Nesting vs Chaining

- It is not easy to see exactly what this code was doing but we can write this in a manner that follows our logic much better. 
- The code below represents how to do this with chaining. 


```r
gapminder %>%
    select(country, lifeExp, gdpPercap) %>%
    filter(country=="Kenya")
```

--- .class #id

## Breaking Down the Code

- We now have something that is much clearer to read.
- Here is what our chaining command says:
    1. Take the `gapminder` data
    2. Select the variables: `country`, `lifeExp` and `gdpPercap`.
    3. Only keep information from Kenya. 
- The nested code says the same thing but it is hard to see what is going on if you have not been coding for very long.


--- .class #id

## Breaking Down the Code

- The result of this search is below: 


```
# A tibble: 12 x 3
   country lifeExp gdpPercap
    <fctr>   <dbl>     <dbl>
 1   Kenya  42.270  853.5409
 2   Kenya  44.686  944.4383
 3   Kenya  47.949  896.9664
 4   Kenya  50.654 1056.7365
 5   Kenya  53.559 1222.3600
 6   Kenya  56.155 1267.6132
 7   Kenya  58.766 1348.2258
 8   Kenya  59.339 1361.9369
 9   Kenya  59.285 1341.9217
10   Kenya  54.407 1360.4850
11   Kenya  50.992 1287.5147
12   Kenya  54.110 1463.2493
```

--- .class #id

## What is `%>%`

- In the previous code we saw that we used `%>%` in the command you can think of this as saying ***then***.
- For example:


```r
gapminder %>%
    select(country, lifeExp, gdpPercap) %>%
    filter(country=="Kenya")
```

--- .class #id

## What Does this Mean?

- This translates to:
    - Take Gapminder ***then*** select these columns select(country, lifeExp, gdpPercap) ***then*** filter out so we only keep Kenya


--- .class #id

## Why Chain?

- We still might ask why we would want to do this. 
- Chaining increases readability significantly when there are many commands. 
- With many packages we can replace the need to perform nested arguments. 
- The chaining operator is automatically imported from the [magrittr](https://github.com/smbache/magrittr) package. 

--- .class #id

## User Defined Function


- Let's say that we wish to find the Euclidean distance between two vectors say, `x1` and `x2`. 
- We could use the math formula:

\[\sqrt{\sum(x_1-x_2)^2}\]

--- .class #id

## User Defined Function

- In the nested manner this would be:


```r
x1 <- 1:5; x2 <- 2:6
sqrt(sum((x1-x2)^2))
```

--- .class #id

## User Defined Function


- However, if we chain this we can see how we would perform this mathematically. 

```r
# chaining method
(x1-x2)^2 %>% sum() %>% sqrt()
```
- If we did it by hand we would perform elementwise subtraction of `x2` from `x1` ***then*** we would sum those elementwise values ***then*** we would take the square root of the sum. 


--- .class #id

## User Defined Function



```r
# chaining method
(x1-x2)^2 %>% sum() %>% sqrt()
```

```
## [1] 2.236068
```

- Many of us have been performing calculations by this type of method for years, so that chaining really is more natural for us. 
