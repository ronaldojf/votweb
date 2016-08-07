require 'simplecov'
require 'paperclip/matchers'

SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.around(:each) do |example|
    if example.metadata[:vcr] == false # Isso mesmo, tem que ser igual a false, outro valor não pode
      WebMock.allow_net_connect!
      VCR.turned_off { example.run }
      WebMock.disable_net_connect!
    else
      example.run
    end
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_files/"])
  end
end
