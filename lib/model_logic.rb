module PublishingLogic
  module ModelLogic
    PUBLISHED_CONDITIONS = <<EOT
publishing_enabled = true AND
(published_until is null or published_until > ?) AND
(published_at is null or published_at < ?)
EOT

    def published?
      return false if published_at && Time.now < published_at
      return false if published_until && Time.now > published_until
      publishing_enabled?
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.instance_eval do
        named_scope :published, lambda {{ :conditions => [PUBLISHED_CONDITIONS, Time.now.utc, Time.now.utc] }} do
          def newest
            find(:first, :order => "published_at DESC")
          end

          def oldest
            find(:last, :order => "published_at DESC")
          end
        end

        # If objects have identical published_at values, order by created_at. If these are
        # identical as well, then order by id. This is done to ensure there is a unique
        # ordering of objects, ordering by newest and oldest should result in arrays that are
        # the inverse of the other.
        named_scope :by_date_oldest_first, :order => 'published_at ASC, created_at ASC, id ASC'
        named_scope :by_date_newest_first, :order => 'published_at DESC, created_at DESC, id DESC'
      end
    end

    module ClassMethods
    end

  end
end
