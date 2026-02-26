# ==============================================================================
#     _                _ _          _   ____  _        _
#    / \   _ __  _ __ | (_) ___  __| | / ___|| |_ __ _| |_ ___
#   / _ \ | '_ \| '_ \| | |/ _ \/ _` | \___ \| __/ _` | __/ __|
#  / ___ \| |_) | |_) | | |  __/ (_| |  ___) | || (_| | |_\__ \
# /_/   \_\ .__/| .__/|_|_|\___|\__,_| |____/ \__\__,_|\__|___/
#         |_|   |_|
#
# Life expectancy and GDP/capita
#
# ============================= See README file for data sources and details ===

# required packages -------------------------------------------------------

library(ggrepel)
library(sf)
library(tidyverse)

# load and inspect the data -----------------------------------------------

d <- readr::read_tsv("data/life-expectancy.tsv")

summary(d$lexp)

# quantiles
quantile(d$lexp, c(0.05, .25, .75, 0.95), na.rm = TRUE)

# standardized (z-scores)
d$z_lexp <- d$lexp - mean(d$lexp, na.rm = TRUE)
d$z_lexp <- d$z_lexp / sd(d$lexp, na.rm = TRUE)

summary(d$z_lexp)          # mean = 0
sd(d$z_lexp, na.rm = TRUE) # sd = 1

# which countries are far off?
filter(d, z_lexp < -2 | z_lexp > 1.5) %>%
  arrange(z_lexp) %>%
  select(country, iso3c, continent, z_lexp, lexp)

# colonial origin dummy
d$colonized <- if_else(d$ht_colonial == 0, FALSE, TRUE)
with(d, table(continent, colonized))

# distributions -----------------------------------------------------------

# histogram
ggplot(d, aes(lexp)) +
  geom_histogram(binwidth = 5, color = "white")

# density curve
ggplot(d, aes(lexp)) +
  geom_density() +
  geom_rug()

# faceted histograms
ggplot(d, aes(lexp)) +
  geom_histogram(binwidth = 2.5, color = "white") +
  facet_wrap(~ continent, ncol = 1, scales = "free_y")

# faceted density curves
ggplot(d, aes(lexp, fill = continent)) +
  geom_density(binwidth = 5, alpha = 0.5) +
  facet_wrap(~ continent, ncol = 1, scales = "free_y")

# box plots
ggplot(d, aes(x = continent, y = lexp, fill = continent)) +
  geom_boxplot() +
  coord_flip() +
  guides(fill = "none")

# scatterplots ------------------------------------------------------------

ggplot(d, aes(y = lexp, x = gdpc)) +
  geom_text(aes(label = iso3c)) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(y = "Life expectancy", x = "GDP / capita")

# natural units: heavy skew
ggplot(d, aes(gdpc)) +
  geom_histogram() +
  labs(title = "GDP / capita (dollars)")

# logarithmic units: closer to normal
ggplot(d, aes(gdpc)) +
  geom_density() +
  scale_x_log10() +
  labs(title = "GDP / capita (logged)")

# apply log-10 transformation
d$log_gdpc <- log10(d$gdpc)

# visualize with a linear fit
ggplot(d, aes(y = lexp, x = log_gdpc)) +
  geom_text(aes(label = iso3c)) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(y = "Life expectancy", x = "GDP / capita (logged)")

# bar plots with a continuous variable ------------------------------------

ggplot(d, aes(x = continent, fill = colonized)) +
  geom_bar()

# step 1: create a small data frame (without missing values)
by_continent <- drop_na(d, colonized) %>%
  group_by(continent, colonized) %>%
  summarise(mu_lifexp = mean(lexp, na.rm = TRUE))

# step 2: plot average life expectancy by continent + colonial origin
ggplot(by_continent, aes(y = continent, x = mu_lifexp, fill = colonized)) +
  geom_col(position = position_dodge2(preserve = "single"))

# the bar plots above require understanding that you can plot different things
# with them: by default, `geom_bar` plots counts, such as the number of former
# colonies in Asia, Oceania etc., whereas `geom_col` will plot actual values,
# such as average life expectancy in Asia, Oceania etc.

# another way to use `geom_bar` is to ask it to plot a summary statistic, e.g.
# an average, which it will compute for us; this avoids having to proceed in
# two separate steps, as shown above (thanks Kevin for the reminder)

ggplot(d , aes(y = continent, x = lexp)) +
  geom_bar(stat = "summary", fun = "mean") +
  labs(title = "Average life expectancy per continent")

# maps --------------------------------------------------------------------

# step 1: import country boundaries (shapefile)
geo <- sf::st_read("data/WB_countries_Admin0_lowres.geojson")
glimpse(geo)

# sanity check: only one measure per country
stopifnot(!duplicated(lexp$iso3c))

# step 2: merge to main data by country codes
geo <- full_join(geo, d, by = c("WB_A3" = "iso3c"))

# step 3: project onto choropleth map
ggplot(geo, aes(fill = lexp)) +
  geom_sf() +
  # WGS84 - World Geodetic System 1984
  coord_sf(crs = 4326) +
  # legend color, title and shape
  scale_fill_viridis_c("Years", guide = guide_legend(), na.value = "grey75") +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#b3cee5"), # pale light blue
    legend.position = "bottom",
    legend.key.width = unit(1.5, "cm"),
    plot.title = element_text(face = "bold"),
    plot.margin = margin(1 ,1 , 1, 1, "cm")
  ) +
  labs(title = "Life expectancy at birth",
       subtitle = "Data: World Development Indicators, 2022-2023")

# export with specific dimensions
ggsave("plots/life-expectancy.png", width = 8, height = 4.5)

# more complex plots ------------------------------------------------------

# another look at the nonlinear relationship between life expectancy and GDP
# per capita, (a.k.a. the Preston curve), adding population size and geographic
# region, and tweaking many graphic parameters to add labels and other things

# draw the owl
ggplot(d, aes(y = lexp, x = gdpc)) +
  # draw the Preston curve
  geom_smooth(se = FALSE, method = "loess", color = "grey50") +
  # draw the underlying data points
  geom_point(aes(size = pop, color = region)) +
  # highlight a few very populous countries
  ggrepel::geom_label_repel(
    data = filter(d, pop > 200 * 10^6),
    aes(label = country),
    box.padding = 1.25, segment.color = "grey50", fill = "white",
    label.size = 0, seed = 42) +
  # redraw the highlighted points, with an additional border
  geom_point(data = filter(d, pop > 200 * 10^6),
             aes(size = pop, fill = region),
             shape = 21, color = "black") +
  # control the minimal and maximal point sizes
  scale_size_continuous(range = c(1.5, 10.5)) +
  # required for the color and fill scales to look alike
  scale_fill_discrete(drop = FALSE) +
  # final cosmetics
  guides(fill = "none", size = "none") +
  theme_classic(base_size = 12) +
  theme(legend.position = c(0.87, 0.25), legend.title = element_blank()) +
  labs(y = "Life expectancy", x = "GDP per capita")

# export final result
ggsave("plots/preston-curve.png", width = 9, height = 6)

# kthxbye
