require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe 'Using publishing logic on models with no published until field' do
  def create_objects_with_different_published_at_dates
    @object2 = Factory.create(:article, :publishing_enabled => true, :published_at => 2.days.ago)
    @object1 = Factory.create(:article, :publishing_enabled => true, :published_at => 1.days.ago)
    @object3 = Factory.create(:article, :publishing_enabled => true, :published_at => 3.days.ago)
  end

  describe "published?" do
    describe "with publishing enabled" do
      it "should be published by default" do
        Factory.create(:article,
                       :publishing_enabled => true,
                       :published_at => nil).should be_published
      end

      it "should not be published if the published_at datetime is in the future" do
        Factory.create(:article,
                       :publishing_enabled => true,
                       :published_at => 5.seconds.from_now).should_not be_published
      end
    end
    describe "with publishing disabled" do
      it "should not be published" do
        Factory.create(:article,
                       :publishing_enabled => false,
                       :published_at => 1.days.ago).should_not be_published
      end
    end
  end

  describe "published named scope" do
    it "should include published objects" do
      article = Factory.create(:article, :publishing_enabled => true)
      Article.published.should == [article]
    end

    it "should not include any unpublished objects" do
      Factory.create(:article, :publishing_enabled => false)
      Article.published.should be_empty
    end

    it "should not include objects with a published_at in the future" do
      Factory.create(:article,
                     :publishing_enabled => true,
                     :published_at => 5.seconds.from_now)
      Article.published.should be_empty
    end

    it "should get a new Time.now for each invocation of the named scope" do
      mock_now = mock('now', :utc => 20.days.from_now, :to_f => 0)
      Time.stub(:now).and_return mock_now
      Article.published
    end

    it "should use the utc of the current time" do
      # Make sure utc is used, which is hard to test as a behaviour
      mock_now = mock('now')
      Time.stub(:now).and_return mock_now
      mock_now.should_receive(:utc).once
      Article.published
    end

    describe "newest" do
      before do
        create_objects_with_different_published_at_dates
      end

      it "should be the most recently published object" do
        Article.published.newest.should == @object1
      end
    end

    describe "oldest" do
      it "should be the object published the longest ago" do
        Article.published.oldest.should == @object3
      end
    end
  end

  describe "ordering by published_at" do
    describe "by date oldest first" do
      it "should return the items, oldest first" do
        create_objects_with_different_published_at_dates
        Article.by_date_oldest_first.map(&:id).should == [@object3,
                                                          @object2,
                                                          @object1].map(&:id)
      end

      it "should order by created_at date if published_ats are equal" do
        create_objects_with_different_published_at_dates
        @object2b = Factory.create(:article,
                                   :publishing_enabled => true,
                                   :published_at => @object2.published_at,
                                   :created_at => 3.days.ago)
        Article.by_date_oldest_first.map(&:id).should == [@object3,
                                                          @object2b,
                                                          @object2,
                                                          @object1].map(&:id)
      end
    end

    describe "by date newest first" do
      it "should return the items, oldest first" do
        create_objects_with_different_published_at_dates
        Article.by_date_newest_first.map(&:id).should == [@object1,
                                                          @object2,
                                                          @object3].map(&:id)
      end

      it "should order by created_at date if published_ats are equal" do
        create_objects_with_different_published_at_dates
        @object2b = Factory.create(:article,
                                   :publishing_enabled => true,
                                   :published_at => @object2.published_at,
                                   :created_at => 3.days.from_now)
        Article.by_date_newest_first.map(&:id).should == [@object1,
                                                          @object2b,
                                                          @object2,
                                                          @object3].map(&:id)
      end
    end

    it "should have a newest first ordering that is the reverse of the oldest first ordering for identical objects" do
      creation_time = 2.days.ago
      publish_time = 1.days.ago
      5.times { Factory.create(:article, :created_at => creation_time, :published_at => publish_time) }
      Article.by_date_newest_first.map(&:id).should == Article.by_date_oldest_first.map(&:id).reverse
    end
  end
end
