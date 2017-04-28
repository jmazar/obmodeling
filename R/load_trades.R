#' load trades or quotes from a csv file
#'
#' @param filename filename to load trades/quotes from
#' @param symbol.col string defining the column containing the symbol, default 'X.RIC'
#' @param tz timezone string as defined by [base::timezones], default 'GMT'
#' @param format character string representing the date-time specification as described in [base::strptime]
#' @param \dots any passthrough parameters for [utils::read.csv]
#' @return
#'
#' @examples
#' @aliases load.quotes
#' @export
load.trades <- function(filename, symbol.col='X.RIC', tz='GMT' , format="%d-%b-%Y %H:%M:%OS", ...) {
  .ob <- getOB()
  raw.csv <- read.csv(filename, ...=...)
  symbol.list <- split(raw.csv, raw.csv[,symbol.col])

  xts.data <- lapply(symbol.list, function(x) {
    tmp <- paste(x$Date.G., x$Time.G.)
    time <- as.POSIXct(tmp, tz=tz, format=format)
    out <- xts(x[, 6:7], order.by=time)
    class(out) <- c('ob.trades','xts','zoo')
  })
  names(xts.data) <- names(symbol.list)
  for(symbol in names(xts.data)) {
    .ob[[symbol]]$trades <- new.env()
    .ob[[symbol]]$trades <- xts.data[[symbol]]
  }
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

