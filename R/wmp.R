wmp <- function(data) {
  totalsize <- data$L1.BidSize + data$L1.AskSize
  wmp <- data$L1.BidPrice * (data$L1.AskSize / totalsize) + data$L1.AskPrice * (data$L1.BidSize / totalsize)
  wmp
}

