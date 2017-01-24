class WidgetsController < ApplicationController
  before_action :set_widget, only: [:destroy]

  def new
    @widget = Widget.new(category: params[:category])
  end

  def create
    @widget = Widget.new(widget_params)
    @widget.dashboard = default_dashboard
    processed_widget_params = process_fields(config_params_for(@widget))
    @widget.assign_attributes(processed_widget_params)

    if @widget.save
      return redirect_to ENV['WEB_HOST'], notice: 'Widget was successfully created.'
    else
      return render :new
    end
  end

  def destroy
    if @widget.destroy!
      notice = 'Widget was successfully deleted.'
    else
      notice = 'Widget could not be deleted.'
    end

    redirect_to ENV['WEB_HOST'], notice: notice
  end

  private

  def process_fields(fields)
    fields.map do |field, value|
      field_format = @widget.category.fields[field.to_sym][:format]
      processed_value = field_format == 'csv' ? FieldParserService.new.csv_to_array(value) : value

      [field, processed_value]
    end.to_h
  end

  def set_widget
    @widget = Widget.find(params[:id])
  end

  def widget_params
    params.require(:widget).permit(:title, :category, :height, :width)
  end

  def config_params_for(widget)
    params.require(:widget).permit(*widget.category.fields.keys)
  end
end
