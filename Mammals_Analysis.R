## R Assigment 8 --All together

library(dplyr)

# Data from ()
mammal_sizes<-read.csv("MOMv3.3.txt", sep = "\t", head=FALSE, stringsAsFactors = FALSE, na.strings = "-999")

colnames(mammal_sizes) <- c("continent", "status", "order", 
                            "family", "genus", "species", "log_mass", "combined_mass", 
                            "reference")
head(mammal_sizes)
summary(mammal_sizes) 
names(mammal_sizes)
getClassName(mammal_sizes)


## 1. --Size-biased extinction--

## Calculation of the mean mass of the extinct species and the mean mass of the extant species:

unique(mammal_sizes$status)   # used to get the different classes of the status variable

select(mammal_sizes, status, combined_mass)
filter_status<-filter(mammal_sizes, status =="extant"| status =="extinct")
unique(filter_status$status)  # Review the selected columns

by_status<-group_by(filter_status,status); head(by_status_extant)

mean_mass <- summarize(by_status, avg_mass = mean(combined_mass, na.rm=TRUE)) ; mean_mass # remove NA inside combined_mass


