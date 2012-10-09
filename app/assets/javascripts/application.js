// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function() {
  // Handler for .ready() called.
  $(".gift_bttn").click(function(){
 		 id = $(this).attr("id");
 		 text = $(this).text("Loading...");
		$.post('/ajax',{ product_id: id, send: "gift" }, function(data) {
  			//$('.result').html(data);
  			$(this).text("Gift a Jewel");
		});
		 
	});
	
	$(".tag_bttn").click(function(){
 		 id = $(this).attr("id");
 		 text = $(this).text("Wait..");
		// alert(id);
		$.post('/ajax',{ product_id: id, send: "tag" }, function(data) {
  			//$('.result').html(data);
  			$(this).text("Tag");
		});
	});
	
	$(".ajax_overlay").click(function(){
		$("#ajax1").hide();
		$(".ajax_overlay").hide();
	})
});



    $('img').load(function() {
        $('.image_hide').show();
    });
