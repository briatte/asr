# README

__Data source for fertility:__ World Bank [World Development Indicators][wdi], retrieved with the [`WDI` R package][wdi-pkg] by Vincent Arel-Bundock. Estimates are for year 2015.

[wdi]: https://databank.worldbank.org/source/world-development-indicators
[wdi-pkg]: https://vincentarelbundock.github.io/WDI/

__Data source for average schooling years and regions:__ [Barro-Lee Educational Attainment Dataset][bl], version 3 (September 2021). Estimates are for females aged 15-64 in year 2015.

[bl]: https://barrolee.github.io/BarroLeeDataSet/

## R code to generate the `fertility` dataset

```r
library(countrycode)
library(tidyverse)
library(WDI)

"https://barrolee.github.io/BarroLeeDataSet/BLData/BL_v3_F1564.dta" %>%
  haven::read_dta() %>%
  filter(year == 2015) %>%
  transmute(iso3c = countrycode(country, "country.name", "iso3c"),
            country, region = region_code, schooling = yr_sch) %>%
  full_join(WDI::WDI(indicator = "SP.DYN.TFRT.IN", start = 2015) %>%
              filter(year == 2015) %>%
              select(iso3c, births = SP.DYN.TFRT.IN),
            by = "iso3c") %>%
  drop_na(births, schooling) %>%
  readr::write_tsv("fertility.tsv") # N = 144
```
