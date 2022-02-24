library(readxl)
library(writexl)
library(dplyr)
library(data.table)
library(car)
library(gvlma)
library(lm.beta)
library(lmtest)
library(magrittr)
library(tidyverse)
library(ggplot2)
library(ggiraph)
library(ggiraphExtra)
library(shiny)
library(mycor)
library(R.utils)
library(maps)

setwd(dir = "C:/Users/eljuw/Desktop/Fire/")


fire <- read_excel(path = "Fire.xlsx", sheet = 1, col_names = TRUE)
rain <- read_excel(path = "Rainfall.xlsx", sheet = 1, col_names = TRUE)
solar <- read_excel(path = "Solar.xlsx", sheet = 1, col_names = TRUE)
temp_max <- read_excel(path = "Temp_max.xlsx", sheet = 1, col_names = TRUE)
temp_min <- read_excel(path = "Temp_min.xlsx", sheet = 1, col_names = TRUE)

merged_temp <- left_join(temp_max, temp_min, by = c("Bureau of Meteorology station number" = "Bureau of Meteorology station number", "Date" = "Date"))

merged_temp_c <- subset(merged_temp, select = -c(Year.x, Month.x, Day.x))

writexl::write_xlsx(merged_temp_c, path = "Temp.xlsx")

merged_temp_c %>% rename(Year = Year.y, Month = Month.y, Day = Day.y)

names(merged_temp_c)[names(merged_temp_c) == "Year.y"] <- "Year"
names(merged_temp_c)[names(merged_temp_c) == "Month.y"] <- "Month"
names(merged_temp_c)[names(merged_temp_c) == "Day.y"] <- "Day"

merged_temp_1 <- left_join(rain, merged_temp_c, by = c("Bureau of Meteorology station number" = "Bureau of Meteorology station number", "Date" = "Date", "Year" = "Year", "Month" = "Month", "Day" = "Day"))
merged_temp_2 <- left_join(merged_temp_1, solar, by = c("Bureau of Meteorology station number" = "Bureau of Meteorology station number", "Date" = "Date", "Year" = "Year", "Month" = "Month", "Day" = "Day"))

writexl::write_xlsx(merged_temp_2, path = "Full.xlsx")

climate <- read_excel(path = "Full.xlsx", sheet = 1, col_names = TRUE)

fire$state <- map("state", fire$Longitude, fire$Latitude)

fire <- read.csv("Fire1.csv", header = T)
weather <- read.csv("full2.csv", header = T)

names(weather)[1] <- "City"

merged_full <- left_join(fire, weather, by = c("Area.of.Fire" = "City", "Year" = "Year", "Month" = "Month", "Day" = "Day"))

write.csv(merged_full, file="full_new.csv", row.names = F)

merged_full %>% filter_all(all_vars(!is.na(.)))
merged_full %>% filter_all(all_vars(complete.cases(.))) 

na.omit(merged_full)

merged_full %>% remove_empty("rows")

merged_full %>% drop_na()

is.na(merged_full)
sum(is.na(merged_full))
