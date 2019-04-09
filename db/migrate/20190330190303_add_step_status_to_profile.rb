class AddStepStatusToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :step_status, :string
  end
end
