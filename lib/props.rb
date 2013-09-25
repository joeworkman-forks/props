# encoding: utf-8

# core and stlibs

require 'yaml'
require 'pp'
require 'fileutils'
require 'erb'



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
     
    # todo: use logger - how?
    ## puts "env home=>#{path}<"
    
    path
  end

end # class Env


module INI

  def self.load_file( path )
    # returns a nested hash
    #  (compatible structure - works like YAML.load_file)

    text = File.open( path, 'r:bom|utf-8' ).read
    self.load( text )
  end


  def self.load( text )
    hash = top_hash = Hash.new

    text = text.gsub( "\t", ' ' )   # replace all tabs w/ spaces

    text.each_line do |line|

      ### skip comments
      #  e.g.   # this is a comment line
      #  or     ; this too
      #  or     --  haskell style
      #  or     %   text style

      if line =~ /^\s*#/ || line =~ /^\s*;/ || line =~ /^\s*--/ || line =~ /^\s*%/
        ## logger.debug 'skipping comment line'
        next
      end

      ### skip blank lines
      if line =~ /^\s*$/ 
        ## logger.debug 'skipping blank line'
        next
      end

      # pass 1) remove possible trailing eol comment
      ##  e.g    -> New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> New York

      line = line.sub( /\s+#.*$/, '' )

      # pass 2) remove leading and trailing whitespace
      
      line = line.strip
 
      ## check for new section e.g.  [planet012-xxx_bc]

      ### todo: allow _ or - in strict section key? why? why not??
      ###   allow _ or - in value key? why why not??
      if line =~ /^\s*\[\s*([a-z0-9_\-]+)\s*\]\s*$/   # strict section
        key = $1.to_s.dup
        hash = top_hash[ key ] = Hash.new
      elsif line =~ /^\s*\[\s*([^ \]]+)\s*\]\s*$/     # liberal section; allow everything in key
        key = $1.to_s.dup
        hash = top_hash[ key ] = Hash.new
      elsif line =~ /^\s*([a-z0-9_\-]+)\s*[:=](.*)$/
        key   = $1.to_s.dup
        value = $2.to_s.strip.dup   # check if it can be nil? if yes use blank string e.g. ''
        ### todo:  strip quotes from value??? why? why not?
        hash[ key ] = value
      else
        puts "*** warn: skipping unknown line type in ini >#{line}<"
      end
    end # each lines

    top_hash
  end # method load


end  # module INI



class Props

  VERSION = '1.0.1'

  attr_reader :path
  attr_reader :parent
    
  def initialize( hash, path, parent=nil)
    @hash   = hash
    @path   = path
    @parent = parent
  end
    
  def self.load_file( path, parent=nil )
    h = YAML.load_file( path )
    Props.new( h, path, parent )
  end
  
  ### todo: use TOP_LEVEL_BINDING for binding default?
  def self.load_file_with_erb( path, binding, parent=nil )  # run through erb first
    text = ERB.new( File.read( path ) ).result( binding )
    h = YAML.load( text )
    Props.new( h, path, parent )
  end
    
  def dump   # for debugging
    puts "dump of >#{@path}<:"
    pp @hash
  end

    
  def fetch(key, default)
    value = get( key )
    value.nil? ? default : value
  end
  
  def fetch_from_section(section, key, default)
    value = get_from_section( section, key )
    value.nil? ? default : value
  end

  def [](key)  get( key );  end

  def get( key )
    value = @hash.fetch( key.to_s, nil )
    # if not found try lookup in parent hash
    (value.nil? && parent) ? parent.get(key) : value
  end

  def get_from_section( section, key )
    value = @hash.fetch( section.to_s, {} ).fetch( key.to_s, nil )
    # if not found try lookup in parent hash
    (value.nil? && parent) ? parent.get_from_section(section,key) : value
  end

end # class Props