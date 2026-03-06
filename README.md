# `>` Tutorials in Applied Stats with R and RStudio

> [François Briatte](https://f.briatte.org/)  
> Spring 2026. __Work in progress.__

Teaching material for some tutorials in ~~applied statistics~~ data science with [R][r], [RStudio][rstudio], and the [`{tidyverse}`][tidyverse] packages, aimed at first-year social science undergraduates with zero prior training in statistical computing whatsoever.

[r]: https://www.r-project.org/
[rstudio]: https://posit.co/products/open-source/rstudio/
[tidyverse]: https://www.tidyverse.org/

The content is very much related to [this other course][dsr], which is aimed at slightly older students with more study time and marginally better computing skills. Unlike that other course, the present tutorials are meant to be accompanied by an introductory stats lecture.

[dsr]: https://github.com/briatte/dsr

This folder contains the code, data and documentation of the examples used either during the practice sessions in class, or distributed as homework exercises. __Slides, exercise solutions and data documentation are not included.__

__Very much work in progress.__ The list of topics covered in each session, especially, is subject to change. The ultimate goal of the tutorials is to cover more or less the same ground as Matt Blackwell's [Data Analysis and Politics](https://gov51.mattblackwell.org/) course at Harvard University.

# Outline

1. [Software](#1-software)
2. [Data](#2-data)
3. [Visualization](#3-visualization)
4. [Association](#4-association)
5. [Association (continued)](#5-association-continued)
6. [Regression](#6-regression)
7. [Regression (continued)](#7-regression-continued)
8. [Wrap-up](#8-wrap-up)

Bonus section: [dependencies](#dependencies)

Bonus documents:

- [What to learn and to revise for the tutorials][revise]
- [Survey research project instructions][projects] (if relevant)
- [Troubleshooting][troubleshooting]

[revise]: https://docs.google.com/document/d/1QxZUho_ZmsdlIJZ5x87sijz3f6JGiq7t-S_S2bd6NBg/edit?usp=sharing
[projects]: https://docs.google.com/document/d/1pTb-IY5qYQvIURK8PJItLBQjRzCnMlO7YHOrDOPJZq8/edit?usp=sharing
[troubleshooting]: https://docs.google.com/document/d/1_JZ48kJnAo4etDJbOeISbGRqMXDdsxpalppB7woEY7w/edit?usp=sharing

# Part 1. Basics

Software setup, first steps with coding, handling data, and plotting things, plus univariate stats.

## 1. Software

- __RStudio interface__
  - The panes layout -- Console, Files, Plots
  - Setting RStudio preferences
  - Executing code from the __Console__
  - Clearing the Console with `Ctrl-L`
  - Executing code from a __script__ with `Ctrl-Enter`
- __R syntax__
  - Comments (`#`) and code
  - Functions and arguments, e.g. `round`, `x^k`, `sqrt`, `x:y`, `sum`, `mean`
  - Objects and assignment: `<-`
  - Package installation, with RStudio or with `install.packages`

`>` Class 1: __[Cholera deaths in London, 1854][d1]__ (John Snow)  
`>` Exercise 1: __[Support for Ukraine joining the EU][x1]__ (Eurobarometer)

_This README does not include links to the data sources, but these are provided in the individual README files of each folder. In their class versions, I also include some of the technical documentation of each dataset with the class examples and exercises._

[d1]: https://github.com/briatte/asr/tree/main/class-01
[x1]: https://github.com/briatte/asr/tree/main/exercise-01

## 2. Data

- More on the RStudio interface
  - Setting the __working directory__
  - Doing so by using RStudio project files: `.Rproj`
  - The Files and Plots panes
  - Executing code down to a given line: `Ctrl-Alt-B`
- More R syntax essentials
  - Code spanning multiple lines, and pipes: `%>%` or `|>`
  - R objects and types
  - R datasets, a.k.a. ‘data frames’ or ‘tibbles’
  - Logical tests: `TRUE` (=1) or `FALSE` (=0), `==`, `!=`, `>=` etc.
  - R has many packages and sub-syntaxes: base, `{tidyverse}`, `{ggplot2}`, etc.
- __Data wrangling__, mostly with the `{dplyr}` package
  - __Data I/O__
    - reading/writing datasets with `{readr}`, `{haven}` and `{readxl}`
    - inspecting datasets: `print`, `glimpse`, `view`
    - observations, variables and values
    - __strings__ and other special formats, e.g. dates (passing mentions)
    - __joining__ (merging) two datasets: `full_join`, `left_join` and the like
  - Data manipulation on a single dataset
    - __selecting__ variables: `$`, `select`
    - __sorting__ (ordering): `arrange`
    - __subsetting__ (filtering) observations: `filter`
    - __counting__ or __summarising__ values: `table`, `count`, `summary`
    - __aggregating and summarising__ values: `group_by` + `summarise`
  - Recoding and transforming values: `mutate`
    - __'if/else'__ recodes: `if_else` and `case_when`
    - handling __missing values__ (`NA`): `is.na`, `na_if` and `drop_na`
    - type coercion/conversion: `as.numeric`, `as.integer`, `as.character`
    - using __labelled__ variables in esp. survey data: `print_labels`, `as_factor`
    - using __factor__ variables: `factor` and `levels`

_Note that joining datasets is already more advanced than what we wish to cover. We will occasionally use it, just like some of our examples will reshape datasets with `pivot_longer` or manipulate lists with `map`, but these are all outside of the revision scope._

`>` Class 2: __[Support for the implementation of sharia law][d2]__ (WVS)  
`>` Exercise 2: __[U.S. adult obesity][x2]__ (U.S. NHIS)

[d2]: https://github.com/briatte/asr/tree/main/class-02
[x2]: https://github.com/briatte/asr/tree/main/exercise-02

## 3. Visualization

- __Data visualization__, almost exclusively with the `{ggplot2}` package
  - Principles of data abstraction and plotting engines
  - The ‘grammar of graphics’ approach: `ggplot`, `aes`, `geom_*`, `facet_wrap`, `labs`, …
  - Histograms, density curves, bar plots, scatterplots
  - Maps with the `{sf}` + `{ggplot2}` packages
- __Descriptive statistics__ (central tendency, dispersion)
  - For continuous variables: `summary`, `mean`, `sd`, `range` / `min` / `max`
  - Variable standardization (_z_-scores)
  - Normality assessment (i.e. comparison to the normal distribution)
  - Logarithmic transformations with `log`

_Note that, just like last week, visualization in this course will occasionally involve using advanced functions provided by the `{ggrepel}` and `{sf}` packages, but that these are outside of the revision scope. The same goes for the most advanced `{ggplot2}` functions, which will be shown only for demo purposes._

`>` Class 3: __[Life expectancy and GDP/capita][d3]__ (World Bank)  
`>` Exercise 3: __[U.S. adult obesity, continued][x3]__ (U.S. NHIS)

_The code in the exercise for this session shows how to produce survey-weighted estimates with the `{survey}` package, but using the package is not a class requirement for graded work._

[d3]: https://github.com/briatte/asr/tree/main/class-03
[x3]: https://github.com/briatte/asr/tree/main/exercise-03

# Part 2. Bivariate relationships

Basically, significance testing and an introduction to linear regression, to be continued in 2nd-year and 3rd-year courses.

## 4. Association

- estimation of 95% __confidence intervals__
- __comparison of means__ (_t_-tests): `t.test`
- _p_-values and __null hypothesis significance testing__
- quick mention of scientific notation, e.g. `1e-7`

`>` Class 4: __[Life expectancy and colonial origin][d4]__ (World Bank, QOG)  
`>` Exercise 4: _listed at the end of class 4_

<!-- DISTRIBUTE PROJECT INSTRUCTIONS + TEMPLATE -->

[d4]: https://github.com/briatte/asr/tree/main/class-04

## 5. Association (continued)

- __cross-tabulations__ and row/column percentages: `table` and `prop.table`
- __Chi-squared tests__ on ‘crosstabs’: `chisq.test`

The code contains a passing mention of (one-way) __analysis of variance__ (ANOVA), but we do not properly delve into the topic.

`>` Class 5: __[Acceptability of torture][d5]__ (ESS)  
`>` Exercise 5: _listed at the end of class 5_

[d5]: https://github.com/briatte/asr/tree/main/class-05

## 6. Regression

- __analysis of variance__ (ANOVA), again as a passing mention: `aov` + `summary`
- __simple linear regression__ (OLS): `lm` + `summary`
  - coefficients and __goodness-of-fit__
  - regression diagnostics: __fitted values__ and __residuals__
  - using the `{broom}` package to access results: `tidy`, `augment`
  - using the `{texreg}` package to present models: `screenreg`

`>` Class 6: __[Fertility and education][d6]__ (World Bank, Barro & Lee)  
`>` Exercise 6: _listed at the end of class 6_

[d6]: https://github.com/briatte/asr/tree/main/class-06

## 7. Regression (continued)

- revisions and extensions
  - survey data, variable recodes, bar plots, small multiples with `facet_wrap`
  - breaking things down by groups: `count`, `aggregate`
  - __categorical predictors__ (dummies) in regression results
- more advanced topics (passing mentions):
  - multiple linear regression
  - survey-weighted regression with the `{survey}` package
  - if time permits, generalized linear models: `glm` (focused on logistic regression)

`>` Class 7: __[Acceptability of torture, continued][d7]__ (ESS)  
`>` Last documents: [final project template][proj] or [mock final exam][exam]

_See next week for the meaning of the last documents._

[d7]: https://github.com/briatte/asr/tree/main/class-07

[proj]: https://github.com/briatte/asr/tree/main/project-template
[exam]: https://github.com/briatte/asr/tree/main/exam-example

# Part 3. Closing

## 8. Wrap-up

Bonus documents, distributed much earlier in the term:

- [What to learn and to revise for the tutorials][revise]
- [Survey research project instructions][projects] (if relevant)

`>` Class 8(a): [mock final exam][exam] (QOG)  
`>` Class 8(b): [final project template][proj] (U.S. NHIS)  

_The final assessment is either-or -- students get to complete one or the other, not both. The eighth tutorial wraps things up and includes class presentations of the (draft) student projects if that is the assessment option used. The lecture comes with its own exam in all cases. The total volume of teaching is around 40 hours, 24h lecture + 16h tutorials._

* * *

# Dependencies

The course runs on R 4.x and depends on the following packages:

```r
install.packages("remotes")

# required for the classes and exercises
pkgs <- c("broom", "ggrepel", "sf", "survey", "texreg", "tidyverse")
remotes::install_cran(pkgs)

# required to produce the data extracts
remotes::install_cran(c("countrycode", "WDI", "writexl"))
```
