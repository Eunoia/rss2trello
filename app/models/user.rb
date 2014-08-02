class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:trello]

  def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_create do |user|
	  	raw_info = auth["extra"]["raw_info"]

	    user.email     = raw_info["email"]
	    user.password  = Devise.friendly_token[0,20]
	    # user.full_name = raw_info["fullName"]   # assuming the user model has a name

	    user.uid       = auth["uid"]
	    user.token     = auth["credentials"]["token"]
	    user.secret    = auth["credentials"]["secret"]


	    # user.image = auth.info.image # assuming the user model has an image
	  end
  end

  has_many :feeds
end
