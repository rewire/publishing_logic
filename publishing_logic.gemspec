# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Unboxed Consulting"]
  gem.email         = ["enquiries@unboxedconsulting.com"]
  gem.description   = %Q{Publishing logic for ActiveRecord models}
  gem.summary       = %Q{Publishing logic for ActiveRecord models}
  gem.homepage      = "https://github.com/unboxed/publishing_logic"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "publishing_logic"
  gem.require_paths = ["lib"]
  gem.version       = File.exist?('VERSION') ? File.read('VERSION') : ""

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'activesupport', ">= 3.0.0"
  gem.add_development_dependency 'activerecord', ">= 3.0.0"
  gem.add_development_dependency 'database_cleaner', ">= 0.5.0"
  gem.add_development_dependency 'sqlite3'
end
