
.obstate <- new.env(parent=emptyenv())
.obstate$ob <- '.ob'
.obstate$envir <- .GlobalEnv


#' Create or Get Order Book Environment
#'
#' @param ob string naming the order book environment, or an environment, default '.ob'
#' @param envir environment to use as the parent for the order book, default .GlobalEnv
#'
#' @return
#' pointer to the order book environment
#'
#' @examples
#'
#' .ob <- newOB()
#' is.environment(.ob)
#' # TRUE
#'
#' .ob <- getOB()
#' is.environment(.ob)
#' #TRUE
#'
#' @aliases getOB
#' @export
newOB <- function(ob='.ob', envir=.GlobalEnv){
  if(!is.environment(ob)) {
    assign(ob, new.env(hash=TRUE), envir = envir)
  }
  .obstate$ob <- ob
  .obstate$envir <- envir
  get(x=ob, pos=envir)
}

#' @rdname newOB
getOB <- function(ob=NULL, envir=NULL){
  if(is.null(ob)){
    ob <- .obstate$ob
  }
  if(is.null(envir)){
    envir <- .obstate$envir
  }
  if(!is.environment(ob) || !is.environment(get(x=ob, envir=envir))) {
    newOB(ob=ob, envir=envir)
  }
  get(ob, pos=envir)
}


###############################################################################
# obmodeling: Parsing, analysis, visualization of L1 and L2 order book data
# Copyright (c) 2017- Jeffrey Mazar and Brian G. Peterson
#
# This library is distributed under the terms of the GNU Public License (GPL)
# for full details see https://www.gnu.org/licenses/licenses.en.html
#
###############################################################################

