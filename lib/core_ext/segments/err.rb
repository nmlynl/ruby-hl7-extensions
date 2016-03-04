module Extensions
  module HL7
    module Segments
      module ERR

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def to_hash
            @hash = {}
          end
        end
        
        module ClassMethods
          def index_for(field_name)
            return 12 if field_name == :help_desk_contact_point
            
            index = self.fields.collect {|field| field[0]}.index(field_name) rescue -1
            if index < 0
              return -1
            else
              return index 
            end
          end
        end
        
      end
    end
  end
end
