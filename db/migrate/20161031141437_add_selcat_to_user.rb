class AddSelcatToUser < ActiveRecord::Migration
  def change
    add_column :users, :selected_category, :boolean , default: 'false'
  end
end
