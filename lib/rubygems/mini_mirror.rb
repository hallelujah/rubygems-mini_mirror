require "mini_mirror/version"
require 'rubygems'
require 'yaml'

module Gem
  class MiniMirror

    attr_reader :specs

    def initialize(file)
      @dependencies = []
      @specs_list = Hash.new{|h,k| h[k] = Hash.new{ |h1,k1| h1[k1] = Hash.new}}
      @specs = []
      @dependencies_list = Hash.new{|h,k| h[k] = Hash.new}
      @to_fetch = {}

      hash = YAML.load_file(file)
      hash.each do |gem_name,specs|
        specs.each do |s|
          @dependencies << Gem::Dependency.new(gem_name, s)
        end
      end
    end

    def find_all_specs
      @dependencies.each do |dep|
        found, errors = Gem::SpecFetcher.fetcher.fetch_with_errors dep, true, false
        found.each do |spec,source_uri|
          next if is_in_specs?(spec)
          add_to_specs(spec,source_uri)
          add_to_deps(*spec.dependencies)
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

    def self.run(file)
      mini_mirror = new(file)
      mini_mirror.find_all_specs
      puts "Gems to install"
      gems = mini_mirror.specs.map(&:first)
      puts gems
      puts gems.size
    end
  end
end
