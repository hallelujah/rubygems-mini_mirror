module Gem
  module MiniMirror
    class Dependency

      attr_reader :dependency, :sources

      def initialize(name, requirements, *args)
        options = args.extract_options!
        srcs = args.empty? ? nil : args.flatten
        @sources = srcs || Gem.sources
        @dependency = Gem::Dependency.new(name,requirements)
        @development = !! options[:development]
        @all = !! (options[:all] || true)
      end

      def all?
        @all
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
