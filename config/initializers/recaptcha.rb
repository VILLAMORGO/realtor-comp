Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.recaptcha_v3.recaptcha_site_key
  config.secret_key = Rails.application.credentials.recaptcha_v3.recaptcha_secret_key
end