module Gem
  module MiniMirror
    module Finder

      def find_all_specs
        @dependencies.each do |dep|
          with_sources dep.sources do
            found, errors = Gem::SpecFetcher.fetcher.fetch_with_errors dep, true, false
            found.each do |spec,source_uri|
              next if is_in_specs?(spec)
              add_to_specs(spec,source_uri)
              add_to_deps(*spec.dependencies)
            end
          end
        end
      end

      def add_to_specs(spec, source_uri)
        @specs.push([spec, source_uri])
        @specs_list[spec.platform.to_s][spec.name.to_s][spec.version.to_s] = true
      end

      def is_in_specs?(spec)
        @specs_list.key?(spec.platform.to_s) && @specs_list[spec.platform.to_s].key?(spec.name.to_s) && @specs_list[spec.platform.to_s][spec.name.to_s].has_key?(spec.version.to_s)
      end

      def add_to_deps(*deps)
        deps.each do |dep|
          next if is_in_deps?(dep)
          @dependencies_list[dep.name.to_s][dep.requirement.to_s] = true
          @dependencies.push(dep)
        end
      end

      def is_in_deps?(dep)
        @dependencies_list[dep.name.to_s][dep.requirement.to_s] == true
      end


      def with_sources(sources)
        puts "Changing sources to : #{sources}"
        before_sources = Gem.sources
        Gem.sources = sources
        yield
        Gem.sources = before_sources
      end

    end
  end
end
