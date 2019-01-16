class CreateActivitiesProfilesJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :activities_profiles do |t|
      t.integer "profile_id"
      t.integer "activity_id"
    end
  end
end
