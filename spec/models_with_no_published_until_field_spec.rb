require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
require 'general_model_logic'

describe 'Using publishing logic on models with no published until field' do
  describe "published?" do
    describe "with publishing enabled" do
      it "should be published by default" do
        make_article(:publishing_enabled => true,
                     :published_at => nil).should be_published
      end

      it "should not be published if the published_at datetime is in the future" do
        make_article(:publishing_enabled => true,
                     :published_at => 5.seconds.from_now).should_not be_published
      end
    end
    describe "with publishing disabled" do
      it "should not be published" do
        make_article(:publishing_enabled => false,
                     :published_at => 1.days.ago).should_not be_published
      end
    end
  end

  describe "published scope" do
    it "should include published objects" do
      article = make_article(:publishing_enabled => true)
      Article.published.should == [article]
    end

    it "should not include any unpublished objects" do
      make_article(:publishing_enabled => false)
      Article.published.should be_empty
    end

    it "should not include objects with a published_at in the future" do
      make_article(:publishing_enabled => true,
                   :published_at => 5.seconds.from_now)
      Article.published.should be_empty
    end
  end

  describe 'generally' do
    before do
      @class = Article
    end

    it_should_behave_like 'a model with publish logic'
  end
end
