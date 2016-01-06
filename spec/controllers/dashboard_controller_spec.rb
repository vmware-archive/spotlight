require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns default dashboard" do
      get :index
      expect(assigns(:dashboard)).to be
      expect(assigns(:dashboard).title).to eq 'Default Dashboard'
    end
  end
end
