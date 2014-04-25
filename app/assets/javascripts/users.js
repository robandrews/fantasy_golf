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
  
  
  var players = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    prefetch: {
      url: "http://localhost:3000/players.json",
      filter: function(list) {
        return $.map(list, function(player) { return { name: (player["first_name"] + " " + player["last_name"]),
                                                       id: player["id"],
                                                        picture_url: player["picture_url"]}; });
      }
    }
  });
   
  players.initialize();

  $('#prefetch .typeahead').typeahead(null, {
    name: 'players',
    displayKey: 'name',
    source: players.ttAdapter(),
    templates: {
        empty: [
          '<div class="empty-message">',
          'Unable to find any players that match the current query',
          '</div>'
        ].join('\n'),
        suggestion: name.id 
      }
  })
  
  $("#free-agent-add-button").click(function(event){
    var name = $("#free-agent-select-list").find(":selected").text()
    $("#player-name").html(name)
    $('.confirm-add-free-agent').modal({
      keyboard: false
    });
  });
  
  $("#free-agent-select-list").select2();
};

$(document).ready();

$(document).ready(ready);
$(document).on('page:load', ready);