# 2 packages specific for sorting data and manipulating dataset: "dplyr" and "tidyr"

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

# five categories: pivoting/rectangling/nesting/splitting and combining/implicit missing values 

library ("tidyr")

# 先下載網站上"tw_corals.txt"、"metoo.txt"到data資料夾



# Pivoting: "pivot_longer", "pivot_wider"
TW_corals<-read.table('Data/tw_corals.txt', header=T, sep='\t', dec='.') 
TW_corals
# 將資料行列互換
# wide table轉為long table
TW_corals_long <- TW_corals %>%
  pivot_longer(Southern_TW:Northern_Is, names_to = "Region", values_to = "Richness")
TW_corals_long
# long table轉為wide table
TW_corals_wide <- TW_corals_long %>%
  pivot_wider( names_from = Region, values_from = Richness) 
TW_corals_wide

income<-read.table('Data/metoo.txt',header=T, sep="\t", dec=".", na.strings = "n/a")
income
# two variables from the column names:
# Gender (male and female) and Work Experience (fulltime and other)
income_long <- income %>%  pivot_longer(cols = -state, 
                                        names_to = c("gender","work"), 
                                        names_sep = "_", 
                                        values_to = "income")
income_long
# 轉回wide table
income_long %>% pivot_wider(names_from = c(gender,work), 
                            values_from = income,
                            names_sep = ".")



# Splitting
# "separate"
# Let's first create a delimited table
income_long_var <- income %>%  pivot_longer(cols = -1, 
                                            names_to = "var1", 
                                            values_to = "income")
income_long_var
# Split var1 column into two columns
income_sep <- income_long_var %>%  separate(col = var1, 
                                            sep = "_", 
                                            into = c("gender", "work"))
income_sep
# Split var1 into two rows
income_long_var %>% separate_rows(var1, sep = "_")