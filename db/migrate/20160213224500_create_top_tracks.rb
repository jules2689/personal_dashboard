class CreateTopTracks < ActiveRecord::Migration
  def change
    create_table :top_tracks do |t|
      t.string :rank
      t.string :name, index: true
      t.string :duration
      t.string :playcount
      t.string :mbid, index: true
      t.string :url, index: true
      t.references :artist, index: true
      t.timestamps null: false
    end
  end
end
