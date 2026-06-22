install.packages("BiocManager")
BiocManager::install("MLInterfaces")

library(MLInterfaces)
example(hclustWidget, ask=FALSE)

BiocManager::install("fpc")
BiocManager::install("ivygapSE")
install.packages("dplyr")


install.packages("randomForest")
install.packages("beeswarm")

library(ivygapSE)
library(dplyr)

data(ivySE)
td = metadata(ivySE)$tumorDetails 
left_join(as.data.frame(colData(ivySE)), td, by="tumor_name") -> ll

dim(ll)
length(unique(ll$donor_id))
table(td,ivySE$short_study)




refex = ivySE[, grep("reference", ivySE$structure_acronym)]
refex$struc = factor(refex$structure_acronym)
iqrs = rowIQRs(assay(refex))
inds = which(iqrs>quantile(iqrs,.5))

set.seed(1234)
library(randomForest)
rf1 = randomForest(x=t(assay(refex[inds,])),
                   y=refex$struc, mtry=30, importance=TRUE)
rf1
varImpPlot(rf1)

struc = as.character(colData(ivySE)$structure_acronym)
spls = strsplit(struc, "-")
basis = vapply(spls, function(x) x[1], character(1))
specific = which(basis!= "CT")
iseSP = ivySE[ , specific]
#spbasis = basis[specific]
useful = c("EIF4E3", "RNASE4", "PBK", "RYR2", "TPD52L1",
           "GIMAP6", "PRKCB", "ATP6V1A", "RUNDC3B", "CCPG1")
splim = iseSP[useful,]
#bb = prcomp(log(t(assay(splim))+1))
#rownames(bb$x) = spbasis
struc = as.character(colData(ivySE)$structure_acronym)
spls = strsplit(struc, "-")
basis = vapply(spls, function(x) x[1], character(1))
iseSP = ivySE[ , specific]

useful = c("EIF4E3", "RNASE4", "PBK", "RYR2", "TPD52L1",
           "GIMAP6", "PRKCB", "ATP6V1A", "RUNDC3B", "CCPG1")
splim =ivySE[useful,]
bb = prcomp(log(t(assay(splim))+1))
rownames(bb$x) = basis
biplot(bb)

install.packages("beeswarm")
library(beeswarm)

### This shows how distributions of some of the prominent genes in the biplot differ among the anatomic structures
par(mar=c(5,3,1,1), las=2, mfrow=c(2,3))  
for (i in c("PBK", "RNASE4", "TPD52L1", "PRKCB", "GIMAP6", "RUNDC3B")) 
  beeswarm(split(log2(assay(ivySE[i,])+1), basis), cex=.5, main=i)

satt = darmanis$sra.sample_attributes
ssatt = strsplit(satt, "\\|")
table(sapply(ssatt,"[",1))

rmads = rowMads(assay(darmanis))

sum(rmads>20)
sum(rmads>50)
sum(rmads>100)
sum(rmads>1000)
sum(rmads>10000)
dv = darmanis[which(rmads>10000),]
pp = prcomp(t(log(assay(dv)+1)))
table(cl <- sapply(ssatt,"[",1))
pairs(pp$x[,1:4], pch=19, cex=.3, col=as.numeric(factor(cl)))

### steps to take
## step 1
m=matrix(rnorm=100)

BiocManager::install("MLInterfaces",force = TRUE)

library("MLInterfaces")
library("shiny")

hclustWidget

hclustWidget(useful, featureName = "feature", title =
               paste0("hclustWidget for ", deparse(substitute(useful))),
             minfeats = 2, auxdf = NULL)










