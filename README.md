# `>` Tutorials in Applied Statistics with R and RStudio

> [François Briatte](https://f.briatte.org/)  
> Spring 2025. __Work in progress.__

Tutorials in ~~applied stats~~ data science with [R][r], [RStudio][rstudio], and the [`{tidyverse}`][tidyverse] packages, aimed at social science undergraduates with absolutely zero training in statistical computing whatsoever.

[r]: https://www.r-project.org/
[rstudio]: https://posit.co/products/open-source/rstudio/
[tidyverse]: https://www.tidyverse.org/

The content is very much related to [this other course](https://github.com/briatte/dsr), which is aimed at slightly older students with more study time.

This folder contains the code, data and documentation of the examples used either during the practice sessions in class, or distributed as homework exercises. __Slides and exercise solutions are not included.__

__Very much work in progress. The list of topics covered in each session, especially, is very tentative and subject to change.__

# Outline

1. [Software](#1-software)
2. [Data](#2-data)
3. [Visualization](#3-visualization)
4. [Association](#4-association)
5. [Association (continued)](#5-association-continued)
6. [Regression](#6-regression)
7. [Regression (continued)](#7-regression-continued)
8. Wrap-up

Bonus section: [dependencies](#dependencies).

# Part 1. Basics

Software setup, first steps with coding, handling data, and plotting things.

## 1. Software

- RStudio interface
  - The panes layout
  - Setting preferences
  - Executing code from the Console
  - Clearing the Console: `Ctrl-L`
  - Executing code from a script: `Ctrl-Enter`
- R syntax
  - Comments (`#`) and code
  - Functions and arguments
  - Objects and assignment: `<-`
  - Package installation

`>` Demo 1: __[Cholera deaths in London, 1854][d1]__ (John Snow)  
`>` Exercise 1: __[Support for Ukraine joining the EU][x1]__ (Eurobarometer)

[d1]: https://github.com/briatte/asr/tree/master/class-01
[x1]: https://github.com/briatte/asr/tree/master/exercise-01

## 2. Data

- More on the RStudio interface
  - Setting the working directory
  - Doing so by using RStudio project files: `.Rproj`
  - The Files and Plots panes
  - Executing code down to a given line: `Ctrl-Alt-B`
- More R syntax essentials
  - Code spanning multiple lines, and pipes: `%>%`, `|>`
  - R objects and types
  - Data frames, variables and values
  - R has many packages and sub-syntaxes: base, `{tidyverse}`, `{ggplot2}`, etc.
- Data wrangling, mostly with the `{dplyr}` package
  - Data I/O
    - reading/writing datasets with `{readr}`, `{haven}` and `{readxl}`
    - inspecting datasets: `head`, `glimpse`, `view`
    - using factors with survey data
    - passing mentions -- strings, dates and special formats
  - Data manipulation on a single dataset
    - selecting variables: `$`, `select`
    - sorting (ordering): `arrange`
    - subsetting: `filter`
    - aggregating and summarising values: `group_by` + `summarise`
  - Data manipulation on multiple datasets
    - joining (merging) two datasets: `full_join` and the like
    - binding multiple datasets: `bind_rows`
  - Recoding and transforming values: `mutate`
    - 'if/else' recodes: `if_else` and `case_when`
    - type coercion/conversion: `as.numeric`, `as.integer` etc.
    - handling missing values: `is.na`, `na_if`, `drop_na`

`>` Demo 2: __[Support for the implementation of sharia law][d2]__ (WVS c. 2000)  
`>` Exercise 2: __[U.S. adult obesity][x2]__ (U.S. NHIS 2018)

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

`>` Demo 3: __[Life expectancy and GDP/capita][d3]__ (World Bank)  
`>` Exercise 3: __[U.S. adult obesity, continued][x3]__ (U.S. NHIS 2018)

[d3]: https://github.com/briatte/asr/tree/master/class-03
[x3]: https://github.com/briatte/asr/tree/master/exercise-03

* * *

# Dependencies

The course runs on R 4.x and depends on the following packages:

```r
install.packages("remotes")

# required for the tutorials and exercises
pkgs <- c("broom", "countrycode", "ggrepel", "performance", "sf", "texreg", 
          "survey", "tidyverse")
remotes::install_cran(pkgs)

# required to produce the exercise data
ex <- c("WDI", "writexl")
remotes::install_cran(ex)
```
