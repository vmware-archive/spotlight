/* global $, React */

const DashboardGrid = React.createClass({
  displayName: 'Dashboard Grid',

  propTypes: {
    dashboardId: React.PropTypes.number.isRequired,
    onSave: React.PropTypes.func.isRequired,
    widgets: React.PropTypes.array.isRequired,
    editMode: React.PropTypes.bool.isRequired
  },

  getDefaultProps: function() {
    return {
      autoSize: true,
      cols: 12,
      rowHeight: 100,
      margin: [10, 10],
      minH: 2,
      minW: 1,
      maxH: 12,
      maxW: 12,
      useCSSTransforms: true,
      listenToWindowResize: true,
      verticalCompact: true,
      className: 'layout'
    };
  },

  getInitialState: function() {
    return {currentLayout: []};
  },


  persistLayout: function() {
    const settings = {
      url: '/api/dashboards/' + this.props.dashboardId + '/layout',
      async: true,
      method: 'PUT',
      data: JSON.stringify({layout: this.state.currentLayout}),
      dataType: 'json',
      contentType: 'application/json',
      headers: {
        accept: 'application/json',
        content_type: 'application/json'
      }
    };

    $.ajax(settings)
      .done(this.props.onSave);
  },

  updateLayout: function(layout) {
    this.state.currentLayout = layout; 
    // we think this sound be setState() but this is causing a recursion loop 
    // which we think is caused by setState() triggering a layout change that ReactGridLayout is picking up on and re-triggering this method again, etc...
  },

  renderWidgets: function() {
    return _.map(this.props.widgets, function(widget) {
      return (<div className="widget card" key={widget.uuid} _grid={widget.layout}>
                <CiWidgetContainer {...widget}/>
              </div>);
    });
  },

  render: function() {
    return (
      <div className={this.props.editMode ? 'edit' : 'view'}>
        <DashboardButton action="save" href="javascript:void(0);" onClick={this.persistLayout} tooltip="Save Layout" editOnly={true}/>
        <DashboardButton action="add" href="/widgets/new" tooltip="New Widget" editOnly={true}/>
        <DashboardButton action="edit" href="/dashboards?edit=true" tooltip="Edit Dashboard" editOnly={false}/>

        <ReactGridLayout
          {...this.props}
          isDraggable={this.props.editMode}
          isResizable={this.props.editMode}
          onLayoutChange={this.updateLayout}>
          {this.renderWidgets()}
        </ReactGridLayout>
      </div>
    );
  }
});
