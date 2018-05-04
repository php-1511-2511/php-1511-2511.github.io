Final Exam Extra Questions
--------------------------

Here are the questions I received on Polly. Due to the nature of them I
will just answer them via this page instead of a video.

-   [I know hazard h(t) is a derivative of survival S(t), so are there
    interpretations different? Do I have x chance of survival or x
    hazard of getting disease?](#hazard-vs-survival)
-   [When the proportional hazards assumption is violated, we can
    include a 'strata' term... does this alter our interpretation of the
    beta coefficient? or do you include this as conditional statement?
    For example: adjusting for the 'strata'term, we expect that the
    hazard rate increases by X for every 1 year increase in
    age.](#stratified-cox-ph-models)
-   [Can you confirm what topics the final exam material will go
    through? thank you!](#exam-material)
-   [Perhaps you can go over an example where you use logistic, poisson,
    and Cox and compare and contrast the results you obtain. That would
    be pretty helpful!](#model-comparisons)

Hazard vs Survival
------------------

The hazard is actually the negative of the derivative of the natural
logarithm of survival.

$$h(t) = -\\dfrac{d}{dt}log\\left\[S(t)\\right\]$$
 They do not have the same meaning. Survival is a probability of
surviving past a certain time *t* or Pr(*T* &gt; *t*). However, the
hazard is the instantaneous rate of failure at time *t*.

This means survival is basically trying to calculate the proportion of
individuals who have survived past some time *t* and hazard would be the
rate at which we expect subjects to fail at time *t*.

Anytime you are discussing different concepts, then there are different
interpretations. Consider [Lecture
13](../Notes/Lec-13-survival/survival.html#8) from slide 8 - 13 for the
definitions of survival and hazard. Then consider [Lecture
14](../Notes/Lec-14-survival-2/survival-2.html#13) slides 13-22 for
interpretations.

Stratified Cox PH Models
------------------------

When we stratify the Cox Proportional Hazards models we are startifying
the baseline hazard function which we do not interpret. Consider the
example from [Lecture 14](../Notes/Lec-14-survival-2/survival-2.html#25)

We began fitting a model to look at modeling the hazard of going back to
prison within 1 year of being released. We found that `age` did not pass
the proportional hazards test. We placed age into categories to stratify
over:

    library(tidyverse)
    Rossi <- Rossi %>%
      mutate( age.cat =cut(age, c(0, 19, 25, 30, Inf)))

Then we fit the model with stratified age:

    ## Error in tidy(mod3, exponentiate = T): could not find function "tidy"

    ## Error in inherits(x, "list"): object 'tidy2' not found

We can plot the model to see the effects of stratification:

    library(simPH)
    ggfitStrata(mod3, byStrata = FALSE)

![](final_exam_extra_info_files/figure-markdown_strict/unnamed-chunk-4-1.png)
