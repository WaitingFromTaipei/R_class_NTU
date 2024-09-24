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

rm(list=ls())
