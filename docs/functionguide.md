# Function Guide

This section contains a reference to all of the climate hazard calculations that we have implemented to date. This guide is not exhaustive, and GEE is capable of much more, so we encourage you to expand on this!

# Hazard Functions

## Rainfall

rainfallIntervalSum(dataset,interval,increment,year_start,year_end,include_cap,cap_value)

- dataset: string; satellite to use ["CHIRPS","GPM"]
- interval: integer; number of [increment] to advance by
- increment: string; unit of time ['day','week','month']
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation
- include_cap: boolean; whether to clean data of extreme high values before summing (useful for drought)
- cap_value: integer; cap amount in cumulative mm of rainfall IF include_cap = TRUE

Computes the sum of rainfall over the defined interval and outputs an ImageCollection. This is a common pre-processing step for subsequent analysis, since daily rainfall data tends to be noisy. 

onsetDate(intervalDataset,onsetThreshold,seasonStartDoy,seasonLength,year_start,year_end)

- intervalDataset: output from rainfallIntervalSum
- onsetThreshold: integer; amount of cumulative rainfall in mm which defines start of season
- seasonStartDoy: integer; day of year which defines beginning of agricultural year 
- seasonLength: integer; number of days that the agricultural year lasts
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the onset date (first day of the rainy season) for each year in the defined time period, and outputs an ImageCollection. Season length and onset threshold must be defined empirically; see Section 2 of this guide for discussion on how to focus such analysis.

cessationDate(intervalDataset,cessationThreshold,seasonStartDoy,seasonLength,year_start,year_end)

- intervalDataset: output from rainfallIntervalSum
- cessationThreshold: integer; amount of cumulative rainfall in mm which defines end of season
- seasonStartDoy: integer; day of year which defines beginning of agricultural year 
- seasonLength: integer; number of days that the agricultural year lasts
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the cessation date (last day of the rainy season) for each year in the defined time period, and outputs an ImageCollection. Season length and cessation threshold must be defined empirically; see Section 2 of this guide for discussion on how to focus such analysis.

spi(dataset,interval,increment,year_start,year_end,windowWidth)   

- dataset: string; satellite to use ["CHIRPS","GPM"]
- increment: string; unit of time ['day','week','month']
- interval: integer; number of [increment] to advance by
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation
- windowWidth: integer; number of [increment] before and after each observation to compute SPI

Computes standardized precipitation index (SPI) over the defined interval and outputs an ImageCollection. SPI is a standardized measure of how different a given observation is from the long-term average, as measured in standard deviations (i.e. a z-score). 

The windowWidth argument defines the span of observations that the algorithm samples for computing z-score. For instance, a windowWidth of 10 days means that the observation for 20th June, 2023 is compared against the mean and standard deviation of observations spanning from 10th June to 30th June in the historical record. 

seasonalTotal(intervalDataset,seasonStartDoy,seasonLength,year_start,year_end)

- intervalDataset: output from rainfallIntervalSum or spi
- seasonStartDoy: integer; day of year which defines beginning of agricultural year 
- seasonLength: integer; number of days that the agricultural year lasts
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the seasonal sum of rainfall over the defined interval and outputs an annual ImageCollection.

climatology(dataset,interval,increment,year_start,year_end)

- dataset: string; satellite to use ["CHIRPS","GPM"]
- increment: string; unit of time ['day','week','month']
- interval: integer; number of [increment] to advance by
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the average rainfall, i.e. the climatology, and outputs an ImageCollection of long-term means and standard deviations over the defined time intervals.

seasonalWetDays(dataset,threshold,seasonStartDoy,seasonLength,year_start,year_end)
  
- dataset: string; satellite to use ["CHIRPS","GPM"]
- threshold: integer; threshold of wet day in mm
- seasonStartDoy: integer; day of year which defines beginning of agricultural year  
- seasonLength: integer; number of days that the agricultural year lasts
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the percentage of days in the season above a given rainy day threshold. 

drySpell(dataset,seasonStartDoy,seasonLength,threshold,year_start,year_end)
  
