module Gem
  module MiniMirror
    class Dependency

      attr_reader :dependency, :sources

      def initialize(name, requirements, srcs = nil, options = {})
        @sources = srcs || Gem.sources
        @dependency = Gem::Dependency.new(name,requirements)
        @development = !! options[:development]
      end

      def development?
        @development
      end

      def method_missing(*args)
        @dependency.send(*args)
      end

    end
  end
end
