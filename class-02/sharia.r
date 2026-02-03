# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Support for the application of sharia law, c. 2000
#
# ============================= See README file for data sources and details ===

# required packages -------------------------------------------------------

library(dplyr)   # transform data
library(ggplot2) # visualize data
library(haven)   # open Stata datasets
library(readr)   # open CSV / plain text datasets
library(readxl)  # open Microsoft Excel datasets

# how to open a CSV dataset -----------------------------------------------

# syntax: read_csv("path/to_the_data.csv")
bgd <- readr::read_csv("data/wv4_bangladesh.csv")

# check the result in the Console by typing the object name + [Enter]

# inspect the data
dplyr::glimpse(bgd) # using `dplyr`
str(bgd) # using base R

nrow(bgd) # number of rows

head(bgd) # first 5 rows
tail(bgd) # last 5 rows

# values of variable `V223`
bgd$V223

# distinct values, as a table with counts
table(bgd$V223)

# what you need to understand from the above
#
# - syntax:
#   - objects and how to create them with `<-`
#   - packages, functions, arguments
#
# - jargon:
#   - datasets / data frames / tibbles
#   - rows / observations / values
#   - columns / variables
#
# - printing:
#   - entire objects, esp. data frames
#   - selected variables in data frames

# how to open an Excel dataset --------------------------------------------

bgd <- readxl::read_excel("data/wv4_bangladesh.xlsx", guess_max = 10^4)

# check the result in the 'Environment' tab

# result is identical, and the optional argument above is shown to illustrate
# the fact that `read_*` functions generally have many useful options to e.g.
# change the file encoding, skip empty rows, etc.

# try typing the function above 'interactively', in your Console
#
# - type "read_", select the right function, and press Tab
# - press Tab again to see the arguments, then type ", and press Tab
# - select the right file, and press Enter

# what you need to understand from the above
#
# - some of your code will be typed in an 'improvised' way, directly into the
#   Console, to try out things and get preliminary results
#
#   (interactive functions like `glimpse` are generally used there)
#
# - once you get the right result, save the relevant function in your script,
#   and add a brief comment to explain what it does
#
# - RStudio has auto-complete functionalities
#
#   (requires packages to have been loaded first)
#
# - R has extensive technical documentation
#
#   e.g. ?head
#   e.g. ?readr::read_csv (if the `readr` package was installed first)
#   e.g. ?read_csv (if the `readr` package was installed AND loaded first)
#
# - RStudio can preview objects in the 'Environment' pane

# how to open a Stata dataset ---------------------------------------------

wvs <- haven::read_dta("data/wv4_islam_subset.dta")

glimpse(wvs) # no need to use the `dplyr::` prefix, package has been loaded

# since it looks like the data has labels ("lbl"), take a look at it in the
# 'Environment' pane, or view it in a separate window using the `View` function
View(wvs)

# labels of the `V223` variable
haven::print_labels(wvs$V223)

# replace values with labels
haven::as_factor(wvs$V223)

# show counts of the values after replacing them with labels
table(haven::as_factor(wvs$V223))

# what you need to understand from the above
#
# - most of our data are going to be either numeric (1, 2, -99) or "text",
#   a.k.a. character / strings ("Male", "Female")
#
# - in survey data, variables can have labels assigned to their values, and
#   using 'factors' is a way to deal with these (we'll come back to it)

# counting and summarising ------------------------------------------------

# if you check the age variable, negative values code for missing values
haven::print_labels(wvs$V225)

# do these values exist in the data?
table(wvs$V225, exclude = NULL)
table(wvs$V225 < 0, exclude = NULL)

# be careful with `table` -- it does not show NA values by default
# use `exclude = NULL` to always show them

# if there were negative values, you would do this
wvs$V225[ wvs$V225 < 0 ] <- NA

# age is numeric / continuous, so...
summary(wvs$V225)
mean(wvs$V225, na.rm = TRUE) # `na.rm = TRUE` removes missing values

# if you check the sex variable, two values code for missing values
haven::print_labels(wvs$V223)

# do these values exist in the data?
table(wvs$V223, exclude = NULL)
table(wvs$V223 < 0 | wvs$V223 == 9)

# sex is nominal / categorical, so...
table(wvs$V223)

# but wait, there are multiple countries in the data, so...
table(wvs$B_COUNTRY_ALPHA, wvs$V223)

# same thing, but using the value labels for sex
table(wvs$B_COUNTRY_ALPHA, as_factor(wvs$V223))

# same thing, but using two possible logical tests to count females
table(wvs$B_COUNTRY_ALPHA, wvs$V223 != 1)
table(wvs$B_COUNTRY_ALPHA, as_factor(wvs$V223) != "Male")

# that's your first 'crosstab' (cross-tabulation) right there

# what you need to understand from the above
#
# - some variables are continuous in nature, others are categorical, and these
#   variable types will determine how we summarise / model these variables
#
#   understanding this requires practice, since some variables can be handled
#   in multiple ways (e.g. 5-point scales or 0/1 variables, as shown below)
#
# - R can perform logical tests where TRUE = 1 and FALSE = 0
#
#   in such tests, & means AND, | means OR, and ! means NOT
#
# for more complex operations, e.g. percentage of females or average age per
# country, we need you to be more comfortable with R syntax first, and we also
# need to learn how to rename and recode variables, in order to handle missing
# values or because we want slightly different variables than the data hold

