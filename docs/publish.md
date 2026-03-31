# Publishing and Embedding Apps

If you wish to share your Earth Engine maps with the public, you can publish them to a public URL. To do so, click on the "Apps" icon on the top right of the code editor panel, and then select "New App". You will be prompted to give the app a name, a location (on your GEE repository) for the source code, and an optional logo. 

Once published, it will take a few minutes before the app is publically viewable. You can update the source code of an app at any time by click its name in the Apps panel, and choosing "Overwrite". Note that apps will NOT automatically reflect changes to your code repositories; you must manually publish each update. 

If you encouter errors in viewing an app even when the underlying script works, be sure that all assets that the script is using are accessable to the app. You can share assets with an app without having to make them publically downloadable. To do so, choose the "Add App Access" dropdown from the asset sharing tab. 

The code repository for this project comes with a number of scripts for interactive apps, including the historical hazard analysis maptools used for this workshop discussion, as well as forecast monitoring maptools for seasonal onset, rainy spells, heat waves, and seasonal drought. 

https://ee-maxmauerman.projects.earthengine.app/view/belizeexcessmonitor
https://ee-maxmauerman.projects.earthengine.app/view/belizeheatmonitor
https://ee-maxmauerman.projects.earthengine.app/view/belizemonitor
https://ee-maxmauerman.projects.earthengine.app/view/belizeonsetmonitor

# Map Embed Example 

You can embed Earth Engine apps in any .html webpage. This page contains a code example of how to do so, using html frames. 

Note that the forecast monitor apps are set up to take a "year", "month" and "day" as parameters in the URL. By changing these parameters, you can change the date for which the forecast is displayed. For example, if you wish to display the GFS weather forecast generated on March 15, 2026, you would add "#year=2026;month=3;day=15" to the end of the embed URL. Note that if forecast data does not exist for the specified time period, the app will fail to load. 

The result of the embedding code looks like the below:

<div style="text-align: center; margin-top: 10px;">
    <iframe id="resizableFrame" 
        src="https://ee-maxmauerman.projects.earthengine.app/view/belizeonsetmonitor#year=2026;month=3;day=15;" 
        width="1200" height="1300" 
        style="border:1px solid black; transition: all 0.3s ease;"></iframe>
</div>


<div id="slide-config" data-type="simple" data-next="../functionguide/" data-kobo-id="hACTMCaZ" data-width="100%"> </div>

