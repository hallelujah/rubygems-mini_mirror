module Gem
  module MiniMirror
    module Cli

      # Load default gem configs of the system
      Gem::ConfigFile.new []

      DEFAULT_SOURCES = {:gemcutter => ['http://gemcutter.org'], :github => ['http://gems.github.com'], :default => Gem.sources}

      def initialize(runner, options)
        @options = options
        @runner ||= runner
        @sources = nil
        @dependencies ||= []
      end

      def gem(name, specs, options={})
        if specs.empty?
          specs = ['>=0']
        end
        specs.each do |spec|
          @dependencies << Gem::MiniMirror::Dependency.new(name,spec, options.delete(:source) || @sources, options)
        end
      end

      def source(*sources)
        @sources ||= []
        @sources |= sources.map{|s| DEFAULT_SOURCES[s] || s }.flatten
      end

      def resource(options={})
        errors = catch(:resource_load_error) do
          @runner.load_resource!(options)
          nil
        end
        if errors
          handle_error(errors)
        end
      end

      def load!
        return if @loaded
        @loaded = true
      end

      protected
      def handle_error(errors)
        # MiniMirror.ui.warn(errors.inspect)
        warn errors.inspect
      end

    end
  end
end
