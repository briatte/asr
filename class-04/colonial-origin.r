# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Life expectancy and colonial origin (continued)
#
# ============================= See README file for data sources and details ===

# required packages -------------------------------------------------------

library(broom)
library(tidyverse)

# load and inspect the data -----------------------------------------------

d <- readr::read_tsv("data/life-expectancy.tsv")

summary(d$lexp)

# log-transform GDP/capita (as explained last week)
d$log_gdpc <- log(d$gdpc)

# if you forgot why, check the distributions
pivot_longer(select(d, gdpc, log_gdpc), everything(), values_to = "x") %>%
  ggplot(aes(x, fill = name)) +
  geom_density(alpha = .5) +
  facet_wrap(~ name, scales = "free", ncol = 1)

# create colonial origin dummy
d$colonized <- if_else(d$ht_colonial == 0, FALSE, TRUE)
with(d, table(continent, colonized))

# take a look at the data if you are curious
# glimpse(d)
# view(d)

# plot relationships ------------------------------------------------------

# life expectancy by colonial origin
ggplot(drop_na(d, colonized, lexp), aes(x = lexp)) +
  geom_density(aes(fill = colonized), alpha = .5) +
  geom_rug(aes(color = colonized), alpha = .5)

# GDP/capita by colonial origin
ggplot(drop_na(d, colonized, log_gdpc), aes(x = log_gdpc)) +
  geom_density(aes(fill = colonized), alpha = .5) +
  geom_rug(aes(color = colonized), alpha = .5)

# look carefully at the code:
#
# 1. we drop missing values with `drop_na`
# 2. we indicate that the x-axis will show either `lexp` or `log_gdpc`
# 3. we plot density curves with `geom_density`
# 4. we add the bottom ticks with `geom_rug`

# point estimation (confidence intervals) ---------------------------------

# fastest way to get point estimates
t.test(lexp[ colonized == 0 ] ~ 1, data = d)
t.test(lexp[ colonized == 1 ] ~ 1, data = d)

# the function above is actually the same `t.test` function that we will use
# right below to statistically test the association between both variables

# same results, rounded to two decimals
round(t.test(lexp[ colonized == 0 ] ~ 1, data = d)$conf.int, 2)
round(t.test(lexp[ colonized == 1 ] ~ 1, data = d)$conf.int, 2)

# the above works because the `t.test` function returns a list of results that
# contains an item called `conf.int` that can be accessed with the `$` symbol

# manual breakdown of the underlying 95% CI formula (minus small corrections)
ci95 <- function(x) {

  x <- na.omit(x)          # remove missing values

  n <- length(x)           # sample size N
  xbar <- mean(x)          # mean
  se <- sd(x) / sqrt(n)    # standard error of the mean

  t <- stats::qnorm(.975)  # t / alpha (critical value)

  return(round(c("Lower 95% CI" = xbar - t * se, "Mean" = xbar,
                 "Upper 95% CI" = xbar + t * se, "N" = n), 2))

}

# same results
ci95(d$lexp[ d$colonized == 0 ])
ci95(d$lexp[ d$colonized == 1 ])

# comparison of means (t-test) --------------------------------------------

t.test(lexp ~ colonized, data = d)

# the full list of results looks like this
str(t.test(lexp ~ colonized, data = d))

# the difference in means between both groups can be accessed as follows, but
# note that this shows mean B - mean A, so be careful when reading the sign
diff(t.test(lexp ~ colonized, data = d)$estimate)

# as seen earlier, the confidence interval around that that difference is here
round(t.test(lexp ~ colonized, data = d)$conf.int, 2)

# the p-value is clearly below our threshold
t.test(lexp ~ colonized, data = d)$p.value < 0.01

# last, here's a function to show all results at once, including the difference
# in means, with the sign reversed when compared to the result of the previous
# method used, because this one shows group A - group B instead
broom::tidy(t.test(lexp ~ colonized, data = d))

# exercise (1) ------------------------------------------------------------

# perform a t-test of log-GDP/c by colonial origin


# Q1. how large is the difference?
# Q2. is it statistically significant?

# exercise (2) ------------------------------------------------------------

# is there a life expectancy gap between sub-Saharan African countries and
# MENA (Middle East & North Africa) countries? is it statistically robust?
count(d, continent, region)

# step 1. subset the data to Africa
# step 2. perform a t-test between the two regions


# kthxbye
