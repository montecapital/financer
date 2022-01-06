# defines the url to request a report
.set_url_report <- function(market, tikeri, report){
  # internal parameters
  market = market # XHKG (hong kong),
                  # XASE (American Stock Exchange),
                  # XNAS (Nasdaq Stock Exchane),XNYS (New York Stock Exchange),
                  # XSHE (ShenZhen Stock Exchange), XSHG (Shangai Stock Exchange)
  tikeri = tikeri # the tickr of the company
  report = report # is|cf|bs (income statement, cash flow, balance sheet)
  period = "12"   # 12|3 (annual, quarter)
  ordert = "asc"  # asc|desc (ascending, descending)
  denoms = "raw"  # raw|percentage|decimal
  yearvw = "10"   # 5, 10 and 10 needs registering
  number = "1"    # units 1 = None, 2 = Thousands, 3 = Millions, 4 = Billions
  # reference page
  referer = paste0(
    "https://financials.morningstar.com/ratios/r.html?t=",tikeri,
    "&culture=en&platform=sal")
  # url of the request
  request = paste0(
    "http://financials.morningstar.com/ajax",
    "/ReportProcess4CSV.html?t=", market,":", tikeri,
    "&reportType=", report, "&period=", period,
    "&dataType=A&order=", ordert,
    "&denominatorView=",denoms,
    "&columnYear=", yearvw,
    "&number=", number)
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


# extracts the values from the report
.parse_report <- function(reqs){
  # split the coma separated values
  # lsts = lapply(reqs, function(x) str_split(x, "\\,(?=\\d|\\,|.)")[[1]])
  lsts = lapply(reqs, function(x) str_split(x, "\\,(?!\\s)")[[1]])
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
  data = sapply(data[,-1], as.numeric)
  # first column as row names
  rownames(data) = as.character(nams)
  # return
  return(data)
}

# convert to numeric
.mrn_parse_values <- function(val){
  # first trial
  test1 = as.numeric(val)
  # if all good, continue
  if(!is.na(test1)){out = test1}
  # modify otherwise
  if(is.na(test1)){
    # split
    splt = str_split(val, "")[[1]]
    # reverse and check
    mltply = switch(tail(splt, n = 1), "k" = 1000, "M" = 1e6, "B" = 1e9, "%" = 1e-2)
    # convert
    out = as.numeric(paste0(head(splt, -1), collapse = "")) * mltply
  }
  # return
  return(out)
}

#' Gets financial reports from Morningstar
#'
#' @param tikr tiker of the company, char.
#' @param mrkt name of the market, char.
#' @param rprt name of the report, char.
#'
#' @description For the market (\code{mrkt}), you can choose between
#' \code{"XNAS"} (Nasdaq Exchange),
#' \code{"XASE"} (American Stock Exchange),
#' \code{"XNYS"} (New York's Stock Exchange),
#' \code{"XHKG"} (Hong Kong Stock Exchange),
#' \code{"XSHE"} (ShenZhen Stock Exchange), and
#' \code{"XSHG"} (Shangai Stock Exchange).
#' For the report, please select among
#' \code{"is"} (income statement),
#' \code{"cf"} (cash flow), and
#' \code{"bs"} (balance sheet).
#'
#' @examples
#'
#' morning_report("ILMN", "XNAS", "bs")
#'
morning_report <- function(tikr, mrkt, rprt){
  # prepare the url
  urls = .set_url_report(mrkt, tikr, rprt)
  # send the request
  reqs = .send_request(urls)
  # parse the report
  data = .parse_report(reqs)
  # return the dataset
  return(data)
}
