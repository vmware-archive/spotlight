var DashboardButton = React.createClass({
  render: function() {
    var modeType = this.props.editOnly ? 'edit-only': 'view-only';
    var buttonType = this.props.action + '-button'
    var buttonClass = [modeType , buttonType, "fixed-action-btn"].join(" ");

    return (
      <div className={buttonClass}>
        <a className="btn-floating btn-large waves-effect waves-light red tooltipped" data-delay="20" data-position="top" onClick={this.props.onClick} data-tooltip={this.props.tooltip} href={this.props.href}>
          <i className="material-icons">{this.props.action}</i>
        </a>
      </div>
    )
  }
});
