const SpotlightWindow = React.createClass({
  displayName: 'Spotlight window',

  propTypes: {
    dashboardId: React.PropTypes.number.isRequired,
    onSave: React.PropTypes.func,
    widgets: React.PropTypes.array.isRequired,
    editMode: React.PropTypes.bool.isRequired
  },

  defaultOnSave: function() {
    window.location.href = 'dashboards';
  },

  onSave: function() {
    return (this.props.onSave || this.defaultOnSave);
  },

  render: function() {
    return (
      <div>
        <DashboardGrid  {...this.props} onSave={this.onSave()}/>
      </div>
    );
  }
});
