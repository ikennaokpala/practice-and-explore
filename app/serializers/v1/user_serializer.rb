class V1::UserSerializer < ActiveModel::Serializer
  attributes :jwt, :refresh_token

  def jwt; end

  def refresh_token; end
end
