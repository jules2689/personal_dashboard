class CreateTopTags < ActiveRecord::Migration
  def change
    create_table :top_tags do |t|
      t.string :name, index: true
      t.string :url
      t.timestamps null: false
    end

    create_table :top_tags_tracks, id: false do |t|
      t.references :top_track, index: true
      t.references :top_tag, index: true
      t.timestamps null: false
    end
  end
end
