class Idea < ApplicationRecord
  validates :content, presence: true, length: { maximum: 255 }
  validates :impact, :ease, :confidence, presence: true, inclusion: { in: 1..10 }

  def average_score
    (impact + ease + confidence) / 3
  end
end
