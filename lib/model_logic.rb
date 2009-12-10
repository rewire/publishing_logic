module PublishingLogic
  module ModelLogic
    def published?
      return false if published_at && Time.now < published_at
      return false if published_until && Time.now > published_until
      publishing_enabled?
    end
  end
end
