var LeafletLib = LeafletLib || {};
var LeafletLib = {

    latmin: 90,
    latmax: -90,
    lngmin: 180,
    lngmax: -180,
    markers: [ ],

    initialize: function(element, features, centroid, padding) {

        LeafletLib.map = L.map(element, {scrollWheelZoom:false}).setView(new L.LatLng( centroid[0], centroid[1] ), 13);

        LeafletLib.tiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/smartchicagocollaborative.heooddo8/{z}/{x}/{y}.png', {
            attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
        }).addTo(LeafletLib.map);

        LeafletLib.map.attributionControl.setPrefix('');
        L.Icon.Default.imagePath = "/assets/images/";

        if(typeof features.markers != "undefined"){
          for(var m=0;m<features.markers.length;m++){
            var pt = features.markers[m].getLatLng();
            features.markers[m].addTo( LeafletLib.map );
            LeafletLib.addBoundedPoint( pt );
          }
        }
        if(typeof features.geojson != "undefined"){
          LeafletLib.geojson = L.geoJson(features.geojson, {
              style: LeafletLib.style
          }).addTo(LeafletLib.map);

          LeafletLib.addBoundedBox( LeafletLib.geojson.getBounds() );
        }

        LeafletLib.fitFeatures(padding);

    },

    style: function(feature) {
        return {
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.7,
            fillColor: '#FD8D3C',
            clickable: false
        };
    },

    addMarker: function( marker ){
        LeafletLib.map.addLayer(marker);
        LeafletLib.addBoundedPoint( marker.getLatLng() );
        LeafletLib.markers.push( marker );
    },

    clearMarkers: function(){
      for(var m=0;m<LeafletLib.markers.length;m++){
        LeafletLib.map.removeLayer( LeafletLib.markers[m] );
      }
      LeafletLib.markers = [ ];
    },

    fitFeatures: function(padding){
        if(LeafletLib.latmax > LeafletLib.latmin){
          var bounds = new L.LatLngBounds(
                      new L.LatLng( LeafletLib.latmin, LeafletLib.lngmin ),
                      new L.LatLng( LeafletLib.latmax, LeafletLib.lngmax ));

          LeafletLib.map.fitBounds( bounds.pad(padding) );
        }
    },

    addBoundedPoint: function( latlng ){
        LeafletLib.latmin = Math.min( LeafletLib.latmin, latlng.lat );
        LeafletLib.latmax = Math.max( LeafletLib.latmax, latlng.lat );
        LeafletLib.lngmin = Math.min( LeafletLib.lngmin, latlng.lng );
        LeafletLib.lngmax = Math.max( LeafletLib.lngmax, latlng.lng );
    },

    addBoundedBox: function( bounds ){
        LeafletLib.latmin = Math.min( LeafletLib.latmin, bounds.getSouthWest().lat );
        LeafletLib.latmax = Math.max( LeafletLib.latmax, bounds.getNorthEast().lat );
        LeafletLib.lngmin = Math.min( LeafletLib.lngmin, bounds.getSouthWest().lng );
        LeafletLib.lngmax = Math.max( LeafletLib.lngmax, bounds.getNorthEast().lng );
    }
}
