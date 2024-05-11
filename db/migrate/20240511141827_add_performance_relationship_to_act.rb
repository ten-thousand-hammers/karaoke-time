class AddPerformanceRelationshipToAct < ActiveRecord::Migration[7.1]
  def change
    add_reference :acts, :performance, null: true, foreign_key: true
  end
end
