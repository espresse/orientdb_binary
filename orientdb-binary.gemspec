# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'orientdb_binary/config'

Gem::Specification.new do |spec|
  spec.name          = "orientdb-binary"
  spec.version       = OrientdbBinary::VERSION
  spec.authors       = ["Michal Ostrowski"]
  spec.email         = ["ostrowski.michal@gmail.com"]
  spec.summary       = %q{OrientDB native client for Ruby 2}
  spec.description   = %q{Graph Database OrientDB native client for Ruby}
  spec.homepage      = "http://orientdb-binary.espresse.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '~> 0'
end
