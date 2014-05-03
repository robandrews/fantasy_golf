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
  
  $("#free-agent-add-button").click(function(event){
    var name = $("#free-agent-select-list").find(":selected").text()
    if(name != "Choose a free agent"){
      $(".player-name").html(name)
      $('.confirm-add-free-agent').modal();
    }
  });
  
 
  
  $("#free-agent-select-list").select2();
  
  $("#free-agent-confirmed").click(function(event){
    $("#free-agent-form").submit();
  })
  
  $("#player-drop-confirmed").click(function(event){
    $(".drop-player-form").submit();
  })
      
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
  
};

$(document).ready(ready);
$(document).on('page:load', ready);


