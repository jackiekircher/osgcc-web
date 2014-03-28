var handlers = {

  // add a confirmation dialogue that must be answered
  // affirmatively to allow the action to take place
  warn: function handlersWarn(event) {
          if(!confirm('Are you sure? This action cannot be undone')) {
            event.preventDefault();
          }
        },

  // submit an ajax request rather than an HTTP request to
  // the button's form's action.
  ajaxSubmit: function handlersAjaxSubmit(event) {
                event.preventDefault();
                var form = $(this).parent();

                $.ajax({
                  url:      form.attr('action'),
                  type:     'post',
                  dataType: 'html',
                  success:
                    // this function should be customizable
                    function(data) {
                      form.closest("ul").html(data);
                      loaders.warnIrreversible();
                    }
                });
              }
};

var loaders = {

  // run all loading functions
  loadAll:
    function loadAll() {
      this.warnIrreversible();
      this.ajaxSubmit();
    },

  // add warn event handler to all irreversible actions
  warnIrreversible: 
    function loadWarnIrreversible() {
      $('.irreversible').click(handlers.warn);
    },

  // bind the ajaxSubmit handler to all ajax form buttons
  ajaxSubmit:
    function loadAjaxSubmit() {
      $('.ajax-submit').click(handlers.ajaxSubmit);
    }

};

$(document).ready(function() {
  loaders.loadAll();
});
