---
title       : Transforming Data with `dplyr`
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


# The `dplyr` Package


--- .class #id

## The `dplyr` Package

- Now that we have started to tidy up our data we can see that we have a need to transform this data. 
- We may wish to add additional variables. 
- The `dplyr` package allows us to further work with our data. 

--- .class #id


## `dplyr` Functionality

- With `dplyr` we have five basic verbs that we will learn to work with:
  - `filter()`
  - `select()`
  - `arrange()`
  - `mutate()`
  - `summarize()`


  


---  .segue bg:grey


# Filtering 


--- .class #id

## Filtering


- At this point we will consider how we pick the rows of the data that we wish to work with. 
- If you consider many modern data sets, we have so much information that we may not want to bring it all in at once. 
- R brings data into the RAM of your computer. This means you can be limited for what size data you can bring in at once. 
- Very rarely do you need the entire data set. 
- We will focus on how to pick the rows or observations we want now.


--- .class #id

## Enter the `filter()` Function

- The `filter()` function chooses rows that meet a specific criteria. 
- We can do this with Base R functions or with   `dplyr`. 


```r
library(dplyr)
```


--- .class #id

## Filtering Example

- Let's say that we want to look at the data just for the country of Kenya in 2000
- We could do this without learning a new command and use indexing which we learned yesterday. 


```r
gapminder[gapminder$country=="Kenya" & gapminder$year==2002, ]
```

```
## # A tibble: 1 x 6
##   country continent  year lifeExp      pop gdpPercap
##   <fct>   <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Kenya   Africa     2002    51.0 31386842     1288.
```

--- .class #id

## Filtering Example


- Now this is not very difficult to do, what we have is that we are working with `gapminder` and we only want to keep the rows of data there `country=="Kenya` and `year==2002`. 
- However we could use the `filter()` function to do this in a much easier to read format:

--- .class #id

## `filter()` Function

```
filter(.data, ...)
```

where

- `.data` is a tibble.
- `...` is a set of arguments the data you want returned needs to meet. 


--- .class #id

## Filtering Example

- This means in our example we could perform the following:

```
gapminder %>%
    filter(country=="Kenya", year==2002)
```

Finally we could also only do one filtering at a time and chain it:

```
gapminder %>%
    filter(country=="Kenya") %>%
    filter(year==2002)
```


--- .class #id


## Further Filtering

- `filter()` supports the use of multiple conditions where we can use Boolean. 
- For example if we wanted to consider only observations that have a life expectancy between 49 and 60, we could do the following:


```r
gapminder %>% filter(lifeExp>=49 & lifeExp<60)
```

--- .class #id


## Further Filtering


```
## # A tibble: 373 x 6
##    country    continent  year lifeExp      pop gdpPercap
##    <fct>      <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Albania    Europe     1952    55.2  1282697     1601.
##  2 Albania    Europe     1957    59.3  1476505     1942.
##  3 Algeria    Africa     1967    51.4 12760499     3247.
##  4 Algeria    Africa     1972    54.5 14760787     4183.
##  5 Algeria    Africa     1977    58.0 17152804     4910.
##  6 Bahrain    Asia       1952    50.9   120447     9867.
##  7 Bahrain    Asia       1957    53.8   138655    11636.
##  8 Bahrain    Asia       1962    56.9   171863    12753.
##  9 Bahrain    Asia       1967    59.9   202182    14805.
## 10 Bangladesh Asia       1982    50.0 93074406      677.
## # ... with 363 more rows
```

--- .class #id


## Further Filtering

- We can also use the `filter()` function to remove missing data for us. 
- Previously we learned about a class of functions called `is.`*foo*`()` where *foo* represents a data type. 
- We could choose to only use observations that have life expectancy. 
- That means we wish to not have missing data for life expectancy. 



```r
gapminder %>% filter(!is.na(lifeExp))
```

--- .class #id


## On Your Own: RStudio Practice


Using the `filter()` function and chaining: 

- Choose only rows associated with
  - Uganda
  - Rwanda

--- .class #id


## On Your Own: RStudio Practice


Your end result should be:


