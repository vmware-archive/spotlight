describe('DashboardButton', function () {
  var testAction = "save"
  var testHref = "some/link"
  var testTooltip = "tooltip"
  var editOnly = true

  var testProps = function() {
    return{
      action: testAction,
      href: testHref,
      tooltip: testTooltip,
      editOnly: editOnly
    }
  };

  var renderComponent = function() {
    return window.TestUtils.renderIntoDocument( <DashboardButton {...testProps()}/>);
  };

  it('renders a link with the action', function () {
    var link = window.TestUtils.findRenderedDOMComponentWithTag(renderComponent(), 'a');
    expect(link.textContent).toEqual(testAction);
  });

  it('renders a link  with the correct href', function () {
    var link = window.TestUtils.findRenderedDOMComponentWithTag(renderComponent(), 'a');
    expect(link.href).toContain(testHref);
  });

  it('adds action details as a class', function() {
    var button = window.TestUtils.findRenderedDOMComponentWithTag(renderComponent(), 'div');
    expect(button.classList).toContain(testAction+'-button');
  });

  describe('in edit mode', function (){
    beforeEach(function(){
      editOnly = true;
    });

    it('adds edit-only class', function() {
      var button = window.TestUtils.findRenderedDOMComponentWithTag(renderComponent(), 'div');
      expect(button.classList).toContain('edit-only');
      expect(button.classList).not.toContain('view-only');
    });
  });

  describe('not in edit mode', function (){
    beforeEach(function(){
      editOnly = false;
    });

    it('adds view-only class', function() {
      var button = window.TestUtils.findRenderedDOMComponentWithTag(renderComponent(), 'div');
      expect(button.classList).toContain('view-only');
      expect(button.classList).not.toContain('edit-only');
    });
  });
});
