Factory.define :programme do |p|
  p.publishing_enabled { true }
  p.published_at { Date.yesterday }
  p.published_until { Date.tomorrow }
end

Factory.define :article do |p|
  p.publishing_enabled { true }
  p.published_at { Date.yesterday }
end