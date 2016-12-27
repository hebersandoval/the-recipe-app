class User < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :recipes, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 4 }

  private

  # Convert email to all lower-case
  def downcase_email
    self.email = email.downcase
  end
end
