## R Assigment 8 --All together

library(dplyr)
library(tidyr)
library(ggplot2)

# Data from (Smith et al., 2003. Body mass of late Quaternary mammals. Ecology 84:3403.)
## 1a. --Size-biased extinction--

mammal_sizes<-read.csv("MOMv3.3.txt", sep = "\t", head=FALSE, stringsAsFactors = FALSE, na.strings = "-999")

colnames(mammal_sizes) <- c("continent", "status", "order", 
                            "family", "genus", "species", "log_mass", "combined_mass", 
                            "reference")
head(mammal_sizes)
summary(mammal_sizes) 
names(mammal_sizes)


## 1b. Calculation of the mean mass of the extinct species and the mean mass of the extant species:
# unique(mammal_sizes$status)   # used to get the different classes of the status variable

filter_status<-filter(mammal_sizes, status =="extant"| status =="extinct")  ; head(filter_status) ; unique(filter_status$status)  # Review the selected columns
by_status<-group_by(filter_status,status); head(by_status)
mean_mass <- summarize(by_status, avg_mass = mean(combined_mass, na.rm=TRUE)) ; mean_mass # remove NA inside combined_mass

## 1c. Comparison of the mean masses within each of the different continents  
# unique(mammal_sizes$continent)   Used to check the different classes of the variable: status

# Extract from the big dataset the columns that I need
continent_by_status <- mammal_sizes %>% 
  filter(status =="extant"| status =="extinct") %>% 
  select(continent, combined_mass,status) %>%
  group_by(continent, status) %>%
  summarize(mean_weight = mean(combined_mass, na.rm = TRUE))  ; continent_by_status

# Formatting and saving the new set of data per continent, by status (extant and extinct species) and remove Af:
extant_extinct_mass <- continent_by_status %>%
  spread(status, mean_weight) %>%
  filter(continent!='Af');  extant_extinct_mass

write.table(extant_extinct_mass, "continent_mass_differences.csv") # Use sep = ",",  if you want an organized table in columns when opening in excel

