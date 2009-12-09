require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require 'model_logic'

class FunItem < ActiveRecord::Base
  include PublishingLogic::ModelLogic
end

Factory.define :fun_item do |c|
end

describe PublishingLogic::ModelLogic do
  it "should be published by default" do
    # Factory.create(:fun_item, :publishing_enabled => true).should be_published
    Factory.create(:fun_item).should be_published
  end
end
