// enable popovers for descriptors
var togglr = function() { 
    $('[data-toggle="popover"]').popover()
}

$(document).ready(togglr);
$(document).on("turbolinks:load", togglr);
