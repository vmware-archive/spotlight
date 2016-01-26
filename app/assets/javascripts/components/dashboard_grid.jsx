var currentLayout; //TODO: refactor so we're not using a global variable for current layout state =-(

var DashboardGrid = React.createClass({displayName: 'Dashboard Grid',
  persistLayout: function() {
    var settings = {
      url: '/api/dashboards/' + this.props.dashboardId + '/layout',
      async: true,
      method: "PUT",
      data: JSON.stringify({layout: currentLayout}),
      dataType: "json",
      contentType: "application/json",
      headers: {
        accept: "application/json",
        content_type: "application/json"
      }
    };

    $.ajax(settings)
    .done(this.props.onSave);
  },

  updateLayout: function(layout) {
    currentLayout = layout;
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
    }
  },

  renderWidgets: function() {
    return _.map(this.props.widgets, function(widget) {
      return (<div className='widget card' key={widget.uuid} _grid={widget.layout}>
                <CiWidget {...widget}/>
              </div>);
    });
  },

  render: function() {
    return (
      <div>
        <div className="fixed-action-btn edit-only save-button">
          <a className="btn-floating btn-large waves-effect waves-light red tooltipped" data-delay="20" data-position="top" data-tooltip="Save Dashboard" href="javascript:void(0);" onClick={this.persistLayout}>
            <i className="material-icons">save</i>
          </a>
        </div>
        <div className="fixed-action-btn edit-only add-button">
          <a className="btn-floating btn-large waves-effect waves-light red tooltipped" data-delay="20" data-position="top" data-tooltip="New Widget" href="/widgets/new">
            <i className="material-icons">add</i>
          </a>
        </div>

        <ReactGridLayout
          {...this.props}
          isDraggable={this.props.editMode}
          isResizable={this.props.editMode}
          onLayoutChange={this.updateLayout}>
          {this.renderWidgets()}
        </ReactGridLayout>
      </div>
    )
  }
});
