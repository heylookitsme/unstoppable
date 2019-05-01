class AddReferredByToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :referred_by, :string
  end
end
