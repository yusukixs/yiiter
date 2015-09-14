class User < ActiveRecord::Base
  # 1ページあたりの取得件数
  paginates_per 10
  
  # articleテーブルと1:N関係
  has_many :articles
  
  # 記事の投票先をユーザーと紐付け
  has_many :votes, dependent: :destroy
  has_many :voted_articles, through: :votes, source: :article
  
  # 記事のコメントをユーザーと紐付け
  has_many :comments, dependent: :destroy
  has_many :commented_articles, through: :comments, source: :article
  
  # user_imageテーブルと1:1関係
  has_one :image, class_name:"UserImage", dependent: :destroy
  
  accepts_nested_attributes_for :image, allow_destroy: true
  
  # アカウント名のバリデーション
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
  
  # パスワードのハッシュ化
  def password=(val)
    if val.present?
      self.hashed_password = BCrypt::Password.create(val)
    end
    @password = val
  end
  
  # 記事に投票できるかどうかをチェック
  def votable_for?(article)
    # 自分の記事には投票できない かつ　一つの記事に投票は一度しかできない
    article && article.author != self && !votes.exists?(article_id: article.id)
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
