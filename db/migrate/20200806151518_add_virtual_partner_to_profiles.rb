class AddVirtualPartnerToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :virtual_partner, :boolean, null: false, default: false
  end
end
