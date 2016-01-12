class WidgetsController < ApplicationController
  before_action :set_widget, only: [:show, :update, :destroy]

  # GET /widgets/1
  def show
    return render 'ci_widget'
  end

  # GET /widgets/new
  def new
    @widget = Widget.new
  end

  # POST /widgets
  def create
    @widget = Widget.new(widget_params)

    @widget.dashboard = default_dashboard

    if @widget.save
      return redirect_to @widget, notice: 'Widget was successfully created.'
    else
      return render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:title)
    end

    def default_dashboard
      Dashboard.first
    end
end
