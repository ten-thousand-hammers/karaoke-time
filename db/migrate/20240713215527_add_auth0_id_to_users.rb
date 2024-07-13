class AddAuth0IdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :auth0_id, :string
  end
end
