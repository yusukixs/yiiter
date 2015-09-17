class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validates :comment,
    presence: true

  validate do
    unless user
      errors.add(:base, :invalid)
    end
  end
end
