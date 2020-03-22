#' @rdname ticks.wide
quoted.spread <- function(symbol, store=FALSE) {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  q.spread <- (quotes$L1.AskPrice - quotes$L1.BidPrice)
  colnames(q.spread) <- 'quoted.spread'
  if(store)
    .ob[[symbol]]$quoted.spread <- q.spread
  return(q.spread)
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

