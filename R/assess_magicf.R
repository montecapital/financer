#' Computes statistics for the magic formula
#'
#' @param tikr tiker of the company, char.
#' @param mrkt name of the market, char.
#'
#' @example
#'
#' assess_magicf("ILMN", "XNAS")
#'
assess_magicf <- function(tikr, mrkt){

  # Information
  # general info
  tikr.yh = yahoo_scrape(tikr, ntable = 2)
  # income statement
  tikr.is = morning_report(tikr, mrkt, "is")
  # balance sheet
  tikr.bs = morning_report(tikr, mrkt, "bs")

  # ROC
  # Net working capital
  assets = tikr.bs["Total_current_assets",]
  liablt = tikr.bs["Total_liabilities",]
  net.working.capital = (assets - liablt)
  # Net fixed assets
  fixass = tikr.bs["Net_property_plant_and_equipment",]
  # Earnings Before Interests Taxes Depreciation and Amortization
  ebitda = tikr.is["EBITDA",-which(colnames(tikr.is) =="TTM")]
  # Return on invested capital
  roc = ebitda/(net.working.capital + fixass)
  roc = tail(roc, n = 1)

  # EY
  # marker capitalization
  mrkt.cap = tikr.yh[which(tikr.yh$X1 =="Market Cap"),2]
  mrkt.cap = .mrn_parse_values(mrkt.cap)
  # total debt
  total.debt = tikr.bs["Short-term_debt",] + tikr.bs["Long-term_debt",]
  # and the cash
  cash = tikr.bs["Total_cash",]
  # enterprise value
  ev = (mrkt.cap + total.debt - cash)
  # earning yield
  ey = ebitda/ ev
  ey = tail(ey, n = 1)

  # return
  return(list(roc = roc, ey = ey))
}
