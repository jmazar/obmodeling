#' calculate weighted midpoint for a symbol
#'
#' @param symbol string defining the symbol to analyze
#' @param store boolean defining whether to store result in order book environment, default FALSE
#'
#' @return
#'
#' @examples
#' @export
wmp <- function(symbol, store=FALSE) {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  totalsize <- quotes$L1.BidSize + quotes$L1.AskSize
  wmp <- (quotes$L1.BidPrice * (quotes$L1.AskSize / totalsize)) + (quotes$L1.AskPrice * (quotes$L1.BidSize / totalsize))
  if(store)
    .ob[[symbol]]$wmp <- wmp
  wmp
}


###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

