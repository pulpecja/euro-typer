require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EuroTyper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.i18n.default_locale = :pl
    # config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('services')

    config.to_prepare do
      Dir[ File.expand_path(Rails.root.join('app/logic/*.rb')) ].each do |file|
        require_dependency file
      end
    end
    ISO3166.configure do |config|
      config.locales = [:en, :pl]
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
