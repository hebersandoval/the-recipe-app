class Recipe < ActiveRecord::Base
  has_many :instructions
  has_many :reviews
  has_many :users, through: :reviews, dependent: :destroy

  has_many :pantries
  has_many :ingredients, through: :pantries, dependent: :destroy

  has_many :recipe_categories
  has_many :categories, through: :recipe_categories, dependent: :destroy

  accepts_nested_attributes_for :instructions
  accepts_nested_attributes_for :ingredients
  # accepts_nested_attributes_for :categories

  def categories_attributes=(category_attributes)
    category_attributes.values.each do |category_attribute|
      category = Category.find_or_create_by(category_attribute)
      self.categories << category
    end
  end
end
