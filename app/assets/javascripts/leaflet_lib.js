var LeafletLib = LeafletLib || {};
var LeafletLib = {

    initialize: function(element, geojsonFeature, centroid, zoom) {

        LeafletLib.map = L.map(element).setView(centroid, zoom);

        LeafletLib.tiles = L.tileLayer('http://{s}.tile.cloudmade.com/{key}/{styleId}/256/{z}/{x}/{y}.png', {
            key: 'BC9A493B41014CAABB98F0471D759707',
            styleId: 22677
        }).addTo(LeafletLib.map);

        LeafletLib.geojson = L.geoJson(geojsonFeature, {
            style: LeafletLib.style
        }).addTo(LeafletLib.map);

        LeafletLib.map.fitBounds(LeafletLib.geojson.getBounds());
    },

    style: function(feature) {
        return {
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.7,
            fillColor: '#FD8D3C'
        };
    }
}