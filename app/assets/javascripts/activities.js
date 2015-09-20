$(function() {
  $("button[id^='show-activity-form-']").click(function(){
    var id = parseInt(this.id.replace("show-activity-form-", ""), 10);
    $(this).hide();
    $("#activity-form-"+id).show();
  });
});

// adding new activities Ajax request

$(function() {
  $(".activity-checkbox").change(function() {
    if(this.checked) {
      $.ajax({
        type: 'POST',
        url: '/members/add_activity',
        data: { member_id: this.dataset.memberId, activity_id: this.value}
      });
    } else {
      $.ajax({
        type: 'POST',
        url: '/members/remove_activity',
        data: { member_id: this.dataset.memberId, activity_id: this.value}
      });
    }
  });
});
