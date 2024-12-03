library(vegan)
library(qgraph)
library(ade4)
library(mvabund)
library(pvclust)
library(factoextra)
library(ecodist)
library(tree)
library(rpart)
library(ggplot2)
library(randomForest)
library(caret)
library(rattle)

# to be careful
library(mvpart) # install_github("cran/mvpart", force = T) # after devtools
library(MVPARTwrap) # install_github("cran/MVPARTwrap", force = T) # after devtools

#  functions from Borcard et al. 2011
source('https://www.dipintothereef.com/uploads/3/7/3/5/37359245/coldiss.r') 

# Data Structure
# 1. objects in row (e.g. samples can be sites, time periods, etc.)
# 2. measured variables for those objects in columns (e.g. species, environmental parameters, etc.)
# Measured variables can be binary, quantitative, qualitative, rank-ordered, or even a mixture of them.

# Transformations
# involves the application of a mathematical procedure to every value of a given variable or set of variables
# to create a new set of values
# Hellinger / Chord / χ^2 distance

# `decostand()` from the `vegan` package
# ?varespec
data (varespec); data(varechem)
varespec[1:5,1:5]
varechem[1:5,1:5]

# Transforming  positive  data to a logarithmic
# scale reduces the range of the data set.
varespec.log<-decostand(varespec,'log')
varespec.log[1:5,1:5]

# Centring by translation, standardize.
# Obj is to remove differences in scale due
# due to diff magnitudes between variables
varechem.stand<-decostand(varechem,'stand')
varechem.stand[1:5,1:5]
# making sure `rowSums` is the same
varespec<-decostand(varespec,'total')

# Low weights to variables with
# low counts and many zeros
varespec.hell<-decostand(varespec,'hellinger')
varespec.hell[1:5,1:5]

# Symmetrical coefficients
# Euclidean distance 歐幾里得距離 = √∑(x_i−y_j)^2
env.euc<-vegdist(varechem.stand, method='euc')
env.euc
spe.euc<-vegdist(varespec.hell, method='euc')
spe.euc

# Asymmetrical coefficient
# Bray-Curtis dissimilarity
# default option using vegdist()
spe.bc<-vegdist(varespec)
spe.bc

# Jaccard dissimilarity matrix using vegdist()
spe.jd <- vegdist(varespec,'jac',binary=T) # binary p/a 

# Visualization
# `coldiss` and the package `qgraph` -> Heat map
source('https://www.dipintothereef.com/uploads/3/7/3/5/37359245/coldiss.r')
coldiss(spe.bc,byrank=F,diag=T)
qgraph(1-spe.bc, layout='spring', vsize=4)



#Practice 7.5
library(mvabund)
data(tikus)
tikus.spe <- tikus$abund
tikus.env <- tikus$x
tikus.spe.sel <- tikus.spe[tikus.env$time %in% c(81, 83, 85)]

library(vegan)
bray.site <- vegdist(tikus.spe.sel, method = "euc")
source('https://www.dipintothereef.com/uploads/3/7/3/5/37359245/coldiss.r')
coldiss(spe.bc,byrank=F,diag=T)

bray.spe <- vegdist(t(tikus.spe.sel), "bray")



# Clustering

# Hierarchical Clustering

# Common algorithms
# SINGLE LINKAGE AGGLOMERATIVE CLUSTERING (neighbor sorting)
# Step 1: dataset
# ?doubs
library(ade4)
data(doubs)
spe.db<-doubs$fish
spa.db<-doubs$xy
# remove empty sample 8 from both datasets
spe.db <- spe.db[-8,]
spa.db <- spa.db[-8,]
# Step 2: chord distance = normalization + euclidean
spe.db.norm<-decostand(spe.db,'normalize') 
spe.db.ch<-vegdist(spe.db.norm,'euc') 
# Step 3: single linkage agglomerative clustering
spe.db.ch.single <-hclust(spe.db.ch,method='single') 
# Step 4: plot dendrogram

# COMPLETE LINKAGE AGGLOMERATIVE CLUSTERING (furthest neighbor sorting)
spe.db.ch.complete<-hclust(spe.db.ch,method='complete') 

# AVERAGE AGGLOMERATIVE CLUSTERING (e.g. UPGMA)
spe.db.ch.UPGMA<-hclust(spe.db.ch,method='average') 

# WARD’S MINIMUM VARIANCE CLUSTERING
spe.db.ch.ward<-hclust(spe.db.ch,method='ward.D') 

par(mfrow = c(2, 2))
plot(spe.db.ch.single, main='Single linkage agglomerative clustering' ) 
plot(spe.db.ch.complete, main='Complete linkage agglomerative clustering') 
plot(spe.db.ch.UPGMA, main='Average (UPGMA) agglomerative clustering') 
plot(spe.db.ch.ward, main='Ward clustering')
dev.off()

# Clustering quality

# Single linkage clustering
spe.db.ch.single.coph <- cophenetic (spe.db.ch.single)
cor(spe.db.ch,spe.db.ch.single.coph)

# complete linkage clustering
spe.db.ch.complete.coph <- cophenetic (spe.db.ch.complete)
cor(spe.db.ch,spe.db.ch.complete.coph)

# Average clustering
spe.db.ch.UPGMA.coph <- cophenetic (spe.db.ch.UPGMA)
cor(spe.db.ch,spe.db.ch.UPGMA.coph)

# Ward clustering
spe.db.ch.ward.coph <- cophenetic (spe.db.ch.ward)
cor(spe.db.ch,spe.db.ch.ward.coph)

par(mfrow=c(2,2))

plot(spe.db.ch,spe.db.ch.single.coph,xlab='Chord distance',ylab='Chophenetic distance',asp=1, main=c('Single linkage',paste('Cophenetic correlation',round(cor(spe.db.ch,spe.db.ch.single.coph),3))))
abline (0,1)
lines(lowess(spe.db.ch,spe.db.ch.single.coph),col='red')

