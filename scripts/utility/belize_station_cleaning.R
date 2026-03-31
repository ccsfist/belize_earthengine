
library(readxl)
library(dplyr)

setwd("/Users/mmauerman/Documents/Belize")

sheets <- excel_sheets("NMS Data UNTIL 2025.xlsx")

data_list <- list()

i <- 1
for(s in sheets) {
  
  data_header <- read_xlsx("NMS Data UNTIL 2025.xlsx",sheet=s,range="A2:B4",col_names = FALSE)
  
  data <- read_xlsx("NMS Data UNTIL 2025.xlsx",sheet=s,skip=8) %>%
    mutate(lat = as.numeric(data_header[2,2]),
           lon = as.numeric(data_header[3,2]),
           station = as.character(data_header[1,2])) %>%
    mutate_if(is.numeric,~ ifelse(.x==-99.9,NA,.x))
  
  data_list[[i]] <- data
  
  i <- i + 1
}

data_compiled <- bind_rows(data_list) %>% rename_at(c(1:9),~c("year","month","day","prec","tmax","tmin","lat","lon","station")) %>%
  mutate(ymd = paste(year,month,day,sep="-"))

write.csv(data_compiled,"belize_nms_stations.csv",row.names = FALSE)

## convert to raster
# 
# library(raster)
# 
# ymin <- min(data_compiled$lat)
# ymax <- max(data_compiled$lat)
# xmin <- min(data_compiled$lon)
# xmax <- max(data_compiled$lon)
# 
# raster_files <- list()
# for (date in unique(data_compiled$ymd)) {
# 
#   ras_dom<-raster(xmn=xmin, xmx=xmax, ymn=ymin, ymx=ymax,
#                   crs="+proj=longlat +datum=WGS84 +no_defs ",
#                   resolution=c(0.1,0.1), vals=NA)
#   
#   data_compiled_subset <- data_compiled %>% filter(ymd == date)
#   
#   coordinates(data_compiled_subset) <- ~ lon + lat
#   
#   data_raster <- rasterize(data_compiled_subset,ras_dom,"prec",update=TRUE,fun='first')
#   
#   raster_files[[date]] <- data_raster
# 
# } 
# 
# stationStack <- stack(raster_files)
# 
# writeRaster(stationStack,"nms_stations.tiff",overwrite=TRUE)

