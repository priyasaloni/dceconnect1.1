class AddWeightTotalToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :weight_total, :float
  end
end
