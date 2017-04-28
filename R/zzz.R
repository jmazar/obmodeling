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

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

