require 'rubygems/mini_mirror/resources'
module Gem
  module MiniMirror
    class Runner

      include Gem::MiniMirror::Finder
      attr_reader :specs, :resource_handler
      DEFAULT_GEMS_DIR = File.join(Gem.user_home, '.gem', 'mirror')

      def initialize(options = {})
        @resource_handler = ResourceHandler.instance
        @dependencies = []
        @specs_list = Hash.new{|h,k| h[k] = Hash.new{ |h1,k1| h1[k1] = Hash.new}}
        @specs = []
        @dependencies_list = Hash.new{|h,k| h[k] = Hash.new}
        @to_fetch = {}
        @resources = []
        @resources_signatures = {}
        @pool = Gem::MiniMirror::Pool.new(options[:pool_size] || Gem::MiniMirror::POOL_SIZE)
        @gems_dir = options[:gems_dir] || DEFAULT_GEMS_DIR
        @fetcher = Gem::MiniMirror::Fetcher.new
        super
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

      def from(*args)
        File.join(*args)
      end

      def to(*args)
        File.join(@gems_dir,*args)
      end

      def existing_gems
        Dir[to('gems','.*gem')].entries.map{|f| File.basename(f)}
      end

      def gems_with_sources
        load_all!
        @gems_with_sources ||= Hash[*specs.map{|s,src| [s.full_name + '.gem', src] }.flatten]
      end

      def gems
        @gems ||= gems_with_sources.keys
      end

      def gems_to_fetch
        gems - existing_gems
      end

      def gems_to_delete
        existing_gems - gems
      end

      def update_gems
        gems_to_fetch.each do |g|
          @pool.job do
            @fetcher.fetch(from(gems_with_sources[g],'gems',g),to('gems',g))
          end
        end
      end

      def delete_gems
        gems_to_delete.each do |g|
          @pool.job do
            File.delete(to('gems',g))
          end
        end
      end

      def update
        update_gems
        delete_gems
        @pool.run_til_done
      end

      def self.run(file)
        runner = new
        runner.load_resource! :path => file, :type => 'ruby'
        runner.update
      end

      protected
      def load_all!
        return if @loaded
        @resources.each do |r|
          add_to_deps(*r.dependencies)
        end
        @loaded = true
        find_all_specs
      end



    end
  end
end
