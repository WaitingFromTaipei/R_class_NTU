# Base package

treatment<-c(0.02, 1.8, 17.5, 55, 75.7, 80)
plot(treatment) # scatter plot
plot(treatment, type = 'o') # line plot w/ point
plot(treatment, type = 'l') # line only

plot(treatment, main = "My Plot" , sub="a plot") # Titles
plot(treatment, xlab="Position", ylab="score") # Axis labels

# Orientation of labels
plot(treatment, las=1)
plot(treatment, las=2)

# Point size
plot(treatment, cex=2)
plot(treatment, cex=0.5)

# Point shape
plot(treatment, pch=1)
plot(treatment, pch=20)

# Line weight
plot(treatment, type="l",lwd=10)
plot(treatment, type="l",lwd=0.5)

# Line type
plot(treatment, type="l",lty=1)
plot(treatment, type="l",lty=2)

# Color
plot(treatment, type="l", col="red")
plot(treatment, type="l", col="dodgerblue")
plot(treatment, type="l", col="#ff5733") #HTML color code

myRed <- rgb(1,0,0, alpha=0.5)
plot(treatment, type="p", cex=4, pch=20, col=myRed)

par(mfrow = c(1, 2)) #one row, two columns
plot(treatment, type="p", cex=4, pch=20, col=myRed)
plot(treatment, type="p", cex=4, pch=20, col='#87736f')
dev.off() #  reset graphical parameters

# Add an additional line to a existing plot
control <- c(0, 20, 40, 60, 80, 100)
plot(treatment, type="o", col="blue", ylim = c(0,100)) # extant y axis
lines(control, type="o", pch=22, lty=2, col="red")

g_range <- range(0, treatment, control)
g_range
plot(treatment, type="o", col="blue", ylim = g_range) # extant y axis
lines(control, type="o", pch=22, lty=2, col="red")

# Customize axes
plot(treatment, type="o", col="blue", ylim=g_range, axes=FALSE, ann=FALSE)
lines(control, type="o", pch=22, lty=2, col="red", lwd=2.5)
axis(side=1, at=1:6, lab=c("Mon","Tue","Wed","Thu","Fri","Sat"))
axis(2, las=1, at=seq(0,g_range[2],by=20))
box()

# Legend 圖例
legend("topleft",legend=c("treatment","control"), col=c("blue","red"),
       pch=21:22, lty=1:2, lwd=c(1,2.5)) 

# Considering the demographics in science (~4% of people are color blind)
library(viridis)
viridis(5)


# Histogram
hist(treatment)
hist(treatment, col="lightblue", ylim=c(0,5), cex.main=0.8) # “character expansion” of title

# Specify the number of required bins
par(mfrow = c(1, 2))
hist(treatment, col="lightblue", ylim=c(0,5), cex.main=0.8, breaks = 2)
hist(treatment, col="lightblue", ylim=c(0,5), cex.main=0.8, breaks = 10)
dev.off()


# Dot charts: compare paired data
data<-data.frame(treatment, control)
row.names(data)<-c("Mon","Tue","Wed","Thu","Fri","Sat")
dotchart(as.matrix(t(data)), color=c("red","blue"),main="Dotchart", cex=0.5)
# Given a matrix or data.frame x, t() returns the transpose of x.



# Box plots
exprs <- read.delim("data/gene_data.txt",sep="\t",h=T,row.names = 1)
head(exprs)
boxplot(exprs)
boxplot(log2(exprs),ylab="log2 Expression", col=c("red","red","blue","blue"))

boxplot(len ~ dose, data = ToothGrowth,
        boxwex = 0.25, at = 1:3 - 0.2,
        horizontal=T, las= 1,
        subset = supp == "VC", col = "yellow",
        main = "Guinea Pigs' Tooth Growth",
        xlab = "tooth length",
        ylab = "Vitamin C dose mg",
        xlim = c(0.5, 3.5), ylim = c(0, 35), yaxs='i')



# Extra elements
# Text
plot(control, treatment)
text(20,60, 'THIS AREA OF \n THE PLOT HAS \n NO SAMPLE', col='red')
text(control, treatment, letters[1:6], adj=c(0,-1), col='blue')

# Lines
plot(control, treatment)
abline(h=10, col='blue')
abline(v=50, col='red', lwd=2)
abline(a=0, b=1, lty=2)

# Shape
plot(control, treatment)
polygon(c(50,50,100,100),c(50,80,80,50), col='gray', density=5)

# Saving (in R)
# get my working directory
getwd()
# Saving in bitmap format
bmp(file = "outputs/control_1.bmp")
plot(control)
dev.off()

jpeg(file = "outputs/control_2.jpg", quality = 20)
plot(control)
dev.off()

postscript(file = "outputs/control_3.ps")
plot(control)
dev.off()

pdf(file = "outputs/control_4.pdf", paper = "A4")
plot(control)
dev.off()


# Practice 4.1
data(iris)
plot(iris$Petal.Length, iris$Petal.Width,
     xlab = "Petal length (cm)",
     ylab = "Petal width (cm)",
     main = "Petal width vs. length",
     cex.main = 1.5,
     pch = c(1,2,3)[as.numeric(iris$Species)],
     col = c("black","red","green")[as.numeric(iris$Species)])

pairs(iris[1:4],
      main = "Petal width vs. length",
      pch = 21,
      bg = c("black","red","green")[as.numeric(iris$Species)])