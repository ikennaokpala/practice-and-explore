FactoryBot.define do
  factory :idea do
    content { SecureRandom.alphanumeric(122) }
    impact { rand(1..10) }
    ease { rand(1..10) }
    confidence { rand(1..10) }
  end

  factory :user do
    email { 'jack@example.org' }
    name { 'Jack Ma' }
    password { 'Password1' }
    avatar_url { 'https://www.gravatar.com/avatar/b36aafe03e05a85031fd8c411b69f792?d=mm&s=200' }
  end
end
