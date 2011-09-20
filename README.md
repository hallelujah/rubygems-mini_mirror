# Rubygems Mini Mirror

This gem aims at providing a way to mirror only some gems you want from rubygems.

Create a minigems file

    # minigems

    source :gemcutter

    gem 'rails', ['~> 1.2.0','>= 3.0']

    gem 'mislav-will_paginate', ['= 2.3.11'], :source => 'http://gems.github.com'

    # You can also provide a resource file which provide a list of gems
    # The filetype is guessed by the extension of the file and can be overriden.
    # :type option can be :yaml, :ruby
    resource :path => '/Users/hallelujah/repos/mini_gems.yml', :type => 'yaml'


The princips
------------

This nice DSL is mainly inspired by Bundler, so it will not be unfamiliar to you.

# Note on Patches/Pull Requests

* Fork the project.

* Make your feature addition or bug fix.

* Add tests for it. This is important so I don’t break it in a future version unintentionally.

* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)

* Send me a pull request. Bonus points for topic branches.

# Copyright

Copyright &copy; 2011 Ramihajamalala Hery. See LICENSE for details

