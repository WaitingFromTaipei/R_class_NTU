# Core data types (=modes): determine how the values are stored in the computer

# Numeric: consist of "integers" (e.g. 1 ,-3 ,33 ,0) and "doubles" (e.g. 0.3, 12.4, -0.04, 1.0)
# function "mode" does not distinguish btw "integers" and "doubles"

x <- 4
typeof(x)
# [1] "double"

x <- 4L #這邊要在數值後方加上大寫L
typeof(x)
# [1] "integer"



# Character
# The use of quotation marks to force double to be recognized as character
x <- "3"
y <- "5.3"
# not run:  x + y
# Error in x + y: non-numeric argument to binary operator
plot(x,y) #點會顯示於(3, 5.5)上
# Some functions like plot automatically convert character to double



# Logical: True or False
# full text:
x <- c(TRUE, FALSE, FALSE, TRUE)
# or in short:
x <- c(T, F, F, T)

x1<-c(1,0,0,1)
x2 <- as.logical(c(1,0,0,1))
# OR: x3 <- as.logical(c(1,0,0,1))



# Derived data types:
# additional attribute information that allows these objects to be handled in a special way by certain functions
# define the class of an object and can be extracted from an object using the "class" function

# Factor: to group variables into a fixed number of unique categories or levels
a <- c("M", "F", "F", "U", "F", "M", "M", "M", "F", "U")
typeof(a) # mode character
class(a)# class character

a.fact <- as.factor(a)
class(a.fact)# class factor
# "a" has not changed the mode.
# However, the derived object "a.fact" is now stored as an integer!
mode(a.fact)
# [1] "numeric"
typeof(a.fact)
# [1] "integer"

# This hidden information is stored in attributes.
attributes(a.fact)

levels(a.fact)
# If they are to be displayed in a different order (e.g. first U, then F, then M), we must change it by recreating the factor object
factor(a, levels=c("U","F","M"))



# Practice 3.1
library("dplyr")
data("iris")
iris.sel <- iris %>%filter(Species == "setosa" | Species == "virginica")
levels(iris.sel$Species) # 3 species are still there

# Delete a level after a subset
iris.sel$Species<-droplevels(iris.sel$Species)
# Change the row names in our subset
rownames(iris.sel) = seq(length=nrow(iris.sel))



# Date (非本周重點)
# a package called "lubridate" makes working with dates/times much easier



# NAs and NULLs

# "NA" (Not Available): a value should be available but is unknown.
# "NULL": the value does not exist or that it’s not measurable.
# 兩者不要混用

# When computing the mean of x, R returns an NA value
x <- c(23, NA, 1.2, 5)
mean(x)

# Since NULL implies that a value should not exist,
# R no longer sees the need to treat such an element as questionable and allows the mean value to be calculated
y <- c(23, NULL, 1.2, 5)
mean(y)



# Data structures

# (Atomic) vectors
# can simply be created with the combination function c()
x <- c(674 , 4186 , 5308 , 5083 , 6140 , 6381)
x
# a vector object is an indexable collection
x[3]
# select a subset of elements by index values using the c()
x[c(1,3,4)]
x[2:4]
# assign new values to a specific index
x[2] <- 0
x
# vector can store any type of data, but a vector can only be of one type
# R converts the element types to the highest common mode
# NULL < logical < integer < double < character. 
x <- c( 1.2, 5, "Rt", "2000")
typeof(x)



# Matrices and arrays
# "runif" generates nine random numbers between 0 and 10
m <- matrix(runif(9,0,10), nrow = 3, ncol = 3)
m
# Use the "array" function to create the n-dimensional object
m <- array(runif(27,0,10), c(3,3,3))
m



# Data frames
# Can mix the data types across columns (e.g. both numeric and character columns can coexist in a data frame), but the data type remains the same across rows.
name   <- c("a1", "a2", "b3")
value1 <- c(23, 4, 12)
value2 <- c(1, 45, 5)
dat    <- data.frame(name, value1, value2)
dat
str(dat) # provide structure
attributes(dat) # provide attributes
names(dat) # extract colum names
rownames(dat) # extract row names



# List: an ordered set of components stored in a 1D vector (recursive vector)
# where each vector element can have a different data type and structure

# Each element of a list can contain complex objects such as matrix, data frame,
# and even in some cases other list objects embedded in the list

A <- data.frame(
  x = c(7.3, 29.4, 29.4, 2.9, 12.3, 7.5, 36.0, 4.8, 18.8, 4.2),
  y = c(5.2, 26.6, 31.2, 2.2, 13.8, 7.8, 35.2, 8.6, 20.3, 1.1) )
B <- c(TRUE, FALSE)
C <- c("apples", "oranges", "round")
my.list <- list(A = A, B = B, C = C)
str(my.list)
names(my.list)
my.list$A
my.list[[1]]
class(my.list[[1]])
my.list.notags <- list(A, B, D)
my.list.notags
# When lists do not have component names, the "names" function will return NULL
names(my.list.notags)

# if we fit a linear model between the elements x and y (in the data frame A), the output of this model (here M) is a list
M <- lm( y ~ x, A)
str(M)
names(M)
# The list "M" is more complex than the simple list "my.list" that was created before
str(M$qr)
# Access the element rank in the component "qr" of the list "M"
M$qr$rank



# Coercing data
as.numeric  # Coerce to numeric
as.double   # Coerce to double
as.integer  # Coerce to integer
as.character #  Coerce to character
as.logical  # Coerce to Boolean (logical: TRUE | FALSE)
as.factor   # Coerce to factor
as.Date  # Coerce to date
as.data.frame  # Coerce to data frame
as.list # Coerce to list