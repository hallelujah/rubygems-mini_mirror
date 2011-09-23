require 'rubygems'
require "rubygems/mini_mirror/version"
require "rubygems/array_ext"
require 'yaml'

module Gem
  module MiniMirror
    autoload :Runner, 'rubygems/mini_mirror/runner'
    autoload :Cli, 'rubygems/mini_mirror/cli'
    autoload :Finder, 'rubygems/mini_mirror/finder'
    autoload :Resource, 'rubygems/mini_mirror/resource'
    autoload :Dependency, 'rubygems/mini_mirror/dependency'
    autoload :ResourceHandler, 'rubygems/mini_mirror/resource_handler'
    autoload :Resources, 'rubygems/mini_mirror/resources'
    autoload :Runner, 'rubygems/mini_mirror/runner'

    def self.resources_handler
      ResourceHandler.instance
    end
  end
end