- dataset: string; satellite to use ["CHIRPS","GPM"]
- seasonStartDoy: integer; day of year which defines beginning of agricultural year  
- seasonLength: integer; number of days that the agricultural year lasts
- threshold: daily rainfall threshold for defining a "dry day" 
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes two dry spell statistics: The length of the longest dry spell (i.e., consecutive days with rain below the threshold) and the start day of the longest dry spell, over the defined seasonal interval. 

rainySpell(dataset,seasonStartDoy,seasonLength,threshold,year_start,year_end)
  
- dataset: string; satellite to use ["CHIRPS","GPM"]
- seasonStartDoy: integer; day of year which defines beginning of agricultural year  
- seasonLength: integer; number of days that the agricultural year lasts
- threshold: daily rainfall threshold for defining a "rainy day" 
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes two rainy spell statistics: The length of the longest rainy spell (i.e., consecutive days with rain above the threshold) and the start day of the longest rainy spell, over the defined seasonal interval. 

## Temperature 

tempIntervalAvg(dataset,interval,increment,year_start,year_end)

- dataset: string; satellite to use ["ERA5", "GLDAS","ERA5_LAND"]
- interval: integer; number of [increment] to advance by
- increment: string; unit of time ['day','week','month']
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the average temperature over the defined interval and outputs an ImageCollection. This is a common pre-processing step for subsequent analysis, since daily data tends to be noisy. 

climatology(dataset,interval,increment,year_start,year_end)

- dataset: string; satellite to use ["ERA5", "GLDAS","ERA5_LAND"]
- increment: string; unit of time ['day','week','month']
- interval: integer; number of [increment] to advance by
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the average temperature, i.e. the climatology, and outputs an ImageCollection of long-term means and standard deviations over the defined time intervals.

seasonalHeatDays(dataset,threshold,seasonStartDoy,seasonLength,year_start,year_end)

- dataset: string; satellite to use ["ERA5", "GLDAS","ERA5_LAND"]
- threshold: integer; threshold of hot day in degrees C 
- seasonStartDoy: integer; day of year which defines beginning of agricultural year  
- seasonLength: integer; number of days that the agricultural year lasts
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes the number of heat stress days, i.e. days exceeding some temperature threshold, over the defined interval, and outputs an ImageCollection. This is an alternative way of pre-processing heat data that some applications use.  

hotSpell(dataset,seasonStartDoy,seasonLength,threshold,year_start,year_end)
  
- dataset: string; satellite to use ["ERA5", "GLDAS","ERA5_LAND"]
- seasonStartDoy: integer; day of year which defines beginning of agricultural year  
- seasonLength: integer; number of days that the agricultural year lasts
- threshold: daily temp threshold for defining a "hot day" 
- year_start: integer; first calendar year for calculation
- year_end: integer; last calendar year for calculation

Computes two heat wave statistics: The length of the longest heat wave(i.e., consecutive days with temperature above the threshold) and the start day of the longest heat wave, over the defined seasonal interval. 

# Statistical Functions

## Projections

climChangeProjection(baseline_year_start, baseline_year_end, projection_year_start, projection_year_end, target_month_start, target_month_end, indicator, scenario)

 - baseline_year_start: integer [1950-2015]; first year for computing historical baseline
 - baseline_year_start: integer [1950-2015]; last year for computing historical baseline
 - projection_year_start: integer [2015-2099]; first year for projection period
 - projection_year_end: integer [2015-2099]; last year for projection period
 - target_month_start: integer; first month of target season
 - target_month_end: integer; last month of target season
 - indicator: string ['pr','tasmin','tasmax']: which climate variable to use 
 - scenario: string ['ssp245', 'ssp585']; which emissions scenario to use for projections?

Computes the projected percentage change in long-term climate conditions (total precipitation and maximum temperature), as measured from the chosen baseline period to the chosen projection period. Outputs an Image with bands for % change in precipitation and temperature. 


## Hazard Statistics

computeExposure(processed_dataset,exposure_dataset,exposure_var)

