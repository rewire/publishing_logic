require 'publishing_logic/version'
require 'publishing_logic/model_logic'

if defined?(I18n)
  I18n.load_path << File.dirname(__FILE__) + '/locale/en.yml'
  I18n.load_path << File.dirname(__FILE__) + '/locale/hu.yml'
end
