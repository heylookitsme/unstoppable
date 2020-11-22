class AddSearchParamsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :search_params, :text
  end
end
