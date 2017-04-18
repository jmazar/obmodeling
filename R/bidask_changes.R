bidask.changes <- function(symbol, window) {
  data <- .ob[[symbol]]$quotes
  data <- data[,c("L1.BidPrice", "L1.AskPrice")]
  diffed <- diff(data)
  bidchanges <- diffed$L1.BidPrice > 0
  askchanges <- diffed$L1.AskPrice > 0
  changes <- bidchanges + askchanges
  ends <- endpoints(changes, window)
  sums <- period.apply(changes, INDEX=ends,FUN=sum)
  sums
}
