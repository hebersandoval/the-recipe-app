class Recipe < ActiveRecord::Base
  has_many :instructions
  has_many :reviews
  has_many :users, through: :reviews, dependent: :destroy

  has_many :pantries
  has_many :ingredients, through: :pantries

  accepts_nested_attributes_for :ingredients
end
