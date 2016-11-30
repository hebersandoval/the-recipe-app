class Recipe < ActiveRecord::Base
  has_many :instructions
  has_many :reviews
  has_many :users, through: :reviews, dependent: :destroy

  has_many :pantries
  has_many :ingredients, through: :pantries

  has_many :recipe_categories
  has_many :categories, through: :recipe_categories

  accepts_nested_attributes_for :ingredients
end
