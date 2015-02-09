function fontSizer(element, action) {
  $(element).find('p').each(function(){
    var increment = 1;
    var pattern = /px$/;
    var fontSize = $(this).css('font-size');
    if (action == "up"){
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
  if (sizeKB > 5120){
    alert('The maximum image size is 5 MB.\nPlease select a smaller image.');
    return false;
  }
  return true;
}
