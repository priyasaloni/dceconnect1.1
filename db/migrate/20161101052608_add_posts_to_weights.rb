class AddPostsToWeights < ActiveRecord::Migration
  def change
  	add_column :weights, :posts, :integer, :default => 0
  end
end
