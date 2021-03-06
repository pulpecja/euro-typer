require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EuroTyper
  class Application < Rails::Application
    config.i18n.default_locale = :pl
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('services')

    config.to_prepare do
      Dir[ File.expand_path(Rails.root.join('app/logic/*.rb')) ].each do |file|
        require_dependency file
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end

  ISO3166.configure do |config|
    config.locales = [:en, :pl]
  end
end
