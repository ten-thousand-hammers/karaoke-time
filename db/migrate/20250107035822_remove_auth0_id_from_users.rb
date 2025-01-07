class RemoveAuth0IdFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :auth0_id, :string
  end
end
