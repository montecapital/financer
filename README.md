
<!-- README.md is generated from README.Rmd. Please edit that file -->

# financer

<!-- badges: start -->
<!-- badges: end -->

The goal of financer is to retrieve financial information of companies
from several websites.

## Installation

You can install the development version of financer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("montecapital/financer")
```

## Example

This is a basic example which shows you how to retrieve the balance
sheet of Illumina Inc. from Morningstar:

``` r
library(financer)
#> Warning: replacing previous import 'httr::handle_reset' by 'curl::handle_reset'
#> when loading 'financer'
## basic example code
morning_report("ILMN", "XNAS", "bs")
#>                                              2016-12   2017-12   2018-12
#> Cash_and_cash_equivalents                  734516000 1.225e+09 1.144e+09
#> Short-term_investments                     824208000 9.200e+08 2.368e+09
#> Total_cash                                1558724000 2.145e+09 3.512e+09
#> Receivables                                385164000 4.110e+08 5.140e+08
#> Inventories                                300170000 3.330e+08 3.860e+08
#> Prepaid_expenses                            77881000 9.100e+07 7.800e+07
#> Total_current_assets                      2318091000 2.980e+09 4.490e+09
#> "Gross_property_plant_and_equipment"      1040147000 1.347e+09 1.596e+09
#> "Net_property_plant_and_equipment"         713334000 9.310e+08 1.075e+09
#> Goodwill                                   775995000 7.710e+08 8.310e+08
#> Intangible_assets                          242652000 1.750e+08 1.850e+08
#> Deferred_income_taxes                      123317000 8.800e+07 7.000e+07
#> Other_long-term_assets                     107211000 3.120e+08 3.080e+08
#> Total_non-current_assets                  1962509000 2.277e+09 2.469e+09
#> Total_assets                              4280600000 5.257e+09 6.959e+09
#> Short-term_debt                              1250000 1.000e+07 1.107e+09
#> Capital_leases                             222734000 1.440e+08        NA
#> Accounts_payable                           137930000 1.600e+08 1.840e+08
#> Taxes_payable                               32040000 5.000e+07 8.200e+07
#> Accrued_liabilities                         57762000 5.500e+07 6.300e+07
#> Deferred_revenues                          141149000 1.500e+08 1.750e+08
#> Other_current_liabilities                  111800000 1.770e+08 1.930e+08
#> Total_current_liabilities                  704665000 7.460e+08 1.804e+09
#> Long-term_debt                            1047805000 1.182e+09 8.900e+08
#> Capital_leases_noncurrent                         NA        NA        NA
#> Other_long-term_liabilities                257895000 5.800e+08 4.200e+08
#> Total_non-current_liabilities             1378706000 1.762e+09 1.397e+09
#> Total_liabilities                         2083371000 2.508e+09 3.201e+09
#> Common_stock                                 1887000 2.000e+06 2.000e+06
#> Additional_paid-in_capital                2733394000 2.833e+09 3.290e+09
#> Retained_earnings                         1485414000 2.256e+09 3.083e+09
#> Total_stockholders_equity                 2197229000 2.749e+09 3.758e+09
#> Total_liabilities_and_stockholders_equity 4280600000 5.257e+09 6.959e+09
#>                                             2019-12   2020-12
#> Cash_and_cash_equivalents                 2.042e+09 1.810e+09
#> Short-term_investments                    1.372e+09 1.662e+09
#> Total_cash                                3.414e+09 3.472e+09
#> Receivables                               5.730e+08 4.870e+08
#> Inventories                               3.590e+08 3.720e+08
#> Prepaid_expenses                          1.050e+08 1.520e+08
#> Total_current_assets                      4.451e+09 4.483e+09
#> "Gross_property_plant_and_equipment"      2.012e+09 2.132e+09
#> "Net_property_plant_and_equipment"        1.444e+09 1.454e+09
#> Goodwill                                  8.240e+08 8.970e+08
#> Intangible_assets                         1.450e+08 1.420e+08
#> Deferred_income_taxes                     6.400e+07 2.000e+07
#> Other_long-term_assets                    3.880e+08 5.890e+08
#> Total_non-current_assets                  2.865e+09 3.102e+09
#> Total_assets                              7.316e+09 7.585e+09
#> Short-term_debt                                  NA 5.110e+08
#> Capital_leases                            4.500e+07 5.100e+07
#> Accounts_payable                          1.490e+08 1.920e+08
#> Taxes_payable                             8.600e+07 6.800e+07
#> Accrued_liabilities                       6.400e+07 8.300e+07
#> Deferred_revenues                         1.670e+08 1.860e+08
#> Other_current_liabilities                 1.540e+08 1.530e+08
#> Total_current_liabilities                 6.650e+08 1.244e+09
#> Long-term_debt                            1.141e+09 6.730e+08
#> Capital_leases_noncurrent                 6.950e+08 6.710e+08
#> Other_long-term_liabilities               2.020e+08 3.030e+08
#> Total_non-current_liabilities             2.038e+09 1.647e+09
#> Total_liabilities                         2.703e+09 2.891e+09
#> Common_stock                              2.000e+06 2.000e+06
#> Additional_paid-in_capital                3.560e+09 3.815e+09
#> Retained_earnings                         4.067e+09 4.723e+09
#> Total_stockholders_equity                 4.613e+09 4.694e+09
#> Total_liabilities_and_stockholders_equity 7.316e+09 7.585e+09
```
