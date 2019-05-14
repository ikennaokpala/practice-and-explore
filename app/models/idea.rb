class Idea < ApplicationRecord
  AVERAGE_SCORE_SELECT = 'ideas.*, (impact + confidence + ease) / 3 as average_score'.freeze

  validates :content, presence: true, length: { maximum: 255 }
  validates :impact, :ease, :confidence, presence: true, inclusion: { in: 1..10 }

  scope :by_average_score, -> (offset) do
    select(AVERAGE_SCORE_SELECT)
      .page(offset)
      .order(average_score: :desc)
  end

  def average_score
    (impact + ease + confidence) / 3
  end
end
