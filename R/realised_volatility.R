#' realised volatility defined from trades
#'
#' @param symbol string defining the symbol to analyze
#' @param d number of past entries taken for measurement, default 15
#'
#' @return
#'
#' @examples
#' @references
#'   Cartea, Penalva, Jaimungal. 2015. *Algorithmic and High-Frequency Trading*. Cambridge. p. 77 Formulae of Realised Volatility
#' @export

realised_voltility <- function(symbol, d = 15) {  
  
  #0: check if required packages are installed
  list.of.packages <- c("dplyr")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  library(dplyr)
  
  #1: get the prices from trades (null removed), then calculate return -> r_t = log(p_t/p_(t-1)) for t starting from d and more
  .ob <- getOB()
  trades <- .ob[[symbol]]$trades
  if(is.null(trades)) stop('no trades found for ',symbol)
  #if price is NA, use past price 
  trades$Price <- na.locf(trades$Price)
  trades$LagPrice <- lag(trades$Price,n = 1L)
  trades$Return <- log(trades$Price/trades$LagPrice)
  trades <- trades[!is.na(trades$Return),]
  
  #2: use the formulae of sigma^2 (realised volatility as on p77, Algorithmic & High Frequency Trading)
  trades$Volatility <- NA
  trades
  n <- length(trades$Return)
  d <- 15
  seq <- seq(d,n)
  if(d>=n){
    print("Not enough value for chosen duration, please reduce it. Maximum possible duration: ")
    print(n)
  } else{
    for(i in seq){
      # print(i-d)
      # print(i)
      row_idx <- seq(i-d+1,i)
      dt <- trades[row_idx,]
      return <- (dt$Return)
      r_mean <- sum(return)/length(return)
      # print(sum(return))
      dev <- (return - r_mean)^2
      vol <- sum(dev)
      trades$Volatility[i] <- vol
    }
    trades <- trades[!is.na(trades$Volatility),]
    trades$Volatility
  }
}