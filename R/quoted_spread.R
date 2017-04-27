#' @rdname ticks.wide
quoted.spread <- function(symbol, store=FALSE) {
  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)
  q.spread <- (quotes$L1.AskPrice - quotes$L1.BidPrice)
  colnames(q.spread) <- 'quoted.spread'
  if(store)
    .ob[[symbol]]$quoted.spread <- quoted.spread
  quoted.spread
}
