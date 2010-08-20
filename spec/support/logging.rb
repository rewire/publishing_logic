require 'logger'
ActiveRecord::Base.logger = Logger.new("test.log")
