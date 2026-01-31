# README

_The code in this folder will be run in class. Please refer to the slides for instructions._

The code contains several comments to explain what it does, and what you should learn from it, including the following topics:

- opening ('reading') datasets
- inspecting variables
- understanding variable/data types
- recoding missing values
- recoding values more generally
- counting observations
- performing logical tests
- summarising continuous variables
- aggregating ('grouping') data

Several of the operations described above will be carried with the [`dplyr`][dplyr] package.

[dplyr]: https://dplyr.tidyverse.org/

__Data source:__ [World Values Survey (WVS), Wave 4](https://www.worldvaluessurvey.org/WVSDocumentationWV4.jsp) (1999–2004).

A full data citation is available from the WVS website.

If you are interested in the exact wording of the survey question that is used in our class example, check the English back-translation of the survey questionnaire that was used in Egypt in 2001, which can be found on the WVS website, and which I have included in the `docs` folder.

## R code used to produce the data extracts

```r
library(tidyverse)
library(writexl)

wvs <- haven::read_dta("F00011154-WV4_Data_stata_v20201117.zip",
                       encoding = "UTF-8") %>%
  group_by(B_COUNTRY_ALPHA) %>%
  filter(any(!is.na(IV166))) %>%
  select(V2, V223, V225, V226, V106, V107, V241, IV166, V245)

haven::write_dta(wvs, "data/wv4_islam_subset.dta")

# Bangladesh only, CSV format
filter(wvs, V2 == 50) %>%
  readr::write_csv("data/wv4_bangladesh.csv")

# Bangladesh only, Excel format
filter(wvs, V2 == 50) %>%
  writexl::write_xlsx("data/wv4_bangladesh.xlsx")
```
