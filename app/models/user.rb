class User < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :recipes, dependent: :destroy

  has_secure_password

  private

  # Convert email to all lower-case
  def downcase_email
    self.email = email.downcase
  end
end
