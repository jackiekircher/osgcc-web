class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid
      t.string  :username
      t.string  :image_url
      t.boolean :admin, :default => false

      t.timestamps
    end

    add_index :users, :uid
  end
end
