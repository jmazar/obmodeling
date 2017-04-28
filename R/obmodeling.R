#' @details
#'
#' The obmodeling package is designed to allow for modeling of order book features
#' and dynamics based on L1 and L2 data.  It includes analytical methods and
#' graphiocs drawn from the microstructure literature and aims to be useful both
#' for professional and academic researchers.
#'
#' This is an **R** package which uses *xts* time series objects to manipulate
#' and analyze:
#'
#' - Depth of the market at a given time
#'
#' - Volume
#'
#' - Price movement through the day
#'
#' - Weighted Midpoint (Cartea 2015)
#'
#' - Market spread (Jong 2009, 91–96)
#'
#' - Measures of liquidity (Cartea 2015)
#'
#' - Measures of volatility (Jong 2009, 92; Cartea 2015)
#'
#' - PIT/VPIT (O. Easley D. 1996; L. de P. Easley D. 2012)
#'
#' - Price pressure (Hendershot 2014; Rama Cont 2011)
#'
#' - Trade imbalance (Rama Cont 2011)
#'
#' @references
#'
#' Cartea, Penalva, Jaimungal. 2015. *Algorithmic and High-Frequency Trading*. Cambridge.
#'
#' Easley, López de Prado, D. 2012. “Flow Toxicity and Liquidity in a High-Frequency World.” *Review of Financial Studies* 25 (5): 1456–93.
#'
#' Easley, O’Hara, D. 1996. “Liquidity, Information, and Infrequently Traded Stocks.” *The Journal of Finance*. 2 51 (4): 1405–36.
#'
#' Hendershot, Menkveld. 2014. “Price Pressures.” *Journal of Financial Econometrics* 114: 405–23.
#'
#' Jong, Rindi de. 2009. *The Microstructure of Financial Markets*. Cambridge.
#'
#' Rama Cont, Sasha Stoikov, Arseniy Kukanov. 2011. “The Price Impact of Order Book Events.” **ArXiv**.
#'
#' @author Jeffrey Mazar and Brian G. Peterson
#'
#' @rdname obmodeling-package
#' @docType package
#' @keywords package
"_PACKAGE"

###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################
