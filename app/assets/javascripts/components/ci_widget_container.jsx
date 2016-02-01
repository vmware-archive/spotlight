/* global React, $ */

const CiWidgetContainer = React.createClass({
  propTypes: {
    title: React.PropTypes.string.isRequired,
    uuid: React.PropTypes.string.isRequired,
    widgetPath: React.PropTypes.string.isRequired,
    onBuildUpdate: React.PropTypes.func,
    refreshInterval: React.PropTypes.number,
    timerTick: React.PropTypes.func
  },

  getDefaultProps: function() {
    return {
      refreshInterval: 30000
    };
  },

  getInitialState: function() {
    return {};
  },

  componentDidMount: function() {
    this.timerTick();
    setInterval(this.timerTick, this.props.refreshInterval);
  },

  // default overides
  timerTick: function() {
    return (this.props.timerTick || this.defaultTimerTick)();
  },

  onBuildUpdate: function(data) {
    return (this.props.onBuildUpdate || this.defaultOnBuildUpdate)(data);
  },

  defaultTimerTick: function() {
    console.log(this.props.uuid + ': timer tick');
    this.refreshBuildInfo();
  },

  defaultOnBuildUpdate: function(buildStatus) {
    const buildHistory = buildStatus.status.build_history;
    if (buildHistory.length > 0) {
      const lastBuild = buildHistory[0];

      this.setState({
        status: lastBuild.state,
        committer: lastBuild.committer,
        lastBuildTime: lastBuild.timestamp,
        buildHistory: buildHistory.slice(1, 5)
      });
    }
  },

  refreshBuildInfo: function() {
    const settings = {
      url: '/api/ci_status/' + this.props.uuid,
      async: true,
      method: 'GET',
      headers: {
        accept: 'application/json',
      }
    };

    $.ajax(settings)
      .done(this.onBuildUpdate);
  },

  render: function() {
    return (
      <div className="ci-widget card-content" data-uuid={this.props.uuid}>
        <CiWidget
          title={this.props.title}
          widgetPath={this.props.widgetPath}
          status={this.state.status}
          committer={this.state.committer}
          lastBuildTime={this.state.lastBuildTime}
          buildHistory={this.state.buildHistory}
        />
      </div>
    );
  }
});
