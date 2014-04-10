var ResourcesLib = ResourcesLib || {};
var ResourcesLib = {

  resources_list: [],

  init: function(geography_geometry, geography_centroid, url_fragment, community_area) {
    var geojsonFeature = {
        "type": "Feature",
        "geometry": geography_geometry
    };

    LeafletLib.initialize("map_resources", { geojson: geojsonFeature }, geography_centroid, 13);

    var resources_url = ''
    if (community_area) {
      resources_url = "/resources" + url_fragment + "/" + community_area + ".json";
    }
    else {
      var bounds = [LeafletLib.latmax, LeafletLib.lngmax, LeafletLib.latmin, LeafletLib.lngmin];
      bounds[0] = (bounds[0] + "").replace(".",",");
      bounds[1] = (bounds[1] + "").replace(".",",");
      bounds[2] = (bounds[2] + "").replace(".",",");
      bounds[3] = (bounds[3] + "").replace(".",",");

      resources_url = "/resources" + url_fragment + "/" + bounds.join("/") + ".json";
    }

    $.getJSON(resources_url, function(resources){
      
      ResourcesLib.resources_list = resources;

      // populate list of categories
      for (var i=0;i<ResourcesLib.resources_list.length;i++) {
        $("#categories").append("\
          <li><a href='#' data-category='" + ResourcesLib.resources_list[i]['category'] + "'>\
          " + ResourcesLib.humanize(ResourcesLib.resources_list[i]['category']) + "\
          <span class='badge pull-right'>" + ResourcesLib.resources_list[i]['resources'].length + "</span>\
          </a>\
          </li>");
      }

      // bind clickable event for categories
      $("#categories a").click(function(){
        ResourcesLib.render_category($(this).attr('data-category'));
        return false;
      });

      if ($.address.parameter('category') != null)
        ResourcesLib.render_category($.address.parameter('category'));
      else
        ResourcesLib.render_category('all'); // by default, show all
    });
  },

  render_category: function(category){
    // clean up and highlight selected
    ResourcesLib.reset_view();

    $("#category_title").html(ResourcesLib.humanize(category));
    $("#categories li").attr("class", "");
    $("[data-category='" + category + "']").parent().attr("class", "active");
    $.address.parameter('category', category);

    var table_template = "\
        {{#site_url}}\
          <h4><a target='_blank' href='{{site_url}}'>{{organization_name}}</a></h4>\
        {{/site_url}}\
        {{^site_url}}\
          <h4>{{organization_name}}</h4>\
        {{/site_url}}\
        {{program_name}}\
        {{#address}}\
          <br /><i class='icon-map-marker'></i> {{address}}\
        {{/address}}\
        {{#phone}}\
          <br /><i class='icon-phone'></i> {{phone}}\
        {{/phone}}\
        {{#hours}}\
          <br /><i class='icon-time'></i> {{hours}}\
        {{/hours}}\
        <hr />\
      ";

    var resources = [];
    for (var i=0;i<ResourcesLib.resources_list.length;i++)
      if (ResourcesLib.resources_list[i]['category'] == category)
        resources = ResourcesLib.resources_list[i]['resources'];

    for (var i=0;i<resources.length;i++) {
      // remove N/A data from phone field
      if (resources[i]['phone'].indexOf("N/A") >= 0 ) resources[i]['phone'] = '';

      // link to Program page if available

      resources[i]['site_url'] = '';
      if (resources[i]['program_url'] != '' && resources[i]['program_url'] != 'http://') resources[i]['site_url'] = resources[i]['program_url'];

      // truncate hours field
      var hours_len = resources[i]['hours'].length;
      if (hours_len > 50) hours_len = 50;
      resources[i]['hours'] = resources[i]['hours'].slice(0, hours_len);

      // populate table and map
      $("#list_resources").append(Mustache.render(table_template, resources[i]));

      LeafletLib.addMarker(
        (new L.Marker(
          new L.LatLng( resources[i]['latitude'], resources[i]['longitude'] )
        )).bindPopup(Mustache.render(table_template, resources[i]))
      );
    }
  },

  reset_view: function() {
    LeafletLib.clearMarkers(); 
    $("#list_resources").html("");
  },

  humanize: function(property) {
    return property.replace(/_/g, ' ').replace(/(\w+)/g, function(match) {
      return match.charAt(0).toUpperCase() + match.slice(1);
    });
  }
}