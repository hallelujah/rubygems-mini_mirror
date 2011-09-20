module Gem
  module MiniMirror
    module Resources
      class RubyFile < BaseFile

        register(:type => 'ruby', :ext => ['.rb'])

        def load!
          instance_eval(File.read(@path),__FILE__,  __LINE__ + 1)
        end

      end
    end
  end
end
