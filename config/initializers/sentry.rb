# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://def412573e2b44d39e73a130b09bb25a@o1069899.ingest.sentry.io/4506591637471232'
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
