# README

__Main data source:__ World Bank [World Development Indicators][wdi], 2022-2023, retrieved with the [`WDI` R package][wdi-pkg] by Vincent Arel-Bundock.

[wdi]: https://databank.worldbank.org/source/world-development-indicators
[wdi-pkg]: https://vincentarelbundock.github.io/WDI/

__Data source for continents and regions:__ `countrycode` (by the same author).

__Data source for colonial origin:__ [Quality of Government Standard Dataset][qog], 2026. Data are from years 2022-2023. See the codebook for precise data sources.

[qog]: https://www.gu.se/en/quality-government/qog-data/data-downloads/standard-dataset

__Data source for shapefiles:__ [World Bank Official Boundaries][owb].

[owb]: https://datacatalog.worldbank.org/search/dataset/0038272/World-Bank-Official-Boundaries

```r
library(countrycode)
library(tidyverse)
library(WDI)
# Quality of Government (c. 2022)
full_join("https://www.qogdata.pol.gu.se/data/qog_std_cs_jan26.csv" %>%
            readr::read_csv() %>% 
            transmute(iso3c = countrycode(ccodealp, "iso3c", "iso3c"),
                      ht_colonial),
          # World Development Indicators (2022 or 2023)
          WDI::WDI(indicator = c("lexp" = "SP.DYN.LE00.IN",
                                 "gdpc" = "NY.GDP.PCAP.PP.CD",
                                 "pop" = "SP.POP.TOTL"),
                                 start = 2019) %>%
            # remove non-country ISO-3C codes
            mutate(iso3c = countrycode(iso3c, "iso3c", "iso3c")) %>%
            # drop rows with missing values
            tidyr::drop_na() %>%
            # subset to most recent year
            filter(year == max(year), .by = iso3c) %>%
            select(-iso2c, -year, -country),
          by = "iso3c") %>%
  mutate(country = countrycode(iso3c, "iso3c", "country.name"),
         continent = countrycode(iso3c, "iso3c", "continent"),
         region = countrycode(iso3c, "iso3c", "region"), .after = 1) %>%
  readr::write_tsv("data/life-expectancy.tsv")
```
