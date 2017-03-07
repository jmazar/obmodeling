wmp <- function(symbol, store=FALSE) {
  data <- .ob[[symbol]]$quotes
  totalsize <- data$L1.BidSize + data$L1.AskSize
  wmp <- data$L1.BidPrice * (data$L1.AskSize / totalsize) + data$L1.AskPrice * (data$L1.BidSize / totalsize)
  if(store)
    .ob[[symbol]]$wmp <- wmp
  wmp
}

