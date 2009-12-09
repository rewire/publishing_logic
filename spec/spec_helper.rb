# $LOAD_PATH.unshift(File.dirname(__FILE__))
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.join(File.dirname(__FILE__), "../../../../config/environment"))
require 'spec/rails'

require 'factory_girl'

# require 'publishing_logic'
# require 'spec'
# require 'spec/autorun'

class Programme < ActiveRecord::Base
end

Spec::Runner.configure do |config|
  
end
