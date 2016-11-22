class Recipe < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews, dependent: :destroy

  has_many :pantries
  has_many :ingredients, through: :pantries
end
