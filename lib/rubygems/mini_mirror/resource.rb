module Gem
  module MiniMirror

    module Resource

      def self.included(base)
        base.class_eval do
          attr_accessor :sources
          attr_reader :dependencies
          include Gem::MiniMirror::Cli
          extend ClassMethods
        end
      end

      module  ClassMethods
        def register(options={})
          Gem::MiniMirror.resources_handler.add(self, options[:type], options[:ext])
        end
      end

      def tag
        @options.to_s
      end

    end
  end
end
