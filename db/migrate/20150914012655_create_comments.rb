class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      # 投票先記事ID（userテーブル外部キー）
      t.references :article, null:false
      
      # 投票ユーザーID（userテーブル外部キー）
      t.references :user, null:false
      
      # コメント
      t.text :comment, null:false
      
      t.timestamps null: false
    end
    
    add_index :comments, :article_id
    add_index :comments, :user_id
    add_foreign_key :comments, :articles
    add_foreign_key :comments, :users
  end
end
