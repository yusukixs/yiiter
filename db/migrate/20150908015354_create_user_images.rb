class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_images do |t|
      # ユーザーID（userテーブル外部キー）
      t.references :user, null:false
      
      # 画像データ
      t.binary :data
      
      # MIMEタイプ
      t.string :content_type

      t.timestamps null: false
    end
    
    add_index :user_images, :user_id
    add_foreign_key :user_images, :users
  end
end
