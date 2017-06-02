require 'rails_helper'
require 'capybara/email/rspec'

Capybara.javascript_driver = :webkit

Capybara.server = :puma

OmniAuth.config.test_mode = true

RSpec.configure do |config|  
  config.include AcceptanceMacros, type: :feature 
  config.include WaitForAjax, type: :feature
  config.include OmniauthMacros, type: :feature
  config.include SphinxHelpers, type: :feature
  config.include JavascriptHelper, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
