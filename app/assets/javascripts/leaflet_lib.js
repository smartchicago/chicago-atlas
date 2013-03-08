var LeafletLib = LeafletLib || {};
var LeafletLib = {

    initialize: function(geojsonFeature, centroid, zoom) {

        LeafletLib.map = L.map('map').setView(centroid, zoom);

        LeafletLib.tiles = L.tileLayer('http://{s}.tile.cloudmade.com/{key}/{styleId}/256/{z}/{x}/{y}.png', {
            attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
            key: 'BC9A493B41014CAABB98F0471D759707',
            styleId: 22677
        }).addTo(LeafletLib.map);

        // control that shows info on hover
        LeafletLib.info = L.control();

        LeafletLib.info.onAdd = function (map) {
            this._div = L.DomUtil.create('div', 'info');
            this.update();
            return this._div;
        };

        LeafletLib.info.update = function (props) {
            this._div.innerHTML = '<h4>Community area</h4>' +  (props ?
                '<b>' + props.name + '</b>'
                : 'Hover over a community area');
        };

        LeafletLib.info.addTo(LeafletLib.map);

        LeafletLib.geojson = L.geoJson(geojsonFeature, {
            style: LeafletLib.style,
            onEachFeature: LeafletLib.onEachFeature
        }).addTo(LeafletLib.map);

        LeafletLib.legend = L.control({position: 'bottomright'});

        LeafletLib.legend.onAdd = function (map) {

            var div = L.DomUtil.create('div', 'info legend'),
                grades = [0, 10, 20, 50, 100, 200, 500, 1000],
                labels = [],
                from, to;

            for (var i = 0; i < grades.length; i++) {
                from = grades[i];
                to = grades[i + 1];

                labels.push(
                    '<i style="background:' + LeafletLib.getColor(from + 1) + '"></i> ' +
                    from + (to ? '&ndash;' + to : '+'));
            }

            div.innerHTML = labels.join('<br>');
            return div;
        };

        LeafletLib.legend.addTo(LeafletLib.map);
    },

    // get color depending on population density value
    getColor: function(d) {
        return d > 1000 ? '#800026' :
               d > 500  ? '#BD0026' :
               d > 200  ? '#E31A1C' :
               d > 100  ? '#FC4E2A' :
               d > 50   ? '#FD8D3C' :
               d > 20   ? '#FEB24C' :
               d > 10   ? '#FED976' :
                          '#FFEDA0';
    },

    style: function(feature) {
        return {
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.7,
            fillColor: LeafletLib.getColor(feature.properties.density)
        };
    },

    highlightFeature: function(e) {
        var layer = e.target;

        layer.setStyle({
            weight: 5,
            color: '#666',
            dashArray: '',
            fillOpacity: 0.7
        });

        if (!L.Browser.ie && !L.Browser.opera) {
            layer.bringToFront();
        }

        LeafletLib.info.update(layer.feature.properties);
    },

    resetHighlight: function(e) {
        LeafletLib.geojson.resetStyle(e.target);
        LeafletLib.info.update();
    },

    onEachFeature: function(feature, layer) {
        layer.on({
            mouseover: LeafletLib.highlightFeature,
            mouseout: LeafletLib.resetHighlight
        });
    }
}