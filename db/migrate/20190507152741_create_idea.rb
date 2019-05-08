class CreateIdea < ActiveRecord::Migration[6.0]
  def change
    create_table :ideas do |t|
      t.string :content, limit: 255, null:false
      t.integer :impact, null:false
      t.integer :ease, null:false
      t.integer :confidence, null:false
      t.timestamps
    end 
  end
end
