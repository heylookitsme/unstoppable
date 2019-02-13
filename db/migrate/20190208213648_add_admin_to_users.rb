class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
  end

  # Initialize first account:
  User.create! do |u|
    u.username = "admin"
    u.email     = 'test@test.com'
    u.password    = 'password'
  end 
end
