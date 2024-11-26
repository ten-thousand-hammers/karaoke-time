class AddProblemFieldsToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :file_problem, :boolean
    add_column :songs, :not_embeddable, :boolean
  end
end
