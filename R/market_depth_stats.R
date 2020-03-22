#' generate descriptive statistics and quantiles for L1 market depth
#'
#' @param symbol string defining the symbol to analyze
#' @param on timespan to use for segmenting differences, using [xts::endpoints]
#'
#' @return
#'
#' @examples
#' @export
market.depth.stats <- function(symbol, on) {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  quotes <- quotes[,c("L1.BidSize", "L1.AskSize")]
  ends <- endpoints(quotes, on)
  bid.mean <- period.apply(quotes$L1.BidSize, INDEX=ends,FUN=mean)
  bid.sd <- period.apply(quotes$L1.BidSize, INDEX=ends,FUN=sd)
  bid.quantiles <- period.apply(quotes$L1.BidSize, INDEX=ends,FUN=quantile, probs=c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm=TRUE)
  bid <- cbind(bid.mean, bid.sd, bid.quantiles)
  ask.mean <- period.apply(quotes$L1.AskSize, INDEX=ends,FUN=mean)
  ask.sd <- period.apply(quotes$L1.AskSize, INDEX=ends,FUN=sd)
  ask.quantiles <- period.apply(quotes$L1.AskSize, INDEX=ends,FUN=quantile, probs=c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm=TRUE)
  ask <- cbind(ask.mean, ask.sd, ask.quantiles)
  stats <- cbind(bid, ask)
  colnames(stats) <- c("Bid.Mean", "Bid.Sd", "Bid.P01", "Bid.P25", "Bid.P50", "Bid.P75", "Bid.P99",
      "Ask.Mean", "Ask.Sd", "Ask.P01", "Ask.P25", "Ask.P50", "Ask.P75", "Ask.P99")
  stats
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

