class Release006 < ActiveRecord::Migration
  def up
    create_table :rating_infos do |t|
      t.references :rating
      t.references :player

      t.boolean :won, :default => false

      t.integer :points, :default => 0
      t.integer :best_spree, :default => 0
      t.integer :success_3, :default => 0
      t.integer :success_2, :default => 0
      t.integer :success_1, :default => 0
      t.integer :fail_3, :default => 0
      t.integer :fail_2, :default => 0
      t.integer :fail_1, :default => 0

      t.timestamps
    end
  end

  def down
    drop_table :rating_infos
  end
end
