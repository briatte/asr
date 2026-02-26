# README

___This is an example, ungraded exam. You do not need to submit it.___

__Data source:__ [Quality of Government Basic Dataset][qog], time-series version, January 2026. The data have been restricted to selected variables and years. More information is available from the `docs` folder.

[qog]: https://www.gu.se/en/quality-government/qog-data/data-downloads/basic-dataset

## Instructions

- full student name required at the top
- questions appear in the code sections
- main dataset should be called `df` (as indicated in the script)
- do _not_ modify the numbered code sections
- do _not_ modify the folder structure
- __all answers go into the script directly__

When you are done, __submit your code__ (_after checking that it runs without errors -- see below_), __and nothing else.__ Do _not_ submit plots or the exam data, docs and folder.

## Grading criteria

- R code should be legible, concise, well-documented through comments, and must run without any errors (_as in class examples_)
- __answers and comments should not go beyond 80 characters per line__ (use multiple lines if you need to write longer comments or answers)
- the functions used in the answers can come either from base R or from any of the other loaded packages (_see top of the script_)

All other student regulations apply.

## Grading scheme

- Questions 1--5, 7 and 9 are worth 2 points each
- Questions 6 and 8 are worth 3 points each

## Copy of the exam questions

1. load the data
2. subset to most recent year
3. drop observations with missing values in `wdi_wip` or `ht_regtype`
4. recode `ht_regtype` as `democratic` (`0` = `FALSE`, `1` = `TRUE`)
5. using `wdi_gdpcapcon2015`, create `log_gpdc` (logarithmic units)
6. correlate `wdi_wip` to `log_gdpc`
    1. provide the correlation coefficient, rounded to 2 digits
    2. provide a plot of the relationship
    3. briefly comment on the relationship
7. do democracies have more females in parliament on average?
    1. express the difference in percentage points, rounded to 1 digit
    2. determine whether the observed difference is statistically significant
8. estimate linear regression models
    1. express `wdi_wip` as a linear function of `log_gdpc`
    2. fit the same model to democracies and non-democracies separately
    3. compare the models and comment on their results
9. plot the residuals of the model and interpret

## R code to generate the data extract

```r
haven::read_dta("https://www.qogdata.pol.gu.se/data/qog_bas_ts_jan26.dta") %>% 
  select(ccodealp, cname, year, wdi_wip, wdi_gdpcapcon2015, ht_regtype) %>% 
  filter(year %in% seq(2012, max(year[ !is.na(ht_regtype) ]))) %>% 
  haven::write_dta("data/qog_bas_ts_jan26_extract.dta")
```
