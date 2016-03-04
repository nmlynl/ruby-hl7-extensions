module Extensions
  module HL7
    module Segments
      module NK1

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
            return 1 if field_name == :set_id
            return 2 if field_name == :name           
            return 3 if field_name == :relationship
            return 4 if field_name == :address
            return 5 if field_name == :phone_number
            return 13 if field_name == :organization_name
            return 20 if field_name == :primary_language
            return 30 if field_name == :contact_persons_name
            return 31 if field_name == :contact_persons_telephone_number            
            return 32 if field_name == :contact_persons_address                                   
            return -1
          end
        end
        
      end
    end
  end
end
