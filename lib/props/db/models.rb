# encoding: utf-8

module ConfDb
  module Model


class Prop < ActiveRecord::Base
  ## some code here
end # class Prop

  end # module Model

  ##### add convenience module alias in plural e.g. lets you use include ConfDb::Models
  Models = Model

end # module ConfDb
