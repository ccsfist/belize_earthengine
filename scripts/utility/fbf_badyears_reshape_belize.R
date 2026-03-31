
### This file reshapes and aggregates bad year data from the FbF workshop form
### Input: Kobo form of responses
### Output: Full ranking of years for each participant

# Packages

library(httr)
library(readr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(DT)
library(readxl)
library(reshape2)
library(ggplot2)
library(ggthemes)
library(forcats)
library(RColorBrewer)

setwd("~/Documents/Belize/") ## working dir for writing files, change as desired
proj_name <- "Belize2026" ## file name for output; change as desired
years_toselect <- as.character(c(2000:2025)) ## list of years to create table for

# Load data using Kobo API

fid <- "abdj6eAwSzqGqSzBbBxEa6" ## Change this line based on the form you want to load. Will be part of the Kobo URL after #/forms/...
kobo_user <- "fisteam"
kobo_pw <- "FISTIRI"
url <-"https://kf.kobotoolbox.org/api/v2/assets"

data <- GET(paste(url,fid,"data.json",sep="/"),
            authenticate(kobo_user,kobo_pw))

data <- fromJSON(rawToChar(data[["content"]]))

data_table <- data[["results"]] %>%
  dplyr::select_if(is.character)

# rename stuff to be reasonable

old_names <- colnames(data_table)
short_names <- regexpr("/([^/]*)$",colnames(data_table))
colnames(data_table)[short_names != -1] <- regmatches(colnames(data_table),short_names)
colnames(data_table) <- gsub("/", "", colnames(data_table))
colnames(data_table) <- gsub('^\\_|\\.$', '', colnames(data_table))
colnames(data_table) <- make.unique(colnames(data_table))

## filter out test subs, if any

data_table <- data_table %>% filter(user != "MAX TEST") %>%
  mutate(district = gsub("_"," ",district)) %>%
  group_by(user) %>%
  mutate(n = c(1:n())) %>%
  mutate(user = paste0(user,"_",n)) %>%
  ungroup()

# Reshape

## list of all years by category (good, average, bad)
## years which were not mentioned - code as "average"

years_toselect_seasonality <- paste0(years_toselect,"_002")

years_toselect_seasonality <- years_toselect_seasonality[years_toselect_seasonality %in% colnames(data_table)]

years_long <- data_table %>% 
  dplyr::select(user,district,hazard_name,all_of(years_toselect)) %>% 
  pivot_longer(all_of(years_toselect),names_to="year",values_to="category") %>%
  mutate(category = ifelse(is.na(category),"average_year",category))

years_seasonality <- data_table  %>%  
  dplyr::select(user,all_of(years_toselect_seasonality)) %>% 
  pivot_longer(all_of(years_toselect_seasonality),names_to="year",values_to="seasonality") %>%
  mutate(year = substr(year,1,4))

years_long <- left_join(years_long,years_seasonality,by=c("year" = "year", "user" = "user"))

## rankings of severe bad years

max_severe_years <- max(data_table$num_severe_years,na.rm=T)
severe_year_colnames <- paste0("severe_rank_",c(1:max_severe_years))

ranking_severe <- data_table %>% select(user,all_of(severe_year_colnames)) %>%
  pivot_longer(-c(user),names_to="rank_severe",values_to="year",names_prefix="severe_rank_") %>%
  filter(!is.na(year))

## rankings of moderate bad years

max_moderate_years <- max(data_table$num_moderate_years,na.rm=T)
moderate_year_colnames <- paste0("moderate_rank_",c(1:max_moderate_years))

ranking_moderate <- data_table %>% select(user,all_of(moderate_year_colnames)) %>%
  pivot_longer(-c(user),names_to="rank_moderate",values_to="year",names_prefix="moderate_rank_") %>%
  filter(!is.na(year))

## join rankings together

years_long <- left_join(years_long,ranking_severe,by=c("user" = "user", "year" = "year"))
years_long <- left_join(years_long,ranking_moderate,by=c("user" = "user", "year" = "year"))

## assign recoded ranking value
### decision rule: 1) severe rankings, 
### 2) followed by moderate rankings, 
### 3) followed by single value for average years, 
### 4) followed by single value for good years

years_long <- years_long %>%
  mutate(rank_severe = as.numeric(rank_severe),rank_moderate = as.numeric(rank_moderate),year=as.numeric(year)) %>% 
  group_by(user,district,hazard_name) %>%
  mutate(max_severe = max(rank_severe,na.rm=T),max_moderate=max(rank_moderate,na.rm=T) + max_severe) %>%
  mutate(num_average = sum(ifelse(category == "average_year",1,0)),max_rank = max(year) - min(year) + 1) %>%
  mutate(rank_all = ifelse(category == "bad_year" & !is.na(rank_severe),rank_severe,NA)) %>% 
  mutate(rank_all = ifelse(category == "bad_year" & is.na(rank_severe) & !is.na(rank_moderate),rank_moderate + max_severe,rank_all)) %>% 
  mutate(rank_all = ifelse(category == "bad_year" & is.na(rank_severe) & is.na(rank_moderate),median(rank_all,na.rm=T),rank_all)) %>% ## if year was listed as bad but not ranked
  mutate(rank_all = ifelse(category == "average_year",max_moderate + num_average,rank_all)) %>%
  mutate(rank_all = ifelse(category == "good_year",max_rank,rank_all)) %>%
  mutate(rank_all = ifelse(is.infinite(rank_all),max_rank,rank_all)) %>%
  ungroup()
  
years_long_clean <- years_long %>%
  dplyr::select(user,district,hazard_name,year,rank_all,seasonality)

## visualize

years_vis <- years_long_clean %>% filter(rank_all <= 8) %>% rename("rank" = "rank_all")
  
blank_field <- expand.grid(c(2000:2025),unique(years_vis$user))
colnames(blank_field) <- c("year","user")
blank_field$year <- as.numeric(blank_field$year)
years_vis <- left_join(blank_field,years_vis,by=c("year" = "year","user" = "user"))

years_vis <- years_vis %>% 
  mutate(
    cnt = 1,
    num.rank =  rank,
    string.rank =  case_when(
      rank == 1 ~ "First Worst",
      rank == 2 ~ "Second Worst",
      rank == 3 ~ "Third Worst",
      rank == 4 ~ "Fourth Worst",
      rank == 5 ~ "Fifth Worst",
      rank == 6 ~ "Sixth Worst",
      rank == 7 ~ "Seventh Worst",
      rank == 8 ~ "Eighth Worst"
    ),
    string.rank = fct_reorder(string.rank, num.rank))

ggplot(years_vis %>% filter(!is.na(hazard_name))) + 
  geom_tile(aes(user, year, fill = string.rank,),
            alpha = .7,size=0.5) + 
  facet_wrap(~hazard_name,scales="free_x") +
  scale_fill_manual(values = rev(brewer.pal(8,"Reds")),na.value = 'white') + 
  scale_y_discrete(breaks = c(2000:2025),limits=c(2000:2025)) +
  theme_tufte() + 
  labs(fill = "Bad Year Rank", title = paste0("Top Years by User Input")) + 
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_text(size=8),
    panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    legend.position = "bottom",
    axis.title = element_blank())


  
