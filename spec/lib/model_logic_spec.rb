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

  describe "published named scope" do
    it "should include published objects" do
      fun_item = Factory.create(:fun_item, :publishing_enabled => true)
      FunItem.published.should == [fun_item]
    end

    it "should not include any unpublished objects" do
      fun_item = Factory.create(:fun_item, :publishing_enabled => false)
      FunItem.published.should be_empty
    end

    # it "should not expose a published episode published an hour ago" do
    #   article = Factory.create(:episode, :is_hidden => false, :published_at => 1.hour.from_now, :published_until => nil)
    #   Episode.published.should == []
    # end

    it "should not include objects with a published_until in the past" do
      Factory.create(:fun_item,
                     :publishing_enabled => true,
                     :published_until => 5.seconds.ago)
      FunItem.published.should be_empty
    end

    it "should not include objects with a published_at in the future" do
      Factory.create(:fun_item,
                     :publishing_enabled => true,
                     :published_at => 5.seconds.from_now)
      FunItem.published.should be_empty
    end

    it "should get a new Time.now for each invocation of the named scope" do
      item = Factory.create(:fun_item,
                            :publishing_enabled => true,
                            :published_until => 10.days.from_now)
      mock_now = mock('now', :utc => 20.days.from_now, :to_f => 0)
      Time.stub(:now).and_return mock_now
      FunItem.published.should be_empty
    end

    it "should use the utc of the current time" do
      # Make sure utc is used, which is hard to test as a behaviour
      mock_now = mock('now')
      Time.stub(:now).and_return mock_now
      mock_now.should_receive(:utc).twice
      FunItem.published
    end

    describe "newest" do
      it "should be the most recently published object" do
        object2 = Factory.create(:fun_item, :publishing_enabled => true, :published_at => 2.days.ago)
        object1 = Factory.create(:fun_item, :publishing_enabled => true, :published_at => 1.days.ago)
        object3 = Factory.create(:fun_item, :publishing_enabled => true, :published_at => 3.days.ago)
        FunItem.published.newest.should == object1
      end
    end
    describe "oldest" do
      it "should be the object published the longest ago" do
        object2 = Factory.create(:fun_item, :publishing_enabled => true, :published_at => 2.days.ago)
        object1 = Factory.create(:fun_item, :publishing_enabled => true, :published_at => 1.days.ago)
        object3 = Factory.create(:fun_item, :publishing_enabled => true, :published_at => 3.days.ago)
        FunItem.published.oldest.should == object3
      end
    end
  end
end
