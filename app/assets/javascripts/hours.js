$(function() {
  $("#activity").change(function() {
    $.ajax({
      type: 'GET',
      url: '/hours/get_subactivities',
      dataType: "script",
      data: { activity_id: this.value}
    });
  });
});

$(function() {
  $("#hour_subactivity_id").change(function() {
    $.ajax({
      type: 'GET',
      url: '/hours/get_quantity',
      dataType: "script",
      data: { subactivity_id: this.value}
    });
  });
});
