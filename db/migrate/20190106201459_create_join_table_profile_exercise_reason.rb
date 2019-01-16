class CreateJoinTableProfileExerciseReason < ActiveRecord::Migration[5.0]
  def change
    create_table :exercise_reasons_profiles do |t|
      t.integer "exercise_reason_id"
      t.integer "profile_id"
    end
  end
end
