# normalize the name of the market
.mrkt_nomlz <- function(mrkt){
  switch(mrkt,
    "NASDAQ" = "XNAS",
    "NYSE"   = "XNYS",
    "NYSEAMERICAN" = "XASE",
    NA
    # ,
    # "" = "XHKG",
    # "" = "XSHE",
    # "" = "XSHG"
  )
}

# XHKG (hong kong),
# XASE (American Stock Exchange),
# XNAS (Nasdaq Stock Exchane),XNYS (New York Stock Exchange),
# XSHE (ShenZhen Stock Exchange), XSHG (Shangai Stock Exchange)

#' Finds the country and market of a tikr
#'
#' @param tikr tiker of the company, char.
#' @param tikrs a list of tikrs, from \code{\link{quickfs_getikrs()}}
#' @examples
#'
#' tikrs = quickfs_getikrs()
#' quickfs_findmrkt("ILMN", tikrs)
#'
quickfs_findmrkt <- function(tikr, tikrs){
  # number of countries
  no.cntry = length(tikrs)
  # number of markets
  no.mrkts = unlist(lapply(tikrs, length))
  # number of tikrs
  no.tikrs = length(tikr)
  # initialize the output
  out = list()
  # for each tikr
  for(i in 1:no.tikrs){
    # this market and country
    out[[tikr[i]]] = list()
    # initialize outputs
    out[[tikr[i]]]$country = NA
    out[[tikr[i]]]$market = NA
    # for each country
    for(j in 1:no.cntry){
      # number of markets# for each market
      no.mrkt = no.mrkts[j]
      # for each market
      for(k in 1:no.mrkt){
        # find
        check = tikr[i] %in% tikrs[[j]][[k]]
        # if so, fill info
        if(check){
          # get the country
          country = names(tikrs)[j]
          # get the market name
          market = names(tikrs[[j]])[k]
          # save country name
          out[[tikr[i]]]$country = country
          # save market name
          out[[tikr[i]]]$market = .mrkt_nomlz(market)
        }
      }
    }
  }
  # return results
  return(out)
}

