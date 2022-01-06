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
  # initialize outputs
  country = NULL
  market = NULL
  # for each country
  for(i in 1:no.cntry){
    # number of markets# for each market
    no.mrkt = length(tikrs[[i]])
    # for each market
    for(j in 1:no.mrkt){
      # find
      check = tikr %in% tikrs[[i]][[j]]
      # if so, fill info
      if(check){
        # save country name
        country = names(tikrs)[i]
        # save market name
        market = names(tikrs[[i]])[j]
      }
    }
  }
  # return results
  return(list(country = country, market = market))
}
