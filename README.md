
<!-- README.md is generated from README.Rmd. Please edit that file -->

# financer

<!-- badges: start -->
<!-- badges: end -->

The goal of financer is to retrieve (free) financial information of
companies from several websites using R.

## Installation

You can install the development version of financer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("montecapital/financer")
```

## Example

This is a basic example which shows you how to retrieve information of
Illumina Inc. Use [Yahoo Finance](https://finance.yahoo.com/) for basic
information:

``` r
library(financer)
#> Warning: replacing previous import 'httr::handle_reset' by 'curl::handle_reset'
#> when loading 'financer'

# tiker of Illumina Inc.
tikr = "ILMN"

# Overview
ilmn.ovrw = yahoo_scrape("ILMN")
ilmn.ovrw[[2]]
#> # A tibble: 8 x 2
#>   X1                       X2                         
#>   <chr>                    <chr>                      
#> 1 Market Cap               57.887B                    
#> 2 Beta (5Y Monthly)        0.89                       
#> 3 PE Ratio (TTM)           60.63                      
#> 4 EPS (TTM)                6.11                       
#> 5 Earnings Date            Feb 09, 2022 - Feb 14, 2022
#> 6 Forward Dividend & Yield N/A (N/A)                  
#> 7 Ex-Dividend Date         N/A                        
#> 8 1y Target Est            436.19

# Key-statistics
ilmn.stat = yahoo_scrape("ILMN", page = "key-statistics", ntable = "all")
# Valuation measures
ilmn.stat[[1]]
#> # A tibble: 7 x 2
#>   X1                       X2    
#>   <chr>                    <chr> 
#> 1 Beta (5Y Monthly)        0.89  
#> 2 52-Week Change 3         N/A   
#> 3 S&P500 52-Week Change 3  N/A   
#> 4 52 Week High 3           555.77
#> 5 52 Week Low 3            341.03
#> 6 50-Day Moving Average 3  381.76
#> 7 200-Day Moving Average 3 423.44

# Analysis page
ilmn.anal = yahoo_scrape("ILMN", page = "analysis", ntable = "all")
# Expected revenues
ilmn.anal[[2]]
#> # A tibble: 6 x 5
#>   `Revenue Estimate`      `Current Qtr. (De~ `Next Qtr. (Mar ~ `Current Year (2~
#>   <chr>                   <chr>              <chr>             <chr>            
#> 1 No. of Analysts         13                 6                 16               
#> 2 Avg. Estimate           1.1B               1.15B             4.42B            
#> 3 Low Estimate            1.08B              1.11B             4.41B            
#> 4 High Estimate           1.13B              1.25B             4.45B            
#> 5 Year Ago Sales          953M               1B                3.24B            
#> 6 Sales Growth (year/est) 15.20%             15.30%            36.50%           
#> # ... with 1 more variable: Next Year (2022) <chr>
```

Go to [Morningstar](https://www.morningstar.com/) for more detail
information such as the 5-Year financial reports:

``` r
# NASDAQ: Stock exchange in which Illumina operates
mrkt = "XNAS"

# Get the Income Statement
ilmn.is = morning_report(tikr, mrkt, "is")
# Extract the revenue
ilmn.is["Revenue",]
#>    2016-12    2017-12    2018-12    2019-12    2020-12        TTM 
#> 2398373000 2752000000 3333000000 3543000000 3239000000 4280000000

# Get the Balance Sheet
ilmn.bs = morning_report(tikr, mrkt, "bs")
# Extract cash and cash equivalents
ilmn.bs["Cash_and_cash_equivalents",]
#>    2016-12    2017-12    2018-12    2019-12    2020-12 
#>  734516000 1225000000 1144000000 2042000000 1810000000

# Get the Cash Flow
ilmn.cf = morning_report(tikr, mrkt, "cf")
# Show the free cash flow
ilmn.cf["Free_cash_flow",]
#>   2016-12   2017-12   2018-12   2019-12   2020-12       TTM 
#> 415857000 563000000 846000000 842000000 891000000 469000000
```

Or you can inspect the key ratios:

``` r
# get the key ratios
ilmn.kr = morning_keyratios("ILMN", "XNAS")
# print growth
head(ilmn.kr[[4]])
#>                           2011-12 2012-12 2013-12 2014-12 2015-12 2016-12
#> Year_over_Year                  0    8.81   23.74   30.97   19.26    8.05
#> 3-Year_Average                  0   19.90   16.33   20.81   24.56   19.06
#> 5-Year_Average                  0   25.64   19.91   22.81   19.72   17.84
#> 10-Year_Average                 0   60.64   48.08   43.41   40.61   29.23
#> Year_over_Year_noncurrent       0   23.02   -0.94   74.48   40.54   -7.07
#> 3-Year_Average_noncurrent       0   23.28    6.28   28.59   34.43   31.59
#>                           2017-12 2018-12 2019-12 2020-12 Latest Qtr
#> Year_over_Year              14.74   21.11    6.30   -8.58      39.55
#> 3-Year_Average              13.92   14.51   13.89    5.58       0.00
#> 5-Year_Average              19.10   18.59   13.74    7.85       0.00
#> 10-Year_Average             22.33   19.25   18.19   13.63       0.00
#> Year_over_Year_noncurrent    4.66   45.71   11.55  -41.12    -436.42
#> 3-Year_Average_noncurrent   10.98   12.32   19.37   -1.45       0.00
```

If looking good, visit [Quick FS](https://quickfs.net/) for a 10-Year
financial report. It requires a subscription, but the free version
offers 500 requests a day:

``` r
# Illumina operates in the US
country = "US"

# check current quota
quickfs_quota()
#> [1] 500

# get the statements
ilmn.fstat.long = quickfs_getstatement("ILMN", "US")
#> Today's remaining quota: 490
ilmn.fstat.long$finances$finances_ts["revenue",]
#>         2001-12  2002-12  2003-12  2004-12  2005-12   2006-12   2007-12
#> revenue 2486000 10040000 28035000 50583000 73501000 184586000 366799000
#>           2008-12   2009-12   2010-12    2011-12    2012-12    2013-12
#> revenue 573225000 666324000 902741000 1055535000 1148516000 1421178000
#>            2014-12  2015-12   2016-12   2017-12   2018-12   2019-12   2020-12
#> revenue 1861358000 2.22e+09 2.398e+09 2.752e+09 3.333e+09 3.543e+09 3.239e+09

# financial statements "cost" 10 points
quickfs_quota()
#> [1] 490
```

## Disclaimer

This is a personal project and doesn’t come with any guarantee.
