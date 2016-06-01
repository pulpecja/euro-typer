$(document).ready(function(){
  $('a.editable').each(function() {
    var inlineHttpMethod = ($(this).data('httpmethod')) ? $(this).data('httpmethod') : 'PUT';
    $(this).editable({
      ajaxOptions: {
        type: inlineHttpMethod,
        dataType: 'json'
      },
      error: function(response, newValue) {
        var response = JSON.parse(response.responseText);
        for(key in response) {
          return response[key]
        }
      }
    });
  });
});