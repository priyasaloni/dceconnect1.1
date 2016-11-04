class AddRatioToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :relative_ratio, :float 
  end
end
