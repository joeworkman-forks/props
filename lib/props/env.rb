module ConfUtils

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

end # module ConfUtils
