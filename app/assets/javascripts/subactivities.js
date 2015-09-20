$(function() {
  $("button[id^='show-subactivity-form-']").click(function(){
    var id = parseInt(this.id.replace("show-subactivity-form-", ""), 10);
    $(this).hide();
    $("#subactivity-form-"+id).show();
  });
});
