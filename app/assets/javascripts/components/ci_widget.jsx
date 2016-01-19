var CiWidget = React.createClass({
  render: function() {
    return (
      <div className="ci-widget" data-uuid={this.props.uuid}>
        <h3>
          {this.props.title}
        </h3>
        <table>
          <tbody>
            <tr>
              <td>
                Repository Name:
              </td>
              <td className="value repository_name">
                -
              </td>
            </tr>
            <tr>
              <td>
                Last Build Committer:
              </td>
              <td className="value committer">
                -
              </td>
            </tr>
            <tr>
              <td>
                Last Build Status:
              </td>
              <td className="value status">
                -
              </td>
            </tr>
            <tr>
              <td>
                Last Build Time:
              </td>
              <td className="value last-build-at">
                -
              </td>
            </tr>
          </tbody>
        </table>
        <div className="bottom-row">
          <span className="delete">
            <a data-confirm="Are you sure you want to delete glean?" rel="nofollow" data-method="delete" href={this.props.widget_path}>X</a>
          </span>
        </div>
      </div>
    )
  }
});
