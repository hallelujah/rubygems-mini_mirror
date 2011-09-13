# Rubygems Mini Mirror

This gem aims at providing a way to mirror only some gems you want from rubygems.

Create a minigems file

    # minigems

    source :gemcutter

    gem 'rails', ['~> 1.2.0','>= 3.0']

    gem 'mislav-will_paginate', ['= 2.3.11'], :source => 'http://gems.github.com'

    # You can also provide a file which provide a list of gems
    # The filetype is guessed by the extension of the file and can be overriden.
    # :type option can be :yml, :ruby
    file '/Users/hallelujah/repos/mini_gems.yml', :type => :yml
