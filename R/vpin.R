# #install.packages('fasttime',repos='http://www.rforge.net/')
# require(data.table); require(fasttime); require(plyr)
# # Assuming TAQ data is arranged in 1 year stock csv files
# stock=fread('/Data/Dropbox/AAON.csv'); stock=stock[,1:3,with=FALSE]
# setnames(stock,colnames(stock),c('DateTime','Price','Volume'));
# stock[,DateTime:=paste(paste(substr(DateTime,1,4),substr(DateTime,5,6),
#                              substr(DateTime,7,8),sep='-'),substr(DateTime,10,17))]
# setkey(stock,DateTime);
# stock=as.xts(stock[,2:3,with=FALSE],unique=FALSE,
#              order.by=fastPOSIXct(stock[,DateTime],tz='GMT'))
# # Now we have an xts data frame called 'stock' with a DateTime index and
# # two columns: Price and Volume
# # Vbucket=Number of volume buckets in an average volume day (Vbucket=50)
# VPIN=function(stock,Vbucket) {
#   stock$dP1=diff(stock[,'Price'],lag=1,diff=1,na.pad=TRUE)
#   ends=endpoints(stock,'minutes')
#   timeDF=period.apply(stock[,'dP1'],INDEX=ends,FUN=sum)
#   timeDF$Volume=period.apply(stock[,'Volume'],INDEX=ends,FUN=sum)
#   Vbar=mean(period.apply(timeDF[,'Volume'],INDEX=endpoints(timeDF,'days'),FUN=sum))/Vbucket
#   timeDF$Vfrac=timeDF[,'Volume']/Vbar
#   timeDF$CumVfrac=cumsum(timeDF[,'Vfrac'])
#   timeDF$Next=(timeDF[,'CumVfrac']-floor(timeDF[,'CumVfrac']))/timeDF[,'Vfrac']
#   timeDF[timeDF[,'Next']<1,'Next']=0
#   timeDF$Previous=lag(timeDF[,'dP1'])*lag(timeDF[,'Next'])
#   timeDF$dP2=(1-timeDF[,'Next'])*timeDF[,'dP1'] + timeDF[,'Previous']
#   timeDF$Vtick=floor(timeDF[,'CumVfrac'])
#   timeDF[,'Vtick']=timeDF[,'Vtick']-diff(timeDF[,'Vtick']); timeDF[1,'Vtick']=0
#   timeDF=as.data.frame(timeDF); timeDF[,'DateTime']=row.names(timeDF)
#   timeDF=ddply(as.data.frame(timeDF),.(Vtick),last)
#   timeDF=as.xts(timeDF[,c('Volume','dP2','Vtick')],
#                 order.by=fastPOSIXct(timeDF$DateTime,tz='GMT'))
#   timeDF[1,'dP2']=0
#   timeDF$sigma=rollapply(timeDF[,'dP2'],Vbucket,sd,fill=NA)
#   timeDF$sigma=na.fill(timeDF$sigma,"extend")
#   timeDF$Vbuy=Vbar*pnorm(timeDF[,'dP2']/timeDF[,'sigma'])
#   timeDF$Vsell=Vbar-timeDF[,'Vbuy']
#   timeDF$OI=abs(timeDF[,'Vsell']-timeDF[,'Vbuy'])
#   timeDF$VPIN=rollapply(timeDF[,'OI'],Vbucket,sum)/(Vbar*Vbucket)
#   timeDF=timeDF[,c('VPIN')]; return(timeDF)
# }
# out=VPIN(stock,50)
#source('R/load_trades.R')
#require(data.table); require(fasttime); require(plyr)
#load.trades("data/trades.csv")
vpin <- function(symbol, bucket.size) {
  .ob <- getOB()
  trades <- .ob[[symbol]]$trades
  if(is.null(trades)) stop('no trades found for ',symbol)
  trades$dP1 <- diff(trades$Price, lag=1, diff=1, na.pad=TRUE)
  ends <- endpoints(trades,'seconds')
  timeDF <- period.apply(trades$dP1,INDEX=ends,FUN=sum)
  timeDF$Volume <- period.apply(trades$Volume,INDEX=ends,FUN=sum)
  Vbar <- mean(period.apply(timeDF$Volume,INDEX=endpoints(timeDF,'days'),FUN=sum))/bucket.size
  timeDF$Vfrac <- timeDF$Volume/Vbar
  timeDF$CumVfrac <- cumsum(timeDF$Vfrac)
  timeDF$Next <- (timeDF$CumVfrac-floor(timeDF$CumVfrac))/timeDF$Vfrac
  timeDF[timeDF$Next<1,'Next'] <- 0
  timeDF$Previous <- lag(timeDF$dP1)*lag(timeDF$Next)
  timeDF$dP2 <- (1-timeDF$Next)*timeDF$dP1 + timeDF$Previous
  timeDF$Vtick <- floor(timeDF$CumVfrac)
  timeDF$Vtick <- timeDF$Vtick - diff(timeDF$Vtick)
  timeDF[1,'Vtick'] <- 0
  timeDF <- as.data.frame(timeDF)
  timeDF[,'DateTime']=row.names(timeDF)
  ## FIXME remove ddply
#  timeDF <- ddply(as.data.frame(timeDF),.(Vtick),last)
  timeDF <- as.xts(timeDF[,c('Volume','dP2','Vtick')],
                order.by=fastPOSIXct(timeDF$DateTime,tz='GMT'))
  timeDF[1,'dP2'] <- 0
  timeDF$sigma <- rollapply(timeDF$dP2,bucket.size,sd,fill=NA)
  timeDF$sigma <- na.fill(timeDF$sigma,"extend")
  timeDF$Vbuy <- Vbar * pnorm(timeDF$dP2/timeDF$sigma)
  timeDF$Vsell <- Vbar - timeDF$Vbuy
  timeDF$OI <- abs(timeDF$Vsell -timeDF$Vbuy)
  timeDF$VPIN <- rollapply(timeDF[,'OI'],bucket.size,sum)/(Vbar*bucket.size)
  timeDF <-timeDF[,c('VPIN')]
  return(timeDF)
}

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

