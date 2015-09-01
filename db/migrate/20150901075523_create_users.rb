class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_name
      t.string :full_name
      t.string :password
      t.string :email
      t.boolean :administrator

      t.timestamps null: false
    end
  end
end
