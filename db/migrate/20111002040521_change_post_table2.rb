class ChangePostTable2 < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.float :score_total
    end

  end

  def self.down
  end
end
