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
      end
    end

    module ClassMethods
    end

  end
end
