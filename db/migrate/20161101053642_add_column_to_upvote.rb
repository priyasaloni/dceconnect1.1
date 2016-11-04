class AddColumnToUpvote < ActiveRecord::Migration
  def change
  	add_column :upvotes, :nol, :integer
    add_column :upvotes, :flag, :boolean
  end
end
