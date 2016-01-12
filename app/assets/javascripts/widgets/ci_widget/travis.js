var setCiStatus = function(widgetUuid, ciDetails) {
  console.log(ciDetails);
  var widget = $(".widget[data-uuid=" + widgetUuid + "]");
  widget.find(".repository_name").text(ciDetails.slug);
  widget.find(".last-build-at").text(ciDetails.last_build_finished_at);
  widget.find(".status").text(ciDetails.last_build_state);
  widget.find(".description").text(ciDetails.description);
};

var getTravisStatus = function(widgetUuid, travisUrl, travisAuthKey) {
  var settings = {
    "url": travisUrl,
    "async": true,
    "crossDomain": true,
    "method": "GET",
    "headers": {
      "accept": "application/vnd.travis-ci.2+json",
      "authorization": 'token "' + travisAuthKey + '"',
    }
  };

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
    var travisUrl = widget.dataset.travisUrl;
    var travisAuthKey = widget.dataset.travisAuthKey;
    var widgetUuid = widget.dataset.uuid;
    getTravisStatus( widgetUuid, travisUrl, travisAuthKey );
  })
};

$(function() {
  console.log('window loaded');
  timerTick();
  setInterval(timerTick, 60000);
});
