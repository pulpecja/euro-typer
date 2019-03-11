class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :aws

  def store_dir
    case Rails.env
    when 'test'
      "uploads/test/#{@model.class.name.downcase}/photo/test_photo/"
    when 'development'
      "uploads/development/#{@model.class.name.downcase}/photo/#{@model.id}"
    when 'production'
      "uploads/production/#{@model.class.name.downcase}/photo/#{@model.id}"
    else
      "uploads/all/#{@model.class.name.downcase}/#{@model.id}"
    end
  end

  version :mini do
    resize_to_fit(50, 50)
  end

  version :thumb do
    resize_to_fit(100, 100)
  end

  version :medium do
    resize_to_fit(200, 200)
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end
end
