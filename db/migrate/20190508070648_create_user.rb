class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :password, null: false
    end
  end
end
