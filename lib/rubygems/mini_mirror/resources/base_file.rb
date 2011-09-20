module Gem
  module MiniMirror
    module Resources
      class BaseFile
        include Gem::MiniMirror::Resource

        def initialize(runner, options)
          path = File.expand_path(options[:path])
          throw :resource_load_error, :path => path unless File.exist?(path)
          @path = path
          super
        end
        
        def tag
          'path-' + @path
        end
      end
    end
  end
end
