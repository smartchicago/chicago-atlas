/*!
 * Searchable Map Template with Google Fusion Tables
 * http://derekeder.com/searchable_map_template/
 *
 * Copyright 2012, Derek Eder
 * Licensed under the MIT license.
 * https://github.com/derekeder/FusionTable-Map-Template/wiki/License
 *
 * Date: 8/15/2012
 * 
 */
 
var MapsLib = MapsLib || {};
var MapsLib = {
  
  //Setup section - put your Fusion Table details here
  //Using the v1 Fusion Tables API. See https://developers.google.com/fusiontables/docs/v1/migration_guide for more info
  
  //the encrypted Table ID of your Fusion Table (found under File => About)
  //NOTE: numeric IDs will be depricated soon
  fusionTableId:      "152jqgQ46LE6Y2XWCN45QKs2CF515GIj2Am_YAiM",  
  zipDiabetesId:      "1VyWsjRM3ZzWc0UexTuYxytNCT7dxK0MIWAtxwPs",
  clinicsTableId:     "1NLcaLm_-WRxEsOt57pQ0afGi8X_wNZspSO61D-M", 
  
  //*New Fusion Tables Requirement* API key. found at https://code.google.com/apis/console/   
  //*Important* this key is for demonstration purposes. please register your own.   
  googleApiKey:       "AIzaSyA3FQFrNr5W2OEVmuENqhb2MBB2JabdaOY",        
  
  //name of the location column in your Fusion Table. 
  //NOTE: if your location column name has spaces in it, surround it with single quotes 
  //example: locationColumn:     "'my location'",
  locationColumn:     "geometry",  

  map_centroid:       new google.maps.LatLng(41.8781136, -87.66677856445312), //center that your map defaults to
  locationScope:      "chicago",      //geographical area appended to all address searches
  recordName:         "result",       //for showing number of results
  recordNamePlural:   "results", 
  
  searchRadius:       1,            //in meters ~ 1/2 mile
  defaultZoom:        11,             //zoom level when map is loaded (bigger is more zoomed in)
  addrMarkerImage: '/images/blue-pushpin.png',
  infoWindow: null,
  currentPinpoint: null,
  indicator_view: '',

  blue_array: ["#BDD7E7", "#6BAED6", "#3182BD", "#08519C"],
  green_array: ["#B2E2E2", "#66C2A4", "#2CA25F", "#006D2C"],
  red_array: ["#FCAE91", "#FB6A4A", "#DE2D26", "#A50F15"],
  grey_array: ["#CCCCCC", "#969696", "#636363", "#252525"],
  orange_array: ["#FDBE85", "#FD8D3C", "#E6550D", "#A63603"],
  purple_array: ["#CBC9E2", "#9E9AC8", "#756BB1", "#54278F"],
  
  initialize: function() {
  
    geocoder = new google.maps.Geocoder();
    var myOptions = {
      zoom: MapsLib.defaultZoom,
      center: MapsLib.map_centroid,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map($("#mapCanvas")[0],myOptions);
    
    MapsLib.searchrecords = null;
    
    //run the default search
    MapsLib.doSearch();
  },
  
  doSearch: function(view, colors) {
    MapsLib.clearSearch();

    var whereClause = MapsLib.locationColumn + " not equal to ''";
    MapsLib.submitSearch(whereClause, map, view, colors);
  },
  
  submitSearch: function(whereClause, map, view, colors) {
    
    if (view != undefined)
      MapsLib.indicator_view = view;
    else {
      MapsLib.indicator_view = "2006 diabetes percent";
    }

    if (MapsLib.indicator_view.indexOf('diabetes percent') != -1) {
      MapsLib.searchrecords = new google.maps.FusionTablesLayer({
        query: {
          from:   MapsLib.zipDiabetesId,
          select: MapsLib.locationColumn,
          where:  whereClause
        },
        styles: MapsLib.mapStyles(eval(colors)),
        suppressInfoWindows: true
      });

      MapsLib.searchrecords.setMap(map);

      if (MapsLib.infoWindow) MapsLib.infoWindow.close();

      //override default info window
      google.maps.event.addListener(MapsLib.searchrecords, 'click', 
        function(e) { 
          if (MapsLib.infoWindow) MapsLib.infoWindow.close();
          MapsLib.openFtInfoWindow(e.latLng, e.row['zip'].value, MapsLib.indicator_view, e.row[MapsLib.indicator_view].value);
        }
      );

      MapsLib.pointsLayer = new google.maps.FusionTablesLayer({
        query: {
          from:   MapsLib.clinicsTableId,
          select: MapsLib.locationColumn
        }
      });

      MapsLib.pointsLayer.setMap(map);

    }
    else {
      //get using all filters
      MapsLib.searchrecords = new google.maps.FusionTablesLayer({
        query: {
          from:   MapsLib.fusionTableId,
          select: MapsLib.locationColumn,
          where:  whereClause
        },
        styles: MapsLib.mapStyles(eval(colors)),
        suppressInfoWindows: true
      });

      MapsLib.searchrecords.setMap(map);

      if (MapsLib.infoWindow) MapsLib.infoWindow.close();

      //override default info window
      google.maps.event.addListener(MapsLib.searchrecords, 'click', 
        function(e) { 
          if (MapsLib.infoWindow) MapsLib.infoWindow.close();
          MapsLib.openFtInfoWindow(e.latLng, e.row['Community Area Name'].value, MapsLib.indicator_view, e.row[MapsLib.indicator_view].value);
        }
      );
    }
  },

  openFtInfoWindow: function(position, community_area, indicator_name, indicator_value) {
    // Set up and create the infowindow
    if (!MapsLib.infoWindow) MapsLib.infoWindow = new google.maps.InfoWindow({});
     
    if (indicator_value.indexOf('0.') != -1)
    {
      indicator_value = ((+indicator_value)*100).toFixed(2);
      indicator_value = indicator_value + "%"
    }

    var content = "<div class='googft-info-window' style='font-family: sans-serif'>";
    content += "<span class='lead'>" + community_area + "</span>"
    content += "<p>" + indicator_name + ": " + indicator_value + "</p>";
    content += '</div>';
    
    MapsLib.infoWindow.setOptions({
      content: content,
      pixelOffset: null,
      position: position
    });
    // Infowindow-opening event handler
    MapsLib.infoWindow.open(map);
    //MapsLib.getInfoWindowDescription(zone_class);
  },
  
  getInfoWindowContent: function(whereClause) {
    var indicator_view = MapsLib.indicator_view;
    var selectColumns = "'Community Area Name', '" + MapsLib.indicator_view + "'";
    MapsLib.query(selectColumns, whereClause, "MapsLib.setInfoWindowContent");
  },
  
  setInfoWindowContent: function(json) { 
    var data = json["rows"];
    MapsLib.openFtInfoWindow(MapsLib.currentPinpoint, data[0][0], json["columns"][1], data[0][1])
  },

  bucketRanges: function(indicator_view) {

    var ranges = 
    {
      "Birth Rate": {
        "max": 22.4,
        "min": 9.4,
      },
      "General Fertility Rate": {
        "max": 94.9,
        "min": 27.7,
      },
      "Low Birth Weight": {
        "max": 19.7,
        "min": 3.5,
      },
      "Prenatal Care Beginning in First Trimester": {
        "max": 94.5,
        "min": 63.6,
      },
      "Preterm Births": {
        "max": 17.5,
        "min": 5,
      },
      "Teen Birth Rate": {
        "max": 116.9,
        "min": 1.3,
      },
      "Assault (Homicide)": {
        "max": 62.9,
        "min": 0,
      },
      "Breast cancer in females": {
        "max": 56,
        "min": 8.6,
      },
      "Cancer (All Sites)": {
        "max": 283.9,
        "min": 120.9,
      },
      "Colorectal Cancer": {
        "max": 55.4,
        "min": 6.4,
      },
      "Diabetes-related": {
        "max": 122.8,
        "min": 26.8,
      },
      "Firearm-related": {
        "max": 63.6,
        "min": 1.5,
      },
      "Infant Mortality Rate": {
        "max": 27.6,
        "min": 1.5,
      },
      "Lung Cancer": {
        "max": 98.7,
        "min": 23.6,
      },
      "Prostate Cancer in Males": {
        "max": 129.1,
        "min": 2.5,
      },
      "Stroke (Cerebrovascular Disease)": {
        "max": 110.9,
        "min": 23.5,
      },
      "Childhood Blood Lead Level Screening": {
        "max": 609.4,
        "min": 0,
      },
      "Childhood Lead Poisoning": {
        "max": 3,
        "min": 0,
      },
      "Gonorrhea in Females": {
        "max": 2664.6,
        "min": 0,
      },
      "Gonorrhea in Males": {
        "max": 2125.4,
        "min": 0,
      },
      "Tuberculosis": {
        "max": 22.7,
        "min": 0,
      },
      "Below Poverty Level": {
        "max": 61.4,
        "min": 3.1,
      },
      "Crowded Housing": {
        "max": 17.6,
        "min": 0.2,
      },
      "Dependency": {
        "max": 50.2,
        "min": 15.5,
      },
      "No High School Diploma": {
        "max": 58.7,
        "min": 2.9,
      },
      "Per Capita Income": {
        "max": 87163,
        "min": 8535,
      },
      "Unemployment": {
        "max": 40,
        "min": 4.2,
      },
      "2006 diabetes percent": {
        "max": 0.1555,
        "min": 0.0110,
      },
      "2007 diabetes percent": {
        "max": 0.1555,
        "min": 0.0110,
      },
      "2008 diabetes percent": {
        "max": 0.1555,
        "min": 0.0110,
      },
      "2009 diabetes percent": {
        "max": 0.1555,
        "min": 0.0110,
      },
      "2010 diabetes percent": {
        "max": 0.1555,
        "min": 0.0110,
      }
    }

    if (ranges[indicator_view]['min'] != undefined)
      return [ranges[indicator_view]['min'], ranges[indicator_view]['max']];
    else
      return [0,0];

  },

  mapStyles: function(color_set) {
    var color_array = MapsLib.blue_array;
    if (color_set != undefined)
      color_array = color_set;

    var indicator_view = MapsLib.indicator_view;
    var ranges = MapsLib.bucketRanges(indicator_view);
    var min = ranges[0];
    var max = ranges[1];
    var num_buckets = 4;
    var range = max - min;
    var interval = range / num_buckets;
    var intervalArray = [ min, (min + interval), (min + interval*2), (min + interval*3) ];

    //console.log(intervalArray);
    MapsLib.createLegend(color_array, intervalArray, max);

    return [
      {
        polygonOptions: {
          fillColor: "#ffffff",
          fillOpacity: 0.6
        }
      }, {
        where: "'" + indicator_view + "' >= " + intervalArray[0] + " AND '" + indicator_view + "' < " + intervalArray[1] + "",
        polygonOptions: {
          fillColor: color_array[0]
        }
      }, {
        where: "'" + indicator_view + "' >= " + intervalArray[1] + " AND '" + indicator_view + "' < " + intervalArray[2] + "",
        polygonOptions: {
          fillColor: color_array[1]
        }
      }, {
        where: "'" + indicator_view + "' >= " + intervalArray[2] + " AND '" + indicator_view + "' < " + intervalArray[3] + "",
        polygonOptions: {
          fillColor: color_array[2]
        }
      }, {
        where: "'" + indicator_view + "' >= " + intervalArray[3] + "",
        polygonOptions: {
          fillColor: color_array[3]
        }
      }];
  },

  createLegend: function(color_array, intervalArray, max) {
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].clear();

    var controlDiv = document.createElement('div');

    // Set CSS styles for the DIV containing the control
    // Setting padding to 5 px will offset the control
    // from the edge of the map.
    controlDiv.style.padding = '5px';

    // Set CSS for the control border.
    var controlUI = document.createElement('div');
    controlUI.style.backgroundColor = 'white';
    controlUI.style.borderStyle = 'solid';
    controlUI.style.borderWidth = '2px';
    controlUI.style.cursor = 'pointer';
    controlDiv.appendChild(controlUI);

    // Set CSS for the control interior.
    var controlText = document.createElement('div');
    controlText.style.paddingLeft = '4px';
    controlText.style.paddingRight = '4px';

    var legendText = "";
    var cnt = 0;
    for (color in color_array) {
      if (intervalArray[cnt + 1] == undefined)
        intervalArray[cnt + 1] = max;

      var range1 = MapsLib.checkAndConvertToPercentage(intervalArray[cnt]);
      var range2 = MapsLib.checkAndConvertToPercentage(intervalArray[cnt + 1]);
      
      legendText += "<li><span class='filter-box' style=\"background-color: " + color_array[color] + "\"'></span> ";
      legendText += range1 + " - " + range2 + "</li>";
      cnt += 1;
    }
    legendText = "<strong>" + MapsLib.indicator_view + "</strong><ul class='unstyled'>" + legendText + "</ul>";

    controlText.innerHTML = legendText;
    controlUI.appendChild(controlText);
    controlDiv.index = 1;
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(controlDiv);
  },
  
  clearSearch: function() {
    if (MapsLib.searchrecords != null)
      MapsLib.searchrecords.setMap(null);
    if (MapsLib.addrMarker != null)
      MapsLib.addrMarker.setMap(null); 
    if (MapsLib.pointsLayer != null)
      MapsLib.pointsLayer.setMap(null);  
  },
  
  findMe: function() {
    // Try W3C Geolocation (Preferred)
    var foundLocation;
    
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        foundLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
        MapsLib.addrFromLatLng(foundLocation);
      }, null);
    }
    else {
      alert("Sorry, we could not find your location.");
    }
  },
  
  addrFromLatLng: function(latLngPoint) {
    geocoder.geocode({'latLng': latLngPoint}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[1]) {
          $('#txtSearchAddress').val(results[1].formatted_address);
          $('.hint').focus();
          MapsLib.doSearch();
        }
      } else {
        alert("Geocoder failed due to: " + status);
      }
    });
  },
  
  query: function(selectColumns, whereClause, callback) {
    var queryStr = [];
    queryStr.push("SELECT " + selectColumns);
    queryStr.push(" FROM " + MapsLib.fusionTableId);
    queryStr.push(" WHERE " + whereClause);
  
    var sql = encodeURIComponent(queryStr.join(" "));
    //console.log("https://www.googleapis.com/fusiontables/v1/query?sql="+sql+"&callback="+callback+"&key="+MapsLib.googleApiKey);
    $.ajax({url: "https://www.googleapis.com/fusiontables/v1/query?sql="+sql+"&callback="+callback+"&key="+MapsLib.googleApiKey, dataType: "jsonp"});
  },

  handleError: function(json) {
    if (json["error"] != undefined)
      console.log("Error in Fusion Table call: " + json["error"]["message"]);
  },
  
  displayCount: function(whereClause) {
    var selectColumns = "Count()";
    MapsLib.query(selectColumns, whereClause,"MapsLib.displaySearchCount");
  },
  
  displaySearchCount: function(json) { 
    MapsLib.handleError(json);
    var numRows = 0;
    if (json["rows"] != null)
      numRows = json["rows"][0];
    
    var name = MapsLib.recordNamePlural;
    if (numRows == 1)
    name = MapsLib.recordName;
    $( "#resultCount" ).fadeOut(function() {
        $( "#resultCount" ).html(MapsLib.addCommas(numRows) + " " + name + " found");
      });
    $( "#resultCount" ).fadeIn();
  },
  
  addCommas: function(nStr) {
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
      x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
  },
  
  //converts a slug or query string in to readable text
  convertToPlainString: function(text) {
    if (text == undefined) return '';
    return decodeURIComponent(text);
  },

  checkAndConvertToPercentage: function(number) {
    if (MapsLib.indicator_view.indexOf('diabetes percent') != -1)
    {
      number = ((+number)*100).toFixed(2);
      number = number + "%"
    }
    else
      number = number.toFixed(2);

    return number;
  }
}