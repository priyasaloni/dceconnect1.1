class AddWeightcolumnToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :category_table_weight_new, :float
  end
end
