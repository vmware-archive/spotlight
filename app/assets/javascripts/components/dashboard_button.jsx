const DashboardButton = React.createClass({
  propTypes: {
    editOnly: React.PropTypes.bool.isRequired,
    action: React.PropTypes.oneOf(['edit', 'save', 'add']).isRequired,
    href: React.PropTypes.string.isRequired,
    onClick: React.PropTypes.func,
    tooltip: React.PropTypes.string
  },

  render: function() {
    const modeType = this.props.editOnly ? 'edit-only' : 'view-only';
    const buttonType = this.props.action + '-button';
    const buttonClass = [modeType, buttonType, 'fixed-action-btn'].join(' ');

    return (
      <div className={buttonClass}>
        <a className="btn-floating btn-large waves-effect waves-light red tooltipped"
          data-delay="20"
          data-position="top"
          onClick={this.props.onClick}
          data-tooltip={this.props.tooltip}
          href={this.props.href}>
          <i className="material-icons">{this.props.action}</i>
        </a>
      </div>
    );
  }
});
