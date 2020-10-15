# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inhouse_events/version'

Gem::Specification.new do |spec|
  spec.name          = 'inhouse_events'
  spec.version       = InhouseEvents::VERSION
  spec.authors       = ['lefs']
  spec.summary       = 'Web analytics for Rails applications.'
  spec.description   = 'Web analytics for Rails applications.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'combustion', '~> 1.3'
  spec.add_development_dependency 'rspec-rails', '~> 3.9.1'
  spec.add_development_dependency 'capybara', '~> 2.18'
  spec.add_development_dependency 'ammeter', '~> 1.1.2'
  spec.add_development_dependency 'sucker_punch', '~> 1.3.2'
  spec.add_development_dependency 'teaspoon', '~> 1.1.5'
  spec.add_development_dependency 'teaspoon-jasmine', '~> 2.3.4'
  spec.add_development_dependency 'factory_girl', '~> 4.8.0'
  spec.add_development_dependency 'sidekiq', '~> 3.3.1'
  spec.add_development_dependency 'webmock', '~> 3.8.3'
  spec.add_development_dependency 'appraisal', '~> 2.3'
  spec.add_development_dependency 'poltergeist', '~> 1.6.0'

  spec.add_dependency 'rails', '>= 4.2'
end
