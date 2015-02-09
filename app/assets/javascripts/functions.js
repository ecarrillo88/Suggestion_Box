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