require 'rubygems/mini_mirror'
require 'rubygems/command'
require 'yaml'

class Gem::Commands::MiniMirrorCommand < Gem::Command
  SUPPORTS_INFO_SIGNAL = Signal.list['INFO']

  def initialize
    super 'mirror', 'Mirror a gem repository'
    add_option '-c', '--config-file=FILE', 'the main config file' do |file, options|
      options[:path] = file
    end
    add_option '-t', '--file-type=FILETYPE', 'file type of config file if not guessed' do |t, options|
      options[:type] = t
    end
    add_option '-d', '--cd=DIR', 'directory to cd into before running the command' do |dir,options|
      options[:cd] = dir
    end
    add_option '-r', '--require=lib1,lib2', Array, 'A list of libs to require before running the command' do |libs, options|
      options[:libs] ||= []
      options[:libs].push(*libs)
    end
    add_option '-m', '--mirror-dir=MIRROR_DIR', 'The mirror root directory : whre to download gem files. Default to <Gem.user_home>/mirror' do |dir,options|
      options[:gems_dir] = dir
    end
    add_option '-p', '--pool-size=POOLSIZE', Integer, 'The number of threads in the pool : fro fetching concurrency. Default 10' do |pool, options|
      options[:pool_size] = pool
    end
  end

  def description # :nodoc:
    <<-EOF
The mini_mirror command mirrors remote gem
repositories to a local path. Not all the repository of rubygem is mirrored but only those you have chosen with their dependencies

  See https://github.com/hallelujah/rubygems-mini_mirror

    EOF
  end

  def execute
    Dir.chdir(options.delete(:cd) || '.') do
      if options[:requires]
        options[:requires].each do |lib|
          require lib
        end
      end
      mirror = Gem::MiniMirror::Runner.new(options)
      mirror.load_resource! options
      say "Total gems: #{mirror.gems.size}"
      num_to_fetch = mirror.gems_to_fetch.size
      progress = ui.progress_reporter num_to_fetch, "Fetching #{num_to_fetch} gems"
      trap(:INFO) { puts "Fetched: #{progress.count}/#{num_to_fetch}" } if SUPPORTS_INFO_SIGNAL
      mirror.update_gems { progress.updated true }
      num_to_delete = mirror.gems_to_delete.size
      progress = ui.progress_reporter num_to_delete, "Deleting #{num_to_delete} gems"
      trap(:INFO) { puts "Fetched: #{progress.count}/#{num_to_delete}" } if SUPPORTS_INFO_SIGNAL
      mirror.delete_gems { progress.updated true }
    end

  end
end
