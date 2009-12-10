require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require 'model_logic'

class FunItem < ActiveRecord::Base
  include PublishingLogic::ModelLogic
end

Factory.define :fun_item do |c|
end

describe PublishingLogic::ModelLogic do
  describe "published?" do
    describe "with publishing enabled" do
      it "should be published by default" do
        Factory.create(:fun_item,
                       :publishing_enabled => true,
                       :published_at => nil,
                       :published_until => nil).should be_published
      end

      it "should not be published if the published_at datetime is in the future" do
        Factory.create(:fun_item,
                       :publishing_enabled => true,
                       :published_at => 5.seconds.from_now,
                       :published_until => nil).should_not be_published
      end

      it "should not be published if the published_until datetime is in the past" do
        Factory.create(:fun_item,
                       :publishing_enabled => true,
                       :published_at => nil,
                       :published_until => 5.seconds.ago).should_not be_published
      end
    end
    describe "with publishing disabled" do
      it "should not be published" do
        Factory.create(:fun_item,
                       :publishing_enabled => false,
                       :published_at => 1.days.ago,
                       :published_until => 10.days.from_now).should_not be_published
      end
    end
  end
end
