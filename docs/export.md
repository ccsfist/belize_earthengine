# Exporting Data

You may wish to export data from Google Earth Engine into other mapping or analysis programs. To do so, insert the following block of code at the bottom of your script:

```
Export.image.toDrive({
  image: rainClimTot,
  description: 'total_jja_rainfall',
  maxPixels: 1000000000,
  region: muni.geometry()
  });
```

Note that Google Earth Engine's usage limitations may block very large exports. If this happens to you, we suggest trying the following:

- Export the data in multiple geographic slices.
- Export the data in multiple temporal slices. 
- Lower the resolution of the export (if acceptable) by adding a "scale" (measured in km^2) argument to the export call.

**As your assignment for today**, we would like you to produce a custom hazard map for presentation in the stakeholder workshop tomorrow, following the steps described here. The final tab of this document contains a detailed reference to the code functions, if needed. 

<div id="slide-config" data-type="simple" data-next="../functionguide/" data-kobo-id="hACTMCaZ" data-width="100%"> </div>

