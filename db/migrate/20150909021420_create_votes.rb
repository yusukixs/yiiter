class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      # 投票先記事ID（userテーブル外部キー）
      t.references :article, null:false
      
      # 投票ユーザーID（userテーブル外部キー）
      t.references :user, null:false

      t.timestamps null: false
    end
    
    add_index :votes, :article_id
    add_index :votes, :user_id
    add_foreign_key :votes, :articles
    add_foreign_key :votes, :users
  end
end
