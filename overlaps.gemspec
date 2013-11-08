# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'overlaps/version'

Gem::Specification.new do |spec|
  spec.name          = "overlaps"
  spec.version       = Overlaps::VERSION
  spec.authors       = ["Ryan Stenberg"]
  spec.email         = ["h0tl33t@gmail.com"]
  spec.description   = %q{Overlaps aids in finding shared overlaps between a set of Range or Range-like objects.}
  spec.summary       = %q{Overlaps lets you #find or #count overlaps in a given set of Range or Range-like objects.}
  spec.homepage      = "https://github.com/h0tl33t/overlaps"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
