$(document).ready(function(){
  //Show
  var map_canvas_show = $("#map-canvas-show");
  if (map_canvas_show.length > 0) {
  	lat = map_canvas_show.data('lat');
  	lng = map_canvas_show.data('lng');
  	initializeMapShow(lat, lng);
  }
  	  
  $("#increase_text_size").click(function(event){
  	event.preventDefault();
    fontSizer("#SuggestionComent", "up");
  });
  
  $("#decrease_text_size").click(function(event){
  	event.preventDefault();
    fontSizer("#SuggestionComent", "down");
  });
  
  $(".fancybox").fancybox({
    openEffect  : 'none',
    closeEffect : 'none',
    type        : 'image'
  });
  
  //New
  $('input[id=image1_id], input[id=image2_id]').change(function(event){
    var file = event.target.files[0];
    if (file != undefined) {
      if (!imageValidation(file)){
        // Stops the rest of handlers associated with the input file
        event.stopImmediatePropagation();
      }
    }
  });
  
  if ($("#map-canvas-edit").length > 0) {
  	initializeMapEdit();
  }
  
  $("#clear-marker").click(function(){
  	clearMarker();
  });
  
  $("#search-address").click(function(){
  	searchByAddress();
  });
  
  $("#address").keypress(function(event){
  	if (event.keyCode == 13) {
      event.preventDefault();
      searchByAddress();
  	}
  });
});


function fontSizer(element, action) {
  $(element).find('p').each(function(){
    var increment = 1;
    var pattern = /px$/;
    var fontSize = $(this).css('font-size');
    if (action == "up") {
      newFontSize = parseInt(fontSize.replace(pattern, '')) + increment;
    }
    else {
      newFontSize = parseInt(fontSize.replace(pattern, '')) - increment;
    }
    $(this).css('font-size',newFontSize+'px');
  });
}

function imageValidation(file) {
  var type = file.name.split('.').pop().toLowerCase();
  if ($.inArray(type, ['gif','png','jpg','jpeg']) == -1) {
    alert('Invalid file type.\nPlease select an image.');
    return false;
  }	
  var sizeKB = file.size / 1024;
  if (sizeKB > 5120) {
    alert('The maximum image size is 5 MB.\nPlease select a smaller image.');
    return false;
  }
  return true;
}

