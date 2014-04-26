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
  
  $(".drop-player-button").click(function(event){
    var name = $(event.target).parent().find("a").first().text();
    var id = $(event.target).parent().parent().parent().data("id");
    $(".drop-player-form").attr("action", "/roster_memberships/" + id);
    $(".player-name").html(name);
    $('.drop-player').modal();
  });
  
  $("#free-agent-select-list").select2();
  
  $("#free-agent-confirmed").click(function(event){
    $("#free-agent-form").submit();
  })
  
  $("#player-drop-confirmed").click(function(event){
    $(".drop-player-form").submit();
  })
      
      
};

$(document).ready();

$(document).ready(ready);
$(document).on('page:load', ready);


