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
}

$(document).ready(ready);
$(document).on('page:load', ready);