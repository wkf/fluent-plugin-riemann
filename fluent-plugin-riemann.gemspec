# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-riemann"
  spec.version       = "0.0.1"
  spec.authors       = ["Will Farrell"]
  spec.email         = ["will@mojotech.com"]
  spec.summary       = %q{Riemann output plugin for Fluent}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/wkf/fluent-plugin-riemann"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'fluentd', '~> 0'
  spec.add_runtime_dependency 'riemann-client', '~> 0'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
