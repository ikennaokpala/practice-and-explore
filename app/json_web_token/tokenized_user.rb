class TokenizedUser < ActiveModelSerializers::Model
  def self.call(user)
    new(user: user).call
  end

  attr_accessor :user

  def initialize(attributes = {})
    super
    @user = attributes.fetch(:user)
  end

  def call
    credentials
    self
  end

  def jwt
    credentials[:access]
  end

  def refresh_token
    credentials[:refresh]
  end

  private

  def credentials
    @credentials ||= JWTSessions::Session.new(payload: payload).login
  end

  def payload
    @payload ||= user.as_json.slice('id', 'email', 'name')
  end
end
