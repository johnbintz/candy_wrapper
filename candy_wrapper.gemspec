# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'candy_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "candy_wrapper"
  spec.version       = CandyWrapper::VERSION
  spec.authors       = ["John Bintz"]
  spec.email         = ["john@coswellproductions.com"]
  spec.description   = %q{Use form objects with ease.}
  spec.summary       = %q{Use form objects with ease.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency 'activesupport'
end

