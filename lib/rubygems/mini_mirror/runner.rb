module Gem
  module MiniMirror
    class Runner

      include Gem::MiniMirror::Finder
      attr_reader :specs

      def initialize
        @resource_handler = ResourceHandler.instance
        @dependencies = []
        @specs_list = Hash.new{|h,k| h[k] = Hash.new{ |h1,k1| h1[k1] = Hash.new}}
        @specs = []
        @dependencies_list = Hash.new{|h,k| h[k] = Hash.new}
        @to_fetch = {}
        @resources = []
        @resources_signatures = {}
      end

      def load_resource!(options)
       klass = @resource_handler.find(options)
       resource = klass.new(self, options)
       unless @resources_signatures[resource.tag]
         resource.load!
         @resources << resource
         @resources_signatures[resource.tag] = true
       end
      end

      def load_all!
        return if @loaded
        @resources.each do |r|
          add_to_deps *r.dependencies
        end
        @loaded = true
        find_all_specs
      end

      def self.run(file)
        runner = new
        Gem::MiniMirror::Resources::RubyFileResource.new(runner,:path => file)
        runner.load_all!
        puts "Installing following gems"
        puts runner.specs
      end

    end
  end
end
