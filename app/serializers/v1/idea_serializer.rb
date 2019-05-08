class V1::IdeaSerializer < ActiveModel::Serializer
  attributes :id, :content, :impact, :ease, :confidence, :average_score, :created_at

  def created_at
    object.created_at.to_i
  end
end
