require 'singleton'
module Gem
  module MiniMirror
    class ResourceHandler
      class AlreadyRegistered < Exception
        def initialize(type)
          @type = type
        end
        def message
          "already registered #@type"
        end
      end

      class HandlerNotFound < Exception
        def initialize(options = {})
          @type = options[:type]
          @extension = options[:ext]
        end

        def message
          "could not find handler for file extension '#@extension'" + 
          @type.to_s.empty? ? "" : " or for file type #@type"
        end
      end

      include Singleton

      def initialize
        @handlers = {}
        @handlers_by_file_extension = {}
      end

      def add(klass, type, exts = [])
        raise AlreadyRegistered, type if @handlers.key?(type.to_s)
        @handlers[type.to_s] = klass
        exts.each do |ext|
          @handlers_by_file_extension[ext.to_s] = klass unless ext.to_s.empty?
        end
      end

      def find_handler_by_extension(ext)
        @handlers_by_file_extension[ext.to_s]
      end

      def find_handler_by_type(type)
        @handlers[type.to_s]
      end

      def find(options = {})
        unless options.key?(:ext)
          if path = options[:path]
            options[:ext] = File.extname(path)
          end
        end
        handler = find_handler_by_type(options[:type]) || find_handler_by_extension(options[:ext])
        raise HandlerNotFound, options unless handler
        handler
      end
    end

  end
end
