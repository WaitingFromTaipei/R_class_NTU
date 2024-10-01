# 2 packages specific for sorting data and manipulating dataset

# dplyr: A grammar of data manipulation
# part of package "tidyverse"
browseVignettes(package = "dplyr") #相關介紹

library("dplyr")

# "summarize"
summarised <- summarise(iris, Mean.Width = mean(Sepal.Width))
head(summarised)

# Manipulate
# "select": 選擇特定行資料
selection1 <- dplyr::select(iris, Sepal.Length, Sepal.Width, Petal.Length)
head(selection1)
# 由於可能有其他package也有"select"，使用時寫"dplyr::select"

# 選擇特定範圍column
selection2 <- dplyr::select(iris, Sepal.Length:Petal.Length)
head(selection2, 4) #只叫出前4列資料

selection3 <- dplyr::select(iris,c(2:5))
head(selection3)

# 刪除特定column
selection4 <- dplyr::select(iris, -Sepal.Length, -Sepal.Width)

# "filter"
# Select setosa species
filtered1 <- filter(iris, Species == "setosa" )
head(filtered1,3)

# Select versicolor species with Sepal width more than 3
filtered2 <- filter(iris, Species == "versicolor", Sepal.Width > 3)
tail(filtered2)

# "mutate": to create new columns (variables)
# To create a column “Greater.Half” which stores a logical vector (T/F)
mutated1 <- mutate(iris, Greater.Half = Sepal.Width > 0.5 * Sepal.Length)
tail(mutated1)
# "table" from the base package 
# produces a contingency table with the no. of individual where the condition is TRUE and FALSE
table(mutated1$Greater.Half)

# "arrange": 整理資料排列方式(從小到大)
# Sepal Width by ascending order
arranged1 <- arrange(iris, Sepal.Width)
head(arranged1)
# Sepal Width by descending order
arranged2 <- arrange(iris, desc(Sepal.Width))
head(arranged2)

# "group_by": 
# Mean sepal width by Species
gp <- group_by(iris, Species)
gp.mean <- summarise(gp,Mean.Sepal = mean(Sepal.Width))
gp.mean
# This creates a tibble (a data frame with stricter validation and better formatting)



# pipe operator (%>%)
# makes it possible to link several functions together

#To select the rows with conditions
iris %>% filter(Species == "setosa",Sepal.Width > 3.8)

# find mean Sepal.Length by Species
iris  %>% 
  group_by(Species) %>% 
  summarise(Mean.Length = mean(Sepal.Length))



# tidyr: to help you get tidy data

# tidy data is data where:
# 1. Every column is a variable
# 2. Every row is an observation
# 3. Every cell is a single values.

