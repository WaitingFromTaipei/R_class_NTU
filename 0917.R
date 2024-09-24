# Setting my working directory
setwd("C:/研究所_課程/113-1/Ecological data analysis in R/R_class_NTU")
#要把路徑的\換成/


library(usethis)
use_git()

# 連結github
library(usethis)
create_github_token()
# 會連結到github網站產生token
library(gitcreds)
gitcreds_set()
# Enter password or token:
gitcreds_get() #檢視連結

library(usethis)
use_github()