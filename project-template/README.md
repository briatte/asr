# README

_This little abstract illustrates the kind of research that can be produced with survey data. The accompanying script does_ ___not___ _contain a full-fledged analysis that leads to the conclusions below, but rather shows how to get started with such a project. Turn to the rest of the class material for more examples and guidance._

This folder contain a small-scale survey research project that examines __health inequalities in the United States__.

Using data from the [U.S. National Health Interview Survey][nhis], we show that self-reported heath status is consistently worse among Black and Hispanic Americans.

[nhis]: https://www.cdc.gov/nchs/nhis/index.html

![](plots/health_by_race.pdf)

We further show that these differences are not attributable to age and sex, but that they rather seem to originate in the racial earnings gap, with Black females, in particular, being far less represented in the U.S. middle and upper [income classes][income].

[income]: https://www.pewresearch.org/short-reads/2024/09/16/are-you-in-the-american-middle-class/

Since our study shows that earnings are also insufficient on their own to fully account for the observed inequalities, we suggest further research into the other social determinants of health, in order to better understand the extent of the racial [health and wealth][russo24] gaps in the U.S. population, as well as the policies that might effectively reduce them.

[russo24]: https://cepr.org/voxeu/columns/health-inequality-and-economic-disparities-race-ethnicity-and-gender

## R code to generate the plot above

```r
library(tidyverse)
# health status by race (stacked percentages)
haven::read_dta("data/nhis2018.dta.zip") %>%
  filter(health <= 5, !is.na(race)) %>%
  count(race = haven::as_factor(race),
        health = haven::as_factor(health)) %>%
  group_by(race) %>%
  mutate(pct = 100 * n / sum(n)) %>%
  ggplot(aes(race, pct, fill = health)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(sprintf("%1.0f", pct),"%")),
            position = position_stack(vjust = 0.5)) +
  scale_fill_discrete("Health status") +
  coord_flip() +
  labs(y = "% respondents", x = NULL) +
  theme_bw(base_size = 14)

# N.B. save as PDF for better rendering
ggsave("plots/health_by_race.png", width = 11, height = 5)
```
