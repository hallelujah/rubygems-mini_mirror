module Gem
  module MiniMirror
    module Resources
      class RubyFileResource

        include Gem::MiniMirror::Resource
        register(:type => 'ruby', :ext => ['.rb'])

        def initialize(runner,options)
          path = options[:path]
          throw :resource_load_error, {:path => path} unless File.exist?(path)
          @path = path
          super
        end

        def load!
          instance_eval(File.read(@path),__FILE__,  __LINE__ + 1)
        end

        def tag
         'path-' + File.expand_path(@path)
        end
      end
    end
  end
end
