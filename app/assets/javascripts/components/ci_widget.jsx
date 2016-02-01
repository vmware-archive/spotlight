/* global React, _, moment */

const maxBuildHistory = 4;
const CiWidget = React.createClass({
  propTypes: {
    title: React.PropTypes.string.isRequired,
    widgetPath: React.PropTypes.string.isRequired,
    status: React.PropTypes.oneOf(['passed', 'failed', 'building', 'unknown']).isRequired,
    committer: React.PropTypes.string.isRequired,
    lastBuildTime: React.PropTypes.string.isRequired,
    buildHistory: React.PropTypes.string.isRequired
  },

  getDefaultProps: function() {
    return {
      status: 'unknown',
      buildHistory: [ ]
    };
  },

  committerInfo: function() {
    if (this.props.committer) {
      const committerName = this.props.committer;
      const fomattedCommitterName = (committerName.length > 20) ?
        (committerName.substring(0, 17) + '...') :
        committerName;
      return ('by ' + fomattedCommitterName);
    }
  },

  timeAgo: function(timestamp) {
    return moment(timestamp).fromNow();
  },

  showCommitter: function() {
    return (this.props.status === 'failed' ? '' : 'hidden');
  },

  renderBuildHistory: function() {
    const buildHistory = this.props.buildHistory;
    return _.map(_.range(maxBuildHistory), function(index) {
      const build = buildHistory ? buildHistory[maxBuildHistory - (index + 1)] : null;
      const buildStatus = build ? build.state : 'unknown';
      return ( <div className={'build-block ' + buildStatus }></div>);
    });
  },

  render: function() {
    return (
      <div className={'inner-ci-widget ' + this.props.status}>
        <div className="content">
          <p className="project-name">{this.props.title}</p>
          <div className="symbol"></div>
          <div className="commit-info">
            <div className="inner-div">
              <p className="last-build-at">{this.timeAgo(this.props.lastBuildTime)}</p>
              <p className={ 'committer ' + this.showCommitter() }>{this.committerInfo()}</p>
            </div>
          </div>
          <div className="build-history">
            {this.renderBuildHistory()}
          </div>

          <div className="buttons edit-only">
            <a className="delete btn-floating waves-effect waves-light white-text red tooltipped"
              data-delay="20"
              data-tooltip="Remove Widget"
              data-confirm="You are about to permanently delete this widget. This change cannot be undone. Are you sure?"
              rel="nofollow"
              data-method="delete"
              href={this.props.widgetPath}>
              <i className="tiny material-icons">delete</i>
            </a>
          </div>
        </div>
      </div>
    );
  }
});
