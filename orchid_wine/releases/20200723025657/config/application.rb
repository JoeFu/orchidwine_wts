require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrchidWine
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :zh
    config.assets.enabled = false

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # time:zones[+8]
    config.time_zone = 'Adelaide'
    config.active_record.default_timezone = :local
  end
end

require File.expand_path('../const', __FILE__)

files = %w{components tests}
Dir.glob("app/{#{files.join(',')}}/*.rb").each { |file| require File.join(Rails.root, file) }

REDIS_SERVERS = YAML.load_file('config/redis.yml')
begin
    $redis = Redis.new(REDIS_SERVERS[Rails.env])
    $redis.get '1'
rescue 
    system "cd #{Rails.root} && redis-server config/redis/#{Rails.env}.conf"
    $redis = Redis.new(REDIS_SERVERS[Rails.env])
end
