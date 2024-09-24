data("iris")

head(iris)
tail(iris)
summary(iris)

class(iris) # object summary
str(iris) # examine the structure of the object (variable:numerical/factor)

fix(iris) # spreadsheet

students<-read.table('https://www.dipintothereef.com/uploads/3/7/3/5/37359245/students.txt',header=T, sep="\t", dec='.') # read data set from url
str(students)
summary(students)

students$height
students[,1] # object[row,column]
students[1,]
students[2,4]

students$gender=='female' # TRUE/FALSE
f<-students$gender=='female' # f是用來選擇female的filter
students[f,] #將f套用到row的篩選

students[f,]->female
female

colnames(female)
rownames(female)

rownames(female)<-c('Vanessa', 'Vicky', 'Michelle', 'Joyce', 'Victoria')
female



# Sample
View(sample)

1:nrow(female) # 從1開始列出每個數字
nrow(female) # 直接列出有幾個
1:1000 #列出1~1000

sf<-sample(1:nrow(female), 2) # filter with two randomly selected female students
sf # the selection



# Sorting
ind1<-order(students$height)
students[ind1,]

students[order(students$height),] #簡化行數的寫法
students[order(-students$height),] # Reverse!



# Recording: ifelse
students$color<-ifelse(students$gender=='male', 'blue', 'red') #create a new column
students$gender<-ifelse(students$gender=='male', 'blue', 'red') #replace an existing column
students$color<-NULL
students

rm(list=ls())

# practice 2.1
data("iris")
set<-iris$Species=='setosa'
setosa<-iris[set,]
ver<-iris$Species=='versicolor'
versicolor<-iris[ver,]
vir<-iris$Species=='virginica'
virginica<-iris[vir,]

#practice 2.2
data("iris")
iris$color<-ifelse(iris$Species=='setosa', 'purple', ifelse(iris$Species=='versicolor', 'blue', 'pink'))
iris[order(-iris$Sepal.Width),]

# subset on versicolor
iris[iris$Species=='versicolor',]

iris$color<-NULL
iris
