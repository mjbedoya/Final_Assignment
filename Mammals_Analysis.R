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

# 1d. Plot: Formatting the data to be plotted

filter_status<-filter(mammal_sizes, status =="extant" | status =="extinct")  ; head(filter_status) ; unique(filter_status$status)  # Review the selected columns
by_status<-group_by(filter_status,status); head(by_status)
status_logmass_continent <- select(by_status, continent, log_mass, status) ; status_logmass_continent
filter2<-filter(status_logmass_continent, log_mass != "NA")  # to remove the "Af"
# table(filter2$continent,filter2$status)  # to check if I removed the NAs in Af
extinct_extanct_continent<-filter(filter2, continent != "EA" & continent != "Oceanic")
# table(extinct_extanct_continent$continent,extinct_extanct_continent$status)   # Used to check the data

# Final Plot

png("extinct_extanct_graph.png")
qplot(log_mass, data=extinct_extanct_continent, geom = "histogram", binwidth = 1/6)+
  xlim(c(0,8))+
  facet_grid(continent~status)+
  xlab("Log (Mass)")+
  ylab("No. Species")+
  ggtitle("Number of extant and extinct species per continent")
dev.off()

