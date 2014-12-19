class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.boolean :active
      t.string :hero_image
      t.string :hero_image_alt_text

      t.timestamps
    end
  end
end
