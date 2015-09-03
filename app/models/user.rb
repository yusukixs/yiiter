class User < ActiveRecord::Base
  paginates_per 10
  
  validates :account_name,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { maximum: 16 },
    format: { with: /\A[a-z0-9]+\z/i, message: :invalid_account_name }
    
  validates :full_name,
    presence: true,
    length: { maximum: 20 }
    
  validates :password,
    presence: { on: :create },
    length: { minimum: 6 },
    confirmation: { allow_blank: true }
    
  attr_accessor :password, :password_confirmation
  
  def password=(val)
    if val.present?
      self.hashed_password = BCrypt::Password.create(val)
    end
    @password = val
  end
  
  
  class << self
    def authenticate(account_name, password)
      user = find_by(account_name: account_name)
      if user && user.hashed_password.present? &&
        BCrypt::Password.new(user.hashed_password) == password
        user
      else
        nil
      end
    end
  end
end
