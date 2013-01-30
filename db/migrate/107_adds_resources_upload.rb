class AddsResourcesUpload < ActiveRecord::Migration
  class Resource < ActiveRecord::Base
  end

  def up
    require "fileutils"

    rename_column :resources, :filename, :upload

    if CarrierWave.configure { |config| config.storage == CarrierWave::Storage::File }
      old_path = Rails.root.join("public", "files")
      cw_path = Rails.root.join("public", "files", "resource")

      Resource.find_each do |resource|
        upload_attribute = resource.read_attribute(:upload)

        if File.exists?(old_path.join(upload_attribute)) && !File.exists?(cw_path.join(resource.id.to_s, upload_attribute))
          puts "Copying old resource file #{upload_attribute}..."

          FileUtils.mkdir_p(cw_path.join(resource.id.to_s)) unless File.exists?(cw_path.join(resource.id.to_s))
          FileUtils.cp(old_path.join(upload_attribute), cw_path.join(resource.id.to_s))
          %w(thumb medium).each do |size|
            next unless File.exists?(old_path.join("#{size}_#{upload_attribute}")) && !File.exists?(cw_path.join(resource.id.to_s, "#{size}_#{upload_attribute}"))
            FileUtils.cp(old_path.join("#{size}_#{upload_attribute}"), cw_path.join(resource.id.to_s))
          end
        end
      end
    end
  end

  def down
    rename_column :resources, :upload, :filename
  end
end
