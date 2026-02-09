# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Obesity prevalence in the United States (Part 2), Script 4/4
#
# ==================== See the README file for data sources and instructions ===

# required packages -------------------------------------------------------

library(survey)
library(tidyverse)

# import the processed dataset --------------------------------------------

d <- readr::read_rds("data/nhis2018.rds")

# survey design -----------------------------------------------------------

nhis_design <- survey::svydesign(id = ~ psu,
                                 strata = ~ strata,
                                 nest = TRUE,
                                 weights = ~ sampweight,
                                 data = drop_na(d, bmi))

# survey-weighted estimates -----------------------------------------------

# survey-weighted mean
survey::svymean(~ bmi, nhis_design)

# survey-weighted mean, by race
survey::svyby(~ bmi, ~ race, nhis_design, svymean)

# survey-weighted mean, by race and sex
survey::svyby(~ bmi, ~ race + sex, nhis_design, svymean, vartype = "ci")

# plot confidence intervals -----------------------------------------------

survey::svyby(~ bmi, ~ race + sex, nhis_design, svymean, vartype = "ci") %>%
  ggplot(aes(y = ..., xmin = ..., xmax = ..., x = ..., color = ...)) +
  geom_pointrange(position = position_dodge2(width = 1)) +
  guides(color = "none") +
  facet_grid(... ~ .) +
  labs(y = NULL, x = "\nBMI (95% survey-weighted confidence intervals)\n")

ggsave("plots/bmi-point-estimates.png", width = 6, height = 4)

# kthxbye
