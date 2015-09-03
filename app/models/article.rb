class Article < ActiveRecord::Base
  paginates_per 10
  
  validates :title,
    presence: true,
    length: { maximum: 50 }
    
  validates :description,
    presence: true
end
