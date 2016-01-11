var TRAVIS_AUTH = "token \"5V_zKW9KmdYMpyBR12rtug\""
var TRAVIS_URL_PREFIX = "https://api.travis-ci.com/repos/"

var common_settings = {
  "async": true,
  "crossDomain": true,
  "method": "GET",
  "headers": {
    "accept": "application/vnd.travis-ci.2+json",
    "authorization": TRAVIS_AUTH,
  }
};

var setCiStatus = function(widgetUuid, ciDetails) {
  console.log(ciDetails);
  var widget = $(".widget[data-uuid=" + widgetUuid + "]");
  widget.find(".repository_name").text(ciDetails.slug);
  widget.find(".last-build-at").text(ciDetails.last_build_finished_at);
  widget.find(".status").text(ciDetails.last_build_state);
  widget.find(".description").text(ciDetails.description);
};

var getTravisStatus = function(widgetUuid, travis_url) {
  var travisRepo = TRAVIS_URL_PREFIX + travis_url;
  var settings = $.extend(common_settings, {"url": travisRepo});

  console.log('Checking with Travis API.');
  $.ajax(settings).success(function(response){
    console.log("success");
    setCiStatus(widgetUuid, response.repo);
  }).error(function(response){
    console.log("failure");
  });
};

var timerTick = function() {
  console.log('tick');
  $("#ci-widgets").children().each(function() { 
    var widget =  this.children[0];
    var travisSlug = widget.dataset.travisSlug;
    var widgetUuid = widget.dataset.uuid;
    console.log( travisSlug);
    getTravisStatus( widgetUuid, travisSlug );
  })
};

$(function() {
  console.log('window loaded');
  timerTick();
  setInterval(timerTick, 60000);
});
