class TwitterCount < ActiveRecord::Migration
  def change
    create_table :twitter_counts do |t|
      t.integer :current_followers_count
      t.timestamps null: false, index: true
    end
  end
end
