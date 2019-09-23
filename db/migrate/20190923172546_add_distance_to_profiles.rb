class AddDistanceToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :distance, :integer
  end
end
