
# core and stlibs

require 'yaml'
require 'pp'
require 'logger'
require 'optparse'
require 'fileutils'



class Env

  def self.home
    path = if( ENV['HOME'] || ENV['USERPROFILE'] )
             ENV['HOME'] || ENV['USERPROFILE']
           elsif( ENV['HOMEDRIVE'] && ENV['HOMEPATH'] )
             "#{ENV['HOMEDRIVE']}#{ENV['HOMEPATH']}"
           else
             begin
                File.expand_path('~')
             rescue
                if File::ALT_SEPARATOR
                   'C:/'
                else
                   '/'
                end
              end
            end
      
    puts "env home=>#{path}<"
    path
  end

end # class Env


class Props

  VERSION = '0.1.0'

  attr_reader :path
  attr_reader :parent
    
  def initialize( hash, path, parent=nil)
    @hash   = hash
    @path   = path
    @parent = parent
  end
    
  def self.load_file( path, parent=nil )
    h = YAML.load_file( path )
    puts "dump of >#{path}<:"
    pp h    # todo: add debug flag (turn off for default)
    Props.new( h, path, parent )
  end
    
  def [](key)  get( key );  end
    
  def fetch(key, default)
    value = get( key )
    value.nil? ? default : value
  end

private
  def get( key )
    value = @hash[ key.to_s ]
    # if not found try lookup in parent hash
    (value.nil? && parent) ? parent[key] : value
  end
    
end # class props