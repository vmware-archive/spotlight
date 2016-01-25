describe('CiWidget', function () {
  var ciWidget;
  var testTitle = "Concierge";
  var testUuid = "123456789";
  var testPath = '/widget_path';
  var widgetProps = {
    uuid: testUuid,
    title: testTitle,
    widget_path: testPath
  };

  beforeEach(function() {
    ciWidget = window.TestUtils.renderIntoDocument(
      <CiWidget {...widgetProps}/>
    );
  });

  it('renders the title', function () {
    var titleNode = window.TestUtils.findRenderedDOMComponentWithTag(
      ciWidget,
      'h4'
    )
    expect(titleNode.textContent).toEqual(testTitle);
  });

  it ('widget contains the uuid information', function() {
    expect(ciWidget.getDOMNode().dataset.uuid).toEqual(testUuid);
  });


  it('renders the delete button', function () {
    var deleteLink = window.TestUtils.findRenderedDOMComponentWithClass(ciWidget, 'delete')
    expect(deleteLink.href).toContain(testPath);
  });
});
