class AddWfToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :weight_selected_final, :float
  end
end