plot(spe.db.ch,spe.db.ch.complete.coph,xlab='Chord distance',ylab='Chophenetic distance',asp=1, main=c('Complete linkage',paste('Cophenetic correlation',round(cor(spe.db.ch, spe.db.ch.complete.coph),3))))
abline (0,1)
lines(lowess(spe.db.ch, spe.db.ch.complete.coph),col='red')

plot(spe.db.ch,spe.db.ch.UPGMA.coph,xlab='Chord distance',ylab='Chophenetic distance',asp=1, main=c('UPGMA',paste('Cophenetic correlation',round(cor(spe.db.ch,spe.db.ch.UPGMA.coph),3))))
abline (0,1)
lines(lowess(spe.db.ch,spe.db.ch.UPGMA.coph),col='red')

plot(spe.db.ch,spe.db.ch.ward.coph,xlab='Chord distance',ylab='Chophenetic distance',asp=1, main=c('Ward clustering',paste('Cophenetic correlation',round(cor(spe.db.ch,spe.db.ch.ward.coph),3))))
abline (0,1)
lines(lowess(spe.db.ch,spe.db.ch.ward.coph),col='red')
dev.off()

# Cluster groups
spe.bc.UPGMA<-hclust(spe.bc,method='average') 
plot(spe.bc.UPGMA, main='Average (UPGMA) agglomerative clustering') 
rect.hclust(spe.bc.UPGMA, k=3, border="red")
rect.hclust(spe.bc.UPGMA, k=6, border="blue")
rect.hclust(spe.bc.UPGMA, k=8, border="green")

# Fusion Level values
plot(spe.bc.UPGMA$height, nrow(varespec):2, 
     type='S',main='Fusion levels - bray-curtis - UPGMA',
     ylab='k (number of clusters)', xlab='h (node height)', col='grey')
text (spe.bc.UPGMA$height,nrow(varespec):2, nrow(varespec):2, col='red', cex=0.8)

# The Silhouette widths indicator (also apply for non-hierarchical clustering)
# step 1: cut your tree
cutg1<-cutree(spe.bc.UPGMA, k=6)
# step 2: calculate silhouette for the different partitions
sil1<-silhouette (cutg1,spe.bc)
# step 3: plot silhouette 
plot(sil1)

# the Elbow method
library(factoextra) # fviz_nbclust
library(ecodist) # bcdist
fviz_nbclust(varespec,diss=bcdist(varespec), hcut, method = "wss", hc_method = "average")

# The Mantel test
# Optimal number of clusters
# according to mantel statistic 
# Function to compute a binary distance matrix from groups
grpdist<-function(x){
  require (cluster)
  gr<-as.data.frame(as.factor(x))
  distgr<-daisy(gr,'gower')
  distgr
}
# run based on the UPGMA clustering
kt<-data.frame(k=1:nrow(varespec),r=0)
for (i in 2:(nrow(varespec)-1)){
  gr<-cutree(spe.bc.UPGMA,i)
  distgr<-grpdist(gr)
  mt<-cor(spe.bc,distgr, method='pearson')
  kt[i,2] <- mt
}
k.best <- which.max (kt$r)
plot(kt$k,kt$r, 
     type='h', main='Mantel-optimal number of clusters - UPGMA',
     xlab='k (number of groups)',ylab="Pearson's correlation")
axis(1,k.best, 
     paste('optimum', k.best, sep='\n'), col='red',font=2, col.axis='red')
points(k.best,max(kt$r),pch=16,col='red',cex=1.5)

# Bootstrapping trees
library(pvclust)
pv.results<-pvclust(t(varespec), # to cluster rows - omit t() to cluster columns,
                    method.hclust = "average",
                    method.dist = function(x) vegan::vegdist(t(x), "bray"),
                    n = 1000) # and other arguments you need
plot(pv.results)

# Calculates hierarchical cluster analysis of species data 
spe.db.ch.UPGMA<-hclust(spe.db.ch,method='average') 
fviz_nbclust(spe.db, hcut, diss=dist(spe.db.norm, method='euclidean'),method = "wss",hc_method = "single")

# Dendrogram with the observed groups
par(mfrow=c(1,2))
plot (spe.db.ch.UPGMA)
rect.hclust (spe.db.ch.UPGMA, k = 6, border = 1:6)
# Spatial distribution of samples with projection of hierarchical classification
UPGMA.cluster <- cutree (spe.db.ch.UPGMA, k = 6)
plot (y ~ x, data = spa.db, pch = UPGMA.cluster, col = UPGMA.cluster, type = 'b', main = 'Chord distance - UPGMA method')
dev.off()

spe.chwo<-reorder.hclust(spe.db.ch.UPGMA,spe.db.ch)
dend<-as.dendrogram(spe.chwo) 
heatmap(as.matrix(spe.db.ch),Rowv=dend,symm=TRUE, margin=c(3,3))



# Non-Hierarchical Clustering

# k-means partitioning of the pre-transformed species data
spe.kmeans <- kmeans(spe.bc, centers=6, nstart=100)
# k-means group number of each observation spe.kmeans$cluster 
spe.kmeans$cluster
# Comparison with the 5-group classification derived from UPGMA clustering
comparison<-table(spe.kmeans$cluster,cutg1)
comparison
# Visualize k-means clusters 
fviz_cluster(spe.kmeans, data = varespec,geom = "point",
             stand = T, ellipse.type = "norm") 
spe.KM.cascade<-cascadeKM(spe.bc,inf.gr=2,sup.gr=10,iter=100,criterion='calinski')
plot(spe.KM.cascade,sortg=TRUE)
