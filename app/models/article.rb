class Article < ActiveRecord::Base
  STATUS_VALUES = %w(draft member_only public)
  
  # 1ページあたりの取得件数
  paginates_per 10
  
  # 記事の作成ユーザーを"author"として紐付け
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  
  # 記事への投票をユーザーと紐付け
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user
  
  validates :title,
    presence: true,
    length: { maximum: 50 }
    
  #validates :description,
    #presence: true
    
  validates :status,
    inclusion: { in: STATUS_VALUES }
  
  # 全公開スコープ
  scope :common, -> { where(status: "public") }
  
  # 公開済みスコープ
  scope :published, -> { where("status <> ?", "draft") }
  
  # 全取得スコープ
  scope :full, ->(user) { where("status <> ? OR user_id = ?", "draft", user.id) }
  
  # アクセス可能スコープ
  scope :readable_for, ->(user) { user ? full(user) : common }
  
  class << self
    def status_text(status)
      I18n.t("activerecord.attributes.article.status_#{status}")
    end
    
    def status_options
      STATUS_VALUES.map { |status| [status_text(status), status] }
    end
    
    def sidebar_articles(user, num = 5)
      readable_for(user).order(released_at: :desc).limit(num)
    end
  end
end
