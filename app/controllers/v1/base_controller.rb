class V1::BaseController < ApplicationController
  include JWTSessions::RailsAuthorization

  before_action :set_auth_header!

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWT::DecodeError, with: :not_authorized

  private

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  protected

  def set_auth_header!
    request.headers[JWTSessions.access_header] = x_access_token
  end

  def x_access_token
    @x_access_token ||= request.headers['X-Access-Token']
  end

  def jwt_credentials
    @jwt_credentails ||= params[:refresh_token].blank? ? JWT.decode(x_access_token, nil, false) : [{}]
  end

  def payload
    jwt_credentials.first
  end
end