```
## # A tibble: 24 x 6
##    country continent  year lifeExp     pop gdpPercap
##    <fct>   <fct>     <int>   <dbl>   <int>     <dbl>
##  1 Rwanda  Africa     1952    40   2534927      493.
##  2 Rwanda  Africa     1957    41.5 2822082      540.
##  3 Rwanda  Africa     1962    43   3051242      597.
##  4 Rwanda  Africa     1967    44.1 3451079      511.
##  5 Rwanda  Africa     1972    44.6 3992121      591.
##  6 Rwanda  Africa     1977    45   4657072      670.
##  7 Rwanda  Africa     1982    46.2 5507565      882.
##  8 Rwanda  Africa     1987    44.0 6349365      848.
##  9 Rwanda  Africa     1992    23.6 7290203      737.
## 10 Rwanda  Africa     1997    36.1 7212583      590.
## # ... with 14 more rows
```

---  .segue bg:grey



# Selecting


--- .class #id

## Selecting

- The next logical step would be to select the columns we want as well. 
- Many times we have so many columns that we are no interested in for a particular analysis. 
- Instead of slowing down your analysis by continuing to run through extra data, we could just select the columns we care about. 

--- .class #id


## Enter the `select()` Function

- The `select()` function chooses columns that we specify. 
- Again we can do this with base functions or with `dplyr`. 
- We feel that as you continue on with your R usage that you will most likely want to go the route of `dplyr` functions instead.

--- .class #id

## Select Example

- Let's say that we want to look at the gapminder data but we are really only interested in the country, life expectancy and year. 
- This seems reasonable if we are a customer and wanted to only know these pieces of information. We could do this with indexing : 


```r
gapminder[, c("country", "lifeExp", "year")]
```

--- .class #id

## `select()` Function

```
select(.data, ...)
```

where 

- `.data` is a tibble.
- `...` are the columns that you wish to have in bare (no quotations)


--- .class #id

## Selecting Example Continued

We could then do the following


```r
gapminder %>%
  select(country, lifeExp, year)
```


--- .class #id

## Selecting Example Continued


```
# A tibble: 1,704 x 3
       country lifeExp  year
        <fctr>   <dbl> <int>
 1 Afghanistan  28.801  1952
 2 Afghanistan  30.332  1957
 3 Afghanistan  31.997  1962
 4 Afghanistan  34.020  1967
 5 Afghanistan  36.088  1972
 6 Afghanistan  38.438  1977
 7 Afghanistan  39.854  1982
 8 Afghanistan  40.822  1987
 9 Afghanistan  41.674  1992
10 Afghanistan  41.763  1997
# ... with 1,694 more rows
```


--- .class #id

## Removing Columns


- We may wish to pick certain columns that we wish to have but we also may want to remove certain columns. 
- It is quite common to de-identify a dataset before actually distributing it to a research team. 
- The `select()` function will also remove columns. 



--- .class #id

## Removing Columns

- Lets say that we wished to remove the `gdpPercap` and `pop` of the countries:


```r
gapminder %>%
  select(-gdpPercap,-pop)
```

--- .class #id

## Removing Columns

We also could use a vector for this:


```r
cols <- c("gdpPercap", "pop")
gapminder %>%
  select(-one_of(cols))
```

--- .class #id

## Removing Columns

- We can also remove columns that contain a certain phrase in the name. 
- If we were interested in removing any columns that had to do with time we could search for the phrase "co" in the data and remove them:


```r
gapminder %>%
  select(-matches("co"))
```

--- .class #id

## Removing Columns



```
## # A tibble: 1,704 x 4
##     year lifeExp      pop gdpPercap
##    <int>   <dbl>    <int>     <dbl>
##  1  1952    28.8  8425333      779.
##  2  1957    30.3  9240934      821.
##  3  1962    32.0 10267083      853.
##  4  1967    34.0 11537966      836.
##  5  1972    36.1 13079460      740.
##  6  1977    38.4 14880372      786.
##  7  1982    39.9 12881816      978.
##  8  1987    40.8 13867957      852.
##  9  1992    41.7 16317921      649.
## 10  1997    41.8 22227415      635.
## # ... with 1,694 more rows
```

--- .class #id

## Unique Observations

- Many times we have a lot of repeats in our data. 
- If we just would like to have an account of all things included then we can use the `unique()` command. 
- Lets assume that we wish to know which countries are in the data. 
- We do not want to have every country listed over and over again so we ask for unique values:


```r
gapminder %>% 
  select(country) %>% 
  unique()
```


--- .class #id

## On Your Own: RStudio Practice

