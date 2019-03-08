class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  include CarrierWave::MiniMagick

  def public_id
    random_id = Cloudinary::Utils.random_public_id
    case Rails.env
    when 'test'
      "typerek/test/#{@model.class.name.downcase}/photo/" + random_id
    when 'development'
      "typerek/development/#{@model.class.name.downcase}/photo/" + random_id
    when 'production'
      "typerek/production/#{@model.class.name.downcase}/photo/" + random_id
    else
      "typerek/all/#{@model.class.name.downcase}/" + random_id
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
