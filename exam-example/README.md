# README

__Data source:__ [Quality of Government Standard Dataset][qog], time-series version, January 2026. The data have been restricted to selected variables and years.

[qog]: https://www.gu.se/en/quality-government/qog-data/data-downloads/standard-dataset

More information is available from the `docs` folder.

## R code to generate the data extract

```r
haven::read_dta("https://www.qogdata.pol.gu.se/data/qog_std_ts_jan26.dta") %>% 
  select(ccodealp, cname, year, wdi_wip, wdi_gdpcapcon2015, ht_regtype) %>% 
  filter(year %in% seq(2012, max(year[ !is.na(ht_regtype) ]))) %>% 
  haven::write_dta("data/qog_std_ts_jan26_extract.dta")
```
