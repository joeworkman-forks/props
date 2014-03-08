#########################################
# NB: only load on demand
#  we do NOT want to pull in activerecord gem/dep for simple scripts

# rubygems / 3rd party libs

require 'active_record'   ## todo: add sqlite3? etc.

# our own code

require 'props/db/schema'
require 'props/db/models'


module ConfDb

  def self.banner
    # todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL??
    "confdb/#{ConfUtils::VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.create
    CreateDb.new.up
  end


  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting props table records/data...'
    Model::Prop.delete_all
  end # method delete!

##  def self.stats   ## remove ? -- duplicate - use tables - why?? why not????
##    puts "#{Model::Prop} props"
##  end

  def self.tables
    puts "#{Model::Prop} props"
  end

end # module ConfDb



puts ConfDb.banner    # say hello
