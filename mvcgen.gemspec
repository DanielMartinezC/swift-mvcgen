# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'mvcgen/version'

Gem::Specification.new do |s|
  s.name        = 'mvcgen'
  s.version     = MVCgen::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Generates XCode MVC module controllers structure'
  s.email       = 'daniel@houlak.com'
  s.homepage    = 'https://github.com/DanielMartinezC/swift-utils'
  s.description = 'It saves time in the implementation of MVC, generating the controllers and adding interactions between them (in Swift)'
  s.authors     = ['Daniel Martinez']
  s.license     = 'MIT'

  # Files
  s.files         = Dir['LICENSE', 'README.md', 'lib/**/*']
  s.test_files    = Dir['spec/**/*.rb']
  s.require_path  = 'lib'

  # Dependencies
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'byebug'
  s.add_dependency 'thor'

  # Executables
  s.executables << 'mvcgen'
  s.bindir       = 'bin'   

  # Documentation
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = [
    'README.md'
  ]
  
end