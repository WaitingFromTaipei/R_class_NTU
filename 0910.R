# Setting my working directory
setwd("C:/研究所_課程/113-1/Ecological data analysis in R/R_class_NTU")
#要把路徑的\換成/

library(readxl)
read_excel('Data/reef_fish.xlsx')

fish<-read_excel('Data/reef_fish.xlsx') # store my table in an object called `fish`
fish # print my object `fish`

write.table(fish, file='Data/reef_fish.txt', quote=FALSE, sep='\t', dec='.')

# import data set + create an object in R studio
fish<-read.table('Data/reef_fish.txt', header=T, sep='\t', dec='.')
# a+ simple plot
barplot(fish$richness, main="Top 10 reef fish Richness (Allen, 2000)", horiz=TRUE, names.arg=fish$country, cex.names=0.5, las=1)

# Use R as a calculator
3+2 # addition
3-2 # substraction
3*2 # multiplication
3/2 # division
3^3 # power
log(2) # logarithm
exp(2) # exponential
(5 + 3) / 4 # define priority using () or {} 
pi*4 # common function
