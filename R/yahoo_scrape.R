#' Extracts information from YAHOO
#'
#' @param tikr tiker of the company, char.
#' @param page page from which extracting information
#'
#' @description You can choose diferent \code{page} to scrape several types
#' of information. When nothing is defined, the summary page is scrapped by
#' default. There is also, \code{"key-statistics"}, which provides several
#' metrics, \code{"profile"}, which provides the names of key executives,
#' \code{"analysis"}, which offers different estimates for earnings,
#' revenues, etc.
#'
#' @example
yahoo_scrape <- function(tikr, page = "", ntable = 2, stat = "Market Cap"){
  # find the  url
  url = paste0('https://finance.yahoo.com/quote/',tikr, page,'?p=',tikr)
  # download content
  out = read_html(url) %>% html_nodes("table") %>% html_table()
  # retrieve all tables
  if(ntable != "all"){
    # get the real frame
    out = as.data.frame(out[[ntable]])
    if(stat != "all"){
      # get the
      out = out[which(out[,1] == stat),-1]
    }
  }
  # return
  return(out)
}
