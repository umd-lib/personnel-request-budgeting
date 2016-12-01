// enable popovers for descriptors
var togglr = function() { 
    $('[data-toggle="popover"]').popover({ html: true })
}

$(document).ready(togglr);
$(document).on("turbolinks:load", togglr);
