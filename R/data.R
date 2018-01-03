#' ivySE: SummarizedExperiment for IvyGAP expression data and metadata
#' @format SummarizedExperiment instance
#' @note
#' Expression data retrieved from \url{http://glioblastoma.alleninstitute.org/api/v2/well_known_file_download/305873915}
#' @details
#' %vjcair> unzip -l gene*zip \cr
#' Archive:  gene_expression_matrix_2014-11-25.zip \cr
#'   Length      Date    Time    Name \cr
#' ---------  ---------- -----   ---- \cr
#'     50585  03-31-2015 13:27   columns-samples.csv \cr
#'  86153820  10-31-2014 14:04   fpkm_table.csv \cr
#'      2015  11-24-2014 18:06   README.txt \cr
#'   1689619  10-31-2014 13:55   rows-genes.csv \cr
#' ---------                     ------- \cr
#'  87896039                     4 files \cr
#' @source processed from \url{glioblastoma.alleninstitute.org}; see Note.
#' @examples
#' \dontrun{   # how it was made
#' ivyFpkm = read.csv("fpkm_table.csv", stringsAsFactors=FALSE, 
#'       check.names=FALSE)
#' g = read.csv("rows-genes.csv", stringsAsFactors=FALSE)
#' library(SummarizedExperiment)
#' imat = data.matrix(ivyFpkm[,-1])
#' ivySE = SummarizedExperiment(SimpleList(fpkm=imat))
#' rowData(ivySE) = g
#' rownames(ivySE) = g$gene_symbol
#' col = read.csv("columns-samples.csv", stringsAsFactors=FALSE)
#' rownames(col) = col$rna_well_id
#' stopifnot(all.equal(as.character(col$rna_well_id), 
#'      as.character(colnames(imat))))
#' colData(ivySE) = DataFrame(col)
#' colnames(ivySE) = colnames(imat)
#' metadata(ivySE) = list(README=readLines("README.txt"))
#' metadata(ivySE)$URL = "http://glioblastoma.alleninstitute.org/static/download.html"
#' # metadata(ivySE)$builder = readLines("build.R")
#' de = read.csv("tumor_details.csv", stringsAsFactors=FALSE)
#' metadata(ivySE)$tumorDetails = de
#' subbl = read.csv("sub_block_details.csv", stringsAsFactors=FALSE)
#' metadata(ivySE)$subBlockDetails = subbl
#' bamtab = read.csv("bam.csv", stringsAsFactors=FALSE)
#' rownames(bamtab) = as.character(bamtab$rna_well)
#' bamtab[colnames(ivySE),] -> bamtreo
#' all.equal(rownames(bamtreo), colnames(ivySE))
#' colData(ivySE) = cbind(colData(ivySE), bamtreo)
#' }
#' data(ivySE)
#' names(metadata(ivySE))
"ivySE"

#' helper functions for data access
#' @rdname helper
#' @param se SummarizedExperiment instance, intended to work for ivySE in this package
#' @aliases tumorDetails
#' @export
tumorDetails = function(se) metadata(se)$tumorDetails
#' @rdname helper
#' @aliases subBlockDetails
#' @export
subBlockDetails = function(se) metadata(se)$subBlockDetails
#' @rdname helper
#' @aliases vocab
#' @export
vocab = function() {
data.frame(
 abbr = c("PAN", "PNN", "NE", "BV", "HBV", "MVP", "EN",
   "CT", "CTpnz", "HE", "FOLD", "SPA"),
 def = c("pseudopalisading cells around necrosis",
"pseudopalisading cells no necrosis",
"necrosis", "blood vessels", "hyperplastic blood vessels",
"microvascular proliferation", "early necrosis",
"cellular tumor", "cellular tumor perinecrotic zone",
"hemorrhage", "tissue fold", "space"))
}

#' provide access to a limma analysis of RNA-seq profiles for reference histology samples
#' @importFrom utils download.file
#' @note Uses \code{\link[utils]{download.file}} to acquire RDS of the output
#' of \code{\link[limma]{eBayes}} from a public S3 bucket.  The limma model
#' was fit using \code{\link[limma]{duplicateCorrelation}} to address multiplicity
#' of contributions per donor.  Comparisons are to samples labeled \code{CT-reference} (cellular tumor, reference contributions),
#' with coefficients 2-5 corresponding to CT-mvp (microvascular proliferation),
#' CT-pan (pseudopalisading cells around necrosis), IT (infiltrating tumor),
#' and LE (leading edge), respectively.
#' @examples
#' requireNamespace("limma")
#' ebout = getRefLimma() # is result of eBayes
#' colnames(ebout$coef)
#' limma::topTable(ebout,2)
#' @export
getRefLimma = function() {
 if (!requireNamespace("limma")) stop("install limma to use this function")
 tf = tempfile()
 download.file("https://s3.amazonaws.com/bcfound-itcr/histoLimma.rds", tf)
 readRDS(tf)
}
