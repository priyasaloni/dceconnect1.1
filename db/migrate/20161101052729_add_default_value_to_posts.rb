class AddDefaultValueToPosts < ActiveRecord::Migration
  def up
    change_column :weights, :posts, :integer, :default => 0
  end

  def down
    change_column :weights, :posts, :integer, :default => nil
  end
end

