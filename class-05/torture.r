# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Acceptability of torture
#
# ============================= See README file for data sources and details ===

# required packages -------------------------------------------------------

library(tidyverse)

# data inspection ---------------------------------------------------------

# loaded zipped Stata dataset
ess4 <- haven::read_dta("data/ESS4e04_6_extract.dta.zip")

# data overview
glimpse(ess4)
# view(ess4)

# countries surveyed
table(ess4$cntry)

# dependent variable
# haven::print_labels(ess4$trrtort)
count(ess4, trrtort)

# country-level overview --------------------------------------------------

# reorder countries by average level of dependent variable
ess4$cntry <- forcats::fct_reorder(ess4$cntry, ess4$trrtort, mean)
# create factor version of the dependent variable (showing labels)
ess4$torture <- haven::as_factor(ess4$trrtort)

# stacked percentages, with countries in reverse order (first = most opposed)
with(filter(ess4, trrtort < 6), table(cntry, torture)) %>%
  prop.table(1) %>%
  as_tibble() %>%
  ggplot(aes(n, factor(cntry, rev(levels(ess4$cntry))),
             fill = factor(torture, levels(ess4$torture)[1:5]))) +
  geom_bar(stat = "identity") +
  scale_fill_brewer("", palette = "RdBu") +
  labs(title = "Torture never justified, even to prevent terrorism (%)",
       subtitle = "European Social Survey Round 4, 2008", y = NULL, x = NULL)

# notes: this is obviously much more advanced coding than you should be able to
# perform yourself by now, but the ingredients have all been introduced in past
# tutorials, or will be in this one; also note that we are completely excluding
# missing values (respondents who did not provide an answer)

# analysis of variance ----------------------------------------------------

# total variance
var(ess4$trrtort, na.rm = TRUE)

# variance per country
aggregate(trrtort ~ cntry, var, data = ess4)

# between-country variance versus within-country variance
aov(trrtort ~ cntry, data = ess4)

# significance test
summary(aov(trrtort ~ cntry, data = ess4))

# data preparation --------------------------------------------------------

ess4 <- mutate(ess4, oppose_torture = case_when(trrtort %in% 1:2 ~ "Agree",
                                                trrtort == 3 ~ "Neither",
                                                trrtort %in% 4:5 ~ "Disagree",
                                                .default = NA),
               # age groups: 15-34, 35-44, 45-54, 55-64, 65+
               age_group = cut(agea, c(14, 34, 44, 54, 64, Inf)),
               sex = if_else(gndr == 1, "Male", "Female"))

# check recodes
count(ess4, oppose_torture)
count(ess4, age_group)
count(ess4, sex)

# cross-tabulations -------------------------------------------------------

# opposition to torture by sex
table(ess4$sex, ess4$oppose_torture)

# note on how the `table` function excludes missing values by default
# here's how to change that
table(ess4$sex, ess4$oppose_torture, exclude = NULL)

# here's another way to create the table
by_sex <- with(ess4, table(sex, oppose_torture))
by_sex

# pass that 2 x 3 table (a cross-tabulation, or 'crosstab') to the `prop.table`
# function to get cell, row or column percentages

prop.table(by_sex)
prop.table(by_sex, 1) # row percentages
prop.table(by_sex, 2) # col percentages

# Chi-squared test
chisq.test(by_sex)

# opposition to torture by age group
by_age <- with(ess4, table(age_group, oppose_torture))
# row percentages by age group, rounded to two decimals
round(prop.table(by_age, 1), 2)

# Chi-squared test
chisq.test(by_age)

# details
chisq.test(by_age)$observed
chisq.test(by_age)$expected
chisq.test(by_age)$residuals

# exercise ----------------------------------------------------------------

# step 0: read the docs to understand what the `lrscale` variable measures
# step 1: recode `lrscale` to leftwing (0-4), centre (5), rightwing (6-10)
# step 2: is opposition to torture different on the left and on the right?


# kthxbye
