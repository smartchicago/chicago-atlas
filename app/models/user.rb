class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :zxcvbnable

  has_many :uploaders, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :email
end
