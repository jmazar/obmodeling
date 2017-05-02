
#' Trade Imbalance Model Fit
#'
#' Simple linear model fit for trade imbalance model
#'
#' @details TODO
#'
#' @param x xts object of tick data
#' @param actual.start start date of analysis
#' @param n.days.lookback number of days to look back for in sample data
#' @param adv.mult average daily volume multiplier for bar zize
#' @param lh liquid hours
#' @export
lm.trade.imbalance <- function(symbol, actual.start, n.days.lookback=5, adv.mult=1, lh=""){
  .ob    <- getOB()
  x <- .ob[[symbol]]$trades
  if(is.null(x)) stop('no trades found for ',symbol)
  # FIXME: should I do this by trade date instead of calendar date?
  # all unique calendar dates in x
  x.dates <- unique(as.Date(index(x)))

  # trade date sequency for model evaluation
  tdseq <- x.dates[x.dates >= actual.start]

  # loop through each "trade date"
  # - fit the model in sample
  # - apply model out of sample
  out <- foreach(td = iter(tdseq)) %do% {
    # in sample start date
    # FIXME: check if the in sample dates are in x
    isd <- x.dates[max(0, which(td == x.dates) - n.days.lookback)]

    # construct the subset range for in sample data
    # n.days.lookback from "current" trade date to 1 day prior to "current"
    # trade date
    isr <- paste(isd, td-1, sep="/")

    # in sample subset of x
    is.x <- x[isr]

    # compute average daily volume for the volume bars
    x.wdays <- is.x[.indexwday(is.x) %in% 1:5]
    adv <- sum(x.wdays$Volume, na.rm=TRUE) / length(unique(.indexday(x.wdays)))

    # compute the volume bar size and downsample data based on a volume clock
    n.volume <- floor(adv * adv.mult)
    ep <- volume.endpoints(is.x, n.volume)
    is.dat <- is.x[ep, "WMP"]
    is.dat$Volume <- period.apply(is.x$Volume, ep, sum, na.rm=TRUE)
    is.dat$TI <- period.apply(is.x, ep, trade.imbalance)

    # in sample model data
    # lag TI so that the TI value known at time 't-1' is used for WMP change
    # for time 't'
    model.dat <- na.omit(cbind(diff(is.dat$WMP), lag(is.dat$TI)))
    m <- lm(WMP ~ TI, data = model.dat)
    sm <- summary(m)

    # are the results significant (i.e. beta != 0)
    is.significant <- coef(sm)["TI", 4] <= 0.05

    # model beta estimate
    m.beta <- coef(sm)["TI", 1]

    # define period and subset out of sample data
    os.x <- x[as.character(td)]
    # use the volume bar size computed in sample
    ep <- volume.endpoints(os.x, n.volume)
    os.dat <- os.x[ep, "WMP"]
    os.dat$Volume <- period.apply(os.x$Volume, ep, sum, na.rm=TRUE)
    os.dat$TI <- period.apply(os.x, ep, trade.imbalance)
    os.dat$WMP.diff <- diff(os.dat$WMP)
    # estimated WMP (i.e. fitted values) is the model beta times the TI_{t-1}
    os.dat$e.WMP <- m.beta * lag(os.dat$TI)

    # return from the foreach loop
    return(list(td=td, isr=isr, model=m, model.summary=sm, n.volume=n.volume, os=os.dat))
  }
  names(out) <- tdseq
  out
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################
