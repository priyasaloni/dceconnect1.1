class AddWeightSelectedToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :weight_selected, :float
  end
end
