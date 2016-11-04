class AddCatToUpvote < ActiveRecord::Migration
  def change
  	add_column :upvotes, :category_id, :integer
  end
end
