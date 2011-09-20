module Gem
  module MiniMirror
    module Cli

      def initialize(runner, options)
        @options = options
        @runner ||= runner
        @sources = nil
        @dependencies ||= []
      end

      def gem(name,specs, options={})
        specs.each do |spec|
          @dependencies << Gem::MiniMirror::Dependency.new(name,spec, options.delete(:source) || @sources, options)
        end
      end

      def source(*sources)
        @sources ||= []
        @sources |= sources
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

      def handle_error(errors)
        # MiniMirror.ui.warn(errors.inspect)
      end

    end
  end
end
