class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :starts_at
      t.datetime :ends_at
    end

    create_table :events_profiles, id: false do |t|
      t.belongs_to :event
      t.belongs_to :profile
    end
  end
end
