class Api::DashboardsController < Api::BaseController
  protect_from_forgery with: :null_session

  def index
    show
    render :show
  end

  def show
    @widgets = dashboard.widgets
  end

  def layout
    if layout_param.present?
      layout_param.each do |widget_layout|
        widget = dashboard.widgets.find{ |w| w.uuid == widget_layout['i'] }
        widget.update(width: widget_layout['w'],
                      height: widget_layout['h'],
                      position_x: widget_layout['x'],
                      position_y: widget_layout['y']) if widget
      end
    end

    @layout = layout_param
  end

  private

  def layout_param
    json_post = JSON.parse(request.raw_post)
    params.merge!(json_post)
    params.require(:layout)
  end

  def dashboard
    Dashboard.first
  end
end
