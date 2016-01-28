//= require mock-ajax

describe('DashboardGrid', function () {
  let dashboard;
  const testTitle = 'Concierge';
  const testUuid = '123456789';
  const testPath = '/widget_path';
  const rowHeight = 100;
  const testLayout = {
    x: 3,
    y: 0,
    h: 2,
    w: 6
  };
  const widgetProps = {
    uuid: testUuid,
    title: testTitle,
    layout: testLayout,
    widget_path: testPath
  };
  const fakeWindowRedirect = jasmine.createSpy('fakeWindowRedirect')

  beforeEach(function() {
    dashboard = window.TestUtils.renderIntoDocument(
      <DashboardGrid widgets={[widgetProps]} dashboardId="1" editMode={false} onSave={fakeWindowRedirect}/>
    );
  });

  it('renders the widget', function () {
    const titleNode = window.TestUtils.findRenderedDOMComponentWithTag(
      dashboard,
      'h4'
    );
    expect(titleNode.textContent).toEqual(testTitle);
  });

  it('renders the widget with correct height', function(){
    let widgetHeight = parseInt(window.TestUtils.findRenderedDOMComponentWithClass(dashboard, 'widget').style.height.replace("px",""));
    let delta = 15;
    expect(widgetHeight).toBeGreaterThan((rowHeight*2) - delta);
    expect(widgetHeight).toBeLessThan((rowHeight*2) + delta);
  });

  it('renders the widget with correct width', function() {
    let widgetWidth = parseInt(window.TestUtils.findRenderedDOMComponentWithClass(dashboard, 'widget').style.width.replace("%",""));
    let delta = 3;
    expect(widgetWidth).toBeGreaterThan(50 - delta); //Note: 50% - 6 of 12 columns
    expect(widgetWidth).toBeLessThan(50 + delta);
  });

  describe('not in edit mode', function() {
    beforeEach(function() {
      dashboard = window.TestUtils.renderIntoDocument(<DashboardGrid widgets={[widgetProps]} dashboardId='1' editMode={false}/>);
    });

    it('does not allow dragging', function() {
      expect(dashboard.getDOMNode().innerHTML).not.toContain("react-draggable")
    });

    it('does not allow resizing', function() {
      expect(dashboard.getDOMNode().innerHTML).not.toContain("react-resizable")
    });
  });

  describe('in edit mode', function () {
    beforeEach(function() {
      dashboard = window.TestUtils.renderIntoDocument(<DashboardGrid widgets={[widgetProps]} dashboardId='1' editMode={true}/>);
    });

    it('allows dragging', function() {
      expect(dashboard.getDOMNode().innerHTML).toContain("react-draggable");
    });

    it('allows resizing', function() {
      expect(dashboard.getDOMNode().innerHTML).toContain("react-resizable");
    });
  });

  describe('update layout',function(){
    it('initialized the current layout with widget layout', function() {
      const expectedLayout = _.extend(testLayout, {"i": testUuid});
      expect(dashboard.state.currentLayout).toEqual([expectedLayout]);
    });

    it('saves the provided layout as current layout', function() {
      newLayout = 'new Layout';
      dashboard.updateLayout(newLayout);
      expect(dashboard.state.currentLayout).toEqual(newLayout);
    });
  });

  describe('persist layout',function(){
    beforeEach(function() {
      jasmine.Ajax.install();
    });

    afterEach(function() {
      jasmine.Ajax.uninstall();
    });

    let doPersist = function(){ dashboard.persistLayout() };

    it('sends the current layout to the server', function() {
      dashboard.state.currentLayout = 'new Layout';
      doPersist();

      request = jasmine.Ajax.requests.mostRecent();
      expect(request.url).toBe('/api/dashboards/1/layout');
      expect(request.method).toBe('PUT');
      expect(request.data()).toEqual({layout: "new Layout"});
    });

    describe('when layout is successfully saved',function(){
      beforeEach(function(){
        doPersist();
        request = jasmine.Ajax.requests.mostRecent();
        request.respondWith({ status: 200, responseText: '{}' });
      });

      it('calls the onSave function', function() {
        expect(fakeWindowRedirect.calls.count()).toBe(1);
      });
    });
  });
});
