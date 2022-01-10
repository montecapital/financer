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
  is.ok = length(tikr.is) > 1
  # balance sheet
  tikr.bs = morning_report(tikr, mrkt, "bs")
  bs.ok = length(tikr.bs) > 1

  # if financial data available
  if(is.ok & bs.ok){

    # replace NAS with zeros
    tikr.is[is.na(tikr.is)] == 0
    tikr.bs[is.na(tikr.bs)] == 0

    # Check
    # in the Balance Sheet
    bs.var = rownames(tikr.bs)
    assets.test = "Total_current_assets" %in% bs.var
    liablt.test = "Total_liabilities" %in% bs.var
    fixass.test = "Net_property_plant_and_equipment" %in% bs.var
    stdebt.test = "Short-term_debt" %in% bs.var
    ltdebt.test = "Long-term_debt" %in% bs.var
    totcsh.test = "Total_cash" %in% bs.var
    # in the income statement
    is.var = rownames(tikr.is)
    ebitda.test = "EBITDA" %in% is.var
    # extract
    assets = 0; if(assets.test) assets = tikr.bs["Total_current_assets",]
    liablt = 0; if(liablt.test) liablt = tikr.bs["Total_liabilities",]
    fixass = 0; if(fixass.test) fixass = tikr.bs["Net_property_plant_and_equipment",]
    stdebt = 0; if(stdebt.test) stdebt = tikr.bs["Short-term_debt",]
    ltdebt = 0; if(ltdebt.test) ltdebt = tikr.bs["Long-term_debt",]
    totcsh =NA; if(totcsh.test) totcsh = tikr.bs["Total_cash",]
    ebitda = 0; if(ebitda.test) ebitda = tikr.is["EBITDA",-which(colnames(tikr.is) =="TTM")]

    # ROC
    # Net working capital
    net.working.capital = (assets - liablt)
    # Return on invested capital
    roc = ebitda/(net.working.capital + fixass)
    roc = tail(roc, n = 1)

    # EY
    # marker capitalization
    mrkt.cap = tikr.yh[which(tikr.yh$X1 =="Market Cap"),2]
    mrkt.cap = .mrn_parse_values(mrkt.cap)
    # total debt
    total.debt = stdebt + ltdebt
    # enterprise value
    ev = (mrkt.cap + total.debt - totcsh)
    # earning yield
    ey = ebitda/ ev
    ey = tail(ey, n = 1)

    # Last time of earnings
    dterow = which(tikr.yh[,1] == "Earnings Date")
    dtestr = tikr.yh[dterow, 2]
    earndate = NA
    if(dtestr != "N/A"){
      # take the date
      dteprs = str_split(str_split(dtestr, "-")[[1]][1], "\\s|\\,")[[1]]
      # take the year, month, day
      earnyr = as.numeric(dteprs[4])
      earnmn = match(dteprs[1],month.abb)
      earndy = as.numeric(dteprs[2])
      # turn it into a date
      earndate = as.Date(paste(earnyr, earnmn, earndy, sep = "-"))
    }

    # build output
    out = list(roc = roc, ey = ey, cap = mrkt.cap, date = earndate)
  # otherwise
  } else {
    # return NA
    out = list(roc = NA, ey = NA, cap = NA, date = NA)
  }
  # return
  return(out)
}
