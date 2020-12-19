class CreateChatMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :chatroom_memberships do |t|
      t.datetime :last_read_at
      t.references :user, null: false, foreign_key: true
      t.references :chatroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
