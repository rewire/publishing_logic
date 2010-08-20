require 'rubygems'
gem 'rspec'
gem 'rspec-rails'
gem 'factory_girl'
gem 'activesupport'
gem 'activerecord'
gem 'database_cleaner'

require 'factory_girl'
require 'active_support'
require 'active_record'

# We don't need all of spec/rails - just the bits that're to do with ActiveRecord

require 'active_support/test_case'
require 'active_record/fixtures' if defined?(ActiveRecord::Base)

require 'spec/test/unit'

require "spec/rails/example/model_example_group"
require 'spec/rails/extensions/spec/matchers/have'

require 'spec/rails/matchers/ar_be_valid'
require 'spec/rails/matchers/change'

require 'spec/rails/mocks'

require 'spec/rails/extensions/active_support/test_case'
require 'spec/rails/extensions/active_record/base'

require 'spec/rails/interop/testcase'

Spec::Example::ExampleGroupFactory.default(ActiveSupport::TestCase)

require 'publishing_logic'

require 'logger'
ActiveRecord::Base.logger = Logger.new("test.log")

# Time zone setup Publishing Logic assumes that you've properly set up your timezones.
Time.zone_default = Time.send(:get_zone, 'UTC')
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :utc

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# require 'publishing_logic'
# require 'spec'
# require 'spec/autorun'

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Spec::Runner.configure do |config|
end
