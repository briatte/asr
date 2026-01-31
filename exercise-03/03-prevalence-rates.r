# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Obesity prevalence in the United States (Part 2), Script 3/4
#
# ==================== See the README file for data sources and instructions ===

# required packages -------------------------------------------------------

library(dplyr)
library(ggplot2)
library(readr)
library(sf)

# load obesity data -------------------------------------------------------

brfss <- readr::read_tsv("data/brfss2023_obesity_prevalence.tsv") %>%
  mutate(obesity = as.numeric(na_if(Obesity, "No data")))

# if you go and have a look at the raw data, you will see that the `Obesity`
# variable is set to "No data" for a bunch of states: as a result, the variable
# is imported as "text" instead of numbers; the code above first replaces these
# values with `NA` and then 'converts' the values from text to numbers

# geographic data ---------------------------------------------------------

geo <- sf::st_read("data/cb_2018_us_state_20m/cb_2018_us_state_20m.shp") %>%
  sf::st_transform(crs = "EPSG:5070")

# join and remove non-contiguous states
geo <- inner_join(geo, brfss, by = c("NAME" = "State")) %>%
  filter(!NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))

# the first line above merges (joins) the `geo` and `brfss` datasets by using
# their `NAME` and `State` variables to identify which rows should be joined
# together; the second line keeps only states that are not in the given list

# project as a choropleth map ---------------------------------------------

ggplot(...) +
  geom_sf(aes(fill = ...), color = "white") +
  geom_sf_text(aes(label = ...), color = "white") +
  scale_fill_viridis_c("%", option = "D", direction = -1, begin = 0,
                       values = c(0, .4, .7, .8, 1), na.value = "grey75") +
  theme_void(paper = "white")

ggsave("obesity-prevalence.png", width = 10, height = 7)

# kthxbye
