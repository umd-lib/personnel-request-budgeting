$(document).on("turbolinks:load", function(){ 


  

  $("#select-all").change( function(){
    $(".select-record > input").click(); 
  })

  $("#change-review-status a").click( function(){
      $checkboxes = $(".select-record input:checked"); 
      if ( $checkboxes.length < 1 ) { alert("Please select records for udating using the checkboxes in the first column"); return }

      $this = $(this);
      recordType = $this.data("record-type");
      reviewStatus = $this.data('review-status');

      $(".table.table-striped").spin({ scale: 4  });
      updateReviewStatus = function( id ) {
        var url = "/" + recordType + "s/" + id;
        var data =  {};
        data[recordType] = {};
        data[recordType] = {  review_status_id:  reviewStatus}; 
        $.ajax({ url: url, type: "PUT", dataType: 'json', data: data })
          .fail( function() { alert("Sorry but there was an issue with Record  " + id); });
      }


      $(".select-record input:checked").each( function() { 
          updateReviewStatus( $(this).val() );
      });


  });

});
