class V1::BaseController < ApplicationController
  protected

  def x_access_token
    @x_access_token ||= request.headers["HTTP_HEADERS"][:'X-Access-Token']
  end

  def jwt_credentials
    x_access_token.blank? ? [{}] : JWT.decode(x_access_token, nil, false)
  end

  def payload
    jwt_credentials.first
  end
end
