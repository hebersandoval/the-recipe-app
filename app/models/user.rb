class User < ActiveRecord::Base
  has_many :reviews
  has_many :recipes, through: :reviews, dependent: :destroy
end
