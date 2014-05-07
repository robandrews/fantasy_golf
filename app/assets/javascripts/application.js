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
//= require jquery.ui.all
//= require jquery.autosize.min
//= require bootstrap
//= require wysihtml5.js
//= require turbolinks
//= require select2
//= require_tree .


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
  
  // submits the ajax request to update active roster
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
  
  // Launches modal to confirm free agent petition
  $("#free-agent-add-button").click(function(event){
    var name = $("#free-agent-select-list").find(":selected").text()
    if(name != "Choose a free agent"){
      $(".player-name").html(name)
      $('.confirm-add-free-agent').modal();
    }
  });
  // submits free agent request
  $("#free-agent-confirmed").click(function(event){
    $("#free-agent-form").submit();
  })
  
  // contest free agent on the free agent index page
  $(".contest-free-agent").click(function(event){
    $.ajax({
      url: document.URL + "/" + $(event.target).data("id"),
      type: "PUT",
      success:function(){
        location.reload();
      },
      error:function(){
        location.reload();
      }
    })
  });
  
  // using the select2 plugin for searching/autocomplete in the free agent select dropdown
  $("#free-agent-select-list").select2();
  
  // Launches modal to confirm a player drop
  $(".drop-player-button").click(function(event){
    var name = $(event.target).parent().find("a").first().text();
    var id = $(event.target).parent().parent().parent().data("id");
    $(".drop-player-form").attr("action", "/roster_memberships/" + id);
    $(".player-name").html(name);
    $('.drop-player').modal();
  });
  // submits for to drop player after confirmed in the modal
  $("#player-drop-confirmed").click(function(event){
    $(".drop-player-form").submit();
  })

   // These show and hide elements on the edit pages to allow for a richer user experience when updating their roster
  $( ".show-free-agent" ).click(function() {
    $( ".roster" ).addClass( "hidden");
    $( ".trade" ).addClass( "hidden");
    $( ".free-agent" ).removeClass( "hidden");
    return false;
  });
  
  $( ".show-trade" ).click(function() {
    $( ".roster" ).addClass( "hidden");
    $( ".free-agent" ).addClass( "hidden");
    $( ".trade" ).removeClass( "hidden");
  });
  
  $( ".show-roster" ).click(function() {
    $( ".free-agent" ).addClass( "hidden");
    $( ".trade" ).addClass( "hidden");
    $( ".roster" ).removeClass( "hidden");
    return false;
  });
  
  // This will hit the server for a given league members player and update the trade list accordingly.
  $(".tradee-selector").on("change", function(){
    $.ajax({
      url: document.URL.slice(0,-5) + "/players",
      type: "GET",
      dataType:"html",
      data: {tradee: $(".tradee-selector").find(":selected").data("id")},
      success:function(resp){
        $(".tradee-list").html(resp);
        $(".selectable-resp").click(function(event){
          $(event.target).toggleClass("selected");
        });
      }
    });
  });
  
  // highlight divs for trading
  $(".selectable").click(function(event){
    $(event.target).toggleClass("selected");
  });
  
  // ajax request to submit trade
  $(".submit-trade").click(function(){
    $.ajax({
      url:document.URL.slice(0,-25) + "trades",
      type:"POST",
      data:{trader: $.map($(".trader-list").find(".selected"), function(el){return $(el).data("id")}),
            tradee: $.map($(".tradee-list").find(".selected"), function(el){return $(el).data("id")}),
            tradee_id: $(".tradee-selector").find(":selected").data("id")
            },
      success:function(resp){
        location.reload();
      }
    });
  });
  
  // using autosize plugin to handle textarea resizing
  $("textarea").autosize();
  
  
  // Expose buttons for trades
  $(".tradeable").hover(
    function(){
    $(this).parent().parent().find("button").fadeIn().removeClass("hidden");
    return false;
  }, 
    function(){
      $(this).parent().parent().find("button").fadeOut().addClass("hidden", 500);
      return false;
    }
  );
  
  
};



$(document).ready(ready);
$(document).on('page:load', ready);