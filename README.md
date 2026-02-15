# `>` Tutorials in Applied Stats with R and RStudio

> [François Briatte](https://f.briatte.org/)  
> Spring 2026. __Work in progress.__

Teaching material for some tutorials in ~~applied statistics~~ data science with [R][r], [RStudio][rstudio], and the [`{tidyverse}`][tidyverse] packages, aimed at social science undergraduates with zero prior training in statistical computing whatsoever.

[r]: https://www.r-project.org/
[rstudio]: https://posit.co/products/open-source/rstudio/
[tidyverse]: https://www.tidyverse.org/

The content is very much related to [this other course](https://github.com/briatte/dsr), which is aimed at slightly older students with more study time and marginally better computing skills.

This folder contains the code, data and documentation of the examples used either during the practice sessions in class, or distributed as homework exercises. __Slides and exercise solutions are not included.__

__Very much work in progress.__ The list of topics covered in each session, especially, is very tentative and subject to change.

# Outline

1. [Software](#1-software)
2. [Data](#2-data)
3. [Visualization](#3-visualization)
4. [Association](#4-association)
5. [Association (continued)](#5-association-continued)
6. [Regression](#6-regression)
7. [Regression (continued)](#7-regression-continued)
8. Wrap-up

Bonus section: [dependencies](#dependencies)

# Part 1. Basics

Software setup, first steps with coding, handling data, and plotting things.

## 1. Software

- __RStudio interface__
  - The panes layout
  - Setting preferences
  - Executing code from the Console
  - Clearing the Console: `Ctrl-L`
  - Executing code from a script: `Ctrl-Enter`
- __R syntax__
  - Comments (`#`) and code
  - Functions and arguments
  - Objects and assignment: `<-`
  - Package installation

`>` Class 1: __[Cholera deaths in London, 1854][d1]__ (John Snow)  
`>` Exercise 1: __[Support for Ukraine joining the EU][x1]__ (Eurobarometer)

[d1]: https://github.com/briatte/asr/tree/master/class-01
[x1]: https://github.com/briatte/asr/tree/master/exercise-01

## 2. Data

- More on the RStudio interface
  - Setting the __working directory__
  - Doing so by using RStudio project files: `.Rproj`
  - The Files and Plots panes
  - Executing code down to a given line: `Ctrl-Alt-B`
- More R syntax essentials
  - Code spanning multiple lines, and pipes: `%>%`, `|>`
  - R objects and types
  - Data frames, variables and values
  - R has many packages and sub-syntaxes: base, `{tidyverse}`, `{ggplot2}`, etc.
- __Data wrangling__, mostly with the `{dplyr}` package
  - __Data I/O__
    - reading/writing datasets with `{readr}`, `{haven}` and `{readxl}`
    - inspecting datasets: `head`, `glimpse`, `view`
    - using __factors__ ('labelled' variables) with esp. survey data
    - passing mentions -- strings and other special formats, e.g. dates
  - Data manipulation on a single dataset
    - __selecting__ variables: `$`, `select`
    - __sorting__ (ordering): `arrange`
    - __subsetting__ (filtering) observations: `filter`
    - __aggregating and summarising__ values: `group_by` + `summarise`
  - Recoding and transforming values: `mutate`
    - __'if/else'__ recodes: `if_else` and `case_when`
    - type coercion/conversion: `as.numeric`, `as.integer` etc.
    - handling __missing values__ (`NA`): `is.na`, `na_if`, `drop_na`
 - Data manipulation on multiple datasets
   - __joining__ (merging) two datasets: `full_join`, `left_join` and the like

`>` Class 2: __[Support for the implementation of sharia law][d2]__ (WVS)  
`>` Exercise 2: __[U.S. adult obesity][x2]__ (U.S. NHIS)

[d2]: https://github.com/briatte/asr/tree/master/class-02
[x2]: https://github.com/briatte/asr/tree/master/exercise-02

## 3. Visualization

- Data visualization, mostly with the `{ggplot2}` package
  - Principles of data abstraction
  - Plotting engines
  - The ‘grammar of graphics’ approach
- Descriptive statistics (central tendency, dispersion)
  - Variable standardization (_z_-scores)
  - Normality assessment
  - Logarithmic transformations

`>` Class 3: __[Life expectancy and GDP/capita][d3]__ (World Bank)  
`>` Exercise 3: __[U.S. adult obesity, continued][x3]__ (U.S. NHIS)

[d3]: https://github.com/briatte/asr/tree/master/class-03
[x3]: https://github.com/briatte/asr/tree/master/exercise-03

## 4. Association

- estimation of __confidence intervals__
- __comparison of means__ (_t_-tests)
- _p_-values and __null hypothesis significance testing__

`>` Class 4: __[Life expectancy and colonial origin][d4]__ (World Bank, QOG)  
`>` Exercise 4: _listed at the end of class 4_

<!-- DISTRIBUTE PROJECT INSTRUCTIONS + TEMPLATE -->

[d4]: https://github.com/briatte/asr/tree/master/class-04
<!-- [x4]: https://github.com/briatte/asr/tree/master/exercise-04 -->

## 5. Association (continued)

- __cross-tabulations__
- __Chi-squared tests__

The code contains a passing mention of (one-way) __analysis of variance__ (ANOVA), but we do not properly delve into the topic.

`>` Class 5: __[Acceptability of torture][d5]__ (ESS)  
`>` Exercise 5: _listed at the end of class 5_

[d5]: https://github.com/briatte/asr/tree/master/class-05
<!-- [x5]: https://github.com/briatte/asr/tree/master/exercise-05 -->

## 6. Regression

- __analysis of variance__ (ANOVA), again as a passing mention
- __simple linear regression__ (OLS)
  - coefficients and __goodness-of-fit__
  - regression diagnostics: __residuals__

`>` Class 6: __[Fertility and education][d6]__ (World Bank, Barro & Lee)  
`>` Exercise 6: _listed at the end of class 6_

[d6]: https://github.com/briatte/asr/tree/master/class-06
<!-- [x6]: https://github.com/briatte/asr/tree/master/exercise-06 -->

## 7. Regression (continued)

`>` Class 7: __[Acceptability of torture, continued][d7]__ (ESS)  
`>` _Wrap-up: projects, exams etc._

<!-- WEEK 8 PPE = PROJECT PRESENTATIONS -->
<!-- WEEK 8 RI = EXAM REVISIONS -->

[d7]: https://github.com/briatte/asr/tree/master/class-07
<!-- [x7]: https://github.com/briatte/asr/tree/master/exercise-07 -->

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
