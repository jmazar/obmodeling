.onLoad <- function(lib, pkg)
{
  # Startup Mesage and Desription:
  dsc <- packageDescription(pkg)
  if(interactive() || getOption("verbose")) {
    # not in test scripts
    packageStartupMessage(paste("\nPackage ", pkg, " (",dsc$Version,") loaded.\n"
                          , "Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson, "
                          , dsc$License
                          , dsc$URL
                          , "\n", sep=""))
  }
}

#' @importFrom utils packageDescription
#' @importFrom utils read.csv
#' @import xts
#' @import zoo
#' @import fasttime
#' @import FinancialInstrument
NULL
