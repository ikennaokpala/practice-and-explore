class Idea < ApplicationRecord
  def average_score
    (impact + ease + confidence) / 3
  end
end
