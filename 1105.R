# Loops


# "for": for (counter in vector){task}
# can be replaced by "while" or "repeat"


# Basics
for(i in 1:100) {
  print("Hello world!")
  print(i*i)
}

demo <- seq (1,100,by=2) # sequence  1, 3, ..., 99
n<-length(demo) #  size of the foo sequence = 50
demo.squared = NULL #  empty object

for (i in 1:n) { # our counter
  demo.squared[i] = demo[i]^2 # the task
} 
# demo.squared 1, 9, 25, 49, ..., 9801

demo.df<-data.frame(demo,demo.squared) 
plot (demo.df$demo~demo.df$demo.squared)

# The functions in R are generally vectorized.
# When you applied them to a selected vector, they will apply to all the elements of this vector.
demo.squared2<-demo^2
plot (demo~demo.squared2)

# Vectorized functions are way faster than making loops.
system.time(demo.squared2<-demo^2)


# Recycling
# Exponential growth
num_gen<-10  # no. generation
generation<-1:num_gen # create a variable generation
N <- rep (0,num_gen) #  "vector" of 10 zeros (could be `NULL`)
lambda <- 2 # growth rate
N[1] <- 2 # We need to set initial pop size
for (t in 1:(num_gen - 1)) { # the counter
  N[t+1]=lambda*N[t]  # task: double individuals
}
plot(N~generation, type='b', col='blue', main='Discrete exponential growth') # the plot


# "function": create your own function
grow <- function (growth.rate) { # argument "growth.rate" of function "grow" 
  num_gen<-10
  generation<-1:num_gen
  N <- rep (0,num_gen)
  N[1] <- 1
  for (t in 2:num_gen) { 
    # not the use growth.rate argument and t-1  this time
    N[t]=growth.rate*N[t-1] 
  }
  plot(N~generation,type='b', main=paste("Rate =", growth.rate)) 
}
# It created a function called "grow" and now visible in RStudio environment under functions
# 之後可直接利用"grow"這個function
par(mfrow=c(2,3))
for (i in 2:7){
  grow(i)
}
dev.off()

# Practice 6.1: "grow2"
grow2 <- function(growth.rate, number.generation){
  num_gen<-number.generation
  generation<-1:num_gen
  N <- rep(0,num_gen)
  N[1] <- 1
  for (i in 2:num_gen){
    N[i] = growth.rate*N[i-1]
  }
  plot(N~generation,type='b', main=paste("Rate =", growth.rate, ", ", number.generation, "generations"))
}



# Animation
grow3 <- function (growth.rate) { 
  num_gen<-10
  generation<-1:num_gen
  N <- rep (0,num_gen)
  N[1] <- 1
  for (i in 2:num_gen) {
    N[i]=growth.rate*N[i-1]
  }
  plot(N~generation, xlim=c(0,10), ylim=c(0,100000), type='b', main=paste("Rate =", growth.rate))
}

# "saveGIF": 將數張圖結合為gif並儲存
library(animation)
saveGIF({
  for (i in 2:10){
    grow3(i)
  }})

# "gganimate"
library(ggplot2)
library(gganimate)

demo<-NULL
demo$count<-N
demo$generation<-generation
demo<-as.data.frame(demo)

p <- ggplot(demo, aes(x = generation, y=count, size =2)) +
  geom_point(show.legend = FALSE, alpha = 0.7) +
  scale_color_viridis_d() +
  scale_size(range = c(0, 12)) +
  labs(x = "Generation", y = "Individuals")

p + transition_time(generation) +
  labs(title = "Generation: {frame_time}") +
  shadow_wake(wake_length = 0.2, alpha = FALSE)



# Practice 6.2
logistic <- function(growth.rate){
  num_gen<-50
  generation<-1:num_gen
  N <- rep (0,num_gen)
  N[1] <- 10
  for(i in 2:num_gen){
    N[i]=N[i-1]+growth.rate*N[i-1]*(100-N[i-1])/100
  }
  plot(N~generation, xlim=c(0,50), ylim=c(0,200), type='b', main=paste("Rate =", growth.rate))
}

library(magick)
library(animation)
saveGIF({
  for (i in c(0.5,1,1.5,2,2.5,3)){
    logistic(i)
  }}, convert = "magick")
