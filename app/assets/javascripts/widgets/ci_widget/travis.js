var travisWidgetInfo = function(widget) {
  return {
    url: widget.data('travisUrl'),
    key: widget.data('travisAuthKey'),
    uuid: widget.data('uuid'),
  }
}

var travisRequestSettings = function(projectInfo) {
  return {
    "url": projectInfo.url,
    "async": true,
    "crossDomain": true,
    "method": "GET",
    "headers": {
      "accept": "application/vnd.travis-ci.2+json",
      "authorization": 'token "' + projectInfo.key + '"',
    }
  };
}

var setCiStatus = function(widgetUuid, repo, last_build) {
  var widget = $(".widget[data-uuid=" + widgetUuid + "]");
  widget.find(".repository_name").text(repo.slug);
  widget.find(".last-build-at").text(repo.last_build_finished_at);
  widget.find(".status").text(repo.last_build_state);
  widget.find(".committer").text(last_build.commit.committer_name);
};

var updateTravisCIStatus = function(widget) {
  var projectInfo = travisWidgetInfo(widget);
  var settings = travisRequestSettings(projectInfo);
  var repo;

  $.ajax(settings)
    .then(function(data){
      repo = data.repo;
      settings['url'] = projectInfo.url + '/builds/' + repo.last_build_id;
      return $.ajax(settings);
    })
    .done(function(last_build){
      setCiStatus(projectInfo.uuid, repo, last_build);
    });
}

var timerTick = function() {
  $(".widget").each(function() {
    var widget =  $(this);
    updateTravisCIStatus(widget);
  })
};

$(document).ready(function(){
  if ($('.widget').length > 0) {
    setInterval(timerTick, 60000);
    timerTick();
  }
});
