describe('SpotlightWindow', function () {
  var testProps = {
    foo: 'bar',
    onSave: 'fakeOnSave'
  };

  it('renders dashboard grid', function () {
    var renderer = window.TestUtils.createRenderer();
    renderer.render( <SpotlightWindow {...testProps}/>);
    result = renderer.getRenderOutput();

    var dashboard = result.props.children;
    expect(window.TestUtils.isElementOfType(dashboard, DashboardGrid)).toBe(true);
    expect(dashboard.props.foo).toEqual('bar');
    expect(dashboard.props.onSave).toEqual('fakeOnSave');
  });
});
