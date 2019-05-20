class AddUserToIdea < ActiveRecord::Migration[6.0]
  def change
    add_reference :ideas, :user, foreign_key: true
  end
end
