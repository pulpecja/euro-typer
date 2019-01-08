class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # include Cloudinary::CarrierWave

  version :mini do
    process resize_to_fit: [50, 50]
  end

  version :thumb do
    process resize_to_fit: [100, 100]
  end

  version :medium do
    process resize_to_fit: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

end