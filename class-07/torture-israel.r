# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Acceptability of torture (continued)
#
# ============================= See README file for data sources and details ===

# required packages -------------------------------------------------------

library(survey)
library(tidyverse)

# data preparation --------------------------------------------------------

# ESS Round 4 data for Israel, c. 2008
il <- haven::read_dta("data/ESS4e04_6_IL.dta.zip") %>%
  # data preparation
  mutate(sex = if_else(gndr == 1, "Male", "Female"),
         # age groups: 15-34, 35-44, 45-54, 55-64, 65+
         age_group = cut(agea, c(14, 34, 44, 54, 64, Inf)),
         # simplify religious denomination
         religion = case_when(rlgdnm %in% 1:4 ~ "Christian",
                              rlgdnm == 5 ~ "Jewish",
                              rlgdnm == 6 ~ "Muslim",
                              .default = NA),
         # dependent variable: attitudes towards torture (5-pt scale)
         trrtort = if_else(trrtort > 5, NA, trrtort),
         # recoded dependent variable: 1 = (some) support for torture
         support_torture = if_else(trrtort > 3, 1, 0))

# dependent variable ------------------------------------------------------

# initial coding, categorical (ordinal), treatable as continuous
count(drop_na(il, trrtort), trrtort) %>%
  mutate(pct = n / sum(n))

# recoded as a dummy (binary)
count(drop_na(il, support_torture), support_torture) %>%
  mutate(pct = n / sum(n))

# check recode and missing values
table(il$trrtort, il$support_torture, exclude = NULL)

# predictor 1: sex --------------------------------------------------------

table(il$sex, exclude = NULL)

# percentages
count(il, sex) %>%
  mutate(pct = n / sum(n))

# predictor 2: age (recoded as groups) ------------------------------------

table(il$age_group, exclude = NULL)

# percentages
count(drop_na(il, age_group), age_group) %>%
  mutate(pct = n / sum(n))

# predictor 3: religion ---------------------------------------------------

# religion
count(drop_na(il, religion), religion) %>%
  mutate(pct = n / sum(n))

# initial coding of religious denominations
count(il, rlgdnm)

# descriptive stats -------------------------------------------------------

# rates of support for torture by age and sex
aggregate(support_torture ~ sex, mean, data = il)
aggregate(support_torture ~ age_group, mean, data = il)

# rates of support for torture by age + sex
by_age_and_sex <- aggregate(support_torture ~ sex + age_group, mean, data = il)
by_age_and_sex

# bar plot example (1)
ggplot(by_age_and_sex, aes(x = support_torture, fill = sex)) +
  geom_col(aes(y = forcats::fct_rev(age_group)), position = position_dodge()) +
  labs(y = NULL, x = "% support for torture")

# bar plot example (2)
ggplot(by_age_and_sex, aes(y = support_torture, x = age_group)) +
  geom_col() +
  facet_wrap(~ sex) +
  labs(x = NULL, y = "% support for torture")

# rates of support for torture by religion
aggregate(support_torture ~ religion, mean, data = il)

# bivariate relationships -------------------------------------------------

# by age
by_age <- with(il, table(age_group, support_torture))
prop.table(by_age, 1)
chisq.test(by_age)

# average age among supporters and non-supporters
t.test(agea ~ support_torture, data = il)

# how does age correlate to the initial coding of the dependent variable?
with(il, cor(agea, trrtort, use = "complete"))

# is there a linear relationship between these variables?
summary(lm(trrtort ~ agea, data = il))

# by sex
by_sex <- with(il, table(sex, support_torture))
prop.table(by_sex, 1)
chisq.test(by_sex)

# is there more variation within or between the male and female groups?
# (using the initial coding of the dependent variable)
summary(aov(trrtort ~ sex, data = il))

# by religion
by_religion <- with(il, table(religion, support_torture))
prop.table(by_religion, 1)
chisq.test(by_religion)

# do religious groups share the same socio-demographic composition?
prop.table(with(il, table(religion, age_group)), 1)
prop.table(with(il, table(religion, sex)), 1)

# bar plot example (3)
aggregate(support_torture ~ religion + age_group + sex, mean, data = il) %>%
  # excluding Christians (insufficient number of observations per subgroup)
  filter(religion != "Christian") %>%
  ggplot(aes(y = support_torture, x = age_group, fill = sex)) +
  geom_col() +
  facet_wrap(~ sex + religion, nrow = 1) +
  labs(x = NULL, y = "% support for torture")

# (simple) linear regression with dummies ---------------------------------

# be reminded that higher values of `trrtort` indicate more support for torture
haven::print_labels(il$trrtort)

# let's model the initial variable as a function of sex
summary(lm(trrtort ~ sex, data = il))

# to understand what the results mean, here's average support for torture for
# females, which is the same as the intercept in the model above
mean_for_females <- mean(il$trrtort[ il$sex == "Female" ], na.rm = TRUE)
mean_for_females

# males expressed marginally more support for torture on average
mean_for_males <- mean(il$trrtort[ il$sex == "Male" ], na.rm = TRUE)
mean_for_males

# the coefficient in the model above is the difference between both sexes
mean_for_males - mean_for_females

# females do not appear in the model because they are treated as the 'baseline'
# or 'reference category' of the model (R uses the first level of `sex` as the
# baseline by default, which here is 'Female' by alphabetical order)

# repeat with age groups (baseline = first age group, 15-34 year-old)
summary(lm(trrtort ~ age_group, data = il))

# repeat with religion (baseline = first denomination, Christian)
summary(lm(trrtort ~ religion, data = il))

# (multiple) linear regression --------------------------------------------

# on top of not being statistically significant, the differences in attitudes
# observed among religious groups might actually be attributable to different
# underlying socio-demographics

# let's model the initial variable as a function of religion while controlling
# for age and sex, which is a more advanced model than what we have done so far
summary(lm(trrtort ~ sex + age_group + religion, data = il))

# an arguably better model would also take survey weights into account
survey::svydesign(~ idno, probs = ~ anweight, data = il) %>%
  survey::svyglm(trrtort ~ sex + age_group + religion, design = .) %>%
  summary()

# in the models above, the baseline is young (15-34) Christian females, based
# on the first levels of all categorical predictors included

# there are even more appropriate ways to estimate that model, but the above is
# already much more advanced than what we intend to cover in these tutorials

# welcome to the end of our tutorials, hope you enjoyed the ride!

# 888    888                        888
# 888    888                        888
# 888    888                        888
# 888888 88888b.   8888b.  88888b.  888  888      888  888  .d88b.  888  888
# 888    888 "88b     "88b 888 "88b 888 .88P      888  888 d88""88b 888  888
# 888    888  888 .d888888 888  888 888888K       888  888 888  888 888  888
# Y88b.  888  888 888  888 888  888 888 "88b      Y88b 888 Y88..88P Y88b 888
#  "Y888 888  888 "Y888888 888  888 888  888       "Y88888  "Y88P"   "Y88888
#                                                     888
#                                                Y8b d88P
#                                                 "Y88P"

# kthxbye
