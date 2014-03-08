# encoding: utf-8

# core and stlibs

require 'yaml'
require 'pp'
require 'fileutils'
require 'erb'


# our own code

require 'props/version'   # version always goes first
require 'props/env'
require 'props/ini'
require 'props/props'


######################
# add top_level convenience alias for classes

Env   = ConfUtils::Env
Props = ConfUtils::Props


module INI

  # returns a nested hash
  #  (compatible structure - works like YAML.load_file)

  def self.load_file( path  )   ConfUtils::IniFile.load_file( path );  end
  def self.load( text )         ConfUtils::IniFile.load( text );   end

end  # module INI


module ConfUtils

  def self.banner
    # todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL??
    "props/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end
  
end  # module ConfUtils


puts ConfUtils.banner   if $DEBUG    # say hello
