class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.references :user
      t.text :data
      t.references :post

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