years_calendar <- years_long_clean %>% filter(!is.na(seasonality)) %>% separate_wider_delim(seasonality," ",names_sep = "_",too_few = "align_start") %>%
  pivot_longer(c(seasonality_1:seasonality_11),names_to = "var",values_to = "month") %>%
  filter(!is.na(month))

ggplot(years_calendar %>% mutate(month = as.numeric(month))) + geom_tile(aes(x=month,y=year),alpha=0.4) + facet_wrap(~hazard_name) +
  scale_x_continuous(breaks=c(1:12)) +
  scale_y_discrete(breaks = c(2000:2025),limits=c(2000:2025)) +
  ggtitle("Reported Disaster Timing")

## aggregate over districts, hazards 

years_long_average <- years_long_clean %>%
  group_by(district,hazard_name,year) %>%
  summarise(rank_avg = mean(rank_all,na.rm=T)) %>%
  mutate(rank_bysector = rank(rank_avg,ties.method = 'min'))

# Export

write.csv(years_long_average,"expert_bad_years_belize.csv",row.names = FALSE)


## tabulate community questions

community <- data_table %>% dplyr::select(hazard_name, organization,community_what)

write.csv(community,'community_qs.csv',row.names = FALSE)
  
## tabulate info questions

info <- data_table %>% filter(!is.na(climate_info)) %>% dplyr::select(c(hazard_name,organization,climate_info,climate_lead,climate_who)) %>%
    pivot_longer(c(climate_info:climate_who))
  
write.csv(info,'forecast_info.csv',row.names = FALSE)


## tabulate action questions

actions <- data_table %>% filter(!is.na(climate_info)) %>% dplyr::select(c(hazard_name,organization,severe_actions_1:moderate_actions_3)) %>%
    pivot_longer(c(severe_actions_1:moderate_actions_3)) %>%
    filter(!is.na(value))
  
write.csv(actions,'forecast_actions.csv',row.names = FALSE)




