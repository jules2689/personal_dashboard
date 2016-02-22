class CreatePackGroups < ActiveRecord::Migration
  def change
    create_table :headspace_pack_groups do |t|
      t.boolean :is_elective
      t.integer :total_packs
      t.integer :no_of_packs
      t.string :colour
      t.string :remote_pack_group_id, index: true
      t.string :icon_url
      t.string :name
      t.string :ldpi_icon_url
      t.string :mdpi_icon_url
      t.string :hdpi_icon_url
      t.string :xhdpi_icon_url
      t.string :xxhdpi_icon_url
      t.references :headspace_stat, index: true
      t.timestamps null: false
    end
  end
end
