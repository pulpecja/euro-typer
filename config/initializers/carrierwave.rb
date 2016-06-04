require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.storage = :file
  config.root = Rails.root.join('public')
  config.cache_dir = Rails.root.join('tmp/carrierwave')
end