class AddLikesToWeights < ActiveRecord::Migration
  def change
  	add_column :weights, :likes, :integer, :default => 0
  end
end
