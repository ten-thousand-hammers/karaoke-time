class AddUpNextInToPerformance < ActiveRecord::Migration[7.1]
  def change
    add_column :performances, :up_next_in, :integer
  end
end
