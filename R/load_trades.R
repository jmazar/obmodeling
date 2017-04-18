load.trades <- function(filename) {
  #if(!is.environment(.ob))
    .ob <<- new.env()
  raw.csv <- read.csv(filename)
  symbols <- split(raw.csv, raw.csv$X.RIC)
  xts.data <- lapply(symbols, function(x) {
    tmp <- paste(x$Date.G., x$Time.G.)
    time <- as.POSIXct(tmp, tz=paste0("Etc/GMT", x$GMT.Offset[1]), format="%d-%b-%Y %H:%M:%OS")
    xts(x[, 6:7], order.by=time)
  })
  names(xts.data) <- names(symbols)
  for(symbol in names(xts.data)) {
    .ob[[symbol]]$trades <- new.env()
    .ob[[symbol]]$trades <- xts.data[[symbol]]
  }
}
load.trades("data/trades.csv")