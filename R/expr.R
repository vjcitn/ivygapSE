#' simple plot of expression values by structure/expression-based selection in IvyGAP
#' @importFrom graphics axis plot
#' @param sym a gene symbol found among `rownames(ivySE)`
#' @param \dots passed to plot, exclusive of ylab, xlab, axes
#' @examples
#' exprByType("MYC")
#' @export
exprByType = function (sym, ...) 
{
    if (!exists("ivySE")) data(ivySE)
    stopifnot(sym %in% rownames(ivySE))
    opar = par(no.readonly=TRUE)
    par(mar=c(11,4,2,2))
    on.exit(par(opar))
    inds = grep(sym, ivySE$structure_acronym)
    if (length(inds)==0) stop(sprintf("%s not found among genes used for RNA-seq sample selection", sym))
    n = length(inds)
    plot(1:n,  assay(ivySE)[sym, inds], ylab = sym, xlab = "sample type", 
        axes = FALSE, ...)
    axis(2)
    axis(1, at = 1:n, labels = ivySE$structure_acronym[inds], 
        las = 2)
}

