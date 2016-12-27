class Instruction < ActiveRecord::Base
  belongs_to :recipe

  validates :content, presence: true
end
