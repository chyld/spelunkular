class AddImagesTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :url
      t.boolean :viewed, :default => false
      t.timestamps
    end
  end
end
