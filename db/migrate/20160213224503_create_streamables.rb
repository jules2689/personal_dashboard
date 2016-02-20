class CreateStreamables < ActiveRecord::Migration
  def change
    create_table :streamables do |t|
      t.string :fulltrack
      t.string :content
      t.references :top_track, index: true
      t.timestamps null: false
    end
  end
end
