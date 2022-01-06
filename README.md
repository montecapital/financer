
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
#> 1 Market Cap               57.5B                      
#> 2 Beta (5Y Monthly)        0.89                       
#> 3 PE Ratio (TTM)           60.22                      
#> 4 EPS (TTM)                6.11                       
#> 5 Earnings Date            Feb 09, 2022 - Feb 14, 2022
#> 6 Forward Dividend & Yield N/A (N/A)                  
#> 7 Ex-Dividend Date         N/A                        
#> 8 1y Target Est            436.19

# Key-statistics
ilmn.stat = yahoo_scrape("ILMN", page = "key-statistics", ntable = "all")
# Valuation measures
ilmn.stat[[1]]
#> # A tibble: 9 x 2
#>   X1                        X2    
#>   <chr>                     <chr> 
#> 1 Market Cap (intraday)     58.54B
#> 2 Enterprise Value          59.81B
#> 3 Trailing P/E              61.30 
#> 4 Forward P/E               91.74 
#> 5 PEG Ratio (5 yr expected) 2.95  
#> 6 Price/Sales (ttm)         13.02 
#> 7 Price/Book (mrq)          5.53  
#> 8 Enterprise Value/Revenue  13.97 
#> 9 Enterprise Value/EBITDA   43.56

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

If looking good, visit [Quick FS](https://quickfs.net/) for a 10-Year
financial report. It requires a subscription, but the free version
offers 500 requests a day:

``` r
# Illumina operates in the US
country = "US"

# check current quota
quickfs_quota()
#> [1] 490

# get the statements
ilmn.fstat.long = quickfs_getstatement("ILMN", "US")
#> Today's remaining quota: 480
ilmn.fstat.long$finances$finances_ts["revenue",]
#>         2001-12  2002-12  2003-12  2004-12  2005-12   2006-12   2007-12
#> revenue 2486000 10040000 28035000 50583000 73501000 184586000 366799000
#>           2008-12   2009-12   2010-12    2011-12    2012-12    2013-12
#> revenue 573225000 666324000 902741000 1055535000 1148516000 1421178000
#>            2014-12  2015-12   2016-12   2017-12   2018-12   2019-12   2020-12
#> revenue 1861358000 2.22e+09 2.398e+09 2.752e+09 3.333e+09 3.543e+09 3.239e+09

# financial statements "cost" 10 points
quickfs_quota()
#> [1] 480
```

## Disclaimer

This is a personal project and doesn’t come with any guarantee.
