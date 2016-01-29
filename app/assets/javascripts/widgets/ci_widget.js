var widgetInfo = function(widget) {
  return {
    uuid: widget.data('uuid')
  }
}

var requestSettings = function(projectInfo) {
  return {
    "url": '/api/ci_status/' + projectInfo.uuid,
    "async": true,
    "method": "GET",
    "headers": {
      "accept": "application/json"
    }
  };
}

var setCiStatus = function(widgetUuid, build_info) {
  var widget = $(".ci-widget[data-uuid=" + widgetUuid + "]");
  var build_status = build_info.status;

  widget.find(".repository_name").text(build_status.repo_name);

  if (build_status.build_history.length > 0) {
    var last_build = build_status.build_history[0];

    widget.find(".last-build-at").text(last_build.timestamp);
    widget.find(".status").text(last_build.state);
    widget.find(".committer").text(last_build.committer);
  }
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
  $(".ci-widget").each(function() {
    var widget =  $(this);
    updateCIStatus(widget);
  })
};

$(document).ready(function(){
  if ($('.ci-widget').length > 0) {
    setInterval(timerTick, 30000);
    timerTick();
  }
});
