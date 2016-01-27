
var SpotlightWindow = React.createClass({
  displayName: 'Spotlight window',

  defaultOnSave: function(data) {
    window.location.href = "dashboards";
  },

  onSave: function() {
    return (this.props.onSave || this.defaultOnSave);
  },

  render: function() {
    return (
      <div>
        <DashboardGrid  {...this.props} onSave={this.onSave()}/>
      </div>
    )
  }
});
