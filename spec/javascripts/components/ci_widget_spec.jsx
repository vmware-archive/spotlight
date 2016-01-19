describe('CiWidget', function () {
  it('renders the title', function () {
    var testTitle = "Concierge";
    var ciWidget = window.TestUtils.renderIntoDocument(
      <CiWidget title={testTitle} />
    );

    var titleNode = window.TestUtils.findRenderedDOMComponentWithTag(
      ciWidget,
      'h3'
    )

    expect(titleNode.textContent).toEqual(testTitle);
  });

});
