# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Fertility and education
#
# ============================= See README file for data sources and details ===

# required packages -------------------------------------------------------

library(broom)
library(texreg)
library(tidyverse)

# data inspection ---------------------------------------------------------

d <- readr::read_tsv("data/fertility.tsv")

# data inspection
glimpse(d)

# sample composition
count(d, region) %>%
  mutate(pct = n / sum(n))

# correlation between fertility and female education
with(d, cor(births, schooling))

# the above is equivalent to writing this
cor(d$births, d$schooling)

# if any of the variables contain missing values, use this option
cor(d$births, d$schooling, use = "complete")

# region-level summary statistics and correlations
group_by(d, region) %>%
  summarise(n = n(), mu_births = mean(births), mu_schooling = mean(schooling),
            rho = cor(births, schooling))

# plots -------------------------------------------------------------------

# main relationship under study
ggplot(d, aes(y = births, x = schooling)) +
  geom_rug(size = 1, alpha = 1/4) +
  geom_text(aes(label = iso3c))

# show variable means, which are used to compute their correlation
ggplot(d, aes(y = births, x = schooling)) +
  geom_hline(yintercept = mean(d$births), lty = "dashed") +
  geom_vline(xintercept = mean(d$schooling), lty = "dashed") +
  geom_text(aes(label = iso3c))

# add a linear fit to the plot
ggplot(d, aes(y = births, x = schooling)) +
  geom_hline(yintercept = mean(d$births), lty = "dashed") +
  geom_vline(xintercept = mean(d$schooling), lty = "dashed") +
  geom_smooth(method = "lm") +
  geom_text(aes(label = iso3c))

# try fitting a nonlinear relationship
ggplot(d, aes(y = births, x = schooling)) +
  geom_text(aes(label = iso3c)) +
  geom_smooth(method = "gam")

# (simple) linear regression ----------------------------------------------

summary(lm(births ~ schooling, data = d))

# model object
m <- lm(births ~ schooling, data = d)

# model results
round(coef(m), 2) # coefficients
nobs(m)           # sample size

# handier functions
broom::tidy(m)
broom::glance(m) # goodness-of-fit, including F-test and R-squared

# regression diagnostics --------------------------------------------------

# fitted values and residuals
broom::augment(m, newdata = d)

# visual explanation (for demonstration purposes)
ggplot(broom::augment(m, newdata = d), aes(y = births, x = schooling)) +
  geom_smooth(method = "lm", fill = "steelblue", alpha = 1/4) +
  geom_segment(aes(y = .fitted, yend = births, xend = schooling,
                   color = .resid > 0), lty = "dashed") +
  geom_point(aes(y = .fitted, x = schooling), color = "steelblue") +
  ggrepel::geom_text_repel(aes(label = if_else(abs(.resid) > 1.5, iso3c, NA))) +
  geom_point()

# distribution of the residuals
# plot(density(resid(m)))
ggplot(broom::augment(m), aes(.resid)) +
  geom_density() +
  geom_vline(xintercept = 0, lty = "dashed") +
  geom_rug()

# root mean squared error (RMSE)
sqrt(mean(resid(m)^2))

# fitted values versus residuals (heteroskedasticity)
ggplot(broom::augment(m, newdata = d), aes(y = .resid, x = .fitted)) +
  geom_text(aes(label = iso3c)) +
  geom_hline(yintercept = 0, lty = "dashed")

# this is possibly more advanced than what the lecture will try to cover, so
# let's stop at that, and feel free to ignore other parts of this script if the
# lecture did not cover the concepts mentioned (e.g. RMSE)

# presenting the results --------------------------------------------------

# with standard errors and p-values
texreg::screenreg(m, include.rmse = TRUE)

# with confidence intervals
texreg::screenreg(m, ci.force = TRUE, include.rmse = TRUE)

# compare to published tables to get an idea of how these are formatted in
# scientific publications (publication standards have their flaws, though)

# exercise ----------------------------------------------------------------

# recall sample composition by region
count(d, region)

# highlight regions
ggplot(d, aes(y = births, x = schooling)) +
  geom_label(aes(label = iso3c, fill = region), color = "white")

# break down the relationship by region
ggplot(d, aes(y = births, x = schooling)) +
  geom_smooth(method = "lm") +
  geom_text(aes(label = iso3c)) +
  facet_wrap(~ region, scales = "free")

# one-way analysis of variance
summary(aov(births ~ region, data = d))    # fertility
summary(aov(schooling ~ region, data = d)) # education

# compare the following models, and establish which regions show the most
# similar profiles when it comes to the relationship between fertility and
# female education at the country-level

models <- group_by(d, region) %>%
  group_split() %>%
  map(~ lm(births ~ schooling, data = .x))

# region-level models (with abbreviated region names)
texreg::screenreg(models, include.rmse = TRUE, include.adjrs = FALSE,
                  custom.model.names = str_sub(sort(unique(d$region)), 1, 9))

# if it helps, replace `screenreg` with `plotreg` in the code above to get a
# visual summary (and do not worry about the code used in this section, which
# is for demonstration purposes)

# kthxbye
