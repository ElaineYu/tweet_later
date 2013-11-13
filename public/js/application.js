$(document).ready(function() {

  $("#tweet").submit(function(event){
    event.preventDefault();
    var form = this;
    $.post("/tweet", $(form).serialize(), function(response){
      var job_id = response.sidekiq_job_id
      var status = response.status;
      var interval = setInterval(function(){
        $.get('/status/' + job_id, function(response){
          if (response === "true") {
            clearInterval(interval);
          }
        });
      },100);
    });
  });

  // $(document).ajaxStart(function () {
  //     $("#tweet").children().attr("disabled", true);
  //     $("#tweet").append("<p><img src=/ajax-loader.gif/>Processing Tweet</p>");
  // }).ajaxStop(function () {
  //     $("#tweet").children().attr("disabled", false);
  //     $("#tweet textarea").val("");
  //     $("#tweet p").replaceWith("<p style=\"color:green\">All Good!</p>");
  //     $("#tweet p").fadeOut(1500, function(){
  //       $(this).remove();
  //     });
  // });

});
