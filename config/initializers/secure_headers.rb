::SecureHeaders::Configuration.configure do |config|
  config.hsts = "max-age=#{20.years.to_i}; includeSubdomains; preload"
  config.x_frame_options = 'sameorigin'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = '1; mode=block'
  config.csp = {
    default_src: []
  }
end
