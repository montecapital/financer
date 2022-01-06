#' Retrieve annual financial statements
#'
#' @param tikr tiker of the company, char.
#' @param country name of the country's headquarters
#'
quickfs_getstatement <- function(tikr, country){
  # url
  url = paste0("https://public-api.quickfs.net/v1/data/all-data/",
               tikr, ":", country, "?api_key=",quickfs_key)
  # send the request
  response = GET(url, add_headers("X-QFS-API-Key" = quickfs_key))
  # parse the response
  data = content(response)[[1]]
  # parse financial data: annual
  finances = data$financials$annual
  finances = lapply(finances, unlist)
  # count the number of data
  ndata = lapply(finances, length)
  priod = finances$period_end_date
  nyear = length(priod)
  # time series
  finances_ts = as.data.frame(do.call(rbind, finances[-1][ndata == nyear]))
  colnames(finances_ts) = priod
  # summaries
  finances_sm = finances[-1][ndata != nyear]
  finances = list(finances_ts = finances_ts, summary = finances_sm)
  # extract the metadata
  metadata = data.frame(var = names(data$metadata),
                        value = unlist(data$metadata),
                        row.names = NULL)
  # compile information
  info = list(finances = finances, metadata = metadata)
  # print the remaining quota
  message(paste("Today's remaining quota:", quickfs_quota()))
  # return the metric
  return(info)
}
