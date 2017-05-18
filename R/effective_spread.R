#' effective bid/ask spread defined from trades
#'
#' @param symbol string defining the symbol to analyze
#' @param store boolean defining whether to store result in order book environment, default FALSE
#'
#' @return
#'
#' @examples
#' @references
#'   Jong, Rindi de. 2009. *The Microstructure of Financial Markets*. Cambridge. p. 93 Definition 3
#' @export
effective.spread <- function(symbol, store=FALSE) {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  trades <- .ob[[symbol]]$trades
  if(is.null(trades)) stop('no trades found for ',symbol)
  trades.inside <- merge(trades, quotes$L1.AskPrice, quotes$L1.BidPrice)
  trades.inside$L1.AskPrice <- na.locf(trades.inside$L1.AskPrice)
  trades.inside$L1.BidPrice <- na.locf(trades.inside$L1.BidPrice)
  trades.inside$side <- ifelse(trades.inside$Price == trades.inside$L1.AskPrice, 1, -1)
  eff.spread <- 2 * trades.inside$side * (trades.inside$Price - (trades.inside$L1.AskPrice + trades.inside$L1.BidPrice) / 2)
  eff.spread <- na.omit(eff.spread)
  colnames(eff.spread) <- 'effective.spread'
  if(store)
    .ob[[symbol]]$effective.spread <- eff.spread
  eff.spread
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################