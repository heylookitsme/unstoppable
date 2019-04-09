class AddModeratedToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :moderated, :boolean, :default => false
  end
end
