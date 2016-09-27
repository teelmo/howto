# KML to GeoJSON to TopoJSON on Mac OS X

These introductions help you to convert a KML file to TopoJSON which allows you to reduce filesize.

# Converting KML to TopoJSON

**Get KML (File -> Download -> KML)**

https://www.google.com/fusiontables/DataSource?docid=153JjwSASwB6C4r1o0itwZr7imkDfuedEGIjk4LHr#map:id=3

**Install node via ports or brew (if not yet available)**

`port install npm`
`brew install node.js`

**Install togeojson (might need admin privilidges)**

`npm install -g togeojson`

**Rename file to data.kml**

~~~~
cd Downloads
mv Kuntarajat\ 2015.kml data.kml
~~~~

**Convert KML to GeoJson with togeojson**

`togeojson data.kml > data.json`

**Install topojson (might need admin privilidges)**

`npm install -g topojson`

**Convert GeoJson to TopoJson**

`topojson data.json -o data.tjson -p Name`

**Simplify if needed**

`topojson data.json -o data.tjson --simplify-proportion=0.5 -p Name`

**Use tools to determinate appropriate simplify value**

http://www.mapshaper.org/
http://shancarter.github.io/distillery/


# Implementation guidelines

**Get TopoJSON library**

https://github.com/mbostock/topojson

**In your implementation define a map**

~~~~
var map = new google.maps.Map($('.map_container')[0], {
    center:new google.maps.LatLng(60.25, 24.87),
    mapTypeControl:false,
    mapTypeId:google.maps.MapTypeId.ROADMAP,
    minZoom:9,
    overviewMapControl:true,
    panControl:true,
    scaleControl:false,
    streetViewControl:false,
    zoom:yleApp.zoom,
    styles:styler,
    zoomControl:true
});
~~~~

**Attach polygons to the map**

~~~~
$.getJSON('data.tjson', function (data) {
    yleApp.map.data.addGeoJson(topojson.feature(data, data.objects.data)); 
});
~~~~

**Define polygon styles**

~~~~
yleApp.map.data.setStyle(function (feature) {
  return {
    cursor:'pointer',
    fillColor:'#f00',
    fillOpacity:0.6,
    strokeColor:'#666',
    strokeWeight:0.5
  }
});
~~~~

**Attach listeners**

~~~~
map.data.addListener('mouseover', function (event) {
  yleApp.map.data.overrideStyle(event.feature, {
    fillOpacity:0.8,
    strokeWeight:1
  });
});
map.data.addListener('mouseout', function (event) {
  map.data.revertStyle();
});
~~~~