$(document).ready(function(){
  //Index
  $(document).ajaxStart(function() {
    $('#suggestion_list').mask('Loading...');
   });
  $(document).ajaxStop(function() {
     $('#suggestion_list').unmask();
   });

  $('.pagination a').attr('data-remote', 'true')

  $('#distance').attr('disabled', true);

  $('#address').keyup(function() {
    if($(this).val().trim() != '') {
      $('#distance').removeAttr('disabled');
    } else {
      $('#distance').val('0.5')
      $('#distance').attr('disabled', true);
    }
  });

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
  	parent      : 'body',
    openEffect  : 'none',
    closeEffect : 'none',
    type        : 'image'
  });

  $('[data-toggle="tooltip"]').tooltip({
    placement : 'top'
  });

  //New
  if($('.wysihtml5-toolbar').size() == 0) {
    $('#suggestion_comment').wysihtml5({
      toolbar: {
        "font-styles": false, // Font styling, e.g. h1, h2, etc.
        "emphasis":    true,  // Italics, bold, etc.
        "blockquote":  false, // Blockquote
        "lists":       true,  // (Un)ordered lists, e.g. Bullets, Numbers.
        "html":        false, // Button which allows you to edit the generated HTML.
        "link":        true,  // Button to insert a link.
        "image":       false, // Button to insert an image.
        "color":       false, // Button to change color of font

      }
    });
  }

  $('input[id=image1_id], input[id=image2_id]').change(function(event){
    var file = event.target.files[0];
    if (file != undefined) {
      if (!imageValidation(file)){
        // Stops the rest of handlers associated with the input file
        event.stopImmediatePropagation();
      }
    }
  });

  var map_canvas_edit = $("#map-canvas-edit");
  if (map_canvas_edit.length > 0) {
    lat = map_canvas_edit.data('lat');
  	lng = map_canvas_edit.data('lng');
  	initializeMapEdit(lat, lng);
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
