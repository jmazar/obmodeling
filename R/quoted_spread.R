quoted.spread <- function(symbol, store=FALSE) {
  data <- .ob[[symbol]]$quotes
  quoted.spread <- (data$L1.AskPrice - data$L1.BidPrice)
  if(store)
    .ob[[symbol]]$quoted.spread <- quoted.spread
  quoted.spread
}