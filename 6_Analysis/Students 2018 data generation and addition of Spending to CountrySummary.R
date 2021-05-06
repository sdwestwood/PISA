

# Creating 2018 student dataset this is using the dataset from the download: https://webfs.oecd.org/pisa2018/SAS_STU_QQQ.zip
setwd("C:/Users/alish/OneDrive/Desktop/Uni stuff/Courses/P0Q48a - European Seminar on Quantiative Psychology/PISA/6_Analysis/Raw data files/2018 students")

require(haven)

data_2018_student <- read_sas("cy07_msu_stu_qqq.sas7bdat")

sub_cols = as.logical(str_detect(names(data_2018_student), "MATH|CNT|READ|SCIE|TMINS"))

data_2018_student_sub <- data_2018_student[,sub_cols]
data_2018_student_final <- data_2018_student_sub %>%
  gather(key = PV_Item, value = Score, names(data_2018_student_sub)[11:40], na.rm = TRUE) %>%
  select(-c('STIMREAD','JOYREAD','SCREADCOMP','SCREADDIFF','CNTRYID','CNTSCHID','JOYREADP')) %>%
  arrange(CNTSTUID)

setwd("C:/Users/alish/OneDrive/Desktop/Uni stuff/Courses/P0Q48a - European Seminar on Quantiative Psychology/PISA/6_Analysis")
write.csv(data_2018_student_final,"studentsdata_2018.csv",row.names = FALSE)


library(dplyr)
# Get Spending data and add it to country summary
setwd("C:/Users/alish/OneDrive/Desktop/Uni stuff/Courses/P0Q48a - European Seminar on Quantiative Psychology/PISA/6_Analysis/Raw data files/")
spending <- read.csv("learn_spend_data.csv")[2:3]
spending <- spending[is.na(spending[,2]) == FALSE,]
spending$Spending <- (spending$Spending - mean(spending$Spending)) / sd(spending$Spending)
spending$Code[1] = "AUS"
names(spending)[1] = "CNT"

# Get country summary
setwd("C:/Users/alish/OneDrive/Desktop/Uni stuff/Courses/P0Q48a - European Seminar on Quantiative Psychology/PISA/Shared_Data")
countrySummary <- read_csv("countrySummary.csv")

# Add spending to country summary
countrySummary <- countrySummary %>%
  inner_join(spending, by = 'CNT')

rm(spending)

setwd("C:/Users/alish/OneDrive/Desktop/Uni stuff/Courses/P0Q48a - European Seminar on Quantiative Psychology/PISA/6_Analysis/")
write.csv(countrySummary,"countrySummary_incl_Spend.csv", row.names = FALSE)

