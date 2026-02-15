# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# STUDENT RESEARCH PROJECT - 15 March 2026
#
# Group No. 7
#
# - Full Student Name 1
# - Full Student Name 2
# - Full Student Name 3
#
# Topic: Health Inequalities in the United States, 2018
#
# ======================== See the final report for data sources and details ===

# required packages

library(tidyverse)

# ------------------------------------------------------------------------------
# DATA: U.S. National Health Interview Survey 2018
# ------------------------------------------------------------------------------

nhis <- haven::read_dta("data/nhis2018.dta.zip")

nrow(nhis) # full sample size

# ------------------------------------------------------------------------------
# DEPENDENT VARIABLE: self-reported health status
# ------------------------------------------------------------------------------

count(nhis, health)

# recode missing values
nhis$health[ nhis$health > 5 ] <- NA

# percentages
count(nhis, health) %>%
  mutate(percent = 100 * n / sum(n))

# ------------------------------------------------------------------------------
# PREDICTOR 1 = sex
# ------------------------------------------------------------------------------

# initial coding: 1 = male, 2 = female
count(nhis, sex)

# recode as text
nhis$female <- if_else(nhis$sex == 1, "0. Male", "1. Female")

# percentages
count(nhis, female) %>%
  mutate(percent = 100 * n / sum(n))

# ------------------------------------------------------------------------------
# PREDICTOR 2 = age
# ------------------------------------------------------------------------------

count(nhis, age)

# recode to groups
nhis$age_group <- case_when(nhis$age < 25 ~ "18-24",
                            nhis$age < 35 ~ "25-34",
                            nhis$age < 45 ~ "35-44",
                            nhis$age < 55 ~ "45-54",
                            nhis$age < 65 ~ "55-64",
                            nhis$age > 64 ~ "65+")

# check recoding (.1 = min, .2 = max)
aggregate(age ~ age_group, range, data = nhis)

# percentages
count(nhis, age_group) %>%
  mutate(percent = 100 * n / sum(n))

# ------------------------------------------------------------------------------
# PREDICTOR 3 = race
# ------------------------------------------------------------------------------

count(nhis, race)

# replace values with labels
nhis$race <- haven::as_factor(nhis$race)

# percentages (without missing values)
count(drop_na(nhis, race), race) %>%
  mutate(percent = 100 * n / sum(n))

# ------------------------------------------------------------------------------
# PREDICTOR 4 = earnings
# ------------------------------------------------------------------------------

count(nhis, earnings)

# recode missing values
nhis$earnings[ nhis$earnings > 11 ] <- NA

# recode to 3 income bands (source for bands below)
nhis$income_band <- case_when(nhis$earnings %in% 1:5 ~ "1. Low",
                              nhis$earnings %in% 6:10 ~ "2. Middle",
                              nhis$earnings %in% 11 ~ "3. High")

# percentages (without missing values)
count(drop_na(nhis, income_band), income_band) %>%
  mutate(percent = 100 * n / sum(n))

# ------------------------------------------------------------------------------
# SELECTED PLOTS
# ------------------------------------------------------------------------------

# average self-reported health status by sex and race
ggplot(drop_na(nhis, race), aes(x = female, y = health)) +
  geom_bar(stat = "summary", fun = "mean") +
  coord_flip() +
  facet_grid(race ~ .) +
  labs(title = "Health status by sex and race",
       y = "health status (1 = excellent, 5 = poor)", x = NULL)

# average self-reported health status by sex, race and age group
ggplot(drop_na(nhis, race, age_group),
       aes(x = age_group, y = health, color = race, group = race)) +
  geom_line(stat = "summary", fun = "mean") +
  geom_point(stat = "summary", fun = "mean") +
  facet_grid(~ female) +
  labs(title = "Health status by sex and age group",
       y = "health status (1 = excellent, 5 = poor)", x = "age group")

ggsave("plots/health_by_sex_race_age.png", width = 11, height = 5)

# average self-reported health status by sex, race and income
ggplot(drop_na(nhis, race, income_band),
       aes(x = income_band, y = health, color = race, group = race)) +
  geom_line(stat = "summary", fun = "mean") +
  geom_point(stat = "summary", fun = "mean") +
  facet_grid(~ female) +
  labs(title = "Health status by sex and income band",
       y = "health status (1 = excellent, 5 = poor)", x = "income band")

ggsave("plots/health_by_sex_race_income.png", width = 11, height = 5)

# ------------------------------------------------------------------------------
# COMPARISON OF MEANS: (health status) x (sex)
# ------------------------------------------------------------------------------

# average self-reported health status by sex
group_by(nhis, sex) %>%
  summarise(average_health = mean(health, na.rm = TRUE), n = n())

# t-test
t.test(health ~ sex, data = nhis)

# ------------------------------------------------------------------------------
# CROSS-TABULATION: (health status = bad) x (sex) x (race)
# ------------------------------------------------------------------------------

# percentage of respondents reporting bad (fair | poor) health, by sex and race
drop_na(nhis, female, race, health) %>%
  group_by(female, race) %>%
  summarise(n = n(), pct_bad_health = sum(health > 3, na.rm = TRUE) / n)

# cross-tabulation (both sexes together)
by_race <- with(nhis, table(health > 3, race))
by_race

# column percentages (1 = excellent health, 5 = poor health)
prop.table(by_race, 2)

# Chi-squared test
chisq.test(by_race)

# cross-tabulation (separating by sex)
by_race_m <- with(filter(nhis, sex == 1), table(race, health > 3)) # males
by_race_f <- with(filter(nhis, sex == 2), table(race, health > 3)) # females

# counts
by_race_m # males
by_race_f # females

# row percentages, rounded to 2 digits
round(prop.table(by_race_m, 1), 2) # males
round(prop.table(by_race_f, 1), 2) # females

# Chi-squared tests
chisq.test(by_race_m)
chisq.test(by_race_f)

# ------------------------------------------------------------------------------
# LINEAR REGRESSION
# ------------------------------------------------------------------------------

# simple linear regressions
ols_1 <- lm(health ~ female, data = nhis)
ols_2 <- lm(health ~ age_group, data = nhis)
ols_3 <- lm(health ~ race, data = nhis)
ols_4 <- lm(health ~ income_band, data = nhis)

texreg::screenreg(list(ols_1, ols_2, ols_3, ols_4))

# multiple linear regression
m <- lm(health ~ female + age_group + race + income_band, data = nhis)
summary(m)

texreg::screenreg(m)

# kthxbye
