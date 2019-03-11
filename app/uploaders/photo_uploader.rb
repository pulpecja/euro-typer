class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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
