class PhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def filename
    binding.pry
  end

  def store_dir
    binding.pry
    "/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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
