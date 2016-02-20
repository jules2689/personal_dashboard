class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :remote_id, index: true
      t.string :name
      t.string :role
      t.string :image_url
      t.string :small_image_url
      t.string :link
      t.string :average_rating
      t.string :ratings_count
      t.string :text_reviews_count
      t.references :book, index: true
      t.timestamps null: false
    end
  end
end
