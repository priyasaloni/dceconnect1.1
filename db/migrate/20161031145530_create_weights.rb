class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|

      t.timestamps null: false
    end
  end
end
