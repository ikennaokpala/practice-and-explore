class AddAvatarToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avatar_url, :string, default: 'https://www.gravatar.com/avatar/b36aafe03e05a85031fd8c411b69f792?d=mm&s=200'
  end
end
