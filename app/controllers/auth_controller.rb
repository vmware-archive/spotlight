class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:login]

  def login
    google_user = GoogleProfileService.get_profile user_params.fetch(:access_token)

    if is_pivotal? google_user
      user = User.find_or_create_by(google_user.slice(:name, :email))

      render json: {auth_token: user.auth_token}, status: :created
    else
      render json: {error: 'This is not a valid pivotal email.'}, status: :forbidden
    end
  end

  private

  def user_params
    params.permit(:access_token)
  end

  def is_pivotal? user
    user.has_key?(:email) && user.fetch(:email).ends_with?('@pivotal.io')
  end
end
