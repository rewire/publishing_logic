require 'active_record'
require 'logger'

require 'publishing_logic'

ActiveRecord::Base.logger = Logger.new("test.log")

ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :utc

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
