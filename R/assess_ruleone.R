#' Computes the rule-one statistics
#'
#' @param tikr tiker of the company, char.
#' @param mrkt the name of the market, char.
#' @param nyrs number of years to analyze, int. (Default, 5)
#'
#' @example
#'
#' library(financer)
#' assess_ruleone("ILMN", "XNAS")
#'
assess_ruleone <- function(tikr, mrkt, nyrs = 5){
  # if 5 years, morningstar
  if(nyrs <= 5){
    # download the financial statements
    tikr.is = morning_report(tikr, mrkt, "is")
    tikr.bs = morning_report(tikr, mrkt, "bs")
    tikr.cf = morning_report(tikr, mrkt, "cf")
    #
  # if more than 5, quick fs
  }else if (nyrs > 5){

  }
}
