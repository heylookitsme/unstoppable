class RemoveAvatarFromProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :avatar, :string
  end
end
