class ReplaceUserWithUserReferencesInActs < ActiveRecord::Migration[7.1]
  def change
    remove_column :acts, :user, :string

    up_only do
      delete <<-SQL
        delete from acts
      SQL
    end

    add_reference :acts, :user, null: false, foreign_key: true
  end
end
