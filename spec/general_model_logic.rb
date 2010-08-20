shared_examples_for 'a model with publish logic' do
  def create_objects_with_different_published_at_dates(for_class)
    factory_name = for_class.name.underscore.to_sym
    @object2 = Factory.create(factory_name, :publishing_enabled => true, :published_at => 2.days.ago)
    @object1 = Factory.create(factory_name, :publishing_enabled => true, :published_at => 1.days.ago)
    @object3 = Factory.create(factory_name, :publishing_enabled => true, :published_at => 3.days.ago)
  end

  describe "ordering by published_at" do
    describe "from the published scope" do
      before do
        create_objects_with_different_published_at_dates(@class)
      end

      describe "newest first" do
        it "should be the most recently published object" do
          @class.published.newest.should == @object1
        end
      end

      describe "oldest first" do
        it "should be the object published the longest ago" do
          @class.published.oldest.should == @object3
        end
      end
    end

    describe "by publication date oldest first" do
      before do
        create_objects_with_different_published_at_dates(@class)
      end

      it "should return the items, oldest first" do
        @class.by_publication_date_oldest_first.map(&:id).should == [@object3,
                                                                     @object2,
                                                                     @object1].map(&:id)
      end

      it "should order by created_at date if published_ats are equal" do
        @object2b = Factory.create(@class.name.underscore.to_sym,
                                   :publishing_enabled => true,
                                   :published_at => @object2.published_at,
                                   :created_at => 3.days.ago)
        @class.by_publication_date_oldest_first.map(&:id).should == [@object3,
                                                                     @object2b,
                                                                     @object2,
                                                                     @object1].map(&:id)
      end

      it 'should have deprecated by_date_oldest_first' do
        assert_deprecated do
          @class.by_date_oldest_first
        end
      end
    end

    describe "by publication date newest first" do
      before do
        create_objects_with_different_published_at_dates(@class)
      end

      it "should return the items, newest first" do
        @class.by_publication_date_newest_first.map(&:id).should == [@object1,
                                                                     @object2,
                                                                     @object3].map(&:id)
      end

      it "should order by created_at date if published_ats are equal" do
        @object2b = Factory.create(@class.name.underscore.to_sym,
                                   :publishing_enabled => true,
                                   :published_at => @object2.published_at,
                                   :created_at => 3.days.from_now)
        @class.by_publication_date_newest_first.map(&:id).should == [@object1,
                                                                     @object2b,
                                                                     @object2,
                                                                     @object3].map(&:id)
      end

      it 'should have deprecated by_date_newest_first' do
        assert_deprecated do
          @class.by_date_newest_first
        end
      end
    end

    it "should have a newest first ordering that is the reverse of the oldest first ordering for identical objects" do
      creation_time = 2.days.ago
      publish_time = 1.days.ago
      5.times { Factory.create(@class.name.underscore.to_sym, :created_at => creation_time, :published_at => publish_time) }
      @class.by_publication_date_newest_first.map(&:id).should == @class.by_publication_date_oldest_first.map(&:id).reverse
    end
  end
end
