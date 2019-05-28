class CreateLikesProfilesJoinTable < ActiveRecord::Migration[5.2]
  def change
  
   # create_table :likes_profiles do |t|
    #  t.integer "profile_id"
    #  t.integer "like_id"
   # end

    create_table :likes do |t|
      t.belongs_to :profile
      t.integer "like_id"
      t.timestamps
    end
  end
end
