class Post < ActiveRecord::Base
	belongs_to :user
    belongs_to :category

    has_many :upvotes
    has_many :users, through: :upvotes

end
