class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :username, presence: true

  scope :all_another_users, ->(user) { where.not(id: user.id) }

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.try(:email)
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      username = auth.info.try(:name)
      password = Devise.friendly_token[0, 20]
      user = User.new(username: username, email: email, password: password, password_confirmation: password)
      user.skip_confirmation! if auth.provider == 'facebook'
      user.save
      user.create_authorization(auth) if user.persisted?
    end
    user
  end

  def author?(resource)
    resource.user_id == id ? true : false
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
