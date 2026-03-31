
library(dplyr)
library(ggplot2)

setwd("/Users/mmauerman/Documents/Belize")

stations <- read.csv("belize_nms_stations.csv")


dekads <- read.csv("daily_vector_dekads.csv") %>% rename_at(c(1:2),~c("time","dekad")) %>% mutate(time = as.Date(paste0("2000-",time),format="%Y-%d-%b")) %>%
  mutate(month = as.numeric(format(time,"%m")),day=as.numeric(format(time,"%d"))) %>% dplyr::select(-time) %>%
  group_by(dekad) %>% mutate(pentad = ifelse(day < median(day),(dekad*2)-1,dekad*2 )) %>% ungroup()

## clean data

cap <- 20 

stations <- stations %>% mutate(prec_nocap = prec) %>% mutate(prec = ifelse(prec > cap, cap, prec))

stations_dek <- stations %>% left_join(dekads,by=c("month"="month","day"="day")) %>%
  group_by(station,year,dekad) %>% summarise(rain_dek = sum(prec,na.rm=T), heat_dek = mean(tmax,na.rm=T), month = max(month), day = max(day)) %>% 
  ungroup()

stations_pentad <- stations %>% left_join(dekads,by=c("month"="month","day"="day")) %>%
  group_by(station,year,pentad) %>% summarise(rain_pentad = sum(prec,na.rm=T), heat_pentad = mean(tmax,na.rm=T), month = max(month), day = max(day))  %>% 
  ungroup()

## plot on map

stations_map <- stations %>% group_by(station) %>% mutate(n = c(1:n())) %>% filter(n ==1 ) %>% ungroup()
write.csv(stations_map,"stations_map.csv",row.names = FALSE)

## climatology

clim <- stations_dek %>% group_by(station,dekad) %>% summarise(prec_clim = mean(rain_dek,na.rm=T),day=max(day),month=max(month)) %>%
  mutate(date = as.Date(paste("2000",month,day,sep="-")))

ggplot(clim,aes(x=date,y=prec_clim)) + geom_line() + facet_wrap(~station)

## wettest and driest years

season_totals <- stations_dek %>% filter(month %in% c(6:8)) %>% group_by(station,year) %>% summarise(rain_tot=sum(rain_dek))

ggplot(season_totals,aes(x=year,y=rain_tot)) + geom_point() + facet_wrap(~station)

ggplot(season_totals %>% filter(year %in% c(2000:2022)),aes(x=year,y=rain_tot)) + geom_point() + facet_wrap(~station)

ggplot(season_totals %>% filter(year %in% c(2000:2022)),aes(x=rain_tot)) + stat_ecdf() + facet_wrap(~station)

## season onset

onset_thresh <- 25

season_onset <- stations_pentad %>% filter(pentad %in% c(28:38)) %>% mutate(date = as.Date(paste(year,month,day,sep="-"))) %>%
  mutate(doy = as.numeric(format(date,"%j"))-5) %>%
  mutate(above_thresh = ifelse(rain_pentad > onset_thresh,1,0)) %>%
  filter(above_thresh == 1) %>%
  group_by(station,year) %>%
  summarise(onset = min(doy))

ggplot(season_onset,aes(x=year,y=onset)) + geom_point() + facet_wrap(~station)

ggplot(season_onset %>% filter(year %in% c(2000:2022)),aes(x=year,y=onset)) + geom_point() + facet_wrap(~station)

ggplot(season_onset %>% filter(year %in% c(2000:2022)),aes(x=onset)) + stat_ecdf() + facet_wrap(~station)

## rainy spells

rainy_thresh = 40

rainy_spells <- stations %>% filter(month %in% c(6:11)) %>% mutate(is_rainy = ifelse(prec_nocap > rainy_thresh,1,0)) %>% 
  group_by(station,year) %>% mutate(diff = is_rainy - lag(is_rainy)) %>% mutate(index = c(1:n())) %>%
  filter(diff != 0) %>%
  mutate(length = index - lag(index)) %>%
  filter(diff == -1) %>%
  summarise(longest_spell = max(length)) %>%
  ungroup() %>%
  mutate(longest_spell = ifelse(is.na(longest_spell),0,longest_spell))
  
ggplot(rainy_spells,aes(x=year,y=longest_spell)) + geom_point() + facet_wrap(~station)

ggplot(rainy_spells %>% filter(year %in% c(2000:2022)),aes(x=year,y=longest_spell)) + geom_point() + facet_wrap(~station)

ggplot(rainy_spells %>% filter(year %in% c(2000:2022)),aes(x=longest_spell)) + stat_ecdf() + facet_wrap(~station)


## heat climatology 


clim_temp <- stations_dek %>% group_by(station,dekad) %>% summarise(temp_clim = mean(heat_dek,na.rm=T),day=max(day),month=max(month)) %>%
  mutate(date = as.Date(paste("2000",month,day,sep="-")))

ggplot(clim_temp,aes(x=date,y=temp_clim)) + geom_line() + facet_wrap(~station)


## heat waves

heat_thresh = 35

hot_spells <- stations %>% filter(month %in% c(4:6)) %>% mutate(is_hot = ifelse(tmax > heat_thresh,1,0)) %>% 
  group_by(station,year) %>% mutate(diff = is_hot - lag(is_hot)) %>% mutate(index = c(1:n())) %>%
  filter(diff != 0) %>%
  mutate(length = index - lag(index)) %>%
  filter(diff == -1) %>%
  summarise(longest_spell = max(length)) %>%
  ungroup() %>%
  mutate(longest_spell = ifelse(is.na(longest_spell),0,longest_spell))

ggplot(hot_spells,aes(x=year,y=longest_spell)) + geom_point() + facet_wrap(~station)

ggplot(hot_spells %>% filter(year %in% c(2000:2022)),aes(x=year,y=longest_spell)) + geom_point() + facet_wrap(~station)

ggplot(hot_spells %>% filter(year %in% c(2000:2022)),aes(x=longest_spell)) + stat_ecdf() + facet_wrap(~station)

## daily heat

ggplot(stations,aes(x=tmax)) + stat_ecdf() + facet_wrap(~station)

