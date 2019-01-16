class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.date :dob
      t.string :zipcode
      t.string :other_favorite_activities
      t.string :fitness_level
      t.string :cancer_location
      t.string :prefered_exercise_location
      t.string :prefered_exercise_time
      t.string :reason_for_match
      t.string :treatment_status
      t.string :treatment_description
      t.string :personality
      t.string :work_status
      t.string :details_about_self
      t.string :other_cancer_location
      t.boolean :part_of_wellness_program 
      t.string :which_wellness_program  
      

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
