class CreatePhotos < ActiveRecord::Migration
  drop_table :photos
  def change
    create_table :photos do |t|
      t.string :image
      t.string :image_uid
      t.string :image_name

      t.timestamps null: false
    end
  end
end
