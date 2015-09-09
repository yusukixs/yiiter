class Vote < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validate do
    unless user && user.votable_for?(article)
      errors.add(:base, :invalid)
    end
  end
end
