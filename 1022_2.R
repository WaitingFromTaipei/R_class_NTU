library(ggplot2)

# Aesthetics
ggiris_scatter <- ggplot(data=iris,
                         mapping=aes(x=Petal.Length,y=Petal.Width))
ggiris_scatter+geom_point(colour="red")

ggiris_scatter2 <- ggplot(data=iris,
                          mapping=aes(x=Petal.Length,y=Petal.Width,color=Species))
ggiris_scatter2 + geom_point()

ggiris_scatter4 <- ggplot(data=iris)
ggiris_scatter4 + geom_point(aes(x=Petal.Length,y=Petal.Width,color=Species, shape=Species))



# Faceting
patients_clean<-read.delim('data/patients_clean.txt')
pcPlot <- ggplot(data=patients_clean,aes(x=Height,y=Weight, 
                                         colour=Sex))+geom_point()
pcPlot + facet_grid(Smokes~Sex)
pcPlot + facet_grid(~Sex)
pcPlot + facet_grid(Sex~.)

pcPlot + facet_wrap(~Pet+Smokes+Sex)
pcPlot + facet_grid(Smokes~Sex+Pet)



# Plotting order
ggplot(patients_clean, aes(x=Sex, y=Weight)) + geom_boxplot()
patients_clean$Sex <- factor(patients_clean$Sex, 
                             levels=c("Male","Female"))
ggplot(patients_clean,aes(x=Sex, y=Weight)) + geom_boxplot()



# Scales
pcPlot + geom_point() + facet_grid(Smokes~Sex)+
  scale_x_continuous(name="height ('cm')",
                     limits = c(100,200),
                     breaks=c(125,150,175),
                     labels=c("small","justright","tall"))

pcPlot <- ggplot(data=patients_clean,aes(x=Sex,y=Height))
pcPlot +
  geom_violin(aes(x=Sex,y=Height)) +
  scale_x_discrete(labels=c("Women", "Men"))

pcPlot <- ggplot(data=patients_clean,aes(x=Sex,y=Height,fill=Smokes))
pcPlot +
  geom_violin(aes(x=Sex,y=Height)) +
  scale_x_discrete(labels=c("Women", "Men"))+
  scale_y_continuous(breaks=c(160,180),labels=c("Short", "Tall"))

pcPlot <- ggplot(data=patients_clean,
                 aes(x=Height,y=Weight,colour=Sex))
pcPlot + geom_point(size=4)

pcPlot + geom_point(size=4) + 
  scale_colour_manual(values = c("Green","Purple"),
                      name="Gender")
pcPlot <- ggplot(data=patients_clean,
                 aes(x=Height,y=Weight,colour=Pet))
pcPlot + geom_point(size=4) + 
  scale_colour_brewer(palette = "Set2")

pcPlot <- ggplot(data=patients_clean,
                 aes(x=Height,y=Weight,alpha=BMI))
pcPlot + geom_point(size=4) + 
  scale_alpha_continuous(range = c(0.5,1))

pcPlot <- ggplot(data=patients_clean,
                 aes(x=Height,y=Weight,size=BMI))
pcPlot + geom_point(alpha=0.8) + 
  scale_size_continuous(range = c(3,6))
pcPlot + geom_point() + scale_size_continuous(range = c(3,6),
                                              limits = c(25,40))
pcPlot + geom_point() + 
  scale_size_continuous(range = c(3,6), 
                        breaks=c(25,30), 
                        labels=c("Good","Good but not 25")) 

pcPlot <- ggplot(data=patients_clean,
                 aes(x=Height,y=Weight,colour=BMI))
pcPlot + geom_point(size=4,alpha=0.8) + 
  scale_colour_gradient(low = "White",high="Red")
pcPlot + geom_point(size=4,alpha=0.8) + 
  scale_colour_gradient2(low = "Blue",mid="Black", high="Red",
                         midpoint = median(patients_clean$BMI))
pcPlot + geom_point(size=4,alpha=0.8) + 
  scale_colour_gradient2(low = "Blue",
                         mid="Black",
                         high="Red",
                         midpoint = median(patients_clean$BMI),
                         breaks=c(25,30),labels=c("Low","High"),
                         name="Body Mass Index")

pcPlot <- ggplot(data=patients_clean,
                 aes(x=Height,y=Weight,colour=BMI,shape=Sex))
pcPlot + geom_point(size=4,alpha=0.8)+ 
  scale_shape_discrete(name="Gender") +
  scale_colour_gradient2(low = "Blue",mid="Black",high="Red",
                         midpoint = median(patients_clean$BMI),
                         breaks=c(25,30),labels=c("Low","High"),
                         name="Body Mass Index")



# Transformations
# Fitting lines
pcPlot <- ggplot(data=patients_clean,
                 mapping=aes(x=Weight,y=Height))
pcPlot+geom_point()+stat_smooth()
pcPlot+geom_point()+stat_smooth(method="lm")

pcPlot <- ggplot(data=patients_clean,
                 mapping=aes(x=Weight,y=Height,colour=Sex))
pcPlot+geom_point()+stat_smooth(method="lm")

pcPlot+geom_point()+stat_smooth(aes(x=Weight,y=Height),method="lm",
                                inherit.aes = F)
# Summary statistics
pcPlot <- ggplot(data=patients_clean,
                 mapping=aes(x=Sex,y=Height)) + geom_jitter()
pcPlot + stat_summary(fun=quantile, geom="point",shape=8,
                      colour="purple", size=4)



# Themes
# Predefined themes
pcPlot <- ggplot(data=patients_clean,
                 mapping=aes(x=Weight,y=Height))+geom_point()
pcPlot+theme_minimal()
# Custom themes: Create your own style :)



# Titles and Labels
pcPlot <- ggplot(data=patients_clean,
                 mapping=aes(x=Weight,y=Height))+geom_point()
pcPlot+labs(title="Weight vs Height",y="Height (cm)")
pcPlot+ggtitle("Weight vs Height")+ylab("Height (cm)")

# Saving plot
pcPlot <- ggplot(data=patients_clean,
                 mapping=aes(x=Weight,y=Height))+geom_point()

ggsave(pcPlot,filename = "outputs/anExampleplot.png",width = 15,
       height = 15,units = "cm")

