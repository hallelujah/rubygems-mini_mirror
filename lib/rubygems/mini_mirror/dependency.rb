module Gem
  module MiniMirror
    class Dependency

      attr_reader :dependency, :sources

      def initialize(name, requirements, sources = Gem.sources)
        @sources = sources
        @dependency = Gem::Dependency.new(name,requirements)
      end

      def method_missing(*args)
        @dependency.send(*args)
      end

    end
  end
end
