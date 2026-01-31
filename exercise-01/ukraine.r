# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Support for Ukraine joining the EU, 2022
#
# ==================== See the README file for data sources and instructions ===


# load required packages --------------------------------------------------

library(sf)
library(tidyverse)

# When you will open this script, RStudio will show a yellow banner offering to
# install the packages if you have not installed them already. You can either
# click the 'Install' button of that banner, or execute the following lines of
# code from the Console to install the packages yourself:
#
# install.packages("sf")
# install.packages("tidyverse")

# load a dataset ----------------------------------------------------------
#
# https://europa.eu/eurobarometer/surveys/detail/2772
# https://search.gesis.org/research_data/ZA7871

# open the Flash Eurobarometer data (provided in Stata format)
eb <- haven::read_dta("data/ZA7871_v1-0-0.dta")

# prepare the data of interest --------------------------------------------

# recode Question 3_8 as missing if answers are outside of the 1-4 range, and
# store that new variable under the name `ukraine` in the `eb` dataset
eb$ukraine <- if_else(eb$q3_8 %in% 1:4, eb$q3_8, NA)

# recode that new variable into a dummy (i.e. a 0/1 binary variable)
# - answers 1 + 2 = 1 (support)
# - answers 3 + 4 = 0 (no support)
eb$ukraine <- if_else(eb$ukraine > 2, 0, 1)

# extract country codes (e.g. "FR" for France)
eb$cty <- substr(haven::as_factor(eb$country), 1, 2)

# aggregate answers into country-level percentages
data <- select(eb, cty, ukraine) %>%
  group_by(cty) %>%
  summarise(ukr_in_eu = 100 * sum(ukraine, na.rm = TRUE) / n())

# take a look at the result
print(data, n = 27)

# open a shapefile (geographic dataset) -----------------------------------
#
# https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/territorial-units-statistics

# note: the code below requires that you installed the {sf} package
map <- sf::st_read("data/NUTS_RG_60M_2024_3035.gpkg")

# check the 'Plots' pane: you should recognise that map...
ggplot(map) +
  geom_sf(fill = "grey50", color = "white")

# plot a map of the Eurobarometer data ------------------------------------

# let's now prepare the map y adding the variable that we extracted from the
# Flash Eurobarometer earlier, and by removing oversea territories
eu27 <- left_join(map, data, by = c("CNTR_CODE" = "cty")) %>%
  # remove French oversea territories + Spanish and Portuguese islands
  filter(LEVL_CODE == 2, !str_detect(NUTS_ID, "^FRY|^ES70|PT200?|PT300?"))

# plot the result (map + Eurobarometer data)
ggplot(eu27) +
  geom_sf(aes(fill = ukr_in_eu), color = "white") +
  scale_fill_binned("%", palette = "viridis") +
  theme(axis.ticks = element_blank(), axis.text = element_blank()) +
  labs(title = "% supporting Ukraine joining the EU when ready",
       subtitle = "Flash Eurobarometer 506 (2022)",
       caption = "NUTS-2 (2024), EPSG:3035")

# save the result
ggsave("ukraine_in_eu.png", width = 9, height = 5)

# bonus question ----------------------------------------------------------

# In the code below, `raw_pct` contains the same variable that we called
# `ukr_in_eu` in our previous steps. However, in the code below, we also create
# a different variable called `wgt_pct`. Execute the code, and compare both
# variables. Can you guess what `wgt_pct` stands for? Same question with `n`.

select(eb, cty, ukraine, wgt = w1) %>%
  group_by(cty) %>%
  summarise(raw_pct = 100 * sum(ukraine, na.rm = TRUE) / n(),
            wgt_pct = 100 * sum(wgt * ukraine, na.rm = TRUE) / sum(wgt),
            n = n()) %>%
  print(n = 27)

# kthxbye
