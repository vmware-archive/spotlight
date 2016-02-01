/* global jasmine */

//= require mock-ajax

describe('CiWidgetContainer', function() {
  let fakeTimerTick;

  const widgetProps = {
    title: 'Concierge',
    widgetPath: '/widget_path',
    uuid: 'some uuid'
  };

  beforeEach(function() {
    jasmine.Ajax.install();
  });

  afterEach(function() {
    jasmine.Ajax.uninstall();
  });


  let component;
  let ciWidget;
  beforeEach(function() {
    fakeTimerTick = jasmine.createSpy('timer tick');
    component = window.TestUtils.renderIntoDocument(<CiWidgetContainer {...widgetProps} timerTick={fakeTimerTick}/>);
    ciWidget = window.TestUtils.findRenderedComponentWithType(component, CiWidget);
  });

  it('passes its title to the CI widget component', function() {
    expect(ciWidget.props.title).toEqual(widgetProps.title);
  });

  it('adds uuid as a data-element on the parent', function() {
    const containerNode = window.TestUtils.findRenderedDOMComponentWithClass(component, 'ci-widget');
    expect(containerNode.dataset.uuid).toEqual(widgetProps.uuid);
  });

  describe('build information', function() {
    it('calls the server to get latest build data', function() {
      component.refreshBuildInfo();

      const request = jasmine.Ajax.requests.mostRecent();
      expect(request.url).toBe('/api/ci_status/' + widgetProps.uuid);
      expect(request.method).toBe('GET');
    });

    describe('when build status is retrieved', function() {
      let fakeOnBuildUpdate;

      beforeEach(function() {
        fakeOnBuildUpdate = jasmine.createSpy('fakeOnBuildUpdate');
        component = window.TestUtils.renderIntoDocument(
          <CiWidgetContainer {...widgetProps} onBuildUpdate={fakeOnBuildUpdate}/>
        );

        component.refreshBuildInfo();

        const request = jasmine.Ajax.requests.mostRecent();
        request.respondWith({ status: 200, responseText: '{"foo": "bar"}' });
      });

      it('calls the onBuildUpdate function', function() {
        expect(fakeOnBuildUpdate.calls.count()).toBe(1);
      });
    });
  });

  describe('updateBuildInfo', function() {
    const testBuildInfo = {
      state: 'passed',
      committer: 'Luke Skywalker',
      timestamp: 'A long time ago'
    };

    const buildInfo = {
      status: {
        build_history: [testBuildInfo]
      }
    };

    it('updates the component state', function() {
      component.onBuildUpdate(buildInfo);
      expect(component.state.status).toEqual(testBuildInfo.state);
      expect(component.state.committer).toEqual(testBuildInfo.committer);
      expect(component.state.lastBuildTime).toEqual(testBuildInfo.timestamp);
    });
  });

  describe('componentDidMount', function() {
    beforeEach(function() {
      fakeTimerTick = jasmine.createSpy('timer tick');
      jasmine.clock().install();
    });

    afterEach(function() {
      jasmine.clock().uninstall();
    });

    it('causes the timerTick to be called at interval', function() {
      const refreshRate = 20000;
      component = window.TestUtils.renderIntoDocument(
        <CiWidgetContainer {...widgetProps} timerTick={fakeTimerTick} refreshInterval={refreshRate}/>
      );

      expect(fakeTimerTick.calls.count()).toBe(1);

      jasmine.clock().tick(refreshRate - 1);
      expect(fakeTimerTick.calls.count()).toBe(1);

      jasmine.clock().tick(2);
      expect(fakeTimerTick.calls.count()).toBe(2);
    });
  });

  it('passes the build status from its state to the CI widget component', function() {
    const expectedProps = {status: 'status', committer: 'committer name', lastBuildTime: 'last build'};
    component.setState(expectedProps);
    expect(ciWidget.props).toEqual(jasmine.objectContaining(expectedProps));
  });
});
