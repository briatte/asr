# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Obesity prevalence in the United States (Part 2), Script 1/4
#
# ==================== See the README file for data sources and instructions ===

# required packages -------------------------------------------------------

library(tidyverse)

# import ------------------------------------------------------------------

nhis <- haven::read_dta("data/nhis2018.dta.zip")

# take a quick look (uncomment to run, or type in the Console)
# glimpse(nhis)
# View(nhis)

# note how some variables come with labels (`lbl`)
# we covered labelled variables with Exercise 2
# more on them below, as a means of revision

nrow(nhis) # number of observations

# recode sex --------------------------------------------------------------

# let's quickly revise factors
# in this dataset, sex is coded as `1` or `2`
table(nhis$sex)

# however, it is also coded as labelled values
# 1 = "1 Male"
# 2 = "2 Female"
count(nhis, sex)

# as we saw before, you can replace the values
# with the value labels with haven::as_factor
table(as_factor(nhis$sex))

# however, if you want to change the order of the levels (females first!) and
# also change their (text) labels, you will have to use the `factor` function
# to relevel and relabel the variable, as shown below
nhis$sex <- factor(nhis$sex, levels = c(2, 1), labels = c("Female", "Male"))

# final coding (1 = female, 2 = male)
count(nhis, sex)

# percentages (relative frequencies)
prop.table(table(nhis$sex))

# recode 'race' -----------------------------------------------------------

# remember: `exclude = NULL` is required to show missing values (`NA`)
table(nhis$race, exclude = NULL)

# show levels (1, 2, 3, 4) and their labels
count(nhis, race)

# here, let's simply replace the value with their labels
nhis$race <- haven::as_factor(nhis$race)
count(nhis, race)

# percentages (including missing values)
prop.table(table(nhis$race, exclude = NULL))

# to produce percentages, the code above basically counts observations and then
# divides that by the total number of observations (the total number of rows)
table(nhis$race, exclude = NULL) / nrow(nhis)

# cross-tabulations will use the same syntax
prop.table(table(nhis$sex, nhis$race))
prop.table(table(nhis$sex, nhis$race), 1) # row percentages
prop.table(table(nhis$sex, nhis$race), 2) # column percentages

# for something that looks closer to an actual table, you will need more code
# the example below shows row percentages, rounded up to the first decimal
with(nhis, round(100 * prop.table(table(sex, race), 1), 1))

# we will come back to 'crosstabs' later on

# compute Body Mass Index -------------------------------------------------

# we saw in the past exercise (or just by reading the data documentation) that
# some values of `height` and `weight` are actually missing values
nhis$height[ nhis$height >= 96 ] <- NA
nhis$weight[ nhis$weight >= 996 ] <- NA

nhis$bmi <- 703 * nhis$weight / nhis$height^2

# here's another way to do the above in a slightly more readable code
nhis <- nhis %>%
  mutate(weight = if_else(weight >= 996, NA, weight),
         height = if_else(height >= 96, NA, height),
         bmi = 703 * weight / height^2)

# an advantage of the code above is that it can be 'chained' with `%>%` to
# continue performing operations on it; for instance, here's how to subset the
# data to just Black females, and then to select only a few columns/variables,
# and then to show only a sample of observations
filter(nhis, sex == "Female", race == "Black") %>%
  select(h_id, age, sex, race, bmi) %>%
  slice_sample(n = 5)

# this:
#
# data %>%
#   mutate(...) %>%
#   filter(...) %>%
#   etc.
#
# is the same as that:
#
# mutate(data, ...) %>%
#   filter(...) %>%
#   etc.

# last, here's the same result as in Exercise 2
summary(nhis$bmi)

# export the processed dataset --------------------------------------------

readr::write_rds(nhis, "data/nhis2018.rds", compress = "xz")

# kthxbye
