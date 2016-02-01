describe('CiWidget', function() {
  let status = 'building';
  let buildHistory = [ {state: 'passed'} ];

  const widgetProps = function() {
    return {
      title: 'Concierge',
      widgetPath: '/widget_path',
      status: status,
      committer: 'committer name',
      lastBuildTime: moment().format(),
      buildHistory: buildHistory
    };
  };

  const renderWidget = function() {
    return window.TestUtils.renderIntoDocument(
      <CiWidget {...widgetProps()}/>
    );
  };

  it('renders the title', function() {
    const titleNode = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'project-name');
    expect(titleNode.textContent).toEqual(widgetProps().title);
  });

  it('renders the time since the last build', function() {
    const titleNode = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'last-build-at');
    expect(titleNode.textContent).toEqual('a few seconds ago');
  });

  it('renders the delete button', function() {
    const deleteLink = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'delete');
    expect(deleteLink.href).toContain(widgetProps().widgetPath);
  });

  it('renders the build status', function() {
    expect(window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), widgetProps().status).tagName).toEqual('DIV');
  });

  describe('committers name', function() {
    describe('build is building', function() {
      beforeEach(function() {
        status = 'building';
      });

      it('hides the committer', function() {
        const committerNode = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'committer');
        expect(committerNode.classList).toContain('hidden');
      });
    });

    describe('build is passed', function() {
      beforeEach(function() {
        status = 'passed';
      });

      it('hides the committer', function() {
        const committerNode = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'committer');
        expect(committerNode.classList).toContain('hidden');
      });
    });

    describe('build is unknown', function() {
      beforeEach(function() {
        status = 'unknown';
      });

      it('hides the committer', function() {
        const committerNode = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'committer');
        expect(committerNode.classList).toContain('hidden');
      });
    });

    describe('build has failed', function() {
      beforeEach(function() {
        status = 'failed';
      });

      it('shows the committer', function() {
        const committerNode = window.TestUtils.findRenderedDOMComponentWithClass(renderWidget(), 'committer');
        expect(committerNode.textContent).toEqual('by ' + widgetProps().committer);
        expect(committerNode.classList).not.toContain('hidden');
      });
    });
  });

  it('renders previous build status', function() {
    const nodes = window.TestUtils.scryRenderedDOMComponentsWithClass(renderWidget(), 'build-block');
    expect(nodes.length).toEqual(4);
  });

  it('renders previous build in reverse order and pads mising builds', function() {
    buildHistory = [
      {state: 'passed'},
      {state: 'unknown'},
      {state: 'failed'}
    ];

    const nodes = window.TestUtils.scryRenderedDOMComponentsWithClass(renderWidget(), 'build-block');
    expect(nodes.length).toEqual(4);
    expect(nodes[0].className).toContain('unknown');
    expect(nodes[1].className).toContain('failed');
    expect(nodes[2].className).toContain('unknown');
    expect(nodes[3].className).toContain('passed');
  });
});
