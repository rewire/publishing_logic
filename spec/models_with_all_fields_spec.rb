require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'general_model_logic'

describe 'Using publishing logic on models with all fields' do
  describe "published?" do
    describe "with publishing enabled" do
      it "should be published by default" do
        Factory.create(:programme,
                       :publishing_enabled => true,
                       :published_at => nil,
                       :published_until => nil).should be_published
      end

      it "should not be published if the published_at datetime is in the future" do
        Factory.create(:programme,
                       :publishing_enabled => true,
                       :published_at => 5.seconds.from_now,
                       :published_until => nil).should_not be_published
      end

      it "should not be published if the published_until datetime is in the past" do
        Factory.create(:programme,
                       :publishing_enabled => true,
                       :published_at => nil,
                       :published_until => 5.seconds.ago).should_not be_published
      end
    end
    describe "with publishing disabled" do
      it "should not be published" do
        Factory.create(:programme,
                       :publishing_enabled => false,
                       :published_at => 1.days.ago,
                       :published_until => 10.days.from_now).should_not be_published
      end
    end
  end

  describe "published named scope" do
    it "should include published objects" do
      programme = Factory.create(:programme, :publishing_enabled => true)
      Programme.published.should == [programme]
    end

    it "should not include any unpublished objects" do
      Factory.create(:programme, :publishing_enabled => false)
      Programme.published.should be_empty
    end

    it "should not include objects with a published_until in the past" do
      Factory.create(:programme,
                     :publishing_enabled => true,
                     :published_until => 5.seconds.ago)
      Programme.published.should be_empty
    end

    it "should not include objects with a published_at in the future" do
      Factory.create(:programme,
                     :publishing_enabled => true,
                     :published_at => 5.seconds.from_now)
      Programme.published.should be_empty
    end

    it "should get a new Time.now for each invocation of the named scope" do
      mock_now = mock('now', :utc => 20.days.from_now, :to_f => 0)
      Time.stub(:now).and_return mock_now
      Programme.published
    end

    it "should use the utc of the current time" do
      # Make sure utc is used, which is hard to test as a behaviour
      mock_now = mock('now')
      Time.stub(:now).and_return mock_now
      mock_now.should_receive(:utc).twice
      Programme.published
    end
  end

  describe 'generally' do
    before do
      @class = Programme
    end

    it_should_behave_like 'a model with publish logic'
  end
end
