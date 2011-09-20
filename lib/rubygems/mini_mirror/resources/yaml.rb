require 'yaml'
module Gem
  module MiniMirror
    module Resources
      class Yaml
        include Gem::MiniMirror::Resource
        register(:type => 'yaml', :ext => ['.yml', '.yaml'])

        def initialize(runner, options)
          path = File.expand_path(options[:path])
          throw :resource_load_error, :path => path unless File.exist?(path)
          @path = path
          super
        end

        def load!
          config = YAML.load_file(@path)
          config.each do |instructs|
            instructs.each do |k, args|
              send(k, *args)
            end
          end
        end

        def tag
          'path-' + @path
        end
      end
    end
  end
end
