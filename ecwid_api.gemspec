# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ecwid_api/version'

Gem::Specification.new do |spec|
  spec.name          = "ecwid_api"
  spec.version       = EcwidApi::VERSION
  spec.authors       = ["David Biehl"]
  spec.email         = ["me@davidbiehl.com"]
  spec.summary       = %q{A client for the Ecwid REST API}
  spec.description   = %q{A client for the Ecwid REST API in Ruby}
  spec.homepage      = "https://github.com/davidbiehl/ecwid_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 2.14", ">= 2.14.1"

  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"
end
