class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name, index: true
      t.string :mbid, index: true
      t.string :url
      t.timestamps null: false
    end
  end
end
