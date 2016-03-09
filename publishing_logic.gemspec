# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'publishing_logic/version'

Gem::Specification.new do |spec|
  spec.name          = "publishing_logic"
  spec.version       = PublishingLogic::VERSION
  spec.authors       = ["Unboxed Consulting", "Attila Györffy"]
  spec.email         = ["enquiries@unboxedconsulting.com"]

  spec.summary       = %q{Publishing logic for ActiveRecord models}
  spec.description   = %q{Publishing logic for ActiveRecord models}
  spec.homepage      = "https://github.com/unboxed/publishing_logic"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'activerecord', ">= 3.0.0"
  spec.add_development_dependency 'database_cleaner', ">= 0.5.0"
  spec.add_development_dependency 'sqlite3'
end
