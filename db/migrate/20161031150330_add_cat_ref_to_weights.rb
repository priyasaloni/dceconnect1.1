class AddCatRefToWeights < ActiveRecord::Migration
  def change
    add_reference :weights, :category, index: true, foreign_key: true
  end
end
