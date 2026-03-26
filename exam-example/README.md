# README

___This is an example, ungraded exam. You do not need to submit it.___

__Data source:__ [Quality of Government Basic Dataset][qog], time-series version, January 2026. The data are restricted to selected variables and years. More information is available from the `docs` folder.

[qog]: https://www.gu.se/en/quality-government/qog-data/data-downloads/basic-dataset

## Instructions

- full student name required at the top
- questions appear in the code sections
- see the next page for additional hints
- main dataset should be called `df` (as indicated in the script)
- do _not_ modify the numbered code sections
- do _not_ modify the folder structure
- __all answers go into the script directly__
- __answer questions in their dedicated sections__

When you are done, __submit your code__ (_after checking that it runs without errors -- see below_), __and nothing else.__ Do _not_ submit plots or the exam data, docs and folder.

## Grading criteria

- R code should be legible, concise, well-documented through comments, and must run without any errors (_as in class examples_)
- __answers and comments should not go beyond 80 characters per line__ (use multiple lines if you need to write longer comments or answers)
- the functions used in the answers can come either from base R or from any of the other loaded packages (_see top of the script_)

All other student regulations apply.

## Grading scheme

- Questions 1--5, 7 and 9 are worth 2 points each
- Questions 6 and 8 are worth 3 points each

## Exam questions, with details and hints

1. __Load the data.__  
    _Hint:_ check the `data` folder.
2. __Subset to the most recent year.__
3. __Drop observations with missing values in `wdi_wip` or `ht_regtype`.__
4. __Recode `ht_regtype` as `democratic` (`0` = `FALSE`, `1` = `TRUE`).__
5. __Using `wdi_gdpcapcon2015`, create `log_gpdc` (logarithmic units).__  
    _Hint:_ use the `log` function.
6. __Correlate `wdi_wip` to `log_gdpc`__, as follows:
    1. Provide the correlation coefficient, rounded to 2 digits
    2. Provide a plot of the relationship, with `log_gdpc` on the y-axis
    3. Briefly comment on the relationship
7. __Do democracies have more females in parliament on average?__ Find out by doing the following:
    1. Compute the mean percentage of women in parliament for democracies and non-democracies
    2. Report the difference between these two means in percentage points, rounded to 1 digit
    3. Determine whether the observed difference is statistically significant at _p_ < 0.05, and report your interpretation
8. __Estimate linear regression models__, as follows:
    1. Regress `wdi_wip` on `log_gdpc`  
        ... i.e. express `wdi_wip`, the dependent variable, as a linear function of `log_gdpc`, the predictor/independent variable
    2. Fit the same model to democracies and non-democracies separately
    3. Compare all three models and comment on their results
9. __Plot the residuals of the model and interpret them.__  
      _Hint:_ normality.

* * *

Thank you for your work!

## R code to generate the data extract

_The code below is not part of the exam, is not useful to complete any of the exam steps, and should be ignored._

```r
haven::read_dta("https://www.qogdata.pol.gu.se/data/qog_bas_ts_jan26.dta") %>% 
  select(ccodealp, cname, year, wdi_wip, wdi_gdpcapcon2015, ht_regtype) %>% 
  filter(year %in% seq(2012, max(year[ !is.na(ht_regtype) ]))) %>% 
  haven::write_dta("data/qog_bas_ts_jan26_extract.dta")
```
