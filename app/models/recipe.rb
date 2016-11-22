class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :reviews
  has_many :users, :through :reviews, dependent: :destroy
end
