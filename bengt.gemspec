# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bengt/version'

Gem::Specification.new do |spec|
  spec.name          = "bengt"
  spec.version       = Bengt::VERSION
  spec.authors       = ["Magnus Skog"]
  spec.email         = ["magnus.m.skog@gmail.com"]
  spec.summary       = "For Reddit"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'aws-sdk',  '~> 2.0'
  spec.add_runtime_dependency 'slack-notifier', '~> 1.2'
  spec.add_runtime_dependency 'virtus', '~> 1.0'
  spec.add_runtime_dependency 'faraday', '~> 0.9'
  spec.add_runtime_dependency 'ruby-thumbor', '~> 1.3.0'
  spec.add_runtime_dependency 'pusher', '~> 0.14'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rspec-given', '~> 3.7'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'pry-byebug', '~> 3.1'
end
