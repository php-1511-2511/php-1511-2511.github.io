---
title       : Further Data Summarisations
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






# Summarizing Data

--- .class #id

## Summarizing Data

- Like in the rest of these lessons, let's consider what happens when we try to to do this in base R. We will:
  1. Create a table grouped by `country`.
  2. Summarize each group by taking mean of `lifeExp`.


```r
head(with(gapminder, tapply(lifeExp, country, mean, na.rm=TRUE)))
head(aggregate(lifeExp ~ country, gapminder, mean))
```

--- .class #id


## Enter `summarise()` Function

- The `summarise()` function is:

```
summarise(.data, ...)
```

- where
  - `.data` is the tibble of interest.
  - `...` is a list of name paired summary functions
    - Such as:
      - `mean()`
      - `median`
      - `var()`
      - `sd()`
      - `min()`
      - `max()
      - ...



--- .class #id

## Summarizing Data Example 

- Consider the logic here:
  1. Group data by country
  2. Find the average life Expectancy of the groups and call it `avg_lifeExp`.
- This is much easier to understand than the  Base R code. 


```r
gapminder %>%
    group_by(country) %>%
    summarise(avg_lifeExp = mean(lifeExp, na.rm=TRUE))
```



--- .class #id

## Summarizing Data Example 



```r
gapminder %>%
    group_by(country) %>%
    summarise(avg_lifeExp = mean(lifeExp, na.rm=TRUE))
```

--- .class #id


## Another Example

- Lets say that we would like to have more than just the averages but we wish to have the minimum and the maximum life expectancies by country:


```r
gapminder %>%
    group_by(country) %>%
    summarise_each(funs(min(., na.rm=TRUE), max(., na.rm=TRUE)), lifeExp)
```


--- .class #id


## Another Example




```
## # A tibble: 142 x 3
##    country       min   max
##    <fct>       <dbl> <dbl>
##  1 Afghanistan  28.8  43.8
##  2 Albania      55.2  76.4
##  3 Algeria      43.1  72.3
##  4 Angola       30.0  42.7
##  5 Argentina    62.5  75.3
##  6 Australia    69.1  81.2
##  7 Austria      66.8  79.8
##  8 Bahrain      50.9  75.6
##  9 Bangladesh   37.5  64.1
## 10 Belgium      68    79.4
## # ... with 132 more rows
```

--- .class #id

## On Your Own: RStudio Practice 

- The following is a new function:
  - Helper function `n()` counts the number of rows in a group
- Then for each year and continent:
  - count total lifeExp
  - Sort in descending order. 

--- .class #id

## On Your Own: RStudio Practice 

Your answer should look like:


```
## # A tibble: 60 x 3
## # Groups:   continent [5]
##    continent  year lifeExp_count
##    <fct>     <int>         <int>
##  1 Africa     1952            52
##  2 Africa     1957            52
##  3 Africa     1962            52
##  4 Africa     1967            52
##  5 Africa     1972            52
##  6 Africa     1977            52
##  7 Africa     1982            52
##  8 Africa     1987            52
##  9 Africa     1992            52
## 10 Africa     1997            52
## # ... with 50 more rows
```


We could also have used what is called the  `tally()` function:


```r
gapminder %>%
    group_by(country, year) %>%
    tally(sort = TRUE)
```

```
## # A tibble: 1,704 x 3
## # Groups:   country [142]
##    country      year     n
##    <fct>       <int> <int>
##  1 Afghanistan  1952     1
##  2 Afghanistan  1957     1
##  3 Afghanistan  1962     1
##  4 Afghanistan  1967     1
##  5 Afghanistan  1972     1
##  6 Afghanistan  1977     1
##  7 Afghanistan  1982     1
##  8 Afghanistan  1987     1
##  9 Afghanistan  1992     1
## 10 Afghanistan  1997     1
## # ... with 1,694 more rows
```

---  .segue bg:grey


# Adding New Variables


--- .class #id

## Adding New Variables

- There is usually no way around needing a new variable in your data. 
- For example, most medical studies have height and weight in them, however many times what a researcher is interested in using is Body Mass Index (BMI). 
- We would need to add BMI in. 


--- .class #id

## Adding New Variables

- Using the `tidyverse` we can add new variables in multiple ways
  - `mutate()`
  - `transmute()`

--- .class #id

## Adding New Variables


- With `mutate()` we have
    ```
    mutate(.data, ...)
    ```
- where
    - `.data` is your tibble of interest.
    - `...` is the name paired with an expression


--- .class #id

## Adding New Variables

- Then with `transmute()` we have:
    ```
    transmute(.data, ...)
    ```
- where
    - `.data` is your tibble of interest.
    - `...` is the name paired with an expression


--- .class #id


## Differences Between `mutate()` and `transmute()`

- There is only one major difference between `mutate()` and `transmutate` and that is what it keeps in your data. 
  - `mutate()`
      - creates a new variable
      - It keeps all existing variables
  - `transmute()`
      - creates a new variable.
      - It only keeps the new variables


--- .class #id

## Example

- Let's say we wish to have a variable called gdp We want to basically do:

\[\text{gdp} = gdpPercap\times pop\]


- We can first do this with `mutate()`:


```r
gapminder %>% 
  select(country, gdpPercap, pop) %>%
  mutate(gdp = gdpPercap*pop)
