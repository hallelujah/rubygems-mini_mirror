require 'yaml'
module Gem
  module MiniMirror
    module Resources
      class Yaml < BaseFile
        register(:type => 'yaml', :ext => ['.yml', '.yaml'])

        def load!
          super
          config = YAML.load_file(@path)
          config.each do |instructs|
            instructs.each do |k, args|
              send(k, *args)
            end
          end
        end

      end
    end
  end
end
