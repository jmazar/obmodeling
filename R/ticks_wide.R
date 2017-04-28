#' calculate the quoted market bid/ask spread
#'
#' For `quoted.spread`, the bid ask spread will be calculated as
#'
#' \eqn{ L1.AskPrice - L1.BidPrice }
#'
#' for `ticks.wide` the quoted spread will be additionally divided by the
#' `tick_size`.
#'
#'
#' @param symbol string defining the symbol to analyze
#' @param tick_size numeric tick size to use as denominator, if NULL, look up using [FinancialInstrument::getInstrument]
#' @param store boolean defining whether to store result in order book environment, default FALSE
#'
#' @return
#' `xts` object containing the spread
#' @examples
#' @export
ticks.wide <- function(symbol, tick_size=NULL, store=FALSE) {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  if(is.null(tick_size)){
    tick_size <- tryCatch(getInstrument(symbol)$tick_size,
                          stop('no tick_size defined, and no instrument found for ',symbol))
  }
  spread.ticks <- quoted.spread(symbol=symbol, store=store) / tick_size
  colnames(spread.ticks) <- 'quoted.spread.ticks'
  if(store)
    .ob[[symbol]]$ticks.wide <- ticks.wide
  ticks.wide
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

