# defines the url to request the key ratios
.set_url_keyratios <- function(tikeri, market){
  # reference page
  referer = paste0(
    "https://financials.morningstar.com/ratios/r.html?t=",tikeri,
    "&culture=en&platform=sal")
  # url of the request
  request = paste0(
    "http://financials.morningstar.com/ajax",
    "/exportKR2CSV.html?t=", market,":", tikeri)
  # return
  return(list(referer = referer,request = request))
}

# defines the url to send the request
.send_request <- function(url){
  # build a new handler
  c.handle = new_handle()
  handle_setopt(c.handle, referer = url$referer, followlocation = TRUE, autoreferer = TRUE)
  # get the response and load in memory
  response = curl_fetch_memory(url$request, c.handle)
  # reformat the output
  output = strsplit(rawToChar(response$content), "\n")[[1]]
  # return
  return(output)
}

# parse the csv of key ratios
.parse_keyratios <- function(req){
  # split by table
  sep.tables = c(1, which(req == ""), length(req))
  num.tables = length(sep.tables)
  lst.tables = lapply(2:num.tables, function(i) req[(sep.tables[i-1]+1):(sep.tables[i]-1)])
  # initialize output
  out = list()
  # for each table
  for(i in 1:length(lst.tables)){
    # split columns by commas
    lsts = lapply(lst.tables[[i]], function(x) str_split(x, '(?<!\\\"\\d)\\,(?!\\s)')[[1]])
    # count the number of values
    nums = unlist(lapply(lsts, length))
    # stick to the time series
    data = as.data.frame(do.call(rbind,lsts[nums == nums[2]]))
    # refine the names
    data[,1] = gsub('\\.|\\,|\\"', "", data[,1])
    data[,1] = gsub(" ", "_", data[,1])
    # find the duplicated capital_leases and add "noncurrent"
    dupl = which(duplicated(data[,1]))
    data[dupl, 1] = paste0(data[dupl, 1], "_noncurrent")
    # first row as column names
    names(data) = as.character(data[1,])
    data = data[-1,]
    # make data numeric
    nams = data[,1]
    # data = sapply(data[,-1], as.numeric)
    data = sapply(data[,-1], function(x) as.numeric(gsub('\\\"', "", gsub(',',"",x))))
    # first column as row names
    rownames(data) = as.character(nams)
    data[is.na(data)] = 0
    # save
    out[[i]] = data
  }
  return(out)
}


#' Returns the key ratios of the company
#'
#' @param tikr
#' @param mrkt
#'
#' @example
#'
#' morning_keyratios("ILMN", "XNAS")
#'
morning_keyratios <- function(tikr, mrkt){
  # build the url
  url = .set_url_keyratios(tikr, mrkt)
  # send the request
  req = .send_request(url)
  # parse key ratios
  out = .parse_keyratios(req)
  # return output
  return(out)
}

