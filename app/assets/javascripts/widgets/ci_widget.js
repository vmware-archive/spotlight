var widgetInfo = function(widget) {
  return {
    uuid: widget.data('uuid')
  }
}

var requestSettings = function(projectInfo) {
  return {
    "url": '/ci_status/' + projectInfo.uuid,
    "async": true,
    "method": "GET",
    "headers": {
      "accept": "application/json"
    }
  };
}

var setCiStatus = function(widgetUuid, last_build) {
  var widget = $(".widget[data-uuid=" + widgetUuid + "]");
  var build_status = last_build.status
  widget.find(".repository_name").text(build_status.repo_name);
  widget.find(".last-build-at").text(build_status.last_build_time);
  widget.find(".status").text(build_status.last_build_status);
  widget.find(".committer").text(build_status.last_committer);
};

var updateCIStatus = function(widget) {
  var projectInfo = widgetInfo(widget);
  var settings = requestSettings(projectInfo);

  $.ajax(settings)
    .done(function(last_build){
      setCiStatus(projectInfo.uuid, last_build);
    });
}

var timerTick = function() {
  $(".widget").each(function() {
    var widget =  $(this);
    updateCIStatus(widget);
  })
};

$(document).ready(function(){
  if ($('.widget').length > 0) {
    setInterval(timerTick, 60000);
    timerTick();
  }
});
