Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # User letter opener to open email in browser rather than sending.
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    authentication: :plain,
    address: "smtp.mailgun.org",
    port: 587,
    domain: "sandbox3bc19c1c6c0a4cb68396eb0faae48aec.mailgun.org",
    user_name: "postmaster@sandbox3bc19c1c6c0a4cb68396eb0faae48aec.mailgun.org",
    password: "f7455917d97c8c785e1d1bf8030ad589 "
  }
  config.action_mailer.default_url_options = { :host => 'localhost' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true
  config.action_controller.include_all_helpers = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
