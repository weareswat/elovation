class Release006 < ActiveRecord::Migration
  def up
    create_table :result_infos do |t|
      t.references :result
      t.references :player

      t.boolean :won, :default => false

      t.integer :points, :default => 0
      t.integer :best_spree
      t.integer :success_3
      t.integer :success_2
      t.integer :success_1
      t.integer :fail_3
      t.integer :fail_2
      t.integer :fail_1
      t.integer :tie_breaker

      t.timestamps
    end
  end

  def down
    drop_table :rating_infos
  end
end
