class Ingredient < ActiveRecord::Base
  has_many :pantries
  has_many :recipes, through: :pantries, dependent: :destroy

  validates :name, presence: true
end
