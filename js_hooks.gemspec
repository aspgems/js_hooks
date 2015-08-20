# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'js_hooks/version'

Gem::Specification.new do |spec|
  spec.name          = 'js_hooks'
  spec.version       = Jshooks::VERSION
  spec.authors       = ['Francisco R. Santos']
  spec.email         = ['frsantos@aspgems.com']
  spec.description   = %q{Manages JavaScript hooks for Rails controllers and views}
  spec.summary       = %q{Manages JavaScript hooks for Rails controllers and views}
  spec.homepage      = 'https://github.com/aspgems/js_hooks'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4.0.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
