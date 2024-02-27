# frozen_string_literal: true

# RAILS_ENV is set to 'production' for both stage and prod servers.
# We use LOCAL_DOMAIN to differentiate for better Sentry logging.
local_domain = ENV.fetch('LOCAL_DOMAIN', '')
sentry_dsn = ENV.fetch('SENTRY_DSN', '')

sentry_dsn.present? && Sentry.init do |config|
  config.dsn = sentry_dsn
  config.environment = if local_domain['mozilla.social']
                         'production'
                       elsif local_domain['stage']
                         'staging'
                       else
                         'development'
                       end

  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
