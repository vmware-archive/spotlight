const CiWidget = React.createClass({
  propTypes: {
    title: React.PropTypes.string.isRequired,
    uuid: React.PropTypes.string.isRequired,
    widget_path: React.PropTypes.string.isRequired
  },

  render: function() {
    return (
      <div className="ci-widget card-content" data-uuid={this.props.uuid}>
        <h4 className="card-title">{this.props.title}</h4>
        <table>
          <tbody>
            <tr>
              <td>Repository Name:</td>
              <td className="value repository_name"> - </td>
            </tr>
            <tr>
              <td> Last Build Committer: </td>
              <td className="value committer"> - </td>
            </tr>
            <tr>
              <td> Last Build Status: </td>
              <td className="value status"> - </td>
            </tr>
            <tr>
              <td> Last Build Time: </td>
              <td className="value last-build-at"> - </td>
            </tr>
          </tbody>
        </table>

        <div className="buttons edit-only">
          <a className="delete btn-floating waves-effect waves-light white-text red tooltipped"
            data-delay="20"
            data-tooltip="Remove Widget"
            data-confirm="You are about to permanently delete this widget. This change cannot be undone. Are you sure?"
            rel="nofollow"
            data-method="delete"
            href={this.props.widget_path}>

            <i className="tiny material-icons">delete</i>
          </a>
        </div>
      </div>
    );
  }
});
