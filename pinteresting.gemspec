# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pinteresting/version'

Gem::Specification.new do |gem|
  gem.name          = "pinteresting"
  gem.version       = Pinteresting::VERSION
  gem.authors       = ["Kendra Osburn", "Ryan Urabe"]
  gem.email         = ["kdosburn@gmail.com"]
  gem.description   = %q{Pin it. Pin it good.}
  gem.summary       = %q{Oh! So Pinteresting!}
  gem.homepage      = "https://github.com/kdosburn/pinteresting"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('mechanize')
end
