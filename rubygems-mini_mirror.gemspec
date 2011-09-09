# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rubygems/mini_mirror/version"

Gem::Specification.new do |s|
  s.name        = "rubygems-mini_mirror"
  s.version     = Gem::MiniMirror::VERSION
  s.authors     = ["Ramihajamalala Hery"]
  s.email       = ["hery@rails-royce.org"]
  s.homepage    = ""
  s.summary     = %q{A rubygems mini mirror}
  s.description = %q{
  Mirror some version of gems with Gem::Version DSL
  Create a mini_gem file and add to it this :
  source :gemcutter
  gem 'rails', ['~> 1.2.0', '>= 3.0']

  or
  source :gemcutter
  file '/your_path/mini_gem.yml'

  # /your_path/mini_gem.yml

  rails:
    - '~> 1.2.0'
    - '>= 3.0'

  It will solve the dependencies for you so you don't have to write an exhaustive list of the gems you want to mirror
  }

  s.rubyforge_project = "rubygems-mini_mirror"
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
