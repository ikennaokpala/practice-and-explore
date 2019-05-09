class V1::TokenizedUserSerializer < ActiveModel::Serializer
  attributes :jwt, :refresh_token
end