- Consider the gapminder data: `gapminder`. 
  1. Select all but the `pop` column.
  2. Remove the year and lifeExp from them.
  3. Select values which contain "p" in them. 
  4. Chain these together so that you run a command and it does all of these things. 

--- .class #id

## On Your Own: RStudio Practice


Your answer should look like:


```
## # A tibble: 1,704 x 1
##    gdpPercap
##        <dbl>
##  1      779.
##  2      821.
##  3      853.
##  4      836.
##  5      740.
##  6      786.
##  7      978.
##  8      852.
##  9      649.
## 10      635.
## # ... with 1,694 more rows
```


# Arranging the Data

--- .class #id

## Arranging the Data

- We also have need to make sure the data is ordered in a certain manner. This can be easily done in R with the `arrange()` function. 
- Again we can do this in base R but this is not always a clear path. 

--- .class #id

## Arranging the Data Example

- Let's say that we wish to look at only carriers and departure delay and we wish to order departure delays from what smallest to largest. 
- In base R we would have to run the following command:


```r
flights[order(flights$dep_delay), c("carrier", "dep_delay")]
```

```
## Error in eval(expr, envir, enclos): object 'flights' not found
```

--- .class #id

## Enter the `arrange()` Function

We could do this in an easy manner using the  `arrange()` function:

```
arrange(.data, ...)
```

Where

- `.data` is a data frame of interest.
- `...` are the variables you wish to sort by. 

--- .class #id

## Arranging the Data Example Continued


```r
flights %>%
    select(carrier, dep_delay) %>%
    arrange(dep_delay)
```

--- .class #id

## Arranging the Data Example Continued


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

--- .class #id

## Arranging the Data Example Continued

- With `arrange()` we first use `select()` to pick the only columns that we want and then we arrange by the `dep_delay`. 
- If we had wished to order them in a descending manner we could have simply used the `desc()` function:


```r
flights %>%
    select(carrier, dep_delay) %>%
    arrange(desc(dep_delay))
```

--- .class #id


## More Complex Arrange

- Lets consider that we wish to look at the top 3 departure delays for each day.
- Then we wish to order them from largest to smallest departure delay. 
- We then need to do the following:
    1. Group by month and Day
    2. Pick the top 3 departure delays
    3. order them largest to smallest
    



--- .class #id

## More Complex Arrange Continued



```r
flights %>% 
  group_by(month, day) %>%  
  top_n(3, dep_delay) %>% 
  arrange(desc(dep_delay))
```

Where

- `group_by()` is a way to group data. This way we perform operations on a group. So top 3 delays are by a group of day and month. 
- `top_n()`takes a tibble and returns a specific number of rows based on a chosen value. 


--- .class #id

## More Complex Arrange Continued



```
## Error in eval(lhs, parent, parent): object 'flights' not found
```



--- .class #id

## On Your Own: RStudio Practice

- Perform the following operations:
  - Group by month and day. 
  - use `sample_n()` to pick 1 observation per day. 
  - Arrange by longest to smallest departure delay. 



--- .class #id





## On Your Own: RStudio Practice


Your answer ***may*** look like:


```r
flights %>%
  group_by(month,day) %>%
  sample_m(1) %>%
  arrange(desc(dep_delay))
```

---  .segue bg:grey


# Summarizing Data


--- .class #id

## Summarizing Data

- As you have seen in your own work, being able to summarize information is crucial. 
- We need to be able to take out data and summarize it as well. 
- We will consider doing this using the `summarise()` function. 

--- .class #id

## Summarizing Data

- Like in the rest of these lessons, let's consider what happens when we try to to do this in base R. We will:
  1. Create a table grouped by `dest`.
  2. Summarize each group by taking mean of `arr_delay`.


```r
head(with(flights, tapply(arr_delay, dest, mean, na.rm=TRUE)))
```

```
## Error in with(flights, tapply(arr_delay, dest, mean, na.rm = TRUE)): object 'flights' not found
```

```r
head(aggregate(arr_delay ~ dest, flights, mean))
```

```
## Error in eval(m$data, parent.frame()): object 'flights' not found
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


```
flights %>%
    group_by(dest) %>%
    summarise(avg_delay = mean(arr_delay, na.rm=TRUE))
