var DashboardGrid = React.createClass({displayName: 'Dashboard Grid',

  onLayoutChange: function(layout) {
    this.props.onLayoutChange(layout);
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
    console.log('hello');
    return _.map(this.props.widgets, function(widget) {
      return (<div className='widget' key={widget.uuid} _grid={{w: widget.size.width, h: widget.size.height, x: 0, y: 0}}>
                <CiWidget {...widget}/>
              </div>);
    });
  },

  render: function() {
    return (
      <ReactGridLayout {...this.props}>
        {this.renderWidgets()}
      </ReactGridLayout>
    )
  }
});
