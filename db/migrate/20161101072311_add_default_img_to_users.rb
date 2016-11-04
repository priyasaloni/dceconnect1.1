class AddDefaultImgToUsers < ActiveRecord::Migration
  
  	def up
    change_column :users, :img, :string, :default => "/assets/default-user-image.png"
  end

  def down
    change_column :users, :img, :string, :default => "/assets/default-user-image.png"
  end
  
end
