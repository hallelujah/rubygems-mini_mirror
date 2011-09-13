module Gem
  module MiniMirror
    class Dependency

      attr_reader :dependency, :sources_uri

      def initialize(name, spec, sources_uri)
        @sources_uri = sources_uri
        @dependency = Gem::Dependency.new(name,spec)
      end

      def method_missing(*args)
        @dependency.send(*args)
      end

    end
  end
end
