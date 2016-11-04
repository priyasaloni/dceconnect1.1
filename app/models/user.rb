class User < ActiveRecord::Base


    has_many :weights
    has_many :categories, through: :weights

     has_many :posts

    has_many :upvotes
    has_many :posts, through: :upvotes
    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

	def user_params
      params.require(:user).permit(:Name, :email, :password, :password_confirmation,:provider,:uid)
    end

        def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user| 
        	user.provider = auth.provider
        	user.uid = auth.uid
        	user.Name = auth.info.name
        	user.email = auth.info.email
            user.img = auth.info.image
        end
    end
    def self.new_with_session(params, session)
    	if session["devise.user_attributes"]
    		new(session["devise.user_attributes"], without_protection: true) do |user|
    			user.attributes = params
    			user.valid?
    		end
    	else
    		super
    	end

    end
    def password_required?
    	super && provider.blank?
    end
end
