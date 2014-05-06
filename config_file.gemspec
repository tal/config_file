# -*- encoding: utf-8 -*-
require File.expand_path('../lib/config_file/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tal Atlas"]
  gem.email         = ["me@tal.by"]
  gem.description   = %q{Gem for quickly reading from config files}
  gem.summary       = %q{Gem for quickly reading from config files}
  gem.homepage      = "http://github.com/talby/config_file"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "config_file"
  gem.require_paths = ["lib"]
  gem.version       = ConfigFile::VERSION

  gem.add_development_dependency('rspec')
end
