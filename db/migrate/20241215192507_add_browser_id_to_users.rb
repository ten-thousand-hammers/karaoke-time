class AddBrowserIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :browser_id, :string
  end
end
