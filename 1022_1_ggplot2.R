library(ggplot2)

# Primary layering component:
# dataset, aesthetics, geometric elements

# Additional / Optional layering component:
# statistical element, scale, guide, facets, coordinate systems

ggiris <- ggplot(data=iris)
class(ggiris)
ggiris$mapping
ggiris$theme

ggiris2 <- ggiris+aes(x=Petal.Length,y=Petal.Width)
ggiris2$mapping

ggiris3 <- ggiris2+geom_point()
ggiris3$mapping
ggiris3$theme
ggiris3$layers

ggiris
ggiris2
ggiris3

ggiris3 <- ggplot(data=iris,
                  mapping=aes(x=Petal.Length,y=Petal.Width))
ggiris3+geom_point()

ggiris_line<- ggiris3 + geom_line()
ggiris_line

ggiris_smooth<- ggiris3 + geom_smooth()
ggiris_smooth

ggiris_bar<- ggplot(data=iris, mapping=aes(x=Species))
ggiris_bar2<- ggiris_bar + geom_bar()
ggiris_bar2

ggiris_hist <- ggplot(data=iris,
                      mapping=aes(x=Petal.Length))
ggiris_hist2 <- ggiris_hist + geom_histogram() 
ggiris_hist2

ggiris_dens <- ggiris_hist + geom_density() 
ggiris_dens

ggiris_box <- ggplot(data=iris,
                     mapping=aes(x=Species,y=Petal.Length))
ggiris_box2 <- ggiris_box+geom_boxplot() 
ggiris_box2

pcPlot_violin <- ggiris_box+geom_violin() 
pcPlot_violin

dev.off()
