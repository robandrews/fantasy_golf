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
      url: document.domain + '/players.json',
      // the json file contains an array of strings, but the Bloodhound
      // suggestion engine expects JavaScript objects so this converts all of
      // those strings
      filter: function(list) {
        return $.map(list, function(player) { return { name: (player["first_name"] + " " + player["last_name"]),
                                                       id: player["id"],
                                                        picture_url: player["picture_url"]}; });
      }
    }
  });
 
  // kicks off the loading/processing of `local` and `prefetch`
  players.initialize();
 
  // passing in `null` for the `options` arguments will result in the default
  // options being used
  $('#prefetch .typeahead').typeahead(null, {
    name: 'players',
    displayKey: 'name',
    // `ttAdapter` wraps the suggestion engine in an adapter that
    // is compatible with the typeahead jQuery plugin
    source: players.ttAdapter()
  });
  
  
};

$(document).ready(ready);
$(document).on('page:load', ready);
