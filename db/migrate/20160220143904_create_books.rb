class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :remote_id, index: true
      t.integer :text_reviews_count
      t.string :format
      t.string :isbn13
      t.string :title
      t.string :image_url
      t.string :small_image_url
      t.string :large_image_url
      t.string :num_pages
      t.string :ratings_count
      t.string :rating
      t.string :link
      t.string :published
      t.string :publisher
      t.string :publication_day
      t.string :publication_year
      t.string :publication_month
      t.string :average_rating
      t.string :isbn
      t.string :edition_information
      t.text :description
      t.timestamps null: false
    end
  end
end
