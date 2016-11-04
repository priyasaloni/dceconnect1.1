class AddSelectedToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :selected, :boolean , :default => false
  end
end