```

--- .class #id

## Example: Mutate


```
## # A tibble: 1,704 x 4
##    country     gdpPercap      pop          gdp
##    <fct>           <dbl>    <int>        <dbl>
##  1 Afghanistan      779.  8425333  6567086330.
##  2 Afghanistan      821.  9240934  7585448670.
##  3 Afghanistan      853. 10267083  8758855797.
##  4 Afghanistan      836. 11537966  9648014150.
##  5 Afghanistan      740. 13079460  9678553274.
##  6 Afghanistan      786. 14880372 11697659231.
##  7 Afghanistan      978. 12881816 12598563401.
##  8 Afghanistan      852. 13867957 11820990309.
##  9 Afghanistan      649. 16317921 10595901589.
## 10 Afghanistan      635. 22227415 14121995875.
## # ... with 1,694 more rows
```

--- .class #id

## Example: Transmute



```r
gapminder %>% 
  select(country, gdpPercap, pop) %>%
  transmute(gdp = gdpPercap*pop)
```


--- .class #id

## Example: transmute



```
## # A tibble: 1,704 x 1
##             gdp
##           <dbl>
##  1  6567086330.
##  2  7585448670.
##  3  8758855797.
##  4  9648014150.
##  5  9678553274.
##  6 11697659231.
##  7 12598563401.
##  8 11820990309.
##  9 10595901589.
## 10 14121995875.
## # ... with 1,694 more rows
```

---  .segue bg:grey



# Further Summaries

--- .class #id

## Further Summaries

- We have so far discussed how one could find the basic number summaries:
  - mean
  - median
  - standard deviation
  - variance
  - minimum 
  - maximum
- However there are many more operations that you may wish to do for summarizing data. 
- In fact many of the following examples are excellent choices for working with categorical data which does not always make sense to do the above summaries for. 


--- .class #id

## Further Summaries

- We will consider:
  1. Grouping and Counting
  2. Grouping, Counting and Sorting
  3. Other Groupings
  4. Counting Groups


--- .class #id



## Grouping and Counting


- We have seen the functions `tally()` and `count()`. 
- Both of these can be used for grouping and counting. 
- They also are very concise in how they are called. 


--- .class #id



## Grouping and Counting


- For example if we wished to know how many countrries there were by year, we would use `tally()` in this manner: 


```r
gapminder %>%
  group_by(year) %>% 
  tally()
```

--- .class #id



## Grouping and Counting

- Where as we could do the same thing with `count()`


```r
gapminder %>% 
  count(year)
```

*Notice: `count()` allowed for month to be called inside of it, removing the need for the `group_by()` function. 


--- .class #id



## Grouping, counting and sorting.

- Both `tally()` and `count()` have an argument called `sort()`. 
- This allows you to go one step further and group by, count and sort at the same time. 
- For `tally()` this would be:


```r
gapminder %>% group_by(year) %>% tally(sort=TRUE)
```

--- .class #id

## Grouping, counting and sorting: `tally()`


```
## # A tibble: 12 x 2
##     year     n
##    <int> <int>
##  1  1952   142
##  2  1957   142
##  3  1962   142
##  4  1967   142
##  5  1972   142
##  6  1977   142
##  7  1982   142
##  8  1987   142
##  9  1992   142
## 10  1997   142
## 11  2002   142
## 12  2007   142
```




--- .class #id

## Grouping with other functions

- We can also sum over other values rather than just counting the rows like the above examples. 
- For example let us say we were interested in know the total GDP for countries in a given continent and year.
- We could do this with the `summarise()` function, `tally()` function or the `count()` function:


```r
gapminder %>% 
  group_by(continent, year) %>% 
  summarise(total_gdp = sum(gdp))
```


--- .class #id

## Grouping with other functions



```
## Error in summarise_impl(.data, dots): Evaluation error: object 'gdp' not found.
```


--- .class #id

## What happened?

- Where did gdp go?
- We made it before but we did not save it. 

--- .class #id

## Saving our work


```r
gapminder <- gapminder %>%
    mutate(gdp=gdpPercap*pop)
```

--- .class #id

## Try again:



```
## # A tibble: 5 x 2
##   continent total_gdp
##   <fct>         <dbl>
## 1 Africa      1.30e13
## 2 Americas    1.14e14
## 3 Asia        9.00e13
## 4 Europe      9.70e13
## 5 Oceania     4.52e12
```


--- .class #id

## Grouping with other functions

- For  `tally()` we could do:


```r
gapminder %>% 
  group_by(continent) %>% 
  tally(wt = gdp)
```

*Note: in `tally()` the `wt` stands for weight and allows you to weight the sum based on the gdp*. 

--- .class #id

## Grouping with other functions

- With the `count()` function we also use `wt`:



```r
gapminder %>% count(continent, wt = gdp)
```

```
## # A tibble: 5 x 2
##   continent       n
##   <fct>       <dbl>
## 1 Africa    1.30e13
## 2 Americas  1.14e14
## 3 Asia      9.00e13
## 4 Europe    9.70e13
## 5 Oceania   4.52e12
```

--- .class #id

## Counting Groups


- We may want to know how large our groups are. To do this we can use the following functions:
  - `group_size()` is a function that returns counts of group. 
  - `n_groups()` returns the number of groups

--- .class #id

## Counting Groups

- So if wanted to count the number of countries by continent, we could group by continent and find the groups size using `group_size()`:


```r
gapminder %>% 
  group_by(continent) %>% 
  group_size()
```


--- .class #id

## Counting Groups




```
## [1] 624 300 396 360  24
```


--- .class #id

## Counting Groups


- If we just wished to know how many years were represented in our data we could use the `n_groups()` function:



```r
gapminder %>% 
  group_by(year) %>% 
  n_groups()
```



--- .class #id

## Counting Groups


```
## [1] 12
```

