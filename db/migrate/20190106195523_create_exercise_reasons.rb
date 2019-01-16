class CreateExerciseReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :exercise_reasons do |t|
      t.string :name
      t.timestamps
    end
  end
end
