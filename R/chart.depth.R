#' chart market depth at a point in time for a symbol
#'
#' @param symbol string defining the symbol to analyze
#' @param timestamp ISO-8601 or timebased object defining the point in time you wish to chart
#' @param offset whether to show offers as negative, boolean, default TRUE
#'
#' @return
#'
#' invisible xts object showing prices and depths for timestamp
#'
#' @examples
#' @export
chart.depth <- function(symbol, timestamp, offset=TRUE) {

  .ob <- getOB()
  quotes <- .ob[[symbol]]$quotes
  if(is.null(quotes)) stop('no quotes found for ',symbol)

  if(missing(timestamp)){
    timestamp <- last(index(quotes))
    message('no timestamp argument, using last timestamp ',timestamp,' for ',symbol)
  }

  #subset to one row
  quotes <- quotes[timestamp]
  if(nrow(quotes)==0) stop('no rows in quotes for ', timestamp)
  if(nrow(quotes)>1){
    message('subset [', timestamp, '] contains more than one row, using last')
    quotes<- last(quotes)
  }
  quote.sizes <- quotes[,grep('Size',colnames(quotes))]
  #offset +/-
  if(offset){
    #make offers negative
    askcols <- grep('Ask',colnames(quote.sizes))
    quote.sizes[,askcols] <- -1*quote.sizes[,askcols]

    mq=min(quote.sizes)
  } else {

    mq=0
  }
  prices <- coredata(quotes[,grep('Price',colnames(quotes))])
  colnames(quote.sizes) <- as.character(prices)
  quote.sizes <- quote.sizes[,sort(colnames(quote.sizes))]

  nas <- which(is.na(quote.sizes))
  quote.sizes[,nas] <- 0
  prices <- as.numeric(colnames(quote.sizes))

  # Vertical histogram
  plot (NA, type='n', axes=FALSE, yaxt='n',
        xlab='Quantity', ylab='Price',
        main=paste0('Depth for ',symbol),
        xlim=c(mq,max(quote.sizes)),
        ylim=c(min(prices),max(prices)))
  axis (1)
  arrows(rep(0,ncol(quote.sizes)),prices,
         quote.sizes,prices,
         length=0,angle=0)

  invisible(quote.sizes)
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################
