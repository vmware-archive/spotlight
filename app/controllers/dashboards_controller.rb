class DashboardsController < ApplicationController
  def index
    @dashboard = Dashboard.first
  end
end
