var handlers = {

  // add a confirmation dialogue that must be answered
  // affirmatively to allow the action to take place
  warn: function handlersWarn(event) {
          if(!confirm('Are you sure? This action cannot be undone')) {
            event.preventDefault();
          }
        }
};

$(document).ready(function() {

  // add warn event handler to all irreversible actions
  function warnIrreversible() {
    $('.irreversible').click(handlers.warn);
  }
  warnIrreversible();

  $('.ajax-submit').click(function(event) {
    event.preventDefault();
    var form = $(this).parent();

    $.ajax({
      url: form.attr('action'),
      type: 'post',
      dataType: 'html',
      success: function(data) {
        form.closest("ul").html(data);
        warnIrreversible();
      }
    });
  });
});
