module Gem
  module MiniMirror
    class Dependency

      attr_reader :dependency, :sources

      def initialize(name, spec, sources)
        @sources = sources
        @dependency = Gem::Dependency.new(name,spec)
      end

      def method_missing(*args)
        @dependency.send(*args)
      end

    end
  end
end