# recoding values ---------------------------------------------------------

# there's a million way to recode any variable, e.g. sex
table(wvs$V223, exclude = NULL)

# here's a valid but cumbersome way to do it: create a new 'empty' variable
# with NA values, then change its values according to those in `V223`
wvs$sex <- NA
wvs$sex[ wvs$V223 == 1 ] <- "Male"
wvs$sex[ wvs$V223 == 2 ] <- "Female"
table(wvs$sex, exclude = NULL)

# since we are using Stata data with values, another solution is to use
# `as_factor` like we have before, but for demonstration purposes, let's
# recode sex to a dummy (a binary = 0/1 variable)
wvs$female <- NA
wvs$female[ wvs$V223 == 1 ] <- 0 # 0 = male
wvs$female[ wvs$V223 == 2 ] <- 1 # 1 = female
table(wvs$female, exclude = NULL)

# now that sex is coded as 0/1, the mean makes sense
mean(wvs$female, na.rm = TRUE)

# note how we continue to exclude missing values in the function above, even
# though we know that there are none; always be careful of missing values, and
# always make sure that you are excluding them from your operations, otherwise
# you will get NA results due to R 'propagating' them to the results:

# here's an example of R refusing to compute a mean
mean(wvs$V225)

# this happens because some age values are missing
table(is.na(wvs$V225))

# and here's another way to count non-missing values
sum(!is.na(wvs$V225))

# recoding and aggregating with the `tidyverse` ---------------------------

# let's get to a more complex example
table(as_factor(wvs$IV166), wvs$B_COUNTRY_ALPHA, exclude = NULL)

# the goal is to get (and understand!) the following results
group_by(wvs, country = V2) %>%
  mutate(sharia = if_else(IV166 < 5, IV166, NA),
         prosharia = case_when(sharia %in% 1:2 ~ 1,
                               sharia %in% 3:5 ~ 0, .default = NA)) %>%
  summarise(prosharia = 100 * mean(prosharia, na.rm = TRUE),
            n = n(), missing = sum(is.na(sharia)))

# step number one is to make sure that we exclude any missing values from the
# `IV166` variable, and then step number two is to 'recode' responses 1 and 2
# into value 1 (agree), and the other responses into value 0 (disagree)
wvs$sharia <- if_else(wvs$IV166 < 5, wvs$IV166, NA)
wvs$prosharia <- if_else(wvs$sharia < 3, 1, 0)

mean(wvs$prosharia, na.rm = TRUE) # percentage across all countries

# the `mutate` function lets you do the above with less clutter
wvs <- mutate(wvs, sharia = if_else(IV166 < 5, IV166, NA),
              prosharia = if_else(sharia < 3, 1, 0))

mean(wvs$prosharia, na.rm = TRUE) # percentage across all countries

# note that the second recode above, the one that creates `prosharia`, can be
# performed with `case_when`, which gives you more flexibility than `if_else`

# in the final step, we 'chain' operations with the `%>%` pipe function, which
# allows us to (1) group the data, and then (2) summarise it within each group
# here's a different example for you to get the logic of it:
group_by(wvs, V2) %>%
  summarise(average_age = mean(V225, na.rm = TRUE))

# here's a more elaborate sequence that excludes Nigeria, renames `V2` on the
# fly, and includes counts of all observations and missing values per country
filter(wvs, V2 != 566) %>%
  group_by(country = V2) %>%
  summarise(average_age = mean(V225, na.rm = TRUE),
            n = n(), missing_age = sum(is.na(V225)))

# now back to our previous example, where we use all of the above to
#
# 1 - group the data by country and by sex
# 2 - use value labels for these variables
# 3 - recode support for sharia law as a 0/1 dummy
# 4 - compute average support by country/sex
# 5 - plot the result (more on that next week!)
#
group_by(wvs, country = V2, sex = V223) %>%
  mutate(country = as_factor(country),
         sex = as_factor(sex),
         prosharia = if_else(IV166 < 5, IV166, NA),
         prosharia = case_when(IV166 %in% 1:2 ~ 1,
                               IV166 %in% 3:5 ~ 0, .default = NA)) %>%
  summarise(prosharia = 100 * mean(prosharia, na.rm = TRUE), n = n()) %>%
  ggplot(aes(y = country, x = prosharia, fill = sex)) +
    geom_col(position = position_dodge2(reverse = TRUE)) +
    scale_fill_discrete("Sex") +
    labs(title = "Support for implementation of sharia law",
         subtitle = "WVS Wave 4, 1999-2004",
         y = NULL, x = "% agree strongly agree")

# take a few minutes to reflect on what we did:
#
# - what's the survey design
#   - sampling frame
#   - survey weights
#   - collection mode
#   - question wording
# - what's the proportion of missing values? (check Nigeria again)
# - what choices did we make while recoding the 'dependent' variable?
# - did we observe 'significant' differences? (trick question)
#
# that's a lot of different research steps: (1) get the data, (2) understand it,
# (3) prepare it for analysis, making informed choices, (4) get some results,
# (5) visualize the results, and (6) think critically about them
#
# you'll need a lot of practice to get through all steps, so as a take-home
# exercise, (1) go through this entire script again, executing the code as you
# read through it, (2) read some of the additional resources mentioned in my
# slides, and (3) take two hours to work on the exercise for next week

# kthxbye
