
module ConfDb

  class Deleter
    include ConfDb::Models

    def run
      # for now delete all tables
      
      Prop.delete_all
    end
    
  end # class Deleter
  
end # module ConfDb
