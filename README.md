# Rubygems Mini Mirror

This gem aims at providing a way to mirror only some gems you want from rubygems.

Create a minigems file

```ruby
# minigems
source :gemcutter
gem 'rails', ['~> 1.2.0','>= 3.0']
gem 'mislav-will_paginate', ['= 2.3.11'], :source => 'http://gems.github.com'
# You can also provide a resource file which provide a list of gems
# The filetype is guessed by the extension of the file and can be overriden.
# :type option can be :yaml, :ruby
resource :path => '/Users/hallelujah/repos/mini_gems.yml', :type => 'yaml'
```

The princips
------------

This nice DSL is mainly inspired by Bundler, so it should be familiar to you.

```ruby
# Fetching rails with version 1.2.3 and 2.3.5 with runtime and development dependencies
# By default development dependencies are not fetched
# *WARNING* fetching dependencies may be a slow process !! Use it with caution.
gem 'rails', ['= 1.2.3', '2.3.5'], :development => true

# If you just want to fetch development dependencies for 1.2.3 version, you need separated definitions :
gem 'rails', ['= 1.2.3', '2.3.5'], :development => true
gem 'rails', ['2.3.5']

# To add another resource file :
resource :path => 'development_gems.yml'
```

Building your own resource handler is also easy

```ruby
# You can build your own resource handler :
# my_resource_handler.rb

require 'mysql'
require 'activerecord'
class MyResourceHandler

  # db_gems table structure
  # name: string
  # requirements: text
  # sources: text
  # development: boolean
  class DbGem < ActiveRecord::Base
    serialize :sources, Array
    serialize :requirements, Array
  end

  include Gem::MiniMirror::Resource
  register :type => 'activerecord', :ext => ['.mysql']

  def initialize(runner, options)
    super
    @config = YAML.load_file(@path).with_indifferent_access
    sources(*options[:sources])
    DbGem.establish_connection @config[:db]
  end

  def load!
    super
    DbGem.all.each do |g|
      gem g.name, g.requirements, :source => g.sources, :development => g.development?
    end
  end
end
```

```yaml
# database.yml

sources: :gemcutter
db:
    adapter: mysql
    database: mini_mirror
    host: localhost
    username: root
    password:
```

```ruby
# Usage :
require 'rubygems/mini_mirror'
require 'my_resource_handler'
Gem::MiniMirror::Runner.run :path => 'database.yml', :type => 'activerecord'
```



# Note on Patches/Pull Requests

* Fork the project.

* Make your feature addition or bug fix.

* Add tests for it. This is important so I don’t break it in a future version unintentionally.

* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)

* Send me a pull request. Bonus points for topic branches.

# Copyright

Copyright &copy; 2011 Ramihajamalala Hery. See LICENSE for details

