market.depth.stats <- function(symbol, window) {
  data <- .ob[[symbol]]$quotes
  data <- data[,c("L1.BidSize", "L1.AskSize")]
  ends <- endpoints(data, window)
  bid.mean <- period.apply(data$L1.BidSize, INDEX=ends,FUN=mean)
  bid.sd <- period.apply(data$L1.BidSize, INDEX=ends,FUN=sd)
  bid.quantiles <- period.apply(data$L1.BidSize, INDEX=ends,FUN=quantile, probs=c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm=TRUE)
  bid <- cbind(bid.mean, bid.sd, bid.quantiles)
  ask.mean <- period.apply(data$L1.AskSize, INDEX=ends,FUN=mean)
  ask.sd <- period.apply(data$L1.AskSize, INDEX=ends,FUN=sd)
  ask.quantiles <- period.apply(data$L1.AskSize, INDEX=ends,FUN=quantile, probs=c(0.01, 0.25, 0.5, 0.75, 0.99), na.rm=TRUE)
  ask <- cbind(ask.mean, ask.sd, ask.quantiles)
  stats <- cbind(bid, ask)
  colnames(stats) <- c("Bid.Mean", "Bid.Sd", "Bid.P01", "Bid.P25", "Bid.P50", "Bid.P75", "Bid.P99",
      "Ask.Mean", "Ask.Sd", "Ask.P01", "Ask.P25", "Ask.P50", "Ask.P75", "Ask.P99")
                       
  stats
}
