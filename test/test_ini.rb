###
#  to run use
#     ruby -I ./lib -I ./test test/test_ini.rb
#  or better
#     rake test

require 'helper'

class TestIni < MiniTest::Unit::TestCase


  def test_load

    text = <<EOS
  # comment
  ; another comment
  
   key1 = hello
   key2 : hi!
   
   [section1]
   key3 = salut   # end of line comment here
   
   [section2]
   key4: hola
   blank =
   blank2:
   
   [ http://example.com ]
   title =  A rose is a rose is a rose, eh?
   title2:  A rose is a rose is a rose, eh?   # comment here
   ; another one here
   title3 = A rose is a rose is a rose, eh?
EOS

    hash = INI.load( text )
    pp hash

    assert( hash['key1'] == 'hello' )
    assert( hash['key2'] == 'hi!' )
    assert( hash['section1']['key3'] == 'salut' )
    assert( hash['section2']['key4'] == 'hola' )
    assert( hash['section2']['blank'] == '' )
    assert( hash['section2']['blank2'] == '' )
    assert( hash['http://example.com']['title'] == 'A rose is a rose is a rose, eh?' )
    assert( hash['http://example.com']['title2'] == 'A rose is a rose is a rose, eh?' )
    assert( hash['http://example.com']['title3'] == 'A rose is a rose is a rose, eh?' )
  end

end