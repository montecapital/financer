#' Downloads the companies traded by 99
#'
#' @example
#'
#' nn.list = ninentynine_stocklist()
#' head(nn.list)
#'
ninentynine_stocklist <- function(retrn = TRUE){
  # default number of companies per page
  nppg = 20
  # Extract number of companies and pages
  url = "https://ninetynine.com/acciones/"
  num = .get_nums(url, nppg)
  npg = num[1]
  tot = num[2]
  # initialize the output
  out = data.frame(matrix(NA, nrow = tot , ncol = 3))
  colnames(out) = c("company", "tikr", "price")
  # Read the current page
  counter = 1
  for(i in 1:npg){
    # wait one second
    Sys.sleep(1)
    # find the url for the current page
    urli = paste0(url, "/?currpage=", i)
    # read the page
    htmli = read_html(urli)
    # extract the list
    html_compis = .get_companies(htmli)
    # actual number in this page
    nppgi = length(html_compis)
    # for each company
    for(j in 1:nppgi){
      # extract the info
      out[counter,] = .get_stats(html_compis[j])
      # update the counter
      counter = counter + 1
    }
  }
  # return the matrix
  if(!retrn){
    # Write the output as csv
    fname = paste0("nintynine_list_",format(Sys.Date(),"%Y%m%d"),".csv")
    write.csv(out, fname, row.names = FALSE, col.names = TRUE)
    out = fname
  }
  # return the file name
  return(out)
}



# computes the number of pages
.get_nums <- function(url, nppg){
  # read the url
  html = read_html(url)
  # find number of companies
  html_total = html_text(html_nodes(html, "div.pagination__position"))
  ntotal = as.numeric(strsplit(html_total, " ")[[1]][[2]])
  # compute the number of pages (each 20)
  npages = ceiling(ntotal/nppg)
  # return the result
  return(c(npages, ntotal))
}

# gets the company list
.get_companies <- function(htmli, path = "div.company-list a"){
  # find the list under the path
  html_compis = html_nodes(htmli, "div.company-list a")
  # return the results
  return(html_compis)
}

# extract stats of the company
.get_stats <- function(company){
  # extract the title
  cname = html_text(html_node(company, "h3.company__title"))
  # extrac the tikr
  ctikr = html_text(html_node(company, "span.company__symbol"))
  # extract the price
  cpric = html_text(html_node(company, "div.company__prices"))
  # refine the price
  cpric = str_match(cpric, "\\n(.*?)\\$")[2]
  cpric = gsub("\\.", "", cpric)
  cpric = gsub("\\,", "\\.", cpric)
  cpric = as.numeric(cpric)
  # return the values in order
  return(data.frame(cname, ctikr, cpric))
}
