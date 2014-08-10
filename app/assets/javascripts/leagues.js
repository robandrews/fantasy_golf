var ready = function(){
  $(".delete-roster-membership").click(function(event){
    event.preventDefault();
    $(event.currentTarget).prop('disabled', true);
    $.ajax({
      url:"/roster_membership/admin_delete",
      type:"POST",
      data: {player_id: $(event.currentTarget).attr("data-id"),
            league_membership_id: $(".lm-selector").find(":selected").attr("data-id")},
      success:function(resp){
        $(event.currentTarget).parent().hide();
      },
      failure:function(resp){
        alert("Unable to drop player");
      }
    });
  });
  
  $("#admin-player-add-button").click(function(event){
    event.preventDefault();
    var name = $("#free-agent-select-list").find(":selected").text();
    var player_id = $("#free-agent-select-list").find(":selected").val();
    if(name != "Choose a free agent"){
      $.ajax({
        url:"/roster_memberships",
        type:"POST",
        data:{roster_membership: {player_id: player_id, 
              league_membership_id: $(".lm-selector").find(":selected").attr("data-id")}},
        success: function(resp){
          location.reload();
        },
        failure: function(resp){
          alert("Unable to add player!")
        }
      })
    }
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);