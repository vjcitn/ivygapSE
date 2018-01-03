renderPNG = function(fi) {
  if (!requireNamespace("png")) stop("install png to run this function")
  if (!requireNamespace("grid")) stop("install grid to run this function")
  p = png::readPNG(system.file(paste0("pngs/", fi), package="ivygapSE"))
  grid::grid.raster(p)
}

#' render design overview
#' @rdname imgSupport
#' @aliases designOverview
#' @export
designOverview = function()
  renderPNG("whiteSixStud.png")
#' render anatomic nomenclature
#' @rdname imgSupport
#' @aliases nomenclat
#' @export
nomenclat = function()
  renderPNG("anatomicNomenclature.png")

