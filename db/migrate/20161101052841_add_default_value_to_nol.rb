class AddDefaultValueToNol < ActiveRecord::Migration
    def up
    change_column :posts, :nol, :integer, :default => 0
  end

  def down
    change_column :posts, :nol, :integer, :default => nil
  end
end
