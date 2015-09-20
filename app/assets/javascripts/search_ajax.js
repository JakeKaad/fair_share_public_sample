var typingTimer;
var doneTypingInterval = 700;

$(function(){
  setPlaceholderBasedOnTab();
  $("#family_search").on('keyup', function() {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(familyQuery(), doneTypingInterval);
  });

  $("#family_search").on('keydown', function () {
    clearTimeout(typingTimer);
  });

  function familyQuery() {
    var data = $("#family_search").val();
    $.ajax({
      type: 'POST',
      url: '/families/search',
      data: {query: data, tab: getTabQuery()}
    });
  }
});

$(function(){
  setPlaceholderBasedOnTab();
  $("#student_search").on('keyup', function() {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(studentQuery(), doneTypingInterval);

  });

  $("#student_search").on('keydown', function () {
    clearTimeout(typingTimer);
  });

  function studentQuery() {
    var data = $("#student_search").val();
    $.ajax({
      type: 'POST',
      url: '/students/search',
      data: {query: data, tab: getTabQuery()}
    });
  }
});

$(function(){
  setPlaceholderBasedOnTab();
  $("#member_search").on('keyup', function() {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(memberQuery(), doneTypingInterval);

  });

  $("#member_search").on('keydown', function () {
    clearTimeout(typingTimer);
  });

  function memberQuery() {
    var data = $("#member_search").val();
    $.ajax({
      type: 'POST',
      url: '/members/search',
      data: {query: data, tab: getTabQuery()}
    });
  }
});

function getTabQuery() {
  var query = window.location.search;
  return query.split('=')[1];
}

function setPlaceholderBasedOnTab() {
  var tab = getTabQuery();
  if (tab === undefined) {
    $("#family_search").attr("placeholder", "Search active");
    $("#student_search").attr("placeholder", "Search active");
    $("#member_search").attr("placeholder", "Search active");
  } else if (tab === "archived") {
    $("#family_search").attr("placeholder", "Search archived");
    $("#student_search").attr("placeholder", "Search archived");
    $("#member_search").attr("placeholder", "Search archived");
  } else if (tab == "all") {
    $("#family_search").attr("placeholder", "Search all");
    $("#student_search").attr("placeholder", "Search all");
    $("#member_search").attr("placeholder", "Search all");
  }
}
