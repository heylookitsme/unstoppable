class AddTimeZoneToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :time_zone, :string
  end
end
