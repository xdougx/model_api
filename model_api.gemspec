# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'model_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'model_api'
  spec.version       = ModelApi::VERSION
  spec.authors       = ['Douglas Rossignolli']
  spec.email         = ['douglas@kanamobi.com.br']

  spec.summary       = 'This ruby gem is an adpter for Kanamobi`s API'
  spec.description   = 'This ruby gem is an adpter for Kanamobi`s API'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'activemodel'
  spec.add_runtime_dependency 'activesupport', '>= 5.0.1'
  spec.add_runtime_dependency 'json'
end
