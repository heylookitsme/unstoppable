class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.string :phone_number

      t.belongs_to :user
      t.timestamps
    end
  end
end
