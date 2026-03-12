# Changing Climate Hazard Metrics

Now we will show you how to change the climate hazard metrics used by the tool. For this example, we will change the hazard metric used for drought analysis from seasonal total rainfall to season onset.  

Before:

```
function hazardChart() {
    
    var selectedMuni = muni.filterBounds(ee.Geometry.MultiPoint(selectedPoints)) ;
    
    var startDate = ee.Date.fromYMD(year_start+1,1,1);
    var endDate = ee.Date.fromYMD(year_end+1,1,1) ;
    var secondDate = startDate.advance(1, 'year').millis();
    var increase = secondDate.subtract(startDate.millis());
    var interval_list = ee.List.sequence(startDate.millis(), endDate.millis(), increase) ;
    
   var chart = ui.Chart.image.seriesByRegion({
      imageCollection: rainTot, 
      regions: selectedMuni, 
      reducer: ee.Reducer.mean(), 
      scale: 10000,
      xProperty: 'year',
      seriesProperty: 'shapeName'
    }).setOptions({
      lineWidth: 0,
      pointSize: 5,
      title: 'Total JJA rainfall',
      vAxis: {title: 'total mm'},
      hAxis: {title: 'Year'}
    }) ;
    
    return chart ;
    
  }

```

After:

```
function hazardChart() {
    
    var selectedMuni = muni.filterBounds(ee.Geometry.MultiPoint(selectedPoints)) ;
    
    var startDate = ee.Date.fromYMD(year_start+1,1,1);
    var endDate = ee.Date.fromYMD(year_end+1,1,1) ;
    var secondDate = startDate.advance(1, 'year').millis();
    var increase = secondDate.subtract(startDate.millis());
    var interval_list = ee.List.sequence(startDate.millis(), endDate.millis(), increase) ;
    
   var chart = ui.Chart.image.seriesByRegion({
      imageCollection: seasonAOnset, // replace with the name of another hazard ImageCollection computed in the first part of the script 
      regions: selectedMuni, 
      reducer: ee.Reducer.mean(), 
      scale: 10000,
      xProperty: 'year',
      seriesProperty: 'shapeName'
    }).setOptions({
      lineWidth: 0,
      pointSize: 5,
      title: 'Season onset', // also change title...
      vAxis: {title: 'day of year}, // and axis label 
      hAxis: {title: 'Year'}
    }) ;
    
    return chart ;
    
  }

```

Keep in mind that this only changes the data displayed by the hazard plot in the tool, and NOT the forecast data, or any other accompanying information!

# Function Bank

We have implemented a large number of ready-made functions for computing common climate hazard metrics. You can find a detailed guide to these functions in the final section of this document. 

<div id="slide-config" data-type="simple" data-next="../forecast/" data-kobo-id="hACTMCaZ" data-width="100%"> </div>

