!function($) {
    "use strict";

    var GoogleMap = function() {};


    //creates map with markers
    GoogleMap.prototype.createMarkers = function($container) {
        var map = new GMaps({
          div: $container,
          lat: 39.9443851,
          lng: 32.8600473
        });

        //sample markers, but you can pass actual marker data as function parameter
        map.addMarker({
          lat: 39.9443851,
          lng: 32.8600473,
          title: 'Lima',
          details: {
            database_id: 42,
            author: 'HPNeo'
          },
          click: function(e){
            if(console.log)
              console.log(e);
            alert('You clicked in this marker');
          }
        });
        map.addMarker({
          lat: 39.9417671,
          lng: 32.8630833,
          title: 'Marker with InfoWindow',
          infoWindow: {
            content: '<p>HTML Content</p>'
          }
        });

        return map;
    },

   
    //init
    GoogleMap.prototype.init = function() {
      var $this = this;
      $(document).ready(function(){
        //with sample markers
        $this.createMarkers('#gmaps-markers');

      });
    },
    //init
    $.GoogleMap = new GoogleMap, $.GoogleMap.Constructor = GoogleMap
}(window.jQuery),

//initializing 
function($) {
    "use strict";
    $.GoogleMap.init()
}(window.jQuery);