# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'material_raingular/websocket/version'

Gem::Specification.new do |spec|
  spec.name          = "material_raingular-websocket"
  spec.version       = MaterialRaingular::Websocket::VERSION
  spec.authors       = ["Chris Moody"]
  spec.email         = ["cmoody.eit@gmail.com"]

  spec.summary       = %q{Integration of MaterialRaingular and Websocket-Rails.}
  spec.homepage      = "https://github.com/transcon/material_raingular-websocket"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "material_raingular"
  # spec.add_dependency "websocket-rails"
  spec.add_development_dependency "flying_table"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'minitest-reporters',  '>= 1.0.1'
  spec.add_development_dependency 'sqlite3'
end
