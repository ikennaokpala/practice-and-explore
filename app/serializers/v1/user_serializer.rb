class V1::UserSerializer < ActiveModel::Serializer
  attributes :jwt, :refresh_token

  def jwt
    session[:access]
  end

  def refresh_token
    session[:refresh]
  end

  private

  def session
    @session ||= JWTSessions::Session.new(payload: payload).login
  end

  def payload
    @payload ||= object.as_json.slice('id', 'email', 'name')
  end
end
