require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'general_model_logic'

describe 'Using publishing logic on models with all fields' do
  describe "validations" do
    it "should now allow the published_until to be before the published_at" do
      make_programme(:published_at => 2.days.ago,
                     :published_until => 3.days.ago).should_not be_valid
    end

    it "should allow the published_until to be the same as published_at" do
      make_programme(:published_at => 2.days.ago,
                     :published_until => 2.days.ago).should be_valid
    end

    it "should allow the published_until to be just after published_at" do
      make_programme(:published_at => 2.days.ago,
                     :published_until => 2.days.ago + 1.second).should be_valid
    end
  end

  describe "published?" do
    describe "with publishing enabled" do
      it "should be published by default" do
        make_programme(:publishing_enabled => true,
                       :published_at => nil,
                       :published_until => nil).should be_published
      end

      it "should not be published if the published_at datetime is in the future" do
        make_programme(:publishing_enabled => true,
                       :published_at => 5.seconds.from_now,
                       :published_until => nil).should_not be_published
      end

      it "should not be published if the published_until datetime is in the past" do
        make_programme(:publishing_enabled => true,
                       :published_at => nil,
                       :published_until => 5.seconds.ago).should_not be_published
      end
    end
    describe "with publishing disabled" do
      it "should not be published" do
        make_programme(:publishing_enabled => false,
                       :published_at => 1.days.ago,
                       :published_until => 10.days.from_now).should_not be_published
      end
    end
  end

  describe "published scope" do
    it "should include published objects" do
      programme = make_programme(:publishing_enabled => true)
      Programme.published.should == [programme]
    end

    it "should not include any unpublished objects" do
      make_programme(:publishing_enabled => false)
      Programme.published.should be_empty
    end

    it "should not include objects with a published_until in the past" do
      make_programme(:publishing_enabled => true,
                     :published_until => 5.seconds.ago)
      Programme.published.should be_empty
    end

    it "should not include objects with a published_at in the future" do
      make_programme(:publishing_enabled => true,
                     :published_at => 5.seconds.from_now)
      Programme.published.should be_empty
    end
  end

  describe 'generally' do
    before do
      @class = Programme
    end

    it_should_behave_like 'a model with publish logic'
  end
end
