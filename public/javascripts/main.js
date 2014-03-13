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
  (function warnIrreversible() {
    $('.irreversible').click(handlers.warn);
  })();

});
