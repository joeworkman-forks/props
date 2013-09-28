
module ConfUtils


class IniFile

  # returns a nested hash
  #  (compatible structure - works like YAML.load_file)

  def self.load_file( path )
    text = File.open( path, 'r:bom|utf-8' ).read
    self.load( text )
  end

  def self.load( text )
    IniFile.new( text ).parse
  end


  def initialize( text )
    @text = text
  end

  def parse
    hash = top_hash = Hash.new

    text = @text
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
  end
  
end # class IniReader

end # module ConfUtils
