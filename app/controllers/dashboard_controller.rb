class DashboardController < ApplicationController
  def index
    @dashboard = Dashboard.first
  end
end
