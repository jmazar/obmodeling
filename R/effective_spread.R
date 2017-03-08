effective.spread <- function(symbol, store=FALSE) {
  quotes <- .ob[[symbol]]$quotes
  trades <- .ob[[symbol]]$trades
  trades.inside <- merge(trades, quotes$L1.AskPrice, quotes$L1.BidPrice)
  trades.inside$L1.AskPrice <- na.locf(trades.inside$L1.AskPrice)
  trades.inside$L1.BidPrice <- na.locf(trades.inside$L1.BidPrice)
  trades.inside$side <- ifelse(trades.inside$Price == trades.inside$L1.AskPrice, 1, -1)
  effective.spread <- 2 * trades.inside$side * (trades.inside$Price - (trades.inside$L1.AskPrice + trades.inside$L1.BidPrice) / 2)
  effective.spread <- na.omit(effective.spread)
  if(store)
    .ob[[symbol]]$effective.spread <- effective.spread
  effective.spread
}