- processed_dataset: output of function from 1_HazardMetrics - typically, annual metric
- exposure_dataset: exposure dataset on cloud project or GEE Data Catalog
- exposure_var: string; name of numeric variable denoting level of exposure in exposure_dataset

Takes an ImageCollection of climate hazard over time and scales it by some factor denoting risk exposure – such as population in a given pixel. Outputs an ImageCollection. 

longtermStats(processed_dataset,outcome_var)

  - processed_dataset: output of function from 1_HazardMetrics (optionally, scaled by computeExposure first)
  - outcome_var: variable over which to calculate trend

Takes an ImageCollection of annual climate hazard and computes a number of temporal summary statistics: Mean, standard deviation, 25th and 75th percentiles, linear trend and anomaly. Anomaly is an annual measure; the rest of the statistics do not vary over each year, by definition. Outputs an ImageCollection. 

riskIndex(image,h_var,e_var,v_var,h_weight,e_weight,v_weight)

  - image: compiled image w bands for hazard, exposure, vulnerability (see dashboard template for how to create) 
  - h_var: string; name of hazard variable in collection
  - e_var: string; name of exposure variable in collection
  - v_var: string; name of vulnerability variable in collection
  - h_weight: decimal; weight of hazard in risk index (weights must sum to 1)
  - e_weight: decimal; weight of hazard in risk index (weights must sum to 1)
  - v_weight: decimal; weight of hazard in risk index (weights must sum to 1)

Compiles a climate risk index, which is a weighted average of the given hazard, exposure and vulnerability variables. The function first scales each variable to 0-1 (using minmax scaling), then computes the weighted average index (with user defined weights), then finally minmax scales the risk index a second time.  

longtermStats(processed_dataset,outcome_var)

  - processed_dataset: output of function from 1_HazardMetrics (optionally, scaled by computeExposure first)
  - outcome_var: variable over which to calculate trend

Takes an ImageCollection of annual climate hazard and computes a number of temporal summary statistics: Mean, standard deviation, 25th and 75th percentiles, linear trend and anomaly. Anomaly is an annual measure; the rest of the statistics do not vary over each year, by definition. Outputs an ImageCollection. 


# Areal Functions

clipToAdmin(processed_dataset,shapefile,subset_yn,unit_name,unit_list)

- processed_dataset: output from 1_HazardMetrics or 2_StatsFunctions function
- shapefile: admin shapefile on cloud project or GEE Data Catalog
- subset_yn: boolean; subset by specific sub-units (TRUE) or use entire file (FALSE)?
- unit_name: string ; name of administrative level to subset by 
- unit_list: bracketed list of admin units to subset by ['example1','example2'...]

Clips an ImageCollection to a defined set of administrative boundaries. This is useful for making maps and speeding up other computations (especially exporting data). 

arealSummary(processed_dataset,shapefile,include_geometry)

- processed_dataset: output from 1_HazardMetrics function
- shapefile: string; name of shapefile on cloud project 
- include_geometry: boolean; whether to include feature geometry in the export (TRUE) or only table values (FALSE)

Computes the areal average and standard deviation over the specified geometry for each image in an ImageCollection. Outputs a FeatureCollection; if being used for a table export, can omit the geometry to reduce file size and speed up computation using the include_geometry argument.

arealSummarySingleImg(image,shapefile,include_geometry)

- image: output from 2_StatsFunctions function
- shapefile: string; name of shapefile on cloud project 
- include_geometry: boolean; whether to include feature geometry in the export (TRUE) or only table values (FALSE)

Computes the areal average and standard deviation over the specified geometry for an Image. Outputs a FeatureCollection; if being used for a table export, can omit the geometry to reduce file size and speed up computation using the include_geometry argument.

pointsBuffer(pointsFeature,bufferSize)

- pointsFeature: featureCollection of points data
- bufferSize: integer; size of buffer in meters

Draws a radial buffer zone around each point in a set of point data, merging any features that overlap. Useful for aggregating a lot of neighboring sites, e.g. village coordinates, for the purposes of computing summary statistics. 


