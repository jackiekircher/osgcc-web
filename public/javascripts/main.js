$(document).ready(function() {

  // ensure that there is a confirmation dialgoue when activating
  // irreversible actions
  (function warnIrreversible() {
    $('.irreversible').click(function(event) {
      if(!confirm('Are you sure? This action cannot be undone')) {
        event.preventDefault();
      }
    });
  })();

});
