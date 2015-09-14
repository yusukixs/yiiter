class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validate do
    unless user
      errors.add(:base, :invalid)
    end
  end
end
