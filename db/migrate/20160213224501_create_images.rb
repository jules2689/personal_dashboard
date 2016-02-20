class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :size, index: true
      t.string :content
      t.references :top_track, index: true
      t.timestamps null: false
    end
  end
end
