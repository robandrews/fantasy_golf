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
//= require jquery.autosize.min
//= require bootstrap
//= require advanced
//= require wysihtml5.js
//= require chart.js
//= require turbolinks
//= require select2
//= require_tree .


var ready = function() {
  
  // START -- trades index -- //
  
  // Expose buttons for trades
  $(".tradeable").hover(
    function(){
    $(this).parent().parent().find("button").removeClass("hidden");
    return false;
  }, 
    function(){
      $(this).parent().parent().find("button").addClass("hidden");
      return false;
    });
  
  $(".trade-button").click(function(event){
    var accepted = $(event.target).text() == "Accept" ? true : false;
    $.ajax({
      url:document.URL + "/" + $(event.target).data("id"),
      type:"PUT",
      data:{accepted: accepted, pending: false},
      success:function(resp){
        location.reload();
      },
      error:function(resp){
        location.reload();
      }
    });
  })
  
  $(".trade-button-delete").click(function(event){
    $.ajax({
      url:document.URL + "/" + $(event.target).data("id"),
      type:"DELETE",
      success:function(resp){
        location.reload();
      },
      error:function(resp){
        location.reload();
      }
    });
  })
  
  $(".show-past-trades").click(function(event){
    $.ajax({
      url:document.URL + "?pending=false",
      type:"GET",
      success:function(resp){
        $(".main").html(resp);
        $(document).trigger("page:load");
      }
    });
  })
  
  $(".show-pending-trades").click(function(event){
    $.ajax({
      url:document.URL + "?pending=true",
      type:"GET",
      success:function(resp){
        $(".main").html(resp);
        $(document).trigger("page:load")
      }
    });
  })
  // END -- trades index -- //


  
  
  // START -- free agent offers index -- //
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
  
  // END -- free agent offers index -- //  
  
  
  // START -- Edit league membership javascript -- //
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
    
    var makeRosterData = function(){
      $("div.active").find(".portlet").each(function(){
        return_hash["roster_changes"][$(this).data("id")] = true
      });
      
      $("div.bench").find(".portlet").each(function(){
        return_hash["roster_changes"][$(this).data("id")] = false
      });
    }
    
    makeRosterData();
    
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
    $('#free-agent-add-button').prop('disabled', true);
    $("#free-agent-add-button").text("Adding...")
    if(name != "Choose a free agent"){
      $(".player-name").html(name)
      $('.confirm-add-free-agent').modal();
    }
  });

  // submits free agent request
  $("#free-agent-confirmed").click(function(event){
    $("#free-agent-form").submit();
  })
  
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
    $(".show-free-agent").addClass("active");
    $( ".show-roster" ).removeClass( "active");
    $(".show-trade").removeClass( "active");
    $( ".free-agent" ).removeClass( "hidden");
  });
  
  $( ".show-trade" ).click(function() {
    $( ".roster" ).addClass( "hidden");
    $( ".free-agent" ).addClass( "hidden");
    $(".show-trade").addClass("active");
    $( ".show-roster" ).removeClass( "active");
    $( ".show-free-agent" ).removeClass( "active");
    $( ".trade" ).removeClass( "hidden");
  });
  
  $( ".show-roster" ).click(function() {
    $( ".free-agent" ).addClass( "hidden");
    $( ".trade" ).addClass( "hidden");
    $(".show-roster").addClass("active");
    $( ".show-free-agent" ).removeClass( "active");
    $(".show-trade").removeClass( "active");
    $( ".roster" ).removeClass( "hidden");
    return false;
  });
  
  // This will hit the server for a given league members player and update the trade list accordingly.
  $(".lm-selector").on("change", function(){
    var lm_id = $(".lm-selector").find(":selected").data("id")
    $.ajax({
      url: document.URL.slice(0,-5) + "league_memberships/" + lm_id + "/droppable_players",
      type: "post",
      dataType:"html",
      data: {tradee: lm_id},
      success:function(resp){
        $(".lm-list").html(resp);
        $(document).trigger("page:load")
      }
    });

    $.ajax({
      url: "league_memberships/" + lm_id + "/score",
      type:"GET",
      sucess:function(resp){
        console.log(resp)
        $("#admin-score-input").text(resp);
      }
    });

  });
  

  $(".admin-submit-score").click(function(){
    $("#admin-submit-score").prop('disabled', true);
    $("#admin-submit-score").text("Sumbitting...");
    $.ajax({
      type: "POST",
      url: "league_memberships/" + $(".lm-selector").find(":selected").data("id") + "/update_score",
      data: {season_points: $("#admin-score-input").text()},
      success:function(resp){
        location.reload();
      },
      error:function(resp){
        alert("Update score failed");
      }
    })
  });

  //admin page
  $(".tradee-selector").on("change", function(){
    $.ajax({
      url: document.URL.slice(0,-7) + "/players",
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
  
  
  // Launches modal to confirm trade
  $(".submit-trade").click(function(event){
    var name = $(".tradee-selector").find(":selected").text();
    $(".tradee-name").html(name);
    $('.confirm-trade').modal();
  });
  
  // ajax request to submit trade
  $("#trade-request-confirmed").click(function(){
    $.ajax({
      url: $("#trade-url").val(),
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
    
  // END -- Edit league membership javascript -- //
  
  
  
  
  // START -- Create league javascript -- //
  $.fn.pressEnter = function(fn) {  
    return this.each(function() {  
      $(this).bind('enterPress', fn);
      $(this).keyup(function(e){
        if(e.keyCode == 13)
        {
          $(this).trigger("enterPress");
        }
      })
    });  
  }; 
 
  $('#league-invitee-textfield').pressEnter(function(event){
    event.preventDefault();
    if($(event.target).parent().hasClass("has-success")){
      var email = "<span class='email'>" + event.target.value + "</span>";
      var close_button = "<span class='glyphicon glyphicon-remove pull-right remove-invitee'></span>"
      var invitee = "<li class='list-group-item email_invites'>"+email                +close_button+"</li>";
      $(invitee).hide().appendTo("#invited").slideDown("fast");
      event.target.value = "";
      $(document).trigger("add");
    }
  });

  $(document).on('add', function() {
    $(".remove-invitee").click(function(event){
      $removedInvitee = $(event.target).parent()
      $removedInvitee.hide('fast', function(){ $removedInvitee.remove(); });
    })
  });



  $("button.create-league").click(function(event){
    var league_name = $("#league-name").val()
  
    if(league_name){
      saveLeague(event, league_name);
    }else{
      $(".red-alerts").html("The league must have a title")
    }
  });

  $('#league-invitee-textfield').keyup(function(e){
    var str = $(e.target).val();
    var regex = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.{1}[a-zA-Z]+$/
    if (str.match(regex)){
      $(e.target).parent().removeClass("has-error").addClass("has-success");
    }else{
      $(e.target).parent().removeClass("has-success").addClass("has-error");
    }
  });


  var throwTitleError = function(){
    $("#league-name").popover({
      content: "The league title cannot be blank!"
    })
  };

  var saveLeague = function(event, league_name){ 
    var emails = []
    var spans = $(".email_invites").find(".email")
    for (var i = 0; i < spans.length; i++){
      emails.push(spans[i].innerHTML)
    }
    $.ajax({
      url: "/leagues",
      type: "POST",
      data: {league: {
        invitees: emails,
        name: league_name
      }},
      dataType: "json",
      success: function(resp){
        window.location = resp[1];
      },
      error: function(resp){
        alert("failure");
      }
    })
  };
  // END -- Create league javascript -- //
  
    
  // google analytics
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-50948207-1', 'bushwood.us');
  ga('send', 'pageview');
};



$(document).ready(ready);
$(document).on('page:load', ready);