var map;
var marker;
var geocoder;
var infowindow;

function initializeMapShow(lat, lng) {
  var mapOptions = {
    zoom: 17,
    center: new google.maps.LatLng(lat, lng)
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var location = new google.maps.LatLng(lat, lng);
  placeMarker(location);
  infowindow = new google.maps.InfoWindow();
  setAddressInInfowindow(lat, lng);
  google.maps.event.addDomListener(window, 'load', function() {
    infowindow.open(map,marker);
  });
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map,marker);
  });
}

function initializeMapEdit() {
  var mapOptions = {
    zoom: 14
  };
  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

  // Try HTML5 geolocation
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
                                       position.coords.longitude);

      var infowindow = new google.maps.InfoWindow({
        map: map,
        position: pos,
        content: 'You are here.'
      });

      map.setCenter(pos);
    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }
  
  google.maps.event.addListener(map, 'click', function(event) {
    placeMarker(event.latLng);
    document.getElementById("suggestion_latitude").value = event.latLng.lat();
    document.getElementById("suggestion_longitude").value = event.latLng.lng();
    codeLatLng(event.latLng.lat(), event.latLng.lng());
  });
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }

  map.setZoom(6);

  var options = {
    map: map,
    position: new google.maps.LatLng(40.4167754, -3.7037902),
    content: content
  };

  var infowindow = new google.maps.InfoWindow(options);
  map.setCenter(options.position);
}


function placeMarker(location) {
  if (marker) {
    marker.setPosition(location);
  }
  else {
    marker = new google.maps.Marker({
      position: location,
      map: map
    });
  }
}

function clearMarker() {
	if(marker) {
	  marker.setMap(null);
	  marker = undefined;
	  document.getElementById("suggestion_latitude").value = "";
      document.getElementById("suggestion_longitude").value = "";
      document.getElementById("address").value = "";
    }
}

function searchByAddress() {
  var address = document.getElementById('address').value;
  if(address.trim()){
  if(!geocoder){
  	geocoder = new google.maps.Geocoder();
  }
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      placeMarker(results[0].geometry.location);
      document.getElementById("suggestion_latitude").value = results[0].geometry.location.lat();
      document.getElementById("suggestion_longitude").value = results[0].geometry.location.lng();
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
  }
}

function codeLatLng(lat, lng) {
  var latlng = new google.maps.LatLng(lat, lng);
  if(!geocoder){
  	geocoder = new google.maps.Geocoder();
  }
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[0]) {
        document.getElementById('address').value = results[0].formatted_address;
      } else {
        alert('No results found');
      }
    } else {
      document.getElementById('address').value = "";
    }
  });
}

function setAddressInInfowindow(lat, lng) {
  var latlng = new google.maps.LatLng(lat, lng);
  if(!geocoder){
  	geocoder = new google.maps.Geocoder();
  }
  var address;
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results[0]) {
        address = results[0].formatted_address;
      } else {
        address = 'No results found';
      }
      infowindow.setContent(address);
    }
  });
}

