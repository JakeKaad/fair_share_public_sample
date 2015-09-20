$(function() {
  $("#show-student-form").click(function(){
    $(this).hide();
  $("#family-student-form").show();
  });

  $("#show-member-form").click(function(){
    $(this).hide();
  $("#family-member-form").show();
  });
});
