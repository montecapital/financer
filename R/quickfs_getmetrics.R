#' Retrieve financial metrics of a company
#'
#' @param tikr tiker of the company, char.
#' @param metric metric name, char.
#' @param period period ID (e.g., "FY-9:FY" or "FQ-19:FQ")
#' @returns financial data
#'
#' @examples
#'
#' quickfs_getmetric("ILMN", "revenue", "FY-9:FY")
#'
quickfs_getmetric <- function(tikr, metric, period = "FY-9:FY"){
  # root url
  root = "https://public-api.quickfs.net"
  # build the url
  url = paste0(root,
               "/v1/data/",tikr,
               "/",metric,
               "?period=",period,
               "&api_key=", quickfs_key)
  # send the request
  response = GET(url, add_headers("X-QFS-API-Key" = quickfs_key))
  # parse the response
  data = unlist(content(response))
  # print the remaining quota
  message(paste("Today's remaining quota:", quickfs_quota()))
  # return the metric
  return(data)
}


#' Gets the metricks from quickfs
#'
#' @examples
#'
#' quickfs_getmetrics()
#'
quickfs_getmetrics <- function(){
  # definte the url
  url = "https://public-api.quickfs.net/v1/metrics"
  # send request
  response = GET(url, add_headers("X-QFS-API-Key" = quickfs_key))
  # parse the response
  mtrx = lapply(content(response)[[1]], function(x){
    return(c(x$metric, x$data_type,
             paste(unlist(x$periods), collapse = "/"),
             paste(unlist(x$company_types), collapse = "/")))
  })
  # combine as data frame
  mtrx = as.data.frame(do.call(rbind, mtrx))
  colnames(mtrx) = c("name", "type", "period", "companies")
  # return the list
  return(mtrx)
}
