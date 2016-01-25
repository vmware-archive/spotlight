describe('DashboardGrid', function () {
  var dashboard;
  var testTitle = "Concierge";
  var testUuid = "123456789";
  var testPath = '/widget_path';
  var rowHeight = 100;
  var maxColumns = 12;
  var testLayout = {
    x: 10,
    y: 0,
    h: 2,
    w: 6
  };
  var widgetProps = {
    uuid: testUuid,
    title: testTitle,
    layout: testLayout,
    widget_path: testPath
  };

  beforeEach(function() {
    jQuery(window).width(600);
    jQuery(window).height(400);
    dashboard = window.TestUtils.renderIntoDocument(
      <DashboardGrid widgets={[widgetProps]} dashboardId='1'/>
    );
  });

  it('renders the widget', function () {
    var titleNode = window.TestUtils.findRenderedDOMComponentWithTag(
      dashboard,
      'h4'
    )
    expect(titleNode.textContent).toEqual(testTitle);
  });

  it('renders the widget with correct height', function(){
    var widgetHeight = parseInt(window.TestUtils.findRenderedDOMComponentWithClass(dashboard, 'widget').style.height.replace("px",""));
    var delta = 15;
    expect(widgetHeight).toBeGreaterThan((rowHeight*2) - delta);
    expect(widgetHeight).toBeLessThan((rowHeight*2) + delta);
  });

  it('renders the widget with correct width', function() {
    var widgetWidth = parseInt(window.TestUtils.findRenderedDOMComponentWithClass(dashboard, 'widget').style.width.replace("%",""));
    var delta = 3;
    expect(widgetWidth).toBeGreaterThan(50 - delta); //Note: 50% - 6 of 12 columns
    expect(widgetWidth).toBeLessThan(50 + delta);
  });
});
