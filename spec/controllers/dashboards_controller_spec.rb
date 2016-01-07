require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let!(:dashboard) { FactoryGirl.create :dashboard, title:'Default Dashboard' }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns default dashboard" do
      get :index
      expect(assigns(:dashboard)).to be
      expect(assigns(:dashboard).title).to eq dashboard.title
    end
  end
end
