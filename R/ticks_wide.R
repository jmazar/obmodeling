ticks.wide <- function(symbol, tick.size, store=FALSE) {
  data <- .ob[[symbol]]$quotes
  ticks.wide <- (data$L1.AskPrice - data$L1.BidPrice) / tick.size
  if(store)
    .ob[[symbol]]$ticks.wide <- ticks.wide
  ticks.wide
}