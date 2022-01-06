#' Get the quota from quickfs
#'
#' @examples
#'
#' quickfs_quota()
#'
quickfs_quota <- function(){
  # url
  url = "https://public-api.quickfs.net/v1/usage"
  # send request
  response = GET(url, add_headers("X-QFS-API-Key" = quickfs_key))
  # parse response
  quota = content(response)$usage$quota$remaining
  # return
  return(quota)
}
