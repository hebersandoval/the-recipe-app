class Recipe < ActiveRecord::Base
  has_many :reviews
  has_many :users, :through :reviews, dependent: :destroy
end
