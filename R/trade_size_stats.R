#' generate descriptive statistics and quantiles for trades
#'
#' @param symbol string defining the symbol to analyze
#' @param on timespan to use for segmenting differences, using [xts::endpoints]
#'
#' @return
#'
#' @examples
#' @export
trade.size.stats <- function(symbol, on) {
  .ob    <- getOB()
  trades <- .ob[[symbol]]$trades
  if(is.null(trades)) stop('no trades found for ',symbol)
  ends   <- endpoints(trades, on)
  trade.mean <- period.apply(trades$Volume, INDEX=ends,FUN=mean)
  trade.sd <- period.apply(trades$Volume, INDEX=ends,FUN=sd)
  trade.quantiles <- period.apply(trades$Volume, INDEX=ends,FUN=quantile, probs=c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm=TRUE)
  stats <- cbind(trade.mean, trade.sd, trade.quantiles)
  colnames(stats) <- c("Trade.Mean", "Trade.Sd", "Trade.P01", "Trade.P25", "Trade.P50", "Trade.P75", "Trade.P99")
  stats
}
