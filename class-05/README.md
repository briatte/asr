# README

__Data source:__ [European Social Survey][ess], Round 4, 2008 (although some countries were surveyed as late as 2011).

[ess]: https://www.europeansocialsurvey.org/

The `docs` contains information on [weighting the data][wgt] properly, which we do not do in the example code.

[wgt]: https://www.europeansocialsurvey.org/methodology/ess-methodology/data-processing-and-archiving/weighting

## R code to generate the data extract

```r
library(tidyverse)

# target filenames
f <- "ESS4e04_6_extract.dta"
z <- "ESS4e04_6_extract.dta.zip"

# ESS Round 4 (downloaded)
haven::read_dta("ESS4e04_6.zip") %>% 
  select(name, idno:anweight, agea, gndr, trrtort, lrscale) %>% 
  haven::write_dta(f)

# zip and move to `data` folder
zip(z, f)
fs::file_move(z, fs::path("data", z))
fs::file_delete(f)
```
