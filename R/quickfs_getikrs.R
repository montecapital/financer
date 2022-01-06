#' Gets the list of companies in different markets
#'
#' @examples
#'
#' tikrs = quickfs_getikrs()
#'
quickfs_getikrs <- function(){
  # number of countries
  no.cntry = length(mrkts)
  # intialize output
  tikrs = list()
  # for each country
  for(i in 1:no.cntry){
    # get the countru
    country = names(mrkts)[i]
    # number of markets# for each market
    no.mrkt = length(mrkts[[i]])
    # intialize output
    tikrs[[country]] = list()
    # for each market
    for(j in 1:no.mrkt){
      # name of the market
      mrkti = mrkts[[i]][j]
      # define the url
      url = paste0("https://public-api.quickfs.net/v1/companies/",country,"/", mrkti)
      # query
      response = GET(url, add_headers("X-QFS-API-Key" = quickfs_key))
      # parse response
      nms = lapply(unlist(content(response)), function(x) str_split(x, ":")[[1]][1])
      # get tikers
      tikrs[[country]][[mrkti]] = unlist(nms)
    }
  }
  # return list
  return(tikrs)
}