```

--- .class #id

## Summarizing Data Example 

- Consider the logic here:
  1. Group flights by destination
  2. Find the average delay of the groups and call it `avg_delay`.
- This is much easier to understand than the  Base R code. 


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

--- .class #id


## Another Example

- Lets say that we would like to have more than just the averages but we wish to have the minimum and the maximum departure delays by carrier:


```r
flights %>%
    group_by(carrier) %>%
    summarise_each(funs(min(., na.rm=TRUE), max(., na.rm=TRUE)), matches("delay"))
```


--- .class #id


## Another Example




```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

--- .class #id

## On Your Own: RStudio Practice 

- The following is a new function:
  - Helper function `n()` counts the number of rows in a group
- Then for each day:
  - count total flights
  - Sort in descending order. 

--- .class #id

## On Your Own: RStudio Practice 

Your answer should look like:


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```


We could also have used what is called the  `tally()` function:


```r
flights %>%
    group_by(month, day) %>%
    tally(sort = TRUE)
```

```
## Error in eval(lhs, parent, parent): object 'flights' not found
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


With `mutate()` we have

```
mutate(.data, ...)
```

where

- `.data` is your tibble of interest.
- `...` is the name paired with an expression


--- .class #id

## Adding New Variables

Then with `transmute()` we have:

```
transmute(.data, ...)
```

where

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

- Let's say we wish to have a variable called speed. We want to basically do:

\[\text{speed} = \dfrac{\text{distance}}{\text{time}}*60\]


We can first do this with `mutate()`:


```r
flights %>% 
  select(flight, distance, air_time) %>%
  mutate(speed = distance/air_time*60)
```

--- .class #id

## Example


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

--- .class #id

## Example



```r
flights %>%
  select(flight, distance, air_time) %>%
  transmute(speed = distance/air_time*60)
```


--- .class #id

## Example



```r
flights %>%
  select(flight, distance, air_time) %>%
  transmute(speed = distance/air_time*60)
```

---  .segue bg:grey



#Further Summaries

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


- For example if we wished to know how many flights there were by month, we would use `tally()` in this manner: 


```r
flights %>%
  group_by(month) %>% 
  tally()
```

--- .class #id



## Grouping and Counting

- Where as we could do the same thing with `count()`


```r
flights %>% 
  count(month)
```

*Notice: `count()` allowed for month to be called inside of it, removing the need for the `group_by()` function. 


--- .class #id



## Grouping, counting and sorting. 

- Both `tally()` and `count()` have an argument called `sort()`. 
- This allows you to go one step further and group by, count and sort at the same time. 
- For `tally()` this would be:


```r
flights %>% group_by(month) %>% tally(sort=TRUE)
```

--- .class #id


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```


--- .class #id

- Then for `count()` we would have:


```r
flights %>% count_(month, sort=TRUE)
```


--- .class #id

- Then for `count()` we would have:


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

--- .class #id

## Grouping with other functions

- We can also sum over other values rather than just counting the rows like the above examples. 
- For example let us say we were interested in knowing the total distance for planes in a given month. 
- We could do this with the `summarise()` function, `tally()` function or the `count()` function:


```r
flights %>% 
  group_by(month) %>% 
  summarise(dist = sum(distance))
```

--- .class #id

## Grouping with other functions

- We take flights then group by month and then create a new variable called distance, where we sum the distance. 
- For  `tally()` we could do:


```r
flights %>% 
  group_by(month) %>% 
  tally(wt = distance)
```

*Note: in `tally()` the `wt` stands for weight and allows you to weight the sum based on the distance*. 

--- .class #id

## Grouping with other functions

- With the `count()` function we also use `wt`:



```r
flights %>% count(month, wt = distance)
```

```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

--- .class #id

##Counting Groups


- We may want to know how large our groups are. To do this we can use the following functions:
  - `group_size()` is a function that returns counts of group. 
  - `n_groups()` returns the number of groups

--- .class #id

##Counting Groups

- So if wanted to count the number of flights by month, we could group by month and find the groups size using `group_size()`:


```r
flights %>% 
  group_by(month) %>% 
  group_size()
```


--- .class #id

##Counting Groups




```
## Error in eval(lhs, parent, parent): object 'flights' not found
```


--- .class #id

##Counting Groups


- If we just wished to know how many months were represented in our data we could use the `n_groups()` function:



```r
flights %>% 
  group_by(month) %>% 
  n_groups()
```



--- .class #id

##Counting Groups


```
## Error in eval(lhs, parent, parent): object 'flights' not found
```

