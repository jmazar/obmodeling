trade.size.stats <- function(symbol, window) {
  data <- .ob[[symbol]]$trades
  ends <- endpoints(data, window)
  trade.mean <- period.apply(data$Volume, INDEX=ends,FUN=mean)
  trade.sd <- period.apply(data$Volume, INDEX=ends,FUN=sd)
  trade.quantiles <- period.apply(data$Volume, INDEX=ends,FUN=quantile, probs=c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm=TRUE)
  stats <- cbind(trade.mean, trade.sd, trade.quantiles)
  colnames(stats) <- c("Trade.Mean", "Trade.Sd", "Trade.P01", "Trade.P25", "Trade.P50", "Trade.P75", "Trade.P99")
  stats
}
