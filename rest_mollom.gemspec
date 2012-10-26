# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rest_mollom/version', __FILE__)

Gem::Specification.new do |gem|
   gem.name          = "rest_mollom"
   gem.version       = RestMollom::VERSION
   gem.platform      = Gem::Platform::RUBY
   gem.summary       = 'A Ruby wrapper for Mollom Rest API'
   gem.authors       = ["Hernan Fernandez"]
   gem.email         = ['hfernandez@intergi.com']
   gem.homepage      = ""

   gem.files         = `git ls-files`.split($\)
   gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
   gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

   gem.add_runtime_dependency  'oauth'
   gem.add_runtime_dependency  'json'  
   gem.require_paths = ["lib"]
end
