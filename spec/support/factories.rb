DEFAULT_ATTRS = {
  :publishing_enabled => true,
  :published_at => Date.yesterday
}

def make(klass, attrs = {})
  __send__("make_#{klass.name.downcase}", attrs)
end

def make_programme(attrs = {})
  default = DEFAULT_ATTRS.merge({
    :published_until => Date.tomorrow
  })
  Programme.create(default.merge(attrs))
end

def make_article(attrs = {})
  Article.create(DEFAULT_ATTRS.merge(attrs))
end
