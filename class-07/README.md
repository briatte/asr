# README

__Data source:__ [European Social Survey][ess], Round 4, 2008 (although some countries were surveyed as late as 2011). The data are limited to the Israeli sample, which was surveyed between August 2008 and March 2009.

[ess]: https://www.europeansocialsurvey.org/

Please refer to the docs from the `class-05` folder for the technical documentation of the survey. The folder contains information on [weighting the data][wgt] properly, which we do only at the very end of the example code.

[wgt]: https://www.europeansocialsurvey.org/methodology/ess-methodology/data-processing-and-archiving/weighting

## R code to generate the data extract

```r
library(tidyverse)

# ESS Round 4 (downloaded)
haven::read_dta("ESS4e04_6.zip") %>% 
  filter(cntry == "IL") %>% 
  haven::write_dta("ESS4e04_6_IL.dta")

zip("ESS4e04_6_IL.dta.zip", "ESS4e04_6_IL.dta")
fs::file_delete("ESS4e04_6_IL.dta")
```
