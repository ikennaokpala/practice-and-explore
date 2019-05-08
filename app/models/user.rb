class User < ApplicationRecord
  validates :name, presence: :true
  validates :password, presence: :true, length: { minimum: 8 }, 
          format: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./
  validates :email, presence: :true, format: /\w+@\w+\.{1}[a-zA-Z]{2,}/
end
