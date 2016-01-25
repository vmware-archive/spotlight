class DashboardsController < ApplicationController
  def index
    @dashboard = Dashboard.first
    @edit = params[:edit].present? && params[:edit] == 'true'
  end
end
