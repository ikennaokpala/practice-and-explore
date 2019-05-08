FactoryBot.define do
  factory :idea do
    content { SecureRandom.alphanumeric(122) }
    impact { rand(1..10) }
    ease { rand(1..10) }
    confidence { rand(1..10) }
  end
end
