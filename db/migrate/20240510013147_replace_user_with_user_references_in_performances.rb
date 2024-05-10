class ReplaceUserWithUserReferencesInPerformances < ActiveRecord::Migration[7.1]
  def change
    remove_column :performances, :up_next_user, :string
    remove_column :performances, :now_playing_user, :string

    up_only do
      delete <<-SQL
        delete from performances
      SQL
    end

    add_reference :performances, :up_next_user, null: true, foreign_key: {to_table: :users}
    add_reference :performances, :now_playing_user, null: true, foreign_key: {to_table: :users}
  end
end
