Jumpup::Heroku.configure do |config|
  config.app = 'votweb'
end if Rails.env.development?
