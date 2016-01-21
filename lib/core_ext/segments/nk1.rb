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
        end
        
      end
    end
  end
end
