var DashboardGrid = React.createClass({displayName: 'Dashboard Grid',

  persistLayout: function(layout) {
    var settings = {
      "url": '/api/dashboards/' + this.props.dashboardId + '/layout',
      "async": true,
      "method": "PUT",
      "data": JSON.stringify({"layout":layout}),
      "dataType": "json",
      "headers": {
        "accept": "application/json",
        "content_type":"application/json"
      }
    };

    $.ajax(settings)
      .done(function(data){
        console.log(data)
      });
  },

  getDefaultProps: function() {
    return {
      items: 20,
      autoSize: true,
      cols: 12,
      rowHeight: 100,
      margin: [10, 10],
      minH: 2,
      minW: 1,
      maxH: 12,
      maxW: 12,
      isDraggable: true,
      isResizable: false,
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
      <ReactGridLayout
        {...this.props}
        onLayoutChange={this.persistLayout}>
        {this.renderWidgets()}
      </ReactGridLayout>
    )
  }
});
