class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:get_auth_token]

  def get_auth_token
    token_info = get_token_info(auth_params)

    if for_spotlight?(token_info) && for_pivotal_email?(token_info)
      user = User.find_or_create_by(email: token_info.email)

      render json: {auth_token: user.auth_token}, status: :created
    else
      render json: {error: 'This is not a valid Pivotal email.'}, status: :forbidden
    end
  rescue Google::Apis::ClientError
    render json: {error: 'Invalid token'}, status: :forbidden
  end

  private

  def auth_params
    params.permit(:id_token)
  end

  def get_token_info(params)
    GoogleTokenInfoService.new.get_token_info params.fetch(:id_token)
  end

  def for_spotlight?(token_info)
    token_info.audience == ENV.fetch('GOOGLE_API_CLIENT_ID')
  end

  def for_pivotal_email?(token_info)
    token_info.email.ends_with?('@pivotal.io')
  end
end
