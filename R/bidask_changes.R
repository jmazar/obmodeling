#' calculate changes in L1 bid and ask prices
#'
#' @param symbol string defining the symbol to analyze
#' @param on timespan to use for segmenting differences, using [xts::endpoints]
#'
#' @return
#'
#' @examples
#' @export
bidask.changes <- function(symbol, on='minutes') {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  quotes <- quotes[,c("L1.BidPrice", "L1.AskPrice")]
  diffed <- diff(quotes)
  bidchanges <- diffed$L1.BidPrice > 0
  askchanges <- diffed$L1.AskPrice > 0
  changes <- bidchanges + askchanges
  ends <- endpoints(changes, on)
  sums <- period.apply(changes, INDEX=ends,FUN=sum)
  sums
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

