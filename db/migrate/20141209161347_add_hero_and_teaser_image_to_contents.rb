class AddHeroAndTeaserImageToContents < ActiveRecord::Migration
  def change
    add_column :contents, :hero_image, :string
    add_column :contents, :hero_image_alt_text, :string
    add_column :contents, :teaser_image, :string
    add_column :contents, :teaser_image_alt_text, :string
  end
end
