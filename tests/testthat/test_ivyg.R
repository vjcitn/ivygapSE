
library(ivygapSE)

context("testTargets")
test_that("test suite knows how many functions are exported", {
  exported = ls("package:ivygapSE")
  expect_true(length(exported)==9)
})

context("constantVectors")
test_that("vector lengths as anticipated", {
  expect_true(all(dim(vocab())==c(12,2)))
  gs = makeGeneSets()
  expect_true(all(sapply(gs, length)==c(26,17,17,16)))
})

context("exprPlot")
test_that("exprByType for MYC as expected", {
  et = exprByType("MYC")
  expect_true(all(names(et)==c("exprs", "types")))
  expect_true(length(et$exprs)==6)
})

context("limmaRetrieval")
test_that("getRefLimma returns expected structure", {
  requireNamespace("digest")
  grl = getRefLimma()
  expect_true(digest::digest(grl)=="89c0a44f3d1aaf374518dd3f56a8ca96")
})

context("metadataStructure")
test_that("check metadata components of ivySE", {
  data(ivySE)
  md = metadata(ivySE)
  expect_true(all(names(md)==c("README", "URL", "builder", 
         "tumorDetails", "subBlockDetails")))
  expect_true(length(md$builder)==12)
  expect_true(all(dim(md$tumorDetails)==c(42,10)))
  expect_true(all(dim(md$subBlockDetails)==c(946,26)))
})
