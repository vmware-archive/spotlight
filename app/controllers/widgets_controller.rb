class WidgetsController < ApplicationController
  before_action :set_widget, only: [:edit, :update, :destroy]

  # GET /widgets/new
  def new
    @widget = Widget.new
  end

  # POST /widgets
  def create
    @widget = Widget.new(widget_params)

    @widget.dashboard = default_dashboard

    if @widget.save
      return redirect_to edit_widget_path(@widget), notice: 'Widget was successfully created.'
    else
      return render :new
    end
  end

  # GET /widgets/1/edit
  def edit
    return render 'ci_widget'
  end

  #PATCH update
  def update
    if @widget.update!(config_params(@widget.type))
      return redirect_to dashboards_path, notice: 'Widget configuration was successfully updated.'
    else
      return render :show
    end
  end

  #DELETE destroy
  def destroy
    if @widget.destroy!
      notice = 'Widget was successfully deleted.'
    else
      notice = 'Widget could not be deleted.'
    end

    redirect_to dashboards_path, notice: notice
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

    def config_params(widget_type)
      params.require(:ci_widget).permit(*widget_type.constantize.config_keys)
      #TODO: make this generic by wrapping widget configuration in a form helper
    end

    def default_dashboard
      Dashboard.first
    end
end
