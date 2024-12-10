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



# Decision trees

library(tree)
tree1<-tree(Species~Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data=iris)
summary(tree1 )
plot(tree1)
text(tree1)

library(rpart)
tree2 <- rpart(Species ~ ., data=iris, method="class")
library(rattle)
fancyRpartPlot(tree2, main="Iris") # package rattle

# random forests (bootstrapped version of CART)

library(randomForest)
# Extra to exciting your curiosity
iris.rf=randomForest(Species~., data=iris, importance=TRUE, proximity=TRUE, ntree=500)
# Required number of trees gives errors for each species and the average for all species (black):
plot(iris.rf,lty=2)

# Misclassification error rates:
iris.rf$confusion

# Importance of individual predictor variables for classification (the further the value is on the right of the plot, the more important):
varImpPlot(iris.rf)

# The membership of a particular class as a function of a variable value can be displayed with this
partialPlot(iris.rf,iris,Petal.Width,"setosa")

# we can predict unclassified observations. We make up some sample new observations from the original dataset to save some time importing (the first three rows are P. setosa, lets see if RandomForest gets that right:
newobs=iris[1:3,1:4]
predict(iris.rf,newobs)

# This last plot conveys the confidence in your predictions for each individual sample. Colors represent species and points are samples. In this case, many samples can be predicted with great certainty (1) and only few classifications are questionable (approaching 0)
plot(margin(iris.rf))



# Ordinations

# Principal Component Analysis (PCA)
# find the “best” line (first principal component) according to two different criteria of what is the “best”:
# maximize the variance & minimize the error

# PCA on varechem 
# You can standardize using scale =T
library(vegan)
data(varechem)
env.pca<-rda(varechem, scale=T) # PCA = RDA which only have one matrix (one dataset)
env.pca
summary(env.pca) # default scaling 2

# Plots using biplot
# To help memorize the meaning of the scalings, vegan now accepts argument scaling = "sites" for scaling 1 and scaling="species" for scaling 2. This is true for all vegan functions involving scalings
par(mfrow = c(1, 2))
biplot(env.pca, scaling = "sites", main = "scaling 1 / sites")
biplot(env.pca, scaling = "species", main = "scaling 2 / species") # Default scaling 2
# Objects are always called “Sites” in vegan output files
# For historical reasons, response variables are always called “species” in vegan

summary(env.pca)$species
summary(env.pca)$site
dev.off()

# Eigenvalues
# broken stick model
# One interprets only the axes whose eigenvalues are larger than the length of the corresponding piece of the stick
screeplot(env.pca, bstick = TRUE, npcs = length(env.pca$CA$eig))

# Intepretation
# combining clustering and ordination results
biplot(env.pca, main='PCA - scaling 1',scaling=1) 
ordicluster(env.pca, 
            hclust(dist(scale(varechem)), 'ward.D'), 
            prune=3, col = "blue", scaling=1)



# tb-PCA: transformation based PCA
data (varespec)
varespec.hell<-decostand(varespec,'hellinger')
decorana (varespec.hell) # Hellinger transformation
spe.h.pca<-rda(varespec.hell)
screeplot(spe.h.pca, bstick = TRUE, npcs = length(spe.h.pca$CA$eig))

# adding correlation circle
# functions from Borcard et al. 2011
source ('https://www.dipintothereef.com/uploads/3/7/3/5/37359245/cleanplot.pca.r')
cleanplot.pca (spe.h.pca) 
# Scaling 2 is default
(spe.h.pca.env <- envfit(spe.h.pca, varechem, scaling = 2))



# Redundancy Analysis (RDA & tb-RDA)
varechem.stand<-decostand(varechem,'stand')
spe.rda <- rda(varespec.hell~.,varechem.stand) 
summary (spe.rda) # scaling 2 (default)

# canonical coefficients i.e. the equivalent of regression coefficients for each explanatory variable on each canonical axis
coef(spe.rda)

#Retrieval of the adjusted R2
# Unadjusted R2 retrieve from RDA results
R2<-RsquareAdj(spe.rda)$r.squared
# Adjusted R2 retrieve from RDA object
R2adj<-RsquareAdj(spe.rda)$adj.r.squared

# triplot of the rda results
par(mfrow = c(2, 2))

# site scores are weighted by sum of species
# scaling 1: distance triplot
plot (spe.rda, scaling=1, main='Triplot RDA spe.hel ~ env – scaling 1 – wa scores')
spe.sc <- scores (spe.rda, choices=1:2, scaling=1, display='sp') 
arrows (0,0, spe.sc[,1],spe.sc[,2],length=0,lty=1,col='red') 

# scaling 2 (default)
plot (spe.rda,main='Triplot RDA spe.hel ~ env – scaling 2 – wa scores')
spe2.sc <- scores (spe.rda, choices=1:2, display='sp')
arrows (0,0, spe2.sc[,1],spe2.sc[,2],length=0,lty=1,col='red')

# site scores are linear combinations of the environmental variables
# scaling 1
plot (spe.rda,scaling=1,display=c('sp','lc','cn'),main='Triplot RDA spe.hel ~ env – scaling 1 – lc scores')
arrows (0,0, spe.sc[,1],spe.sc[,2],length=0,lty=1,col='red')
# scaling 2
plot (spe.rda,display=c('sp','lc','cn'),main='Triplot RDA spe.hel ~ env – scaling 2 – lc scores') # cn for centroids
arrows (0,0, spe2.sc[,1],spe2.sc[,2],length=0,lty=1,col='red')
dev.off()

# Global test of the RDA results
# `anova.cca` != classical ANOVA
anova.cca(spe.rda,step=1000)
# Test of all canonical axes
anova.cca(spe.rda,by='axis',step=1000)

# Variables selection
vif.cca(spe.rda) # computing the variables’ variance inflation factor
# A reduction is justified to find a parsimonious RDA !!!



# non-metric Multidimensional Scaling (nMDS):
# An indirect gradient analysis approach which produces an ordination based on a distance or dissimilarity matrix.
# nMDS is a rank-based approach. This means that the original distance data is substituted with ranks.

spe.nmds<-metaMDS(varespec,distance='bray',trymax=999)
spe.nmds
spe.nmds$stress
plot(spe.nmds,type='t',main=paste('NMDS/Bray–Stress =',round(spe.nmds$stress,3)))

stressplot(spe.nmds, main='Shepard plot')
