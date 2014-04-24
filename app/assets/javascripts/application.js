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


//Using documetn on page load to coerce turbolinks into loading our javascript



var ready = function() {
  $( ".column" ).sortable({
    connectWith: ".column",
    handle: ".portlet-header",
    placeholder: "portlet-placeholder ui-corner-all"
  });

  $( ".portlet" )
  .addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
  .find( ".portlet-header" )
  .addClass( "ui-widget-header ui-corner-all" );
  
  
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': AUTH_TOKEN
    }
  });
  
  $("#submit-roster").click(function(event){
    var return_hash = {roster_changes: {}}
    
    var makeData = function(){
      $("div.active").find(".portlet").each(function(){
        return_hash["roster_changes"][$(this).data("id")] = true
      });
      
      $("div.bench").find(".portlet").each(function(){
        return_hash["roster_changes"][$(this).data("id")] = false
      });
    }
    
    makeData();
    
    $.ajax({
      url: document.URL.slice(0, -5),
      type: "PUT",
      data: return_hash,
      success:function(){
        location.reload();
      },
      error:function(){
         location.reload();
      }
    })
    
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);

