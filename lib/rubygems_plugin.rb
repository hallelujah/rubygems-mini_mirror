require 'rubygems/command_manager'
require 'rubygems/mini_mirror/version'
require 'rubygems/mini_mirror/command'

Gem::CommandManager.instance.register_command :mini_mirror
