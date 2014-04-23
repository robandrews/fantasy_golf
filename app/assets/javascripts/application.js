// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(function() {
  $( ".column" ).sortable({
    connectWith: ".column",
    handle: ".portlet-header",
    placeholder: "portlet-placeholder ui-corner-all"
  });

  $( ".portlet" )
  .addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
  .find( ".portlet-header" )
  .addClass( "ui-widget-header ui-corner-all" );
  
  $("#submit-roster").click(function(event){
    console.log("here")
    
    $.ajax({
      url: document.URL.substring(0, document.URL.length-5),
      type: "PUT",
      
    })
  })
});

