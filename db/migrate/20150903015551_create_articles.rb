class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      # 作成ユーザーID（userテーブル外部キー）
      t.references :user, null:false
      
      # 記事タイトル
      t.string :title, null: false
      
      # 記事本文
      t.text :description
      
      # 公開日時
      t.datetime :released_at
      
      # ステータス
      t.string :status, null: false, default: "draft" # 状態

      t.timestamps null: false
    end
    
    add_index :articles, :user_id
  end
end
