describe('CiWidget', function() {
  let ciWidget;

  const widgetProps = {
    title: 'Concierge',
    widgetPath: '/widget_path',
    status: 'building',
    committer: 'committer name',
    lastBuildTime: moment().format(),
  };

  beforeEach(function() {
    ciWidget = window.TestUtils.renderIntoDocument(
      <CiWidget {...widgetProps}/>
    );
  });

  it('renders the title', function() {
    const titleNode = window.TestUtils.findRenderedDOMComponentWithClass(ciWidget, 'project-name');
    expect(titleNode.textContent).toEqual(widgetProps.title);
  });

  it('renders the time since the last build', function() {
    const titleNode = window.TestUtils.findRenderedDOMComponentWithClass(ciWidget, 'last-build-at');
    expect(titleNode.textContent).toEqual('a few seconds ago');
  });

  it('renders the delete button', function() {
    const deleteLink = window.TestUtils.findRenderedDOMComponentWithClass(ciWidget, 'delete');
    expect(deleteLink.href).toContain(widgetProps.widgetPath);
  });

  it('renders the build status', function() {
    expect(window.TestUtils.findRenderedDOMComponentWithClass(ciWidget, widgetProps.status).tagName).toEqual('DIV');
  });

  it('renders the committers name', function() {
    const committerNode = window.TestUtils.findRenderedDOMComponentWithClass(ciWidget, 'committer');
    expect(committerNode.textContent).toEqual('by ' + widgetProps.committer);
  });
});
