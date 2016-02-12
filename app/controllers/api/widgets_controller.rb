class Api::WidgetsController < Api::BaseController
  before_action :set_widget, only: [:destroy]

  def destroy
    if @widget && @widget.destroy!
      return render json: {notice: 'Widget deleted'}
    end
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def set_widget
    @widget = Widget.where(id: params[:id]).first
  end
end
