var ResourcesLib = ResourcesLib || {};
var ResourcesLib = {

  init: function(geography_geometry, geography_centroid, url_fragment) {
    var geojsonFeature = {
        "type": "Feature",
        "geometry": geography_geometry
    };

    LeafletLib.initialize("map_resources", { geojson: geojsonFeature }, geography_centroid, 13);

    var bounds = [LeafletLib.latmax, LeafletLib.lngmax, LeafletLib.latmin, LeafletLib.lngmin];
    bounds[0] = (bounds[0] + "").replace(".",",");
    bounds[1] = (bounds[1] + "").replace(".",",");
    bounds[2] = (bounds[2] + "").replace(".",",");
    bounds[3] = (bounds[3] + "").replace(".",",");

    var category_list = [];

    $.getJSON("/resources" + url_fragment + "/" + bounds.join("/") + ".json", function(resources){
      
      for(var i=0;i<resources.length;i++){
        var categories = eval(resources[i]['categories'])
        for (var j=0;j<categories.length;j++){
          if (category_list.indexOf(categories[j]) == -1) {
            category_list.push(categories[j]);
          }
        }

        // clean up source data
        if (resources[i]['phone'].indexOf("N/A") >= 0 ) resources[i]['phone'] = '';

        // populate table and map
        var table_template = "\
          <tr>\
            <td><strong>{{organization_name}}</strong><br />{{program_name}}</td>\
            <td>{{address}}</td>\
            <td>{{phone}}</td>\
          </tr>\
          ";
        $("#intervention_list").append(Mustache.render(table_template, resources[i]));

        var map_template = "\
          <b>{{organization_name}}</b>\
          <br />{{program_name}}<br/>\
          {{address}}<br/>\
          {{phone}}\
          ";

        LeafletLib.addMarker(
          (new L.Marker(
            new L.LatLng( resources[i]['latitude'], resources[i]['longitude'] )
          )).bindPopup(Mustache.render(map_template, resources[i]))
        );
      }

      // populate list of categories
      category_list = category_list.sort();
      for (var j=0;j<category_list.length;j++) {
        $("#categories").append("<li><a href='#'>" + ResourcesLib.humanize(category_list[j]) + "</a></li>");
      }
    });
    LeafletLib.filterMarkers({ geojson: geojsonFeature });
  },

  humanize: function(property) {
    return property.replace(/_/g, ' ').replace(/(\w+)/g, function(match) {
      return match.charAt(0).toUpperCase() + match.slice(1);
    });
  }
}