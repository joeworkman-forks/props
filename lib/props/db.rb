#########################################
# NB: only load on demand
#  we do NOT want to pull in activerecord gem/dep for simple scripts

# rubygems / 3rd party libs

require 'active_record'   ## todo: add sqlite3? etc.

# our own code

require 'props/db/models'
require 'props/db/schema'
require 'props/db/deleter'


module ConfDb

  def self.banner
    "confdb #{ConfUtils::VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.create
    CreateDb.new.up
  end

  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting props table records/data...'
    Deleter.new.run
  end # method delete!

  def self.stats
    # to be done
  end


end # module ConfDb


# say hello
puts ConfDb.banner
